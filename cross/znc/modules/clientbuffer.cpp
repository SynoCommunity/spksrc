/*
 * Copyright (C) 2014-2015 J-P Nurmi
 * Copyright (C) 2017-2018, 2021 Vladimir Panteleev and contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <znc/Modules.h>
#include <znc/IRCNetwork.h>
#include <znc/Client.h>
#include <znc/Utils.h>
#include <znc/User.h>
#include <znc/Chan.h>
#include <znc/znc.h>
#include <znc/version.h>
#include <sys/time.h>

#if (VERSION_MAJOR < 1) || (VERSION_MAJOR == 1 && VERSION_MINOR < 6)
#error The clientbuffer module requires ZNC version 1.6.0 or later.
#endif

#if (VERSION_MAJOR > 1) || (VERSION_MAJOR == 1 && VERSION_MINOR >= 7)
#define ZNC17 1
#else
#define ZNC17 0
#endif

class CClientBufferCacheJob : public CTimer
{
public:
    CClientBufferCacheJob(CModule* pModule, unsigned int uInterval, unsigned int uCycles, const CString& sLabel, const CString& sDescription)
        : CTimer(pModule, uInterval, uCycles, sLabel, sDescription) {}
    virtual ~CClientBufferCacheJob() {}

protected:
    virtual void RunJob();
};

class CClientBufferMod : public CModule
{
public:
    MODCONSTRUCTOR(CClientBufferMod)
    {
        AddHelpCommand();
        AddCommand("AddClient", static_cast<CModCommand::ModCmdFunc>(&CClientBufferMod::OnAddClientCommand), "<identifier>", "Add a client.");
        AddCommand("DelClient", static_cast<CModCommand::ModCmdFunc>(&CClientBufferMod::OnDelClientCommand), "<identifier>", "Delete a client.");
        AddCommand("ListClients", static_cast<CModCommand::ModCmdFunc>(&CClientBufferMod::OnListClientsCommand), "", "List known clients.");
        AddCommand("SetClientTimeLimit", static_cast<CModCommand::ModCmdFunc>(&CClientBufferMod::OnSetClientTimeLimit), "<identifier> [timelimit]", "Change a client's time limit.");
        AddTimer(new CClientBufferCacheJob(this, 1 /* sec */, 0, "ClientBufferCache", "Periodically save ClientBuffer registry to disk"));
    }

    bool OnLoad(const CString& sArgs, CString& sErrorMsg) override {
        VCString Args;
        sArgs.Split(" ", Args);
        for (size_t n=0; n<Args.size(); n++)
        {
            if (Args[n].Equals("autoadd", CString::CaseInsensitive))
                m_bAutoAdd = true;
            else if (Args[n].StartsWith("timelimit=", CString::CaseInsensitive))
                m_iTimeLimit = Args[n].Token(1, false, "=").ToInt();
            else
	            fprintf(stderr, "ClientBuffer: Unrecognized option: %s\n", Args[n].c_str());
        }
        return true;
    }

    void OnAddClientCommand(const CString& line);
    void OnDelClientCommand(const CString& line);
    void OnSetClientTimeLimit(const CString& line);
    void OnListClientsCommand(const CString& line);

    virtual void OnClientLogin() override;

#if ZNC17
    virtual EModRet OnUserRawMessage(CMessage& Message) override;
    virtual EModRet OnUserTextMessage(CTextMessage& Message) override;
    virtual EModRet OnSendToClientMessage(CMessage& Message) override;
#else
    virtual EModRet OnUserRaw(CString& line) override;
    virtual EModRet OnSendToClient(CString& line, CClient& client) override;
#endif

    virtual EModRet OnChanBufferStarting(CChan& chan, CClient& client) override;
    virtual EModRet OnChanBufferEnding(CChan& chan, CClient& client) override;

#if ZNC17
    virtual EModRet OnChanBufferPlayMessage(CMessage& message) override;
    virtual EModRet OnPrivBufferPlayMessage(CMessage& message) override;
#else
    virtual EModRet OnChanBufferPlayLine2(CChan& chan, CClient& client, CString& line, const timeval& tv) override;
    virtual EModRet OnPrivBufferPlayLine2(CClient& client, CString& line, const timeval& tv) override;
#endif

