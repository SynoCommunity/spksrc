/*
 * ZNC Palaver Module
 *
 * Copyright (c) 2013 Kyle Fuller
 * License under the MIT license
 */

#define REQUIRESSL


#include <znc/Modules.h>
#include <znc/User.h>
#include <znc/IRCNetwork.h>
#include <znc/Client.h>
#include <znc/Chan.h>
#include <znc/FileUtils.h>

#if defined VERSION_MAJOR && defined VERSION_MINOR && VERSION_MAJOR >= 1 && VERSION_MINOR >= 5
#if defined(__has_include)
#if __has_include(<regex>)
#define HAS_REGEX
#include <regex>
#endif
#endif
#endif

#ifndef PALAVER_VERSION
	#define PALAVER_VERSION "unknown"
#endif


const char *kPLVCapability = "palaverapp.com";
const char *kPLVCommand = "PALAVER";
const char *kPLVPushEndpointKey = "PUSH-ENDPOINT";
const char *kPLVMentionKeywordKey = "MENTION-KEYWORD";
const char *kPLVMentionChannelKey = "MENTION-CHANNEL";
const char *kPLVMentionNickKey = "MENTION-NICK";
const char *kPLVIgnoreKeywordKey = "IGNORE-KEYWORD";
const char *kPLVIgnoreChannelKey = "IGNORE-CHANNEL";
const char *kPLVIgnoreNickKey = "IGNORE-NICK";


#ifdef HAS_REGEX
/// Escape all non-alphanumeric characters or special characters in pattern.
CString re_escape(const CString& sString) {
	CString sEscaped;

	for (const char& character : sString) {
		if (isalpha(character) || isdigit(character)) {
			sEscaped += character;
		} else if (character == '\x00') {
			sEscaped += "\\000";
		} else {
			sEscaped += "\\";
			sEscaped += character;
		}
	}

	return sEscaped;
}
#endif


typedef enum {
	StatusLine = 0,
	Headers = 1,
	Body = 2,
	Closed = 3,
} EPLVHTTPSocketState;

class PLVHTTPSocket : public CSocket {
	EPLVHTTPSocketState m_eState;

public:
	PLVHTTPSocket(CModule *pModule, const CString &sMethod, const CString &sURL, MCString &mcsHeaders, const CString &sContent) : CSocket(pModule) {
		m_eState = StatusLine;

		unsigned short uPort = 80;

		CString sScheme = sURL.Token(0, false, "://");
		CString sTemp = sURL.Token(1, true, "://");
		CString sAddress = sTemp.Token(0, false, "/");

		CString sHostname = sAddress.Token(0, false, ":");
		CString sPort = sAddress.Token(1, true, ":");
		CString sPath = "/" + sTemp.Token(1, true, "/");

		if (sPort.empty()) {
			if (sScheme.Equals("https")) {
				uPort = 443;
			} else if (sScheme.Equals("http")) {
				uPort = 80;
			}
		} else {
			uPort = sPort.ToUShort();
		}

		mcsHeaders["Connection"] = "close";
		mcsHeaders["User-Agent"] = "ZNC";

		if (sMethod.Equals("GET") == false) {
			mcsHeaders["Content-Length"] = CString(sContent.length());
		}

		bool useSSL = sScheme.Equals("https");

		DEBUG("Palaver: Connecting to '" << sHostname << "' on port " << uPort << (useSSL ? " with" : " without") << " TLS (" << sMethod << " " << sPath << ")");

		Connect(sHostname, uPort, useSSL);
		EnableReadLine();
		Write(sMethod + " " + sPath + " HTTP/1.1\r\n");
		Write("Host: " + sHostname + "\r\n");

		for (MCString::const_iterator it = mcsHeaders.begin(); it != mcsHeaders.end(); ++it) {
			const CString &sKey = it->first;
			const CString &sValue = it->second;

			Write(sKey + ": " + sValue + "\r\n");
		}

		Write("\r\n");

		if (sContent.length() > 0) {
			Write(sContent);
		}

		Close(Csock::CLT_AFTERWRITE);
	}

