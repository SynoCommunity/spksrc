/*
 * Copyright (C) 2004-2014  See the AUTHORS file for details.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#include <znc/Modules.h>
#include <znc/IRCNetwork.h>
#include <znc/Client.h>
#include <znc/Buffer.h>
#include <znc/Utils.h>
#include <znc/Query.h>
#include <znc/Chan.h>
#include <znc/znc.h>
#include <sys/time.h>
#include <cfloat>

static const char* PlaybackCap = "znc.in/playback";
static const char* EchoMessageCap = "znc.in/echo-message";

class CPlaybackMod : public CModule
{
public:
    MODCONSTRUCTOR(CPlaybackMod)
    {
        m_play = false;
        AddHelpCommand();
        AddCommand("Clear", static_cast<CModCommand::ModCmdFunc>(&CPlaybackMod::ClearCommand), "<buffer(s)>", "Clears playback for given buffers.");
        AddCommand("Play", static_cast<CModCommand::ModCmdFunc>(&CPlaybackMod::PlayCommand), "<buffer(s)> [from] [to]", "Sends playback for given buffers.");
        AddCommand("List", static_cast<CModCommand::ModCmdFunc>(&CPlaybackMod::ListCommand), "[buffer(s)]", "Lists available/matching buffers.");
        AddCommand("Limit", static_cast<CModCommand::ModCmdFunc>(&CPlaybackMod::LimitCommand), "<client> [limit]", "Get/set the buffer limit (<= 0 to clear) for the given client.");
    }

    void OnClientCapLs(CClient* client, SCString& caps) override
    {
        caps.insert(PlaybackCap);
        caps.insert(EchoMessageCap);
    }

    bool IsClientCapSupported(CClient* client, const CString& cap, bool state) override
    {
        return cap.Equals(PlaybackCap) || cap.Equals(EchoMessageCap);
    }

    EModRet OnChanBufferStarting(CChan& chan, CClient& client) override
    {
        if (!m_play && client.IsCapEnabled(PlaybackCap))
            return HALTCORE;
        return CONTINUE;
    }

    EModRet OnChanBufferPlayLine(CChan& chan, CClient& client, CString& line) override
    {
        if (!m_play && client.IsCapEnabled(PlaybackCap))
            return HALTCORE;
        return CONTINUE;
    }

    EModRet OnChanBufferEnding(CChan& chan, CClient& client) override
    {
        if (!m_play && client.IsCapEnabled(PlaybackCap))
            return HALTCORE;
        return CONTINUE;
    }

    EModRet OnPrivBufferPlayLine(CClient& client, CString& line) override
    {
        if (!m_play && client.IsCapEnabled(PlaybackCap))
            return HALTCORE;
        return CONTINUE;
    }

    void ClearCommand(const CString& line)
    {
        // CLEAR <buffer(s)>
        const CString arg = line.Token(1);
        if (arg.empty() || !line.Token(2).empty())
            return;
        std::vector<CChan*> chans = FindChans(arg);
        for (CChan* chan : chans)
            chan->ClearBuffer();
        std::vector<CQuery*> queries = FindQueries(arg);
        for (CQuery* query : queries)
            query->ClearBuffer();
    }

    void PlayCommand(const CString& line)
    {
        // PLAY <buffer(s)> [from] [to]
        const CString arg = line.Token(1);
        if (arg.empty() || !line.Token(4).empty())
            return;
        double from = line.Token(2).ToDouble();
        double to = DBL_MAX;
        if (!line.Token(3).empty())
            to = line.Token(3).ToDouble();
        int limit = -1;
        if (CClient* client = GetClient())
            limit = GetLimit(client->GetIdentifier());
        std::vector<CChan*> chans = FindChans(arg);
        for (CChan* chan : chans) {
            if (chan->IsOn() && !chan->IsDetached()) {
                CBuffer lines = GetLines(chan->GetBuffer(), from, to, limit);
                m_play = true;
                chan->SendBuffer(GetClient(), lines);
                m_play = false;
            }
        }
        std::vector<CQuery*> queries = FindQueries(arg);
        for (CQuery* query : queries) {
            CBuffer lines = GetLines(query->GetBuffer(), from, to, limit);
            m_play = true;
            query->SendBuffer(GetClient(), lines);
            m_play = false;
        }
    }

    void ListCommand(const CString& line)
    {
        // LIST [buffer(s)]
        CString arg = line.Token(1);
        if (arg.empty())
            arg = "*";
        std::vector<CChan*> chans = FindChans(arg);
        for (CChan* chan : chans) {
            if (chan->IsOn() && !chan->IsDetached()) {
                CBuffer buffer = chan->GetBuffer();
                if (!buffer.IsEmpty()) {
                    timeval from = UniversalTime(buffer.GetBufLine(0).GetTime());
                    timeval to = UniversalTime(buffer.GetBufLine(buffer.Size() - 1).GetTime());
                    PutModule(chan->GetName() + " " + CString(Timestamp(from)) + " " + CString(Timestamp(to)));
                }
            }
        }
        std::vector<CQuery*> queries = FindQueries(arg);
        for (CQuery* query : queries) {
            CBuffer buffer = query->GetBuffer();
            if (!buffer.IsEmpty()) {
                timeval from = UniversalTime(buffer.GetBufLine(0).GetTime());
                timeval to = UniversalTime(buffer.GetBufLine(buffer.Size() - 1).GetTime());
                PutModule(query->GetName() + " " + CString(Timestamp(from)) + " " + CString(Timestamp(to)));
            }
        }
    }

    void LimitCommand(const CString& line)
    {
        // LIMIT <client> [limit]
        const CString client = line.Token(1);
        if (client.empty()) {
            PutModule("Usage: LIMIT <client> [limit]");
            return;
        }
        const CString arg = line.Token(2);
        int limit = GetLimit(client);
        if (!arg.empty()) {
            limit = arg.ToInt();
            SetLimit(client, limit);
        }
        if (limit <= 0)
            PutModule(client + " buffer limit: -");
        else
            PutModule(client + " buffer limit: " + CString(limit));
    }

    EModRet OnSendToClient(CString& line, CClient& client) override
    {
        if (client.IsAttached() && client.IsCapEnabled(PlaybackCap) && !line.Token(0).Equals("CAP")) {
            MCString tags = CUtils::GetMessageTags(line);
            if (tags.find("time") == tags.end()) {
                // CUtils::FormatServerTime() converts to UTC
                tags["time"] = CUtils::FormatServerTime(LocalTime());
                CUtils::SetMessageTags(line, tags);
            }
        }
        return CONTINUE;
    }

    EModRet OnUserMsg(CString& target, CString& message) override
    {
        return EchoMessage("PRIVMSG " + target + " :" + message);
    }

    EModRet OnUserNotice(CString& target, CString& message) override
    {
        return EchoMessage("NOTICE " + target + " :" + message);
    }

    EModRet OnUserAction(CString& target, CString& message) override
    {
        return EchoMessage("PRIVMSG " + target + " :\001ACTION " + message + "\001");
    }

private:
    EModRet EchoMessage(CString message)
    {
        CClient* client = GetClient();
        if (client && client->IsCapEnabled(EchoMessageCap)) {
            message.insert(0, ":" + client->GetNickMask() + " ");
            if (client->HasServerTime()) {
                MCString tags = CUtils::GetMessageTags(message);
                tags["time"] = CUtils::FormatServerTime(LocalTime());
                CUtils::SetMessageTags(message, tags);
            }
            client->PutClient(message);
        }
        return CONTINUE;
    }

    static double Timestamp(timeval tv)
    {
        return tv.tv_sec + tv.tv_usec / 1000000.0;
    }

    static timeval LocalTime()
    {
        timeval tv;
        if (gettimeofday(&tv, NULL) == -1) {
            tv.tv_sec = time(NULL);
            tv.tv_usec = 0;
        }
        return tv;
    }

    static timeval UniversalTime(timeval tv = LocalTime())
    {
        tm stm;
        memset(&stm, 0, sizeof(stm));
        const time_t secs = tv.tv_sec; // OpenBSD has tv_sec as int, so explicitly convert it to time_t to make gmtime_r() happy
        gmtime_r(&secs, &stm);
        const char* tz = getenv("TZ");
        setenv("TZ", "UTC", 1);
        tzset();
        tv.tv_sec = mktime(&stm);
        if (tz)
            setenv("TZ", tz, 1);
        else
            unsetenv("TZ");
        tzset();
        return tv;
    }

    std::vector<CChan*> FindChans(const CString& arg) const
    {
        std::vector<CChan*> chans;
        CIRCNetwork* network = GetNetwork();
        if (network) {
            VCString vargs;
            arg.Split(",", vargs, false);

            for (const CString& name : vargs) {
                std::vector<CChan*> found = network->FindChans(name);
                chans.insert(chans.end(), found.begin(), found.end());
            }
        }
        return chans;
    }

    std::vector<CQuery*> FindQueries(const CString& arg) const
    {
        std::vector<CQuery*> queries;
        CIRCNetwork* network = GetNetwork();
        if (network) {
            VCString vargs;
            arg.Split(",", vargs, false);

            for (const CString& name : vargs) {
                std::vector<CQuery*> found = network->FindQueries(name);
                queries.insert(queries.end(), found.begin(), found.end());
            }
        }
        return queries;
    }

    int GetLimit(const CString& client) const
    {
        return GetNV(client).ToInt();
    }

    void SetLimit(const CString& client, int limit)
    {
        if (limit > 0)
            SetNV(client, CString(limit));
        else
            DelNV(client);
    }

    static CBuffer GetLines(const CBuffer& buffer, double from, double to, int limit)
    {
        CBuffer lines(buffer.Size());
        for (size_t i = 0; i < buffer.Size(); ++i) {
            const CBufLine& line = buffer.GetBufLine(i);
            timeval tv = UniversalTime(line.GetTime());
            if (from < Timestamp(tv) && to >= Timestamp(tv))
                lines.AddLine(line.GetFormat(), line.GetText(), &tv);
        }
        if (limit > 0)
            lines.SetLineCount(limit);
        return lines;
    }

    bool m_play;
};

GLOBALMODULEDEFS(CPlaybackMod, "An advanced playback module for ZNC")