private:
    bool m_bAutoAdd = false;
    bool m_bDirty = false;
    int m_iTimeLimit = 0;

    bool AddClient(const CString& identifier);
    bool DelClient(const CString& identifier);
    bool SetClientTimeLimit(const CString& identifier, const int timeLimit);
    bool HasClient(const CString& identifier);

#if ZNC17
    CString GetTarget(const CMessage& msg);
#else
    bool ParseMessage(const CString& line, CNick& nick, CString& cmd, CString& target) const;
#endif

    timeval GetTimestamp(const CString& identifier, const CString& target);
    timeval GetTimestamp(const CBuffer& buffer) const;
    bool SetTimestamp(const CString& identifier, const CString& target, const timeval& tv);
    bool HasSeenTimestamp(const CString& identifier, const CString& target, const timeval& tv);
    bool UpdateTimestamp(const CString& identifier, const CString& target, const timeval& tv);

#if !ZNC17
    void UpdateTimestamp(const CClient* client, const CString& target);
#endif

	bool WithinTimeLimit(const timeval& tv, const CString& identifier);

    void FlushRegistry();
    friend class CClientBufferCacheJob;
};

/// Callback for the AddClient module command.
void CClientBufferMod::OnAddClientCommand(const CString& line)
{
    const CString identifier = line.Token(1);

    if (identifier.empty()) {
        PutModule("Usage: AddClient <identifier>");
        return;
    }
    if (HasClient(identifier)) {
        PutModule("Client already exists: " + identifier);
        return;
    }

    AddClient(identifier);
    PutModule("Client added: " + identifier);
}

/// Callback for the DelClient module command.
void CClientBufferMod::OnDelClientCommand(const CString& line)
{
    const CString identifier = line.Token(1);
    if (identifier.empty()) {
        PutModule("Usage: DelClient <identifier>");
        return;
    }
    if (!HasClient(identifier)) {
        PutModule("Unknown client: " + identifier);
        return;
    }
    DelClient(identifier);
    PutModule("Client removed: " + identifier);
}

/// Callback for the SetClientTimeLimit module command.
void CClientBufferMod::OnSetClientTimeLimit(const CString& line)
{
    const CString identifier = line.Token(1);
    const int timeLimit = line.Token(2).ToInt();

    if (identifier.empty()) {
        PutModule("Usage: SetClientTimeLimit <identifier> [timelimit]");
        return;
    }
    if (!HasClient(identifier)) {
        PutModule("Client doesn't exist: " + identifier);
        return;
    }
    SetClientTimeLimit(identifier, timeLimit);
    if (timeLimit)
        PutModule("Client's " + identifier +  " changed time limit: " + CString(timeLimit) );
    else
        PutModule("Client's " + identifier +  " cleared time limit.");
}

/// Callback for the ListClients module command.
void CClientBufferMod::OnListClientsCommand(const CString& line)
{
    const CString& current = GetClient()->GetIdentifier();

    CTable table;
    table.AddColumn("Client");
    table.AddColumn("TimeLimit");
    table.AddColumn("Connected");

    for (MCString::iterator it = BeginNV(); it != EndNV(); ++it) {
        if (it->first.Find("/") == CString::npos) {
            table.AddRow();
            if (it->first == current)
                table.SetCell("Client",  "*" + it->first);
            else
                table.SetCell("Client",  it->first);
            table.SetCell("TimeLimit", GetNV(it->first + "/timelimit"));
            table.SetCell("Connected", CString(!GetNetwork()->FindClients(it->first).empty()));
        }
    }

    if (table.empty())
        PutModule("No identified clients");
    else
        PutModule(table);
}

/// ZNC callback (called when a client successfully logged in to ZNC).
/// Implements the "autoadd" option.
void CClientBufferMod::OnClientLogin()
{
    const CString& current = GetClient()->GetIdentifier();

    if (!HasClient(current) && m_bAutoAdd) {
        if (current.length() == 0) {
            PutModule("Not auto-adding a client with an empty identifier.");
            return;
        }
        AddClient(current);
    }
}

/// Filter which message kinds cause us to consider the buffer updated.
#if ZNC17
static bool WantMessageType(CMessage::Type MessageType)
{
    return MessageType == CMessage::Type::Text
        || MessageType == CMessage::Type::Notice
        || MessageType == CMessage::Type::Action
        || MessageType == CMessage::Type::CTCP;
}
#else
static bool WantMessageCmd(CString cmd)
{
    return cmd == "PRIVMSG" || cmd == "NOTICE";
}
#endif