	void ReadLine(const CString& sData) {
		CString sLine = sData;
		sLine.TrimRight("\r\n");

		switch (m_eState) {
			case StatusLine: {
				CString sStatus = sLine.Token(1);
				unsigned int uStatus = sStatus.ToUInt();

				if (uStatus < 200 || uStatus > 299) {
					DEBUG("Palaver: Received HTTP Response code: " << uStatus);
				}

				m_eState = Headers;
				break;
			}

			case Headers: {
				if (sLine.empty()) {
					m_eState = Body;
				}

				break;
			}

			case Body: {
				break;
			}

			case Closed: {
				 break;
			 }
		}
	}

	void Disconnected() {
		Close(CSocket::CLT_AFTERWRITE);
	}
};

class CDevice {
public:
	CDevice(const CString &sToken) {
		m_sToken = sToken;
		m_bInNegotiation = false;
		m_uiBadge = 0;
	}

	CString GetVersion() const {
		return m_sVersion;
	}

	bool InNegotiation() const {
		return m_bInNegotiation;
	}

	void SetInNegotiation(bool inNegotiation) {
		m_bInNegotiation = inNegotiation;
	}

	void SetVersion(const CString &sVersion) {
		m_sVersion = sVersion;
	}

	CString GetToken() const {
		return m_sToken;
	}

	void SetPushEndpoint(const CString &sEndpoint) {
		m_sPushEndpoint = sEndpoint;
	}

	CString GetPushEndpoint() const {
		return m_sPushEndpoint;
	}

	bool HasClient(const CClient& client) const {
		bool bHasClient = false;

		for (std::vector<CClient*>::const_iterator it = m_vClients.begin();
				it != m_vClients.end(); ++it) {
			CClient *pCurrentClient = *it;

			if (&client == pCurrentClient) {
				bHasClient = true;
				break;
			}
		}

		return bHasClient;
	}

	void AddClient(CClient& client) {
		if (HasClient(client) == false) {
			m_vClients.push_back(&client);
		}
	}

	void RemoveClient(const CClient& client) {
		for (std::vector<CClient*>::iterator it = m_vClients.begin();
				it != m_vClients.end(); ++it) {
			CClient *pCurrentClient = *it;

			if (&client == pCurrentClient) {
				m_vClients.erase(it);
				break;
			}
		}
	}

	bool AddNetwork(CIRCNetwork& network) {
		return AddNetworkNamed(network.GetUser()->GetUserName(), network.GetName());
	}

	bool HasNetworkNamed(const CString& sUsername, const CString& sNetwork) const {
		bool bHasNetwork = false;

		std::map<CString, VCString>::const_iterator it = m_msvsNetworks.find(sUsername);
		if (it != m_msvsNetworks.end()) {
			const VCString& vNetworks = it->second;

			for (VCString::const_iterator it2 = vNetworks.begin(); it2 != vNetworks.end(); ++it2) {
				const CString &name = *it2;

				if (name.Equals(sNetwork)) {
					bHasNetwork = true;
					break;
				}
			}
		}

		return bHasNetwork;
	}

	bool AddNetworkNamed(const CString& sUsername, const CString& sNetwork) {
		bool bDidAddNetwork = false;

		if (HasNetworkNamed(sUsername, sNetwork) == false) {
			m_msvsNetworks[sUsername].push_back(sNetwork);
			bDidAddNetwork = true;
		}

		return bDidAddNetwork;
	}

