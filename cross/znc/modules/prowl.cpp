/*
 * Copyright (C) 2009 flakes @ EFNet
 * tweaked by Gm4n @ freenode
 * Version 0.9.5-2 (2009-11-9)
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#define REQUIRESSL

#include "znc.h"
#include "User.h"
#include "Chan.h"
#include "Nick.h"
#include "Modules.h"

#if (!defined(VERSION_MAJOR) || !defined(VERSION_MINOR) || (VERSION_MAJOR == 0 && VERSION_MINOR < 72))
#error This module needs ZNC 0.072 or newer.
#endif

class CProwlMod : public CModule
{
protected:
	CString m_host;
	CString m_apiKey;
	int m_priority;
	int m_idleAfterMinutes;
	bool m_onlyWhenDetached;
	bool m_pmWhenDetached;
	bool m_pmAll;
	VCString m_highlights;
	unsigned int m_notificationsSent;

	time_t m_lastActivity;

public:
	MODCONSTRUCTOR(CProwlMod)
	{
		m_host = "prowl.weks.net";

		// defaults:
		m_priority = 1;
		m_idleAfterMinutes = 5;
		m_onlyWhenDetached = false;
		m_pmWhenDetached = false;
		m_pmAll = false;
		// defaults end.

		m_notificationsSent = 0;
		m_lastActivity = time(NULL);
	}

protected:
	static CString URLEscape(const CString& sStr)
	{
		return sStr.Escape_n(CString::EASCII, CString::EURL);
	}

	CString MakeRequest(const CString& sDescription)
	{
		CString s;

		s += "GET /publicapi/add";
		s += "?apikey=" + URLEscape(m_apiKey);
		s += "&priority=" + CString(m_priority);
		s += "&application=ZNC";
		s += "&event=" + URLEscape(m_pUser->GetCurNick());
		s += "&description=" + URLEscape(sDescription);

		s += " HTTP/1.0\r\n";
		s += "Connection: close\r\n";
		s += "Host: " + m_host + "\r\n";
		s += "User-Agent: " + CZNC::GetTag() + "\r\n";
		s += "\r\n";

		return s;
	}

	void SendNotification(const CString& sMessage)
	{
		if(!m_apiKey.empty())
		{
			CSocket *p = new CSocket(this);
			p->Connect(m_host, 443, true); // connect to host at port 443 using SSL
			p->Write(MakeRequest(sMessage));
			p->Close(Csock::CLT_AFTERWRITE); // discard the response...
			AddSocket(p);

			m_notificationsSent++;
		}
	}

	void CheckHighlight(const CString& sNick, const CString& sChannel, const CString& sMessage)
	{
		if(!m_pUser) return;

		// m_idleAfterMinutes < 1 == don't use the "idle feature"
		bool bUseIdleFeature = (m_idleAfterMinutes > 0);
		bool bUserAttached = m_pUser->IsUserAttached();
		bool bIsIdle = (m_lastActivity < time(NULL) - m_idleAfterMinutes * 60 || !bUserAttached);

		if(((bUseIdleFeature && bIsIdle) || !bUseIdleFeature) && (!m_onlyWhenDetached || !bUserAttached))
		{
			const CString sLcMessage = sMessage.AsLower();
			bool bFound = (sLcMessage.find(m_pUser->GetCurNick().AsLower()) != CString::npos);
			bFound |= (sChannel == "(priv)" && m_pmAll);
			
			for(VCString::iterator it = m_highlights.begin();
				!bFound && it != m_highlights.end();
				it++)
			{
				bFound = (sLcMessage.find((*it).AsLower()) != CString::npos);
			}

			if(bFound)
			{
				SendNotification("<" + sNick + "> on " + sChannel + ": " + sMessage);
			}
		}
		else if(m_pmWhenDetached && !bUserAttached && sChannel == "(priv)")
		{
				SendNotification("<" + sNick + "> on " + sChannel + ": " + sMessage);
		}
	}

	void LoadSettings()
	{
		for(MCString::iterator it = BeginNV(); it != EndNV(); it++)
		{
			if(it->first == "api:key")
			{
				m_apiKey = it->second;
			}
			else if(it->first == "api:priority")
			{
				m_priority = it->second.ToInt();
			}
			else if(it->first == "u:idle")
			{
				m_idleAfterMinutes = it->second.ToInt();
			}
			else if(it->first == "u:onlydetached")
			{
				m_onlyWhenDetached = (it->second != "0");
			}
			else if(it->first == "u:highlights")
			{
				it->second.Split("\n", m_highlights, false);
			}
			else if(it->first == "u:pmdetached")
			{
				m_pmWhenDetached = (it->second != "0");
			}
			else if(it->first == "u:pmall")
			{
				m_pmAll = (it->second != "0");
			}
		}
	}

	void SaveSettings()
	{
		ClearNV();

		SetNV("api:key", m_apiKey, false);
		SetNV("api:priority", CString(m_priority), false);
		SetNV("u:idle", CString(m_idleAfterMinutes), false);
		SetNV("u:onlydetached", (m_onlyWhenDetached ? "1" : "0"), false);
		SetNV("u:pmdetached", (m_pmWhenDetached ? "1" : "0"), false);
		SetNV("u:pmall", (m_pmAll ? "1" : "0"), false);
		
		CString sTmp;
		for(VCString::const_iterator it = m_highlights.begin(); it != m_highlights.end(); it++) { sTmp += *it + "\n"; }

		SetNV("u:highlights", sTmp, true);
	}

	bool OnLoad(const CString& sArgs, CString& sMessage)
	{
		LoadSettings();
		return true;
	}
public:
	void OnModCommand(const CString& sCommand)
	{
		const CString sCmd = sCommand.Token(0).AsUpper();

		if(sCmd == "HELP")
		{
			CTable CmdTable;

			CmdTable.AddColumn("Command");
			CmdTable.AddColumn("Description");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET apikey <key>");
			CmdTable.SetCell("Description", "Use this to set your prowl API key.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET priority <number>");
			CmdTable.SetCell("Description", "Sets the prowl notifications' priority.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET idle <minutes>");
			CmdTable.SetCell("Description", "Only send notifications to prowl if you have been idle for at least <minutes> or no client is connected to ZNC.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET onlydetached (on|off)");
			CmdTable.SetCell("Description", "On means 'never send notifications when a client is connected to ZNC'.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET pmdetached (on|off)");
			CmdTable.SetCell("Description", "On means 'send notifications of all PMs when no client is connected to ZNC'.");
			
			CmdTable.AddRow();
			CmdTable.SetCell("Command", "SET pmall (on|off)");
			CmdTable.SetCell("Description", "On means 'treat every PM as a highlight'.");
			
			CmdTable.AddRow();
			CmdTable.SetCell("Command", "HIGHLIGHTS");
			CmdTable.SetCell("Description", "Shows additional words (besides your current nick) that trigger a notification.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "HIGHLIGHTS ADD <word>");
			CmdTable.SetCell("Description", "Adds a word or string to match and notify.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "HIGHLIGHTS REMOVE <index>");
			CmdTable.SetCell("Description", "Removes a word from the highlights list.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "STATUS");
			CmdTable.SetCell("Description", "Shows the active settings.");

			CmdTable.AddRow();
			CmdTable.SetCell("Command", "HELP");
			CmdTable.SetCell("Description", "This help.");

			PutModule(CmdTable);
		}
		else if(sCmd == "SET" || sCmd == "CHANGE")
		{
			const CString sKey = sCommand.Token(1).AsLower();

			if(sKey == "apikey")
			{
				m_apiKey = sCommand.Token(2);
				PutModule("API key set!");
			}
			else if(sKey == "priority")
			{
				m_priority = sCommand.Token(2).ToInt();
				PutModule("Priority set to '" + CString(m_priority) + "'!");
			}
			else if(sKey == "idle")
			{
				m_idleAfterMinutes = sCommand.Token(2).ToInt();
				PutModule("Idle time set to '" + CString(m_idleAfterMinutes) + "'!");
			}
			else if(sKey == "onlydetached")
			{
				const CString sTmp = sCommand.Token(2).AsLower(); 
				m_onlyWhenDetached = (sTmp != "off" && sTmp != "false" && sTmp != "0" && sTmp != "no");
				PutModule("Setting changed to '" + CString(m_onlyWhenDetached ? "on" : "off") + "'!");
			}
			else if(sKey == "pmdetached")
			{
				const CString sTmp = sCommand.Token(2).AsLower(); 
				m_pmWhenDetached = (sTmp != "off" && sTmp != "false" && sTmp != "0" && sTmp != "no");
				PutModule("Setting changed to '" + CString(m_pmWhenDetached ? "on" : "off") + "'!");
			}
			else if(sKey == "pmall")
			{
				const CString sTmp = sCommand.Token(2).AsLower(); 
				m_pmAll = (sTmp != "off" && sTmp != "false" && sTmp != "0" && sTmp != "no");
				PutModule("Setting changed to '" + CString(m_pmAll ? "on" : "off") + "'!");
			}
			else
			{
				PutModule("Unknown setting. Try HELP.");
			}
			
			SaveSettings();
		}
		else if(sCmd == "HIGHLIGHTS" || sCmd == "HIGHLIGHT" || sCmd == "HILIGHTS" || sCmd == "HILIGHT")
		{
			const CString sSubCmd = sCommand.Token(1).AsUpper();

			if(sSubCmd == "")
			{
				size_t iIndex = 1;

				PutModule("Active additional highlights:");

				for(VCString::const_iterator it = m_highlights.begin(); it != m_highlights.end(); it++)
				{
					PutModule(CString(iIndex) + ": " + *it);
					iIndex++;
				}

				PutModule("--End of list");
			}
			else if(sSubCmd == "ADD")
			{
				const CString sParam = sCommand.Token(2, true);

				if(!sParam.empty())
				{
					m_highlights.push_back(sParam);
					PutModule("Entry '" + sParam + "' added.");
					SaveSettings();
				}
				else
				{
					PutModule("Usage: HIGHTLIGHTS ADD <string>");
				}
			}
			else if(sSubCmd == "REMOVE" || sSubCmd == "DELETE")
			{
				size_t iIndex = sCommand.Token(2).ToUInt();

				if(iIndex > 0 && iIndex <= m_highlights.size())
				{
					m_highlights.erase(m_highlights.begin() + iIndex - 1);
					PutModule("Entry removed.");
					SaveSettings();
				}
				else
				{
					PutModule("Invalid list index.");
				}
			}
			else
			{
				PutModule("Unknown action. Try HELP.");
			}
		}
		else if(sCmd == "STATUS" || sCmd == "SHOW")
		{
			CTable CmdTable;

			CmdTable.AddColumn("What");
			CmdTable.AddColumn("Status");

			CmdTable.AddRow();
			CmdTable.SetCell("What", "API Settings");
			CmdTable.SetCell("Status", "Key = '" + CString(m_apiKey) + "', Priority = '" + CString(m_priority) + "'.");

			CmdTable.AddRow();
			CmdTable.SetCell("What", "Notification Parameters");
			CmdTable.SetCell("Status", "Idle time = '" + CString(m_idleAfterMinutes) + " minutes', Only when detached = '" + CString(m_onlyWhenDetached ? "on" : "off") + "', All PMs when detached = '" + CString(m_pmWhenDetached ? "on" : "off") + "', PMs always match = '" + CString(m_pmAll ? "on" : "off") + "'.");

			CmdTable.AddRow();
			CmdTable.SetCell("What", "Additional highlights");
			CmdTable.SetCell("Status", CString(m_highlights.size()));

			CmdTable.AddRow();
			CmdTable.SetCell("What", "Notifications sent");
			CmdTable.SetCell("Status", CString(m_notificationsSent));

			PutModule(CmdTable);
		}
		else
		{
			PutModule("Unknown command! Try HELP.");
		}
	}

	EModRet OnPrivMsg(CNick& Nick, CString& sMessage)
	{
		CheckHighlight(Nick.GetNick(), "(priv)", sMessage);
		return CONTINUE;
	}

	EModRet OnChanMsg(CNick& Nick, CChan& Channel, CString& sMessage)
	{
		CheckHighlight(Nick.GetNick(), Channel.GetName(), sMessage);
		return CONTINUE;
	}

	EModRet OnPrivAction(CNick& Nick, CString& sMessage)
	{
		CheckHighlight(Nick.GetNick(), "(priv)", sMessage);
		return CONTINUE;
	}

	EModRet OnChanAction(CNick& Nick, CChan& Channel, CString& sMessage)
	{
		CheckHighlight(Nick.GetNick(), Channel.GetName(), sMessage);
		return CONTINUE;
	}

	EModRet OnUserAction(CString& sTarget, CString& sMessage) { m_lastActivity = time(NULL); return CONTINUE; }
	EModRet OnUserMsg(CString& sTarget, CString& sMessage) { m_lastActivity = time(NULL); return CONTINUE; }
	EModRet OnUserNotice(CString& sTarget, CString& sMessage) { m_lastActivity = time(NULL); return CONTINUE; }
	EModRet OnUserJoin(CString& sChannel, CString& sKey) { m_lastActivity = time(NULL); return CONTINUE; }
	EModRet OnUserPart(CString& sChannel, CString& sMessage) { m_lastActivity = time(NULL); return CONTINUE; }
};

MODULEDEFS(CProwlMod, "Sends nick highlights to prowl.")