/// ZNC callback (called when a client sends any message to ZNC).
/// Updates the client "last seen" timestamp.
#if ZNC17
CModule::EModRet CClientBufferMod::OnUserRawMessage(CMessage& Message)
{
    CClient* client = Message.GetClient();
    if (!client)
        return CONTINUE;

    if (WantMessageType(Message.GetType()))
        UpdateTimestamp(client->GetIdentifier(), GetTarget(Message), Message.GetTime());

    return CONTINUE;
}
#else
CModule::EModRet CClientBufferMod::OnUserRaw(CString& line)
{
    CClient* client = GetClient();
    if (client) {
        CNick nick; CString cmd, target;
        if (ParseMessage(line, nick, cmd, target) && WantMessageCmd(cmd))
            UpdateTimestamp(client, target);
    }
    return CONTINUE;
}
#endif

/// ZNC callback for messages sent from clients.
/// Used in addition to OnUserRawMessage as this one will contain the parsed target.
#if ZNC17
CModule::EModRet CClientBufferMod::OnUserTextMessage(CTextMessage& Message)
{
    CClient* client = Message.GetClient();
    if (client)
        UpdateTimestamp(client->GetIdentifier(), GetTarget(Message), Message.GetTime());

    return CONTINUE;
}
#endif

/// ZNC callback (called when ZNC sends a raw traffic line to a client).
/// Updates the client "last seen" timestamp.
#if ZNC17
CModule::EModRet CClientBufferMod::OnSendToClientMessage(CMessage& Message)
{
    // make sure not to update the timestamp for a channel when joining it
    if (!WantMessageType(Message.GetType()))
        return CONTINUE;

    // make sure not to update the timestamp for a channel when attaching it
    CChan* chan = Message.GetChan();
    if (!chan || !chan->IsDetached())
        UpdateTimestamp(Message.GetClient()->GetIdentifier(), GetTarget(Message), Message.GetTime());
    return CONTINUE;
}
#else
CModule::EModRet CClientBufferMod::OnSendToClient(CString& line, CClient& client)
{
    CIRCNetwork* network = GetNetwork();
    if (network) {
        CNick nick; CString cmd, target;
        // make sure not to update the timestamp for a channel when attaching it
        if (ParseMessage(line, nick, cmd, target)) {
            CChan* chan = network->FindChan(target);
            if (!chan || !chan->IsDetached())
                UpdateTimestamp(&client, target);
        }
    }
    return CONTINUE;
}
#endif

/// ZNC callback (called before a channel buffer is played back to a client).
/// Filters out the "Buffer Playback..." message as necessary.
CModule::EModRet CClientBufferMod::OnChanBufferStarting(CChan& chan, CClient& client)
{
    if (client.HasServerTime())
        return HALTCORE;

    const CString& identifier = client.GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    // let "Buffer Playback..." message through?
    const CBuffer& buffer = chan.GetBuffer();
    if (!WithinTimeLimit(GetTimestamp(buffer), identifier))
	    return HALTCORE;

    if (!buffer.IsEmpty() && HasSeenTimestamp(identifier, chan.GetName(), GetTimestamp(buffer)))
        return HALTCORE;

    return CONTINUE;
}

/// ZNC callback (called after a channel buffer was played back to a client).
/// Filters out the "Buffer Complete" message as necessary.
CModule::EModRet CClientBufferMod::OnChanBufferEnding(CChan& chan, CClient& client)
{
    if (client.HasServerTime())
        return HALTCORE;

    const CString& identifier = client.GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    // let "Buffer Complete" message through?
    const CBuffer& buffer = chan.GetBuffer();
    if (!WithinTimeLimit(GetTimestamp(buffer), identifier))
	    return HALTCORE;

    if (!buffer.IsEmpty() && !UpdateTimestamp(identifier, chan.GetName(), GetTimestamp(buffer)))
        return HALTCORE;

    return CONTINUE;
}