	void RemoveNetwork(CIRCNetwork& network) {
		const CUser *user = network.GetUser();
		const CString& sUsername = user->GetUserName();

		std::map<CString, VCString>::iterator it = m_msvsNetworks.find(sUsername);
		if (it != m_msvsNetworks.end()) {
			VCString &networks = it->second;

			for (VCString::iterator it2 = networks.begin(); it2 != networks.end(); ++it2) {
				CString &name = *it2;

				if (name.Equals(network.GetName())) {
					networks.erase(it2);
					break;
				}
			}

			if (networks.empty()) {
				m_msvsNetworks.erase(it);
			}
		}
	}

	bool HasNetwork(CIRCNetwork& network) {
		bool hasNetwork = false;

		const CUser *user = network.GetUser();
		const CString& sUsername = user->GetUserName();

		std::map<CString, VCString>::iterator it = m_msvsNetworks.find(sUsername);
		if (it != m_msvsNetworks.end()) {
			VCString &networks = it->second;

			for (VCString::iterator it2 = networks.begin(); it2 != networks.end(); ++it2) {
				CString &name = *it2;

				if (name.Equals(network.GetName())) {
					hasNetwork = true;
					break;
				}
			}
		}

		return hasNetwork;
	}

	void ResetDevice() {
		m_bInNegotiation = false;
		m_sVersion = "";
		m_sPushEndpoint = "";

		m_vMentionKeywords.clear();
		m_vMentionChannels.clear();
		m_vMentionNicks.clear();
		m_vIgnoreKeywords.clear();
		m_vIgnoreChannels.clear();
		m_vIgnoreNicks.clear();

		m_uiBadge = 0;
	}

	void AddMentionKeyword(const CString& sKeyword) {
		m_vMentionKeywords.push_back(sKeyword);
	}

	void AddMentionChannel(const CString& sChannel) {
		m_vMentionChannels.push_back(sChannel);
	}

	void AddMentionNick(const CString& sNick) {
		m_vMentionNicks.push_back(sNick);
	}

	void AddIgnoreKeyword(const CString& sKeyword) {
		m_vIgnoreKeywords.push_back(sKeyword);
	}

	void AddIgnoreChannel(const CString& sChannel) {
		m_vIgnoreChannels.push_back(sChannel);
	}

	void AddIgnoreNick(const CString& sNick) {
		m_vIgnoreNicks.push_back(sNick);
	}

	bool HasMentionChannel(const CString& sChannel) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vMentionChannels.begin();
				it != m_vMentionChannels.end(); ++it) {
			const CString& channel = *it;

			if (channel.WildCmp(sChannel)) {
				bResult = true;
				break;
			}
		}

		return bResult;
	}

	bool HasIgnoreChannel(const CString& sChannel) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vIgnoreChannels.begin();
				it != m_vIgnoreChannels.end(); ++it) {
			const CString& channel = *it;

			if (channel.WildCmp(sChannel)) {
				bResult = true;
				break;
			}
		}

		return bResult;
	}

	bool HasMentionNick(const CString& sNick) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vMentionNicks.begin();
				it != m_vMentionNicks.end(); ++it) {
			const CString& nick = *it;

			if (nick.WildCmp(sNick)) {
				bResult = true;
				break;
			}
		}

		return bResult;
	}

	bool HasIgnoreNick(const CString& sNick) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vIgnoreNicks.begin();
				it != m_vIgnoreNicks.end(); ++it) {
			const CString& nick = *it;

			if (nick.WildCmp(sNick)) {
				bResult = true;
				break;
			}
		}

		return bResult;
	}

	bool IncludesMentionKeyword(const CString& sMessage, const CString &sNick) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vMentionKeywords.begin();
				it != m_vMentionKeywords.end(); ++it) {
			CString sKeyword = *it;

			if (sKeyword.Equals("{nick}")) {
				sKeyword = sNick;
			}

#ifdef HAS_REGEX
			std::smatch match;
			std::regex expression = std::regex("\\b" + re_escape(sKeyword) + "\\b",
					std::regex_constants::ECMAScript | std::regex_constants::icase);

			std::regex_search(sMessage, match, expression);

			if (!match.empty()) {
				bResult = true;
				break;
			}
#else
			if (sMessage.find(sKeyword) != std::string::npos) {
				bResult = true;
				break;
			}
#endif
		}

		return bResult;
	}

	bool IncludesIgnoreKeyword(const CString& sMessage) const {
		bool bResult = false;

		for (VCString::const_iterator it = m_vIgnoreKeywords.begin();
				it != m_vIgnoreKeywords.end(); ++it) {
			const CString& sKeyword = *it;

			if (sMessage.find(sKeyword) != std::string::npos) {
				bResult = true;
				break;
			}
		}

		return bResult;
	}

