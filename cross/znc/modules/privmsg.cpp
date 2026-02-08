/*
 * Copyright (C) 2004-2012  See the AUTHORS file for details.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <znc/IRCNetwork.h>
#include <znc/Modules.h>

class CPrivMsgMod : public CModule {
public:
	MODCONSTRUCTOR(CPrivMsgMod) {}

	virtual EModRet OnUserMsg(CString& sTarget, CString& sMessage) {
		if (m_pNetwork && m_pNetwork->GetIRCSock() && !m_pNetwork->IsChan(sTarget)) {
			m_pNetwork->PutUser(":" + m_pNetwork->GetIRCNick().GetNickMask() + " PRIVMSG " + sTarget + " :" + sMessage, NULL, m_pClient);
		}

		return CONTINUE;
	}

	virtual EModRet OnUserAction(CString& sTarget, CString& sMessage) {
		if (m_pNetwork && m_pNetwork->GetIRCSock() && !m_pNetwork->IsChan(sTarget)) {
			m_pNetwork->PutUser(":" + m_pNetwork->GetIRCNick().GetNickMask() + " PRIVMSG " + sTarget + " :\x01" + "ACTION " + sMessage + "\x01", NULL, m_pClient);
		}

		return CONTINUE;
	}
};

template<> void TModInfo<CPrivMsgMod>(CModInfo& Info) {
	Info.SetWikiPage("privmsg");
	Info.AddType(CModInfo::NetworkModule);
	Info.AddType(CModInfo::GlobalModule);
}

USERMODULEDEFS(CPrivMsgMod, "Send outgoing PRIVMSGs and CTCP ACTIONs to other clients")