/// ZNC callback (called for each message during a channel's buffer play back).
/// Filters out the messages as necessary.
#if ZNC17
CModule::EModRet CClientBufferMod::OnChanBufferPlayMessage(CMessage& Message)
{
    CClient* client = Message.GetClient();
    if (!client)
        return CONTINUE;

    const CString& identifier = client->GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    if (!WithinTimeLimit(Message.GetTime(), identifier))
	    return HALTCORE;

    if (HasSeenTimestamp(identifier, GetTarget(Message), Message.GetTime()))
        return HALTCORE;

    return CONTINUE;
}
#else
CModule::EModRet CClientBufferMod::OnChanBufferPlayLine2(CChan& chan, CClient& client, CString& line, const timeval& tv)
{
    const CString& identifier = client.GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    if (!WithinTimeLimit(tv, identifier))
	    return HALTCORE;

    if (HasSeenTimestamp(identifier, chan.GetName(), tv))
        return HALTCORE;

    return CONTINUE;
}
#endif

/// ZNC callback (called for each message during a query's buffer play back).
/// Filters out the messages as necessary.
#if ZNC17
CModule::EModRet CClientBufferMod::OnPrivBufferPlayMessage(CMessage& Message)
{
    CClient* client = Message.GetClient();
    if (!client)
        return CONTINUE;

    const CString& identifier = client->GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    if (!WithinTimeLimit(Message.GetTime(), identifier))
	    return HALTCORE;

    if (HasSeenTimestamp(identifier, GetTarget(Message), Message.GetTime()))
        return HALTCORE;

    return CONTINUE;
}
#else
CModule::EModRet CClientBufferMod::OnPrivBufferPlayLine2(CClient& client, CString& line, const timeval& tv)
{
    const CString& identifier = client.GetIdentifier();
    if (!HasClient(identifier))
        return HALTCORE;

    if (!WithinTimeLimit(tv, identifier))
	    return HALTCORE;

    CNick nick; CString cmd, target;
    if (ParseMessage(line, nick, cmd, target) && !UpdateTimestamp(identifier, target, tv))
        return HALTCORE;

    return CONTINUE;
}
#endif

/// Add a client identifier.
/// Returns true upon success.
bool CClientBufferMod::AddClient(const CString& identifier)
{
    m_bDirty = true;
    return SetNV(identifier, "", false);
}

/// Remove a client identifier.
/// Returns true upon success.
bool CClientBufferMod::DelClient(const CString& identifier)
{
    SCString keys;
    for (MCString::iterator it = BeginNV(); it != EndNV(); ++it) {
        const CString client = it->first.Token(0, false, "/");
        if (client.Equals(identifier))
            keys.insert(it->first);
    }
    bool success = true;
    for (const CString& key : keys)
        success &= DelNV(key, false);
    m_bDirty = true;
    return success;
}

/// Check whether a client identifier is known.
bool CClientBufferMod::HasClient(const CString& identifier)
{
    return !identifier.empty() && FindNV(identifier) != EndNV();
}

/// Set a client's timelimit.
/// Returns true upon success.
bool CClientBufferMod::SetClientTimeLimit(const CString& identifier, const int timeLimit)
{
    m_bDirty = true;
    if (timeLimit)
        return SetNV(identifier + "/timelimit", CString(timeLimit), false);
    else
        return DelNV(identifier + "/timelimit", false);
}

#if ZNC17
CString CClientBufferMod::GetTarget(const CMessage& msg)
{
    if (msg.GetChan())
        return msg.GetChan()->GetName();
    else {
        CString Nick = msg.GetNick().GetNick();
        CIRCNetwork* Network = msg.GetNetwork();
        // Detect self-messages
        if (Network && Nick == Network->GetNick() && msg.GetParams().size() >= 1)
            return msg.GetParam(0);
        return Nick;
    }
}
#else
/// Split an IRC message line into parts.
/// Populates nick, cmd and target.
/// Returns true upon success.
bool CClientBufferMod::ParseMessage(const CString& line, CNick& nick, CString& cmd, CString& target) const
{
    // discard message tags
    CString msg = line;
    if (msg.StartsWith("@"))
        msg = msg.Token(1, true);

    CString rest;
    if (msg.StartsWith(":")) {
        nick = CNick(msg.Token(0).TrimPrefix_n());
        cmd = msg.Token(1);
        rest = msg.Token(2, true);
    } else {
        cmd = msg.Token(0);
        rest = msg.Token(1, true);
    }

    if (cmd.length() == 3 && isdigit(cmd[0]) && isdigit(cmd[1]) && isdigit(cmd[2])) {
        // must block the following numeric replies that are automatically sent on attach:
        // RPL_NAMREPLY, RPL_ENDOFNAMES, RPL_TOPIC, RPL_TOPICWHOTIME...
        unsigned int num = cmd.ToUInt();
        if (num == 353) // RPL_NAMREPLY
            target = rest.Token(2);
        else
            target = rest.Token(1);
    } else if (cmd.Equals("PRIVMSG") || cmd.Equals("NOTICE") || cmd.Equals("JOIN") || cmd.Equals("PART") || cmd.Equals("MODE") || cmd.Equals("KICK") || cmd.Equals("TOPIC")) {
        target = rest.Token(0).TrimPrefix_n(":");
    }

    return !target.empty() && !cmd.empty();
}
#endif