#pragma mark - Serialization

	void ParseLine(const CString& sLine) {
		if (InNegotiation() == false) {
			return;
		}

		CString sCommand = sLine.Token(0);

		if (sCommand.Equals("SET")) {
			CString sKey = sLine.Token(1);
			CString sValue = sLine.Token(2, true);

			if (sKey.Equals("VERSION")) {
				SetVersion(sValue);
			} else if (sKey.Equals(kPLVPushEndpointKey)) {
				SetPushEndpoint(sValue);
			}
		} else if (sCommand.Equals("ADD")) {
			CString sKey = sLine.Token(1);
			CString sValue = sLine.Token(2, true);

			if (sKey.Equals(kPLVIgnoreKeywordKey)) {
				AddIgnoreKeyword(sValue);
			} else if (sKey.Equals(kPLVIgnoreChannelKey)) {
				AddIgnoreChannel(sValue);
			} else if (sKey.Equals(kPLVIgnoreNickKey)) {
				AddIgnoreNick(sValue);
			} else if (sKey.Equals(kPLVMentionKeywordKey)) {
				AddMentionKeyword(sValue);
			} else if (sKey.Equals(kPLVMentionChannelKey)) {
				AddMentionChannel(sValue);
			} else if (sKey.Equals(kPLVMentionNickKey)) {
				AddMentionNick(sValue);
			} else if (sKey.Equals("NETWORK")) {
				CString sUsername = sValue.Token(0);
				CString sNetwork = sValue.Token(1);

				AddNetworkNamed(sUsername, sNetwork);
			}
		} else if (sCommand.Equals("END")) {
			SetInNegotiation(false);
		}
	}

	void Write(CFile& File) const {
		File.Write("BEGIN " + GetToken() + "\n");

		if (GetVersion().empty() == false) {
			File.Write("SET VERSION " + GetVersion() + "\n");
		}

		if (GetPushEndpoint().empty() == false) {
			File.Write("SET " + CString(kPLVPushEndpointKey) + " " + GetPushEndpoint() + "\n");
		}

		for (VCString::const_iterator it = m_vMentionKeywords.begin();
				it != m_vMentionKeywords.end(); ++it) {
			const CString& sKeyword = *it;

			File.Write("ADD " + CString(kPLVMentionKeywordKey) + " " + sKeyword + "\n");
		}

		for (VCString::const_iterator it = m_vMentionChannels.begin();
				it != m_vMentionChannels.end(); ++it) {
			const CString& sChannel = *it;

			File.Write("ADD " + CString(kPLVMentionChannelKey) + " " + sChannel + "\n");
		}

		for (VCString::const_iterator it = m_vMentionNicks.begin();
				it != m_vMentionNicks.end(); ++it) {
			const CString& sNick = *it;

			File.Write("ADD " + CString(kPLVMentionNickKey) + " " + sNick + "\n");
		}

		for (VCString::const_iterator it = m_vIgnoreKeywords.begin();
				it != m_vIgnoreKeywords.end(); ++it) {
			const CString& sKeyword = *it;

			File.Write("ADD " + CString(kPLVIgnoreKeywordKey) + " " + sKeyword + "\n");
		}

		for (VCString::const_iterator it = m_vIgnoreChannels.begin();
				it != m_vIgnoreChannels.end(); ++it) {
			const CString& sChannel = *it;

			File.Write("ADD " + CString(kPLVIgnoreChannelKey) + " " + sChannel + "\n");
		}

		for (VCString::const_iterator it = m_vIgnoreNicks.begin();
				it != m_vIgnoreNicks.end(); ++it) {
			const CString& sNick = *it;

			File.Write("ADD " + CString(kPLVIgnoreNickKey) + " " + sNick + "\n");
		}

		for (std::map<CString, VCString>::const_iterator it = m_msvsNetworks.begin();
				it != m_msvsNetworks.end(); ++it) {
			const CString& sUsername = it->first;
			const VCString& networks = it->second;

			for (VCString::const_iterator it2 = networks.begin();
					it2 != networks.end(); ++it2) {
				const CString& sNetwork = *it2;

				File.Write("ADD NETWORK " + sUsername + " " + sNetwork + "\n");
			}
		}

		File.Write("END\n");
	}

