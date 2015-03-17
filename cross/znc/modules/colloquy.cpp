/*
 * Copyright (C) 2004-2009  See the AUTHORS file for details.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <znc/znc.h>
#include <znc/IRCNetwork.h>
#include <znc/Chan.h>
#include <znc/User.h>
#include <znc/Modules.h>
#include <time.h>

#define REQUIRESSL 1

using std::set;
using std::map;
using std::vector;

class CDevice {
public:
	CDevice(const CString& sToken, CModule& Parent)
			: m_Parent(Parent), m_sToken(sToken) {
				m_uPort = 0;
				m_bNew = false;
				m_uFlags = 0;
	}

	virtual ~CDevice() {}

	void RemoveClient(CClient* pClient) {
		m_spClients.erase(pClient);
	}

	bool RemKeyword(const CString& sWord) {
		return (m_ssKeywords.erase(sWord) && Save());
	}

	bool AddKeyword(const CString& sWord) {
		if (!sWord.empty()) {
			m_ssKeywords.insert(sWord);

			return Save();
		}

		return false;
	}

	bool Save() {
		CString sStr(Serialize());

		if (!m_Parent.SetNV("device::" + GetToken(), sStr)) {
			DEBUG("ERROR while saving colloquy info!");
			return false;
		}

		DEBUG("SAVED [" + GetToken() + "]");
		return true;
	}

	bool Push(const CString& sNick, const CString& sMessage, const CString& sChannel, bool bHilite, int iBadge) {
		if (m_sToken.empty()) {
			DEBUG("---- Push(\"" + sNick + "\", \"" + sMessage + "\", \"" + sChannel + "\", " + CString(bHilite) + ", " + CString(iBadge) + ")");
			return false;
		}

		if (!m_uPort || m_sHost.empty()) {
			DEBUG("---- Push() undefined host or port!");
		}

		CString sPayload;

		sPayload = "{";

		sPayload += "\"device-token\":\"" + CollEscape(m_sToken) + "\"";

		if (!sMessage.empty()) {
			sPayload += ",\"message\":\"" + CollEscape(sMessage) + "\"";
		}
		// action
		if (!sNick.empty()) {
			sPayload += ",\"sender\":\"" + CollEscape(sNick) + "\"";
		}

		// this handles the badge
		// 0 resets, other values add/subtract
		if ( iBadge == 0 )
		{
			sPayload += ",\"badge\": \"reset\"";
		}
		else
		{
			sPayload += ",\"badge\": " + CString(iBadge);
		}

		if (!sChannel.empty()) {
			sPayload += ",\"room\":\"" + CollEscape(sChannel) + "\"";
		}

		if (!m_sConnectionToken.empty()) {
			sPayload += ",\"connection\":\"" + CollEscape(m_sConnectionToken) + "\"";
		}

		if (!m_sConnectionName.empty()) {
			sPayload += ",\"server\":\"" + CollEscape(m_sConnectionName) + "\"";
		}

		if (bHilite && !m_sHiliteSound.empty()) {
			sPayload += ",\"sound\":\"" + CollEscape(m_sHiliteSound) + "\"";
		} else if (!bHilite && !m_sMessageSound.empty() && iBadge != 0) {
			sPayload += ",\"sound\":\"" + CollEscape(m_sMessageSound) + "\"";
		}

		sPayload += "}";

		DEBUG("Connecting to [" << m_sHost << ":" << m_uPort << "] to send...");
		DEBUG("----------------------------------------------------------------------------");
		DEBUG(sPayload);
		DEBUG("----------------------------------------------------------------------------");

		CSocket *pSock = new CSocket(&m_Parent);
		pSock->Connect(m_sHost, m_uPort, true);
		pSock->Write(sPayload);
		pSock->Close(Csock::CLT_AFTERWRITE);
		m_Parent.AddSocket(pSock);

		return true;
	}

	CString CollEscape(const CString& sStr) const {
		CString sRet(sStr);
		// @todo improve this and eventually support unicode

		sRet.Replace("\\", "\\\\");
		sRet.Replace("\r", "\\r");
		sRet.Replace("\n", "\\n");
		sRet.Replace("\t", "\\t");
		sRet.Replace("\a", "\\a");
		sRet.Replace("\b", "\\b");
		sRet.Replace("\e", "\\e");
		sRet.Replace("\f", "\\f");
		sRet.Replace("\"", "\\\"");

		set<char> ssBadChars; // hack so we don't have to mess around with modifying the string while iterating through it

		for (CString::iterator it = sRet.begin(); it != sRet.end(); it++) {
			if (!isprint(*it)) {
				ssBadChars.insert(*it);
			}
		}

		for (set<char>::iterator b = ssBadChars.begin(); b != ssBadChars.end(); b++) {
			sRet.Replace(CString(*b), ToHex(*b));
		}

		return sRet;
	}

	CString ToHex(const char c) const {
		return "\\u00" + CString(c).Escape_n(CString::EURL).TrimPrefix_n("%");
	}

	bool Parse(const CString& sStr) {
		VCString vsLines;
		sStr.Split("\n", vsLines);

		if (vsLines.size() != 9) {
			DEBUG("Wrong number of lines [" << vsLines.size() << "] [" + sStr + "]");
			for (unsigned int a = 0; a < vsLines.size(); a++) {
				DEBUG("=============== [" + vsLines[a] + "]");
			}

			return false;
		}

		m_sToken = vsLines[0];
		m_sName = vsLines[1];
		m_sHost = vsLines[2].Token(0, false, ":");
		m_uPort = vsLines[2].Token(1, false, ":").ToUInt();
		m_uFlags = vsLines[3].ToUInt();
		m_sConnectionToken = vsLines[4];
		m_sConnectionName = vsLines[5];
		m_sMessageSound = vsLines[6];
		m_sHiliteSound = vsLines[7];
		vsLines[8].Split("\t", m_ssKeywords, false);

		return true;
	}

	CString Serialize() const {
		CString sRet(m_sToken.FirstLine() + "\n"
			+ m_sName.FirstLine() + "\n"
			+ m_sHost.FirstLine() + ":" + CString(m_uPort) + "\n"
			+ CString(m_uFlags) + "\n"
			+ m_sConnectionToken.FirstLine() + "\n"
			+ m_sConnectionName.FirstLine() + "\n"
			+ m_sMessageSound.FirstLine() + "\n"
			+ m_sHiliteSound.FirstLine() + "\n");

		for (SCString::iterator it = m_ssKeywords.begin(); it != m_ssKeywords.end(); it++) {
			if (it != m_ssKeywords.begin()) {
				sRet += "\t";
			}

			sRet += (*it).FirstLine();
		}

		sRet += "\t"; // Hack to work around a bug, @todo remove once fixed

		return sRet;
	}

	// Getters
	CString GetToken() const { return m_sToken; }
	CString GetName() const { return m_sName; }
	CString GetConnectionToken() const { return m_sConnectionToken; }
	CString GetConnectionName() const { return m_sConnectionName; }
	CString GetMessageSound() const { return m_sMessageSound; }
	CString GetHiliteSound() const { return m_sHiliteSound; }
	const SCString& GetKeywords() const { return m_ssKeywords; }
	bool IsConnected() const { return !m_spClients.empty(); }
	bool HasClient(CClient* p) const { return m_spClients.find(p) != m_spClients.end(); }
	CString GetHost() const { return m_sHost; }
	unsigned short GetPort() const { return m_uPort; }
	bool IsNew() const { return m_bNew; }

	// Setters
	void SetToken(const CString& s) { m_sToken = s; }
	void SetName(const CString& s) { m_sName = s; }
	void SetConnectionToken(const CString& s) { m_sConnectionToken = s; }
	void SetConnectionName(const CString& s) { m_sConnectionName = s; }
	void SetMessageSound(const CString& s) { m_sMessageSound = s; }
	void SetHiliteSound(const CString& s) { m_sHiliteSound = s; }
	void AddClient(CClient* p) { m_spClients.insert(p); }
	void SetHost(const CString& s) { m_sHost = s; }
	void SetPort(unsigned short u) { m_uPort = u; }
	void SetNew(bool b = true) { m_bNew = b; }

	// Flags
	void SetFlag(unsigned int u) { m_uFlags |= u; }
	void UnsetFlag(unsigned int u) { m_uFlags &= ~u; }
	bool HasFlag(unsigned int u) const { return m_uFlags & u; }

	enum EFlags {
		Disabled     = 1 << 0,
		IncludeMsg   = 1 << 1,
		IncludeNick  = 1 << 2,
		IncludeChan  = 1 << 3
	};
	// !Flags

	void Reset() {
		m_sToken.clear();
		m_sName.clear();
		m_sConnectionToken.clear();
		m_sConnectionName.clear();
		m_sMessageSound.clear();
		m_sHiliteSound.clear();
		m_sHost.clear();
		m_uPort = 0;
		m_uFlags = 0;
		m_ssKeywords.clear();
	}

private:
	set<CClient*>  m_spClients;
	CModule&       m_Parent;
	bool           m_bNew;
	CString        m_sToken;
	CString        m_sName;
	CString        m_sConnectionToken;
	CString        m_sConnectionName;
	CString        m_sMessageSound;
	CString        m_sHiliteSound;
	SCString       m_ssKeywords;
	CString        m_sHost;
	unsigned short m_uPort;
	unsigned int   m_uFlags;
};


class CColloquyMod : public CModule {
protected:
	int m_idleAfterMinutes;
	int m_lastActivity;
	int m_debug;
	int m_nightHoursStart;
	int m_nightHoursEnd;
	bool m_bAttachedPush;
	bool m_bSkipMessageContent;
	bool m_bAwayOnlyPush;
	bool m_bIgnoreNetworkServices;
public:
	MODCONSTRUCTOR(CColloquyMod) {
		// init vars
		m_bAttachedPush = true;
		m_bSkipMessageContent = false;
		m_bAwayOnlyPush = false;
		m_bIgnoreNetworkServices = false;
		m_idleAfterMinutes=0;
		m_nightHoursStart=-1;
		m_nightHoursEnd=-1;
		m_debug=0;

		LoadRegistry();

		for (MCString::iterator it = BeginNV(); it != EndNV(); it++) {
			CString sKey(it->first);

			if (sKey.TrimPrefix("device::")) {
				CDevice* pDevice = new CDevice(sKey, *this);

				if (!pDevice->Parse(it->second)) {
					DEBUG("  --- Error while parsing device [" + sKey + "]");
					delete pDevice;
					continue;
				}

				m_mspDevices[pDevice->GetToken()] = pDevice;
			} else {
				DEBUG("   --- Unknown registry entry: [" << it->first << "]");
			}
		}
	}

	virtual bool OnLoad(const CString& sArgs, CString& sErrorMsg) {
		SCString sArgSet;

		//Loading stored stuff
		for(MCString::iterator it = BeginNV(); it != EndNV(); it++)
		{
			if(it->first == "u:idle") {
				m_idleAfterMinutes = it->second.ToInt();
			} else if (it->first == "u:attachedpush") {
				m_bAttachedPush = it->second.ToBool();
			} else if (it->first == "u:skipmessagecontent") {
				m_bSkipMessageContent = it->second.ToBool();
			} else if (it->first == "u:awayonlypush") {
				m_bAwayOnlyPush = it->second.ToBool();
			} else if (it->first == "u:ignorenetworkservices") {
				m_bIgnoreNetworkServices = it->second.ToBool();
			} else if (it->first == "u:nighthoursstart") {
				m_nightHoursStart = it->second.ToInt();
			} else if (it->first == "u:nighthoursend") {
				m_nightHoursEnd = it->second.ToInt();
			} else if (it->first == "u:debug") {
				m_debug = it->second.ToInt();
			}
		}

		sArgs.Split("-",sArgSet);
		for ( SCString::iterator it = sArgSet.begin(); it != sArgSet.end(); it++ ) {
			CString sArg(*it);
			sArg.Trim();
			if ( sArg.TrimPrefix("attachedpush") ) {
				m_bAttachedPush = sArg.ToBool();
			} else if ( sArg.TrimPrefix("skipmessagecontent") ) {
				m_bSkipMessageContent = sArg.ToBool();
			} else if ( sArg.TrimPrefix("awayonlypush") ) {
				m_bAwayOnlyPush = sArg.ToBool();
			} else if ( sArg.TrimPrefix("ignorenetworkservices") ) {
				m_bIgnoreNetworkServices = sArg.ToBool();
			}
		}

		return true;
	}

	virtual ~CColloquyMod() {
		for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
			it->second->Save();
			delete it->second;
		}
	}

	virtual EModRet OnUserRaw(CString& sLine) {
		// Trap "ISON *modname" and fake a reply or else colloquy won't let you communicate with *status or *module
		// This is a hack in that it doesn't support multiple users
		const CString& sStatusPrefix = m_pUser->GetStatusPrefix();

		// Assume if we encounter sStatusPrefix on first nick, only controlnicks follow if there are more then one
		if (sLine.Equals("ISON " + sStatusPrefix, false, 5 + sStatusPrefix.size()) ||
		    sLine.Equals("ISON :" + sStatusPrefix, false, 6 + sStatusPrefix.size())) {
			CString sNicks = sLine.Token(1, true);
			if(sNicks[0] == ':')
				sNicks.LeftChomp();
			PutUser(":" + GetNetwork()->GetIRCServer() + " 303 " + GetNetwork()->GetIRCNick().GetNick() + " :" + sNicks);

			return HALTCORE;
		}

		// Trap the PUSH messages that colloquy sends to give us info about the client
		if (sLine.TrimPrefix("PUSH ")) {
			if (sLine.TrimPrefix("add-device ")) {
				CString sToken(sLine.Token(0));
				CDevice* pDevice = FindDevice(sToken);

				if (!pDevice) {
					pDevice = new CDevice(sToken, *this);
					pDevice->SetNew();
					m_mspDevices[pDevice->GetToken()] = pDevice;
				}

				pDevice->Reset();
				pDevice->SetToken(sToken);
				pDevice->SetName(sLine.Token(1, true).TrimPrefix_n(":"));
				pDevice->AddClient(m_pClient);
			} else if (sLine.TrimPrefix("remove-device :")) {
				CDevice* pDevice = FindDevice(sLine);

				if (pDevice) {
					pDevice->SetFlag(CDevice::Disabled);
					//PutModule("Disabled phone [" + pDevice->GetName() + "]");
					m_pUser->PutModule(GetModName(), "Disabled phone [" + pDevice->GetName() + "]", NULL, m_pClient);
				}
			} else {
				CDevice* pDevice = FindDevice(m_pClient);

				if (pDevice) {
					if (sLine.TrimPrefix("connection ")) {
						pDevice->SetConnectionToken(sLine.Token(0));
						pDevice->SetConnectionName(sLine.Token(1, true).TrimPrefix_n(":"));
					} else if (sLine.TrimPrefix("service ")) {
						pDevice->SetHost(sLine.Token(0));
						pDevice->SetPort(sLine.Token(1).ToUInt());
					} else if (sLine.TrimPrefix("highlight-word :")) {
						pDevice->AddKeyword(sLine);
					} else if (sLine.TrimPrefix("highlight-sound :")) {
						pDevice->SetHiliteSound(sLine);
					} else if (sLine.TrimPrefix("message-sound :")) {
						pDevice->SetMessageSound(sLine);
					} else if (sLine.Equals("end-device")) {
						if (!pDevice->Save()) {
							PutModule("Unable to save phone [" + pDevice->GetName() + "]");
						} else {
							if (pDevice->IsNew()) {
								pDevice->SetNew(false);
								m_pUser->PutModule(GetModName(), "Added new phone [" + pDevice->GetName() + "] to the system", NULL, m_pClient);
							}
						}
					} else {
						DEBUG("---------------------------------------------------------------------- PUSH ERROR [" + sLine + "]");
					}
				} else {
					DEBUG("No pDevice defined for this client!");
				}
			}

			return HALT;
		}

		return CONTINUE;
	}

	CDevice* FindDevice(const CString& sToken) {
		map<CString, CDevice*>::iterator it = m_mspDevices.find(sToken);

		if (it != m_mspDevices.end()) {
			return it->second;
		}

		return NULL;
	}

	CDevice* FindDevice(CClient* pClient) {
		for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
			if (it->second->HasClient(pClient)) {
				return it->second;
			}
		}

		return NULL;
	}

	virtual EModRet OnPrivNotice(CNick& Nick, CString& sMessage) {
		Push(Nick.GetNick(), sMessage, "", false, 1);
		return CONTINUE;
	}

	virtual EModRet OnChanNotice(CNick& Nick, CChan& Channel, CString& sMessage) {
		Push(Nick.GetNick(), sMessage, Channel.GetName(), true, 1);
		return CONTINUE;
	}

	virtual EModRet OnPrivMsg(CNick& Nick, CString& sMessage) {
		Push(Nick.GetNick(), sMessage, "", false, 1);
		return CONTINUE;
	}

	virtual EModRet OnChanMsg(CNick& Nick, CChan& Channel, CString& sMessage) {
		Push(Nick.GetNick(), sMessage, Channel.GetName(), true, 1);
		return CONTINUE;
	}

	virtual CString intToHours(int ihour) {
		if (ihour<0) {
			return "---";
		}
		int minutes = (ihour%60);
		CString cMinutes;
		if (minutes<10) {
			cMinutes="0"+CString(minutes);
		} else {
			cMinutes=CString(minutes);
		}
		int hours= (ihour-minutes)/60;
		CString cHour=CString(hours);
		return cHour+":"+cMinutes;
	}

	virtual int hoursToInt(CString chour) {
		int len=chour.length();
		int colon=chour.find(":");
		if (((colon==1) && (len==4)) || ((colon==2) && (len==5))) {//only valid hours
			int hour;
			int minutes;
			if (colon==1) {
				hour=atoi(chour.substr(0,1).c_str());
				minutes=atoi(chour.substr(2,2).c_str());
			} else {
				hour=atoi(chour.substr(0,2).c_str());
				minutes=atoi(chour.substr(3,2).c_str());
			}
			return hour*60+minutes;
		} else {
			return -1;
		}

	}

	virtual void OnModCommand(const CString& sCommand) {
		if (sCommand.Equals("HELP")) {
			PutModule("Commands: HELP, LIST, SET <option>");
			PutModule("Command: LIST");
			PutModule("  List devices that receive notifications.");
			PutModule("Command: STATUS");
			PutModule("  Shows the active settings.");
			PutModule("Command: SET awayonlypush 0|1");
			PutModule("  If enabled, send notifications only if away.");
			PutModule("Command: SET attachedpush 0|1");
			PutModule("  If enabled, push notifications will be sent even if a client is connected.");
			PutModule("Command: SET skipmessagecontent 0|1");
			PutModule("  If enabled, znc won't push the content of the message.");
			PutModule("Command: SET idle <minutes>");
			PutModule("  If attachedpush is enabled, wait for 'idle' minutes before pushing messages.");
			PutModule("Command: SET nighthours <start> <end>");
			PutModule("  Don't send notifications after nighthours start and before nighthours end.");
			PutModule("Command: SET ignorenetworkservices 0|1");
			PutModule("  Enable this to stop receiving notifications from IRC services.");
		} else if (sCommand.Equals("LIST")) {
			if (m_mspDevices.empty()) {
				PutModule("You have no saved devices...");
				PutModule("Connect to znc using your mobile colloquy client...");
				PutModule("Make sure to enable push if it isn't already!");
			} else {
				CTable Table;
				Table.AddColumn("Phone");
				Table.AddColumn("Connection");
				Table.AddColumn("MsgSound");
				Table.AddColumn("HiliteSound");
				Table.AddColumn("Status");
				Table.AddColumn("Keywords");

				for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
					CDevice* pDevice = it->second;

					Table.AddRow();
					Table.SetCell("Phone", pDevice->GetName());
					Table.SetCell("Connection", pDevice->GetConnectionName());
					Table.SetCell("MsgSound", pDevice->GetMessageSound());
					Table.SetCell("HiliteSound", pDevice->GetHiliteSound());
					Table.SetCell("Status", pDevice->HasFlag(CDevice::Disabled) ? "Disabled" : (pDevice->IsConnected() ? "Connected" : "Offline"));

					const SCString& ssWords = pDevice->GetKeywords();

					if (!ssWords.empty()) {
						CString sWords;
						sWords = "[";

						for (SCString::iterator it2 = ssWords.begin(); it2 != ssWords.end(); it2++) {
							if (it2 != ssWords.begin()) {
								sWords += "]  [";
							}

							sWords += *it2;
						}

						sWords += "]";

						Table.SetCell("Keywords", sWords);
					}
				}

				PutModule(Table);
			}
		} else if(sCommand.Token(0).Equals("SET")) {
			const CString sKey = sCommand.Token(1).AsLower();
			if (sKey == "idle") {
				m_idleAfterMinutes=sCommand.Token(2).ToInt();
				PutModule("Idle time: '"+CString(m_idleAfterMinutes)+"'");
			} else if ( sKey == "awayonlypush" ) {
				m_bAwayOnlyPush=sCommand.Token(2).ToBool();
				PutModule("Push only if away: '"+CString(m_bAwayOnlyPush)+"'");
			} else if ( sKey == "attachedpush" ) {
				m_bAttachedPush=sCommand.Token(2).ToBool();
				PutModule("Push even if clients are attached: '"+CString(m_bAttachedPush)+"'");
			} else if ( sKey == "ignorenetworkservices" ) {
				m_bIgnoreNetworkServices=sCommand.Token(2).ToBool();
				PutModule("Ignore network services: '"+CString(m_bIgnoreNetworkServices)+"'");
			} else if (sKey == "debug") {
				m_debug=sCommand.Token(2).ToInt();
				PutModule("Debug: '"+CString(m_debug)+"'");
			} else if (sKey == "nighthours") {
				m_nightHoursStart=hoursToInt(sCommand.Token(2));
				m_nightHoursEnd=hoursToInt(sCommand.Token(3));
				PutModule("Night Hours: "+intToHours(m_nightHoursStart)+" - "+intToHours(m_nightHoursEnd));
			}	else if ( sKey == "skipmessagecontent" ) {
				m_bSkipMessageContent=sCommand.Token(2).ToBool();
				PutModule("Skip Message Content: '"+CString(m_bSkipMessageContent)+"'");
			} else {
				PutModule("Unknown setting. Try HELP.");
			}

			//Save stored stuff
			//ClearNV(); //Dangerous, NV holds devices
			SetNV("u:idle", CString(m_idleAfterMinutes), false);
			SetNV("u:awayonlypush", CString(m_bAwayOnlyPush), false);
			SetNV("u:attachedpush", CString(m_bAttachedPush), false);
			SetNV("u:skipmessagecontent", CString(m_bSkipMessageContent), false);
			SetNV("u:ignorenetworkservices", CString(m_bIgnoreNetworkServices), false);
			SetNV("u:debug", CString(m_debug), false);
			SetNV("u:nighthoursstart", CString(m_nightHoursStart), false);
			SetNV("u:nighthoursend", CString(m_nightHoursEnd), false);
		} else if (sCommand.Token(0).Equals("STATUS")) {
			CTable Table;
			Table.AddColumn("Option");
			Table.AddColumn("Value");

			Table.AddRow();
			Table.SetCell("Option","Push only if away");
			Table.SetCell("Value",CString(m_bAwayOnlyPush));

			Table.AddRow();
			Table.SetCell("Option","Push even if clients are attached");
			Table.SetCell("Value",CString(m_bAttachedPush));

			Table.AddRow();
			Table.SetCell("Option","Skip Message Content");
			Table.SetCell("Value",CString(m_bSkipMessageContent));

			Table.AddRow();
			Table.SetCell("Option","- only if idle for");
			if ( m_idleAfterMinutes > 0 )
				Table.SetCell("Value",CString(m_idleAfterMinutes) + " minutes");
			else
				Table.SetCell("Value","Always");

			Table.AddRow();
			Table.SetCell("Option","");
			Table.SetCell("Value","");

			Table.AddRow();
			Table.SetCell("Option","Night Hours (no push)");
			Table.SetCell("Value",intToHours(m_nightHoursStart)+" - "+intToHours(m_nightHoursEnd));

			Table.AddRow();
			Table.SetCell("Option","Ignore network services");
			Table.SetCell("Value",CString(m_bIgnoreNetworkServices));

			PutModule("  Current Status");
			PutModule(Table);
		/*
		} else if (sCommand.Token(0).Equals("REMKEYWORD")) {
			CString sKeyword(sCommand.Token(1, true));

			if (sKeyword.empty()) {
				PutModule("Usage: RemKeyWord <keyword/phrase>");
				return;
			} else {
				// @todo probably want to make this global and let each device manage its own keywords
				for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
					it->second->RemKeyword(sKeyword);
				}

				PutModule("Removed keyword [" + sKeyword + "]");
			}
		} else if (sCommand.Token(0).Equals("ADDKEYWORD")) {
			CString sKeyword(sCommand.Token(1, true));

			if (sKeyword.empty()) {
				PutModule("Usage: AddKeyWord <keyword/phrase>");
				return;
			} else {
				// @todo probably want to make this global and let each device manage its own keywords
				for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
					it->second->AddKeyword(sKeyword);
				}

				PutModule("Added keyword [" + sKeyword + "]");
			}
		} else if (sCommand.Equals("LISTNV")) {
			if (BeginNV() == EndNV()) {
				PutModule("No NVs!");
			} else {
				for (MCString::iterator it = BeginNV(); it != EndNV(); it++) {
					PutModule(it->first + ": " + it->second);
				}
			}
		*/
		}
	}

	bool Test(const CString& sKeyWord, const CString& sString) {
		return (!sKeyWord.empty() && (
			sString.Equals(sKeyWord + " ", false, sKeyWord.length() +1)
			|| sString.Right(sKeyWord.length() +1).Equals(" " + sKeyWord)
			|| sString.AsLower().WildCmp("* " + sKeyWord.AsLower() + " *")
			|| (sKeyWord.find_first_of("*?") != CString::npos && sString.AsLower().WildCmp(sKeyWord.AsLower()))
		));
	}

	bool Push(const CString& sNick, const CString& sMessage, const CString& sChannel, bool bHilite, int iBadge) {
		if (iBadge != 0 && !m_bAttachedPush && m_pUser->IsUserAttached()) {
			return false;
		}

		if (iBadge != 0) {
			CUser* pUser = GetUser();
			if (pUser && m_bAwayOnlyPush && !(GetNetwork()->IsIRCAway())) {
				return false;
			}
		}

		if ( m_bIgnoreNetworkServices ) {
			if ( sNick.Equals("NickServ") or sNick.Equals("ChanServ") or sNick.Equals("MemoServ") or sNick.Equals("HostServ") ) {
				return false;
			}
		}

		CString sPushMessage = sMessage;
		if (m_bSkipMessageContent && !sMessage.Equals("")) {
			sPushMessage = "";
			if (!bHilite) {
			    sPushMessage = "Private messsage from " + sNick;
			}
		}

		//Check nightHours
		bool bNightHours=false;
		if ((m_nightHoursStart>-1) && (m_nightHoursEnd>-1)) {
			time_t ww;
			time(&ww);
			struct tm* lt=localtime(&ww);
			int minutes=lt->tm_hour*60+lt->tm_min;
			if ((m_nightHoursStart && (minutes>=m_nightHoursStart)) || (m_nightHoursEnd && (minutes<m_nightHoursEnd))) {
				bNightHours=true;
			}
			//PutModule(CString(m_nightHoursStart) + ";"  + CString(m_nightHoursEnd) + "=" + CString(minutes));
		}
		if (bNightHours) {
			return false;
		}


		//Check idleTimer
		bool bIsNotIdle = false;
		// only check idle time if someone is attached
		if (m_idleAfterMinutes>0 && m_pUser->IsUserAttached()) {
			bIsNotIdle = (m_lastActivity > (time(NULL)-m_idleAfterMinutes*60));
		}
		if (bIsNotIdle) {
			return false;
		}

		bool bRet = true;
		const vector<CClient*>& vpClients = GetNetwork()->GetClients();

		// Cycle through all of the cached devices
		for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
			CDevice* pDevice = it->second;

			// Determine if this cached device has a client still connected
			bool bFound = false;

			for (vector<CClient*>::size_type a = 0; a < vpClients.size(); a++) {
				if (pDevice->HasClient(vpClients[a])) {
					bFound = true;
					break;
				}
			}

			// If the current cached device was found to still be connected, don't push the msg
			// unless we're trying to set badge to 0
			if (bFound && iBadge != 0) {
				return false;
			}

			// If it's a highlight, then we need to make sure it matches a highlited word
			if (bHilite) {
				// Test our current irc nick
				const CString& sMyNick(GetNetwork()->GetIRCNick().GetNick());
				bool bMatches = Test(sMyNick, sMessage) || Test(sMyNick + "?*", sMessage);

				// If our nick didn't match, test the list of keywords for this device
				if (!bMatches) {
					const SCString& ssWords = pDevice->GetKeywords();

					for (SCString::iterator it2 = ssWords.begin(); it2 != ssWords.end(); it2++) {
						if (Test(*it2, sMessage)) {
							bMatches = true;
							break;
						}
					}
				}

				if (!bMatches) {
					return false;
				} else if (m_bSkipMessageContent) {
					sPushMessage = "Highlighted message";
				}
			}

			if (m_debug) {
			PutModule("debug: idleTest Pass... "+CString(m_lastActivity) + " < " + CString(time(NULL)-m_idleAfterMinutes*60)+" | #" +sChannel + " "+sMessage);
			}
			if (!pDevice->Push(sNick, sPushMessage, sChannel, bHilite, iBadge)) {
				bRet = false;
			}
		}

		return bRet;
	}

	virtual void OnClientLogin() {
		// Clear all badges on a client login
		// this could be easily modded to only clear them for the connecting client
		Push("","","",false,0);
	}

	virtual void OnClientDisconnect() {
		for (map<CString, CDevice*>::iterator it = m_mspDevices.begin(); it != m_mspDevices.end(); it++) {
			it->second->RemoveClient(m_pClient);
		}
	}


	EModRet OnUserAction(CString& sTarget, CString& sMessage) {
		m_lastActivity = time(NULL);
		if (m_debug) {
			PutModule("debug: lastActivity updated for UserAction to "+sTarget +" ("+CString(m_lastActivity)+")");
		}
		return CONTINUE;
	}
	EModRet OnUserMsg(CString& sTarget, CString& sMessage) {
		m_lastActivity = time(NULL);
		if (m_debug) {
			PutModule("debug: lastActivity updated for UserMsg to "+sTarget +" ("+CString(m_lastActivity)+")");
		}
		return CONTINUE;
	}
	EModRet OnUserNotice(CString& sTarget, CString& sMessage) {
		m_lastActivity = time(NULL);
		if (m_debug) {
			PutModule("debug: lastActivity updated for UserNotice to "+sTarget +" ("+CString(m_lastActivity)+")");
		}
		return CONTINUE;
	}
	EModRet OnUserJoin(CString& sChannel, CString& sKey) {
		m_lastActivity = time(NULL);
		if (m_debug) {
			PutModule("debug: lastActivity updated for UserJoin to "+sChannel +" ("+CString(m_lastActivity)+")");
		}
		return CONTINUE;
	}
	EModRet OnUserPart(CString& sChannel, CString& sMessage) {
		m_lastActivity = time(NULL);
		if (m_debug) {
			PutModule("debug: lastActivity updated for UserJoin to "+sChannel +" ("+CString(m_lastActivity)+")");
		}
		return CONTINUE;
	}
private:
	map<CString, CDevice*>	m_mspDevices;	// map of token to device info for clients who have sent us PUSH info
};
MODULEDEFS(CColloquyMod, "Push privmsgs and highlights to your iOS device via Colloquy Mobile")