/// Get the "last seen" timestamp for a given client identifier and target.
timeval CClientBufferMod::GetTimestamp(const CString& identifier, const CString& target)
{
    CString timestamp = GetNV(identifier + "/" + target);

    long long sec = 0;
    long usec = 0;
    std::sscanf(timestamp.c_str(), "%lld.%06ld", &sec, &usec);

    timeval tv;
    tv.tv_sec = (time_t)sec;
    tv.tv_usec = (suseconds_t)usec;
    return tv;
}

/// Get the timestamp of the last message in a given ZNC playback buffer.
timeval CClientBufferMod::GetTimestamp(const CBuffer& buffer) const
{
    return buffer.GetBufLine(buffer.Size() - 1).GetTime();
}

/// Set the "last seen" timestamp for a given client identifier and target.
bool CClientBufferMod::SetTimestamp(const CString& identifier, const CString& target, const timeval& tv)
{
    char timestamp[32];
    std::snprintf(timestamp, 32, "%lld.%06ld", (long long)tv.tv_sec, (long)tv.tv_usec);
    m_bDirty = true;
    return SetNV(identifier + "/" + target, timestamp, false);
}

/// Returns true if the given timestamp is not greater than the "last
/// seen" timestamp for the given client identifier and target.
bool CClientBufferMod::HasSeenTimestamp(const CString& identifier, const CString& target, const timeval& tv)
{
    const timeval seen = GetTimestamp(identifier, target);
    return !timercmp(&seen, &tv, <);
}

/// Checks whether the given client should receive a message with the
/// given timestamp and target.
/// If the timestamp is greater than the client's "last seen"
/// timestamp, updates the client's "last seen" timestamp accordingly
/// and returns true. Otherwise, returns false.
bool CClientBufferMod::UpdateTimestamp(const CString& identifier, const CString& target, const timeval& tv)
{
    if (!HasSeenTimestamp(identifier, target, tv))
        return SetTimestamp(identifier, target, tv);
    return false;
}

#if !ZNC17
/// Update the "last seen" timestamp of the given client and target to
/// the current time.
void CClientBufferMod::UpdateTimestamp(const CClient* client, const CString& target)
{
    if (client && !client->IsPlaybackActive()) {
        const CString& identifier = client->GetIdentifier();
        if (HasClient(identifier)) {
            timeval tv;
            gettimeofday(&tv, NULL);
            UpdateTimestamp(identifier, target, tv);
        }
    }
}
#endif

bool CClientBufferMod::WithinTimeLimit(const timeval& tv, const CString& identifier)
{
    int timeLimit = GetNV(identifier + "/timelimit").ToInt();
	if (!timeLimit && !m_iTimeLimit)
		return true;
	timeval now;
	gettimeofday(&now, NULL);
	return now.tv_sec - tv.tv_sec < timeLimit ? timeLimit : m_iTimeLimit;
}

template<> void TModInfo<CClientBufferMod>(CModInfo& info) {
	info.SetWikiPage("Clientbuffer");
	info.SetHasArgs(true);
}

void CClientBufferCacheJob::RunJob() {
    CClientBufferMod* mod = (CClientBufferMod*)GetModule();
    mod->FlushRegistry();
}

void CClientBufferMod::FlushRegistry()
{
    if (m_bDirty) {
        SaveRegistry();
        m_bDirty = false;
    }
}

NETWORKMODULEDEFS(CClientBufferMod, "Client specific buffer playback")