#pragma mark - Notifications

	void SendNotification(CModule& module, const CString& sSender, const CString& sNotification, const CChan *pChannel) {
		++m_uiBadge;

		MCString mcsHeaders;

		mcsHeaders["Authorization"] = CString("Bearer " + GetToken());
		mcsHeaders["Content-Type"] = "application/json";

		CString sJSON = "{";
		sJSON += "\"badge\": " + CString(m_uiBadge);
		sJSON += ",\"message\": \"" + sNotification.Replace_n("\"", "\\\"") + "\"";
		sJSON += ",\"sender\": \"" + sSender.Replace_n("\"", "\\\"") + "\"";
		if (pChannel) {
			sJSON += ",\"channel\": \"" + pChannel->GetName().Replace_n("\"", "\\\"") + "\"";
		}
		sJSON += "}";

		PLVHTTPSocket *pSocket = new PLVHTTPSocket(&module, "POST", GetPushEndpoint(), mcsHeaders, sJSON);
		module.AddSocket(pSocket);
	}

	void ClearBadges(CModule& module) {
		if (m_uiBadge != 0) {
			MCString mcsHeaders;

			mcsHeaders["Authorization"] = CString("Bearer " + GetToken());
			mcsHeaders["Content-Type"] = "application/json";

			CString sJSON = "{\"badge\": 0}";

			PLVHTTPSocket *pSocket = new PLVHTTPSocket(&module, "POST", GetPushEndpoint(), mcsHeaders, sJSON);
			module.AddSocket(pSocket);

			m_uiBadge = 0;
		}
	}

	std::map<CString, VCString> GetNetworks() const {
		return m_msvsNetworks;
	}

private:
	CString m_sToken;
	CString m_sVersion;
	CString m_sPushEndpoint;

	std::map<CString, VCString> m_msvsNetworks;

	std::vector<CClient*> m_vClients;

	VCString m_vMentionKeywords;
	VCString m_vMentionChannels;
	VCString m_vMentionNicks;

	VCString m_vIgnoreKeywords;
	VCString m_vIgnoreChannels;
	VCString m_vIgnoreNicks;

	bool m_bInNegotiation;
	unsigned int m_uiBadge;
};

class CPalaverMod : public CModule {
public:
	MODCONSTRUCTOR(CPalaverMod) {
		AddHelpCommand();
		AddCommand("test", static_cast<CModCommand::ModCmdFunc>(&CPalaverMod::HandleTestCommand),
			"", "Send notifications to registered devices");
		AddCommand("list", static_cast<CModCommand::ModCmdFunc>(&CPalaverMod::HandleListCommand),
			"", "List all registered devices");
		AddCommand("info", static_cast<CModCommand::ModCmdFunc>(&CPalaverMod::HandleInfoCommand),
			"", "Show's module information");
	}

	virtual bool OnLoad(const CString& sArgs, CString& sMessage) {
		Load();

		return true;
	}

#pragma mark - Cap

