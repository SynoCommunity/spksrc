#include <cassert>
#include <unordered_set>

#include <znc/main.h>
#include <znc/Modules.h>
#include <znc/znc.h>
#include <znc/IRCNetwork.h>
#include <znc/IRCSock.h>
#include <znc/User.h>

class Identd;

class IdentSock : public CSocket
{
public:
	explicit IdentSock(CModule* module, bool isListener = false)
		: CSocket(module)
		, mIsListener(isListener)
	{
	}

private:
	Identd* GetIdentd();

	// CSocket
	Csock* GetSockObj(CS_STRING const& /*host*/, uint16_t /*port*/) override { return new IdentSock(GetModule()); }
	void Disconnected() override;
	void Timeout() override { SockError(ETIMEDOUT, "socket timed out"); }
	void ReadLine(CS_STRING const& line) override;
	void SockError(int error, CS_STRING const& description) override;
	bool ConnectionFrom(CS_STRING const& host, uint16_t port) override;

	bool const mIsListener;
};

class Identd : public CModule
{
public:
	MODCONSTRUCTOR(Identd) {}

	~Identd()
	{
		RemoveListener();
	}

	bool AddSocket(CIRCSock const* sock)
	{
		if (mIsBlocking && !mSockets.empty())
		{
			PutModule("IRC connection already in progress");
			return false;
		}

		if (Start())
		{
			auto network = sock->GetNetwork();
			DEBUG("identd: adding IRC socket for " + network->GetUser()->GetUserName() + "/" + network->GetName());

			mSockets.insert(sock);

			if (mIsBlocking)
			{
				assert(mSockets.size() == 1);
				CZNC::Get().PauseConnectQueue();
			}
		}

		return true;
	}

	void RemoveSocket(CIRCSock const* sock)
	{
		if (mListener)
		{
			if (mSockets.erase(sock))
			{
				auto network = sock->GetNetwork();
				DEBUG("identd: removed IRC socket for " + network->GetUser()->GetUserName() + "/" + network->GetName());

				if (mIsBlocking)
				{
					assert(mSockets.empty());
					CZNC::Get().ResumeConnectQueue();
				}
			}

			Stop();
		}
	}

	bool HasSockets() const
	{
		return !mSockets.empty();
	}

	CIRCSock const* FindSocket(CS_STRING const& ip, uint16_t port) const
	{
		if (mListener)
		{
			for (auto i : mSockets)
			{
				if (mIsBlocking || (i->IsConnected() && i->GetLocalPort() == port && i->GetLocalIP() == ip))
				{
					return i;
				}
			}
		}

		return nullptr;
	}

	void RemoveListener()
	{
		if (mIsBlocking && !mSockets.empty())
		{
			CZNC::Get().ResumeConnectQueue();
		}

		mSockets.clear();
		Stop();
	}

	void OnStopped()
	{
		if (mListener)
		{
			DEBUG("identd: stopped listening on port " + CString(mPort));

			// Socket will be deleted by manager
			mListener = nullptr;
		}
	}

private:
	bool Start()
	{
		if (mListener)
		{
			if (mListener->IsClosed())
			{
				mListener->Close(CSocket::CLT_DONT);

				DEBUG("identd: resumed listening on port " + CString(mPort));
			}
		}
		else
		{
			mListener = new IdentSock(this, true);

			if (!GetManager()->ListenAll(mPort, "identd", false, SOMAXCONN, mListener))
			{
				// Socket already deleted by manager
				mListener = nullptr;

				PutModule("Failed to listen on port " + CString(mPort) + ", try reloading identd module");
				return false;
			}

			// Hack to get the Disconnected() callback
			mListener->SetIsConnected(true);

			DEBUG("identd: started listening on port " + CString(mPort));
		}

		return true;
	}

	void Stop()
	{
		if (mListener && mSockets.empty())
		{
			DEBUG("identd: will stop listening on port " + CString(mPort));

			mListener->Close();
		}
	}

	bool OnLoad(CString const& args, CString& message) override
	{
		mPort = args.ToUShort();
		mIsBlocking = !args.empty() && args[0] == '+';

		if (!mPort)
		{
			mPort = 9113;
		}

		message = "will listen on port " + CString(mPort) + " (" + (mIsBlocking ? "" : "non-") + "blocking)";
		return true;
	}

	EModRet OnIRCConnecting(CIRCSock* sock) override
	{
		return AddSocket(sock) ? CONTINUE : HALTCORE;
	}

	void OnIRCConnectionError(CIRCSock* sock) override
	{
		RemoveSocket(sock);
	}

	void OnIRCConnected() override
	{
		RemoveSocket(GetNetwork()->GetIRCSock());
	}

	void OnIRCDisconnected() override
	{
		RemoveSocket(GetNetwork()->GetIRCSock());
	}

	uint16_t mPort = 0;
	bool mIsBlocking = false;
	IdentSock* mListener = nullptr;
	std::unordered_set<CIRCSock const*> mSockets;
};

Identd* IdentSock::GetIdentd()
{
	assert(dynamic_cast<Identd*>(GetModule()));
	return static_cast<Identd*>(GetModule());
}

void IdentSock::Disconnected()
{
	if (mIsListener)
	{
		GetIdentd()->OnStopped();
	}
}

void IdentSock::ReadLine(const CS_STRING& line)
{
	if (mIsListener)
	{
		// Should not happen
		assert(false);
		return;
	}

	DEBUG("identd: got query: " + line.Trim_n());

	VCString query;
	line.Split(",", query, false, "", "", true, true);

	if (query.size() != 2)
	{
		// Malformed query
		Close();
		return;
	}

	CString reply = query[0] + " , " + query[1] + " : ";

	uint16_t port = query[0].ToUShort();
	auto sock = GetIdentd()->FindSocket(GetLocalIP(), port);

	if (sock && sock->GetNetwork() && sock->GetNetwork()->GetUser())
	{
		auto network = sock->GetNetwork();
		DEBUG("identd: found IRC socket for " + network->GetUser()->GetUserName() + "/" + network->GetName() + " on " + GetLocalIP() + ":" + CString(port));

		reply += "USERID : UNIX : " + network->GetUser()->GetIdent();
	}
	else
	{
		DEBUG("identd: IRC socket on " + GetLocalIP() + ":" + CString(port) + " not found");

		reply += "ERROR : NO-USER";
	}

	Write(reply + "\r\n");
	Close(CLT_AFTERWRITE);
}

void IdentSock::SockError(int error, CS_STRING const& description)
{
	GetModule()->PutModule("Socket error " + CString(error) + ": " + description);
	Close();

	if (mIsListener)
	{
		GetIdentd()->RemoveListener();
		GetIdentd()->OnStopped();
	}
}

bool IdentSock::ConnectionFrom(CS_STRING const& host, uint16_t port)
{
	DEBUG(CString("identd: ") + (GetIdentd()->HasSockets() ? "allow" : "deny") + "ing connection from " + host + ":" + CString(port));
	return GetIdentd()->HasSockets() ? CSocket::ConnectionFrom(host, port) : false;
}

template<> void TModInfo<Identd>(CModInfo& info)
{
	info.SetHasArgs(true);
	info.SetArgsHelpText("Specify the listening port (default: 9113). Prepend with + for blocking connect.");
}

GLOBALMODULEDEFS(Identd, "identd")