	virtual void OnClientCapLs(CClient* pClient, SCString& ssCaps) {
		ssCaps.insert(kPLVCapability);
	}

	virtual bool IsClientCapSupported(CClient* pClient, const CString& sCap, bool bState) {
		return sCap.Equals(kPLVCapability);
	}

#pragma mark -

	virtual EModRet OnUserRaw(CString& sLine) {
		return HandleUserRaw(m_pClient, sLine);
	}

	virtual EModRet OnUnknownUserRaw(CClient* pClient, CString& sLine) {
		return HandleUserRaw(pClient, sLine);
	}

	virtual EModRet HandleUserRaw(CClient* pClient, CString& sLine) {
		if (sLine.Token(0).Equals(kPLVCommand)) {
			CString sCommand = sLine.Token(1);

			if (sCommand.Equals("BACKGROUND")) {
				pClient->SetAway(true);
			} else if (sCommand.Equals("FOREGROUND")) {
				pClient->SetAway(false);
			} else if (sCommand.Equals("IDENTIFY")) {
				CDevice *pDevice = DeviceForClient(*pClient);
				if (pDevice) {
					pDevice->RemoveClient(*pClient);
				}

				CString sToken = sLine.Token(2);
				CString sVersion = sLine.Token(3);

				CDevice& device = DeviceWithToken(sToken);

				if (device.InNegotiation() == false && device.GetVersion().Equals(sVersion) == false) {
					pClient->PutClient("PALAVER REQ *");
					device.SetInNegotiation(true);
				}

				device.AddClient(*pClient);

				CIRCNetwork *pNetwork = pClient->GetNetwork();
				if (pNetwork) {
					if (device.AddNetwork(*pNetwork) && device.InNegotiation() == false) {
						Save();
					}
				}
			} else if (sCommand.Equals("BEGIN")) {
				CString sToken = sLine.Token(2);
				CString sVersion = sLine.Token(3);
				CDevice& device = DeviceWithToken(sToken);

				device.ResetDevice();
				device.SetInNegotiation(true);
				device.SetVersion(sVersion);

				device.AddClient(*pClient);
			} else if (sCommand.Equals("SET") || sCommand.Equals("ADD") || sCommand.Equals("END")) {
				CDevice *pDevice = DeviceForClient(*pClient);

				if (pDevice) {
					pDevice->ParseLine(sLine.Token(1, true));

					if (sCommand.Equals("END")) {
						Save();
					}
				}
			}

			return HALT;
		}

		return CONTINUE;
	}

#pragma mark -

	virtual void OnClientLogin() {
		// Associate client with the user/network
		CDevice *pDevice = DeviceForClient(*m_pClient);
		if (pDevice && m_pNetwork) {
			if (pDevice->AddNetwork(*m_pNetwork)) {
				Save();
			}
		}

		if (m_pNetwork) {
			// Let's reset any other devices for this client

			for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
					it != m_vDevices.end(); ++it) {
				CDevice& device = **it;

				if (device.HasClient(*m_pClient) == false && device.HasNetwork(*m_pNetwork)) {
					device.ClearBadges(*this);
				}
			}
		}
	}

	virtual void OnClientDisconnect() {
		CDevice *pDevice = DeviceForClient(*m_pClient);
		if (pDevice) {
			pDevice->SetInNegotiation(false);
			pDevice->RemoveClient(*m_pClient);
		}
	}

#pragma mark -

	CDevice& DeviceWithToken(const CString& sToken) {
		CDevice *pDevice = NULL;

		for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
				it != m_vDevices.end(); ++it) {
			CDevice& device = **it;

			if (device.GetToken().Equals(sToken)) {
				pDevice = &device;
				break;
			}
		}

		if (pDevice == NULL) {
			pDevice = new CDevice(sToken);
			m_vDevices.push_back(pDevice);
		}

		return *pDevice;
	}

	CDevice* DeviceForClient(CClient &client) const {
		CDevice *pDevice = NULL;

		for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
				it != m_vDevices.end(); ++it) {
			CDevice& device = **it;

			if (device.HasClient(client)) {
				pDevice = &device;
				break;
			}
		}

		return pDevice;
	}

#pragma mark - Serialization

	CString GetConfigPath() const {
		return (GetSavePath() + "/palaver.conf");
	}

	void Save() const {
		CFile *pFile = new CFile(GetConfigPath());

		if (!pFile->Open(O_WRONLY | O_CREAT | O_TRUNC, 0600)) {
			DEBUG("palaver: Failed to save `" + GetConfigPath() + "` `" + CString(strerror(errno)) + "`");
			delete pFile;
			return;
		}

		for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
				it != m_vDevices.end(); ++it) {
			const CDevice& device = **it;
			device.Write(*pFile);
		}

		pFile->Sync();

		if (pFile->HadError()) {
			DEBUG("palaver: Failed to save `" + GetConfigPath() + "` `" + CString(strerror(errno)) + "`");
			pFile->Delete();
		}

		delete pFile;
	}

	void Load() {
		if (!CFile::Exists(GetConfigPath())) {
			DEBUG("palaver: Config file doesn't exist");
			return;
		}

		if (!CFile::IsReg(GetConfigPath())) {
			DEBUG("palaver: Config file isn't a file");
			return;
		}

		CFile *pFile = new CFile(GetConfigPath());
		if (!pFile->Open(GetConfigPath(), O_RDONLY)) {
			DEBUG("palaver: Error opening config file");
			delete pFile;
			return;
		}

		if (!pFile->Seek(0)) {
			DEBUG("palaver: Error can't seek to start of config file");
			delete pFile;
			return;
		}

		CString sLine;
		CDevice *pDevice = NULL;

		while (pFile->ReadLine(sLine)) {
			sLine.TrimLeft();
			sLine.TrimRight("\n");

			if (pDevice == NULL) {
				CString sCommand = sLine.Token(0);

				if (sCommand.Equals("BEGIN")) {
					CString sToken = sLine.Token(1);

					pDevice = new CDevice(sToken);
					m_vDevices.push_back(pDevice);

					pDevice->ResetDevice();
					pDevice->SetInNegotiation(true);
				}
			}

			if (pDevice) {
				pDevice->ParseLine(sLine);

				if (!pDevice->InNegotiation()) {
					pDevice = NULL;
				}
			}
		}

		delete pFile;
	}

#pragma mark -

	void ParseMessage(CNick& Nick, CString& sMessage, CChan *pChannel = NULL) {
		if (m_pNetwork->IsUserOnline() == false) {
#if defined VERSION_MAJOR && defined VERSION_MINOR && VERSION_MAJOR >= 1 && VERSION_MINOR >= 2
			CString sCleanMessage = sMessage.StripControls();
#else
			CString &sCleanMessage = sMessage;
#endif

			for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
					it != m_vDevices.end(); ++it)
			{
				CDevice& device = **it;

				if (device.HasNetwork(*m_pNetwork)) {
					bool bMention = (
						((pChannel == NULL) || device.HasMentionChannel(pChannel->GetName())) ||
						device.HasMentionNick(Nick.GetNick()) ||
						device.IncludesMentionKeyword(sCleanMessage, m_pNetwork->GetIRCNick().GetNick()));

					if (bMention && (
							(pChannel && device.HasIgnoreChannel(pChannel->GetName())) ||
							device.HasIgnoreNick(Nick.GetNick()) ||
							device.IncludesIgnoreKeyword(sCleanMessage)))
					{
						bMention = false;
					}

					if (bMention) {
						device.SendNotification(*this, Nick.GetNick(), sCleanMessage, pChannel);
					}
				}
			}
		}
	}

	virtual EModRet OnChanMsg(CNick& Nick, CChan& Channel, CString& sMessage) {
		ParseMessage(Nick, sMessage, &Channel);
		return CONTINUE;
	}

	virtual EModRet OnPrivMsg(CNick& Nick, CString& sMessage) {
		ParseMessage(Nick, sMessage, NULL);
		return CONTINUE;
	}

#pragma mark - Commands

	void HandleTestCommand(const CString& sLine) {
		if (m_pNetwork) {
			unsigned int count = 0;

			for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
					it != m_vDevices.end(); ++it)
			{
				CDevice& device = **it;

				if (device.HasNetwork(*m_pNetwork)) {
					++count;
					device.SendNotification(*this, "palaver", "Test notification", NULL);
				}
			}

			PutModule("Notification sent to " + CString(count) + " clients.");
		} else {
			PutModule("You need to connect with a network.");
		}
	}

	void HandleListCommand(const CString &sLine) {
		if (m_pUser->IsAdmin() == false) {
			PutModule("Permission denied");
			return;
		}

		CTable Table;

		Table.AddColumn("Device");
		Table.AddColumn("User");
		Table.AddColumn("Network");
		Table.AddColumn("Negotiating");

		for (std::vector<CDevice*>::const_iterator it = m_vDevices.begin();
				it != m_vDevices.end(); ++it)
		{
			CDevice &device = **it;

			const std::map<CString, VCString> msvsNetworks = device.GetNetworks();
			std::map<CString, VCString>::const_iterator it2 = msvsNetworks.begin();
			for (;it2 != msvsNetworks.end(); ++it2) {
				const CString sUsername = it2->first;
				const VCString &networks = it2->second;

				for (VCString::const_iterator it3 = networks.begin(); it3 != networks.end(); ++it3) {
					const CString sNetwork = *it3;

					Table.AddRow();
					Table.SetCell("Device", device.GetToken());
					Table.SetCell("User", sUsername);
					Table.SetCell("Network", sNetwork);
					Table.SetCell("Negotiating", CString(device.InNegotiation()));
				}

				if (networks.size() == 0) {
					Table.AddRow();
					Table.SetCell("Device", device.GetToken());
					Table.SetCell("User", sUsername);
					Table.SetCell("Network", "");
					Table.SetCell("Negotiating", CString(device.InNegotiation()));
				}
			}

			if (msvsNetworks.size() == 0) {
				Table.AddRow();
				Table.SetCell("Device", device.GetToken());
				Table.SetCell("User", "");
				Table.SetCell("Network", "");
				Table.SetCell("Negotiating", CString(device.InNegotiation()));
			}
		}

		if (PutModule(Table) == 0) {
			PutModule("There are no devices registered with this server.");
		}

		CDevice *pDevice = DeviceForClient(*m_pClient);
		if (pDevice) {
			PutModule("You are connected from Palaver. (" + pDevice->GetToken() + ")");
		} else {
			PutModule("You are not connected from a Palaver client.");
		}
	}

	void HandleInfoCommand(const CString &sLine) {
		PutModule("Please contact support@palaverapp.com if you have any troubles with this module.");
		PutModule("Be sure to include all information from this command so we can try and debug any issues.");
		PutModule("--");

		PutModule("Palaver ZNC: " + CString(PALAVER_VERSION) + " -- http://palaverapp.com/");
		CDevice *pDevice = DeviceForClient(*m_pClient);
		if (pDevice) {
			PutModule("Current device: (" + pDevice->GetToken() + ")");
		}
		PutModule(CString(m_vDevices.size()) + " registered devices");

		PutStatus(CZNC::GetTag());
		PutStatus(CZNC::GetCompileOptionsString());
	}
private:

	std::vector<CDevice*> m_vDevices;
};

template<> void TModInfo<CPalaverMod>(CModInfo& Info) {
	Info.SetWikiPage("palaver");
}

GLOBALMODULEDEFS(CPalaverMod, "Palaver support module")

