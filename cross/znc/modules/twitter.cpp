/*
 * Copyright (C) 2009-2011 flakes @ EFNet
 * Updated 09 March 2011
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 as published
 * by the Free Software Foundation.
 */

#define REQUIRESSL

#include "main.h"
#include "znc.h"
#include "Chan.h"
#include "Modules.h"
#include "User.h"

#if (!defined(VERSION_MAJOR) || !defined(VERSION_MINOR) || (VERSION_MAJOR == 0 && VERSION_MINOR < 72))
#error This module needs ZNC 0.072 or newer.
#endif

#include <stack>
#include <deque>
#include <exception>
#include <algorithm>
#include <limits>

#include <openssl/evp.h>
#include <openssl/hmac.h>

using namespace std;

/************************************************************************/
/* APP IDENTIFICATION STUFF PROVIDED BY TWITTER                         */
/************************************************************************/

#define TWITTER_CONSUMER_KEY "9k8Qvy4wncJzZmOKeJAQ"
#define TWITTER_CONSUMER_SECRET "foW4mvWuFKy3iD9r4cHdekZ4h9P0qiq9jDBN0ZHj2U"

/************************************************************************/
/* SOME NEEDED STRUCTS                                                  */
/************************************************************************/

enum ETwitterFeedType
{
	TWFT_TIMELINE = 1,
	TWFT_MENTIONS,
	TWFT_USER,
	TWFT_SEARCH,
	_TWFT_MAX
};

struct CTwitterFeed
{
	CTwitterFeed(ETwitterFeedType type) { m_type = type; m_lastUpdate = 0; m_lastId = 0; m_id = 0; m_colors = true; }
	ETwitterFeedType m_type;
	int m_id;
	CString m_payload;
	CString m_target;
	CString m_prefix;
	uint64_t m_lastId;
	time_t m_lastUpdate;
	bool m_colors;
};

struct CFontStyle
{
	CFontStyle() { bUnderline = bBold = false; iForeClr = iBackClr = -1; }
	bool bUnderline, bBold;
	int iForeClr, iBackClr;

	CString GetStartCode() const
	{
		return CString(bBold ? "\x02" : "") +
			CString(bUnderline ? "\x1F" : "") +
			(iForeClr > -1 ? "\x03" + CString(iForeClr < 10 && iBackClr == -1 ? "0" : "") + CString(iForeClr)
				+ (iBackClr > -1 ? "," + CString(iBackClr < 10 ? "0" : "") + CString(iBackClr) : "") : "");
	}

	CString GetEndCode() const
	{
		return CString(bBold ? "\x02" : "") +
			CString(bUnderline ? "\x1F" : "") +
			CString(iForeClr > -1 ? "\x03" : "");
	}
};

/************************************************************************/
/*  MODULE HEADER / DECLARATION                                         */
/************************************************************************/

class CTRRequestToken;

class CTwitterModule : public CModule
{
	friend class CTRRequestToken;
private:
	CString m_token, m_tokenSecret;
	bool m_waitingForPIN, m_hasAccessToken;
	CString m_screenName;
	uint64_t m_userId;
	int m_nextFeedId;
	vector<CTwitterFeed> m_feeds;
	vector<pair<time_t, CString> > m_msgQueue;
	time_t m_msgQueueLastSent;
	time_t m_lastRateLimitedCall;
	map<const CString, CFontStyle> m_styles;

	void SaveSettings();
	void LoadSettings();
public:
	MODCONSTRUCTOR(CTwitterModule)
	{
		m_waitingForPIN = m_hasAccessToken = false;
		m_userId = 0;
		m_nextFeedId = 1;
		m_msgQueueLastSent = m_lastRateLimitedCall = 0;
		m_styles["user"] = CFontStyle();
		m_styles["@user"] = CFontStyle();
		m_styles["hashtag"] = CFontStyle();
		m_styles["link"] = CFontStyle();
		m_styles["timestamp"] = CFontStyle();
		m_styles["text"] = CFontStyle();
	}

	const CString& GetToken() { return m_token; }
	const CString& GetTokenSecret() { return m_tokenSecret; }
	const CString& GetScreenName() { return m_screenName; }
	bool IsAuthed() { return m_hasAccessToken; }

	void EraseSession(bool bErrorMessage);
	void SendTweet(CString sMessage);
	void TimerAction();

	CTwitterFeed *GetFeedById(int id);
	time_t InterpretRFC3339Time(const CString& sRFC3339);
	static CString FormatTweetTime(time_t iTime, bool bAllowFuture = false);
	void QueueMessage(CTwitterFeed *fFeed, time_t iTime, const CString& sMessage);

	bool OnLoad(const CString& sArgsi, CString& sMessage);
	void OnModCommand(const CString& sCommand);
	void OnModCTCP(const CString& sMessage);
	~CTwitterModule();
};

/************************************************************************/
/* MISC HELPER + WRAPPER FUNCTIONS                                      */
/************************************************************************/

static CString HMACSHA1(const CString& sInput, const CString& sKey)
{
	HMAC_CTX ctx;
	unsigned char hmacBuf[EVP_MAX_MD_SIZE];
	unsigned int len = 0;

	HMAC_Init(&ctx, sKey.c_str(), sKey.size(), EVP_sha1());
	HMAC_Update(&ctx, (const unsigned char*)sInput.c_str(), sInput.size());
	HMAC_Final(&ctx, &hmacBuf[0], &len);

	HMAC_CTX_cleanup(&ctx);

	CString sTmp;
	sTmp.append((char*)&hmacBuf, len);
	sTmp.Base64Encode();

	return sTmp;
}

/************************************************************************/
/* HTTP CLIENT SOCKET                                                   */
/************************************************************************/

class CSimpleHTTPSock : protected CSocket
{
public:
	CSimpleHTTPSock(CModule *pModInstance)
		: CSocket(pModInstance)
	{
		m_pMod = pModInstance;
		m_maxRedirs = 5;
		m_numRedir = 0;
		m_maxBuf = 1024 * 1024;

		DisableReadLine();
	}

	virtual ~CSimpleHTTPSock()
	{
	}

	static CString URLEscape(const CString& s)
	{
		return s.Escape_n(CString::EASCII, CString::EURL).Replace_n("+", "%20");
	}

	static bool CrackURL(const CString& sURL, CString& srHost, unsigned short& urPort, CString& srPath, bool& brSSL)
	{
		CString sWork(sURL);

		if(sWork.substr(0, 7) == "http://")
		{
			brSSL = false;
			urPort = 80;

			sWork.erase(0, 7);
		}
		else if(sURL.substr(0, 8) == "https://")
		{
			brSSL = true;
			urPort = 443;

			sWork.erase(0, 8);
		}
		else
			return false;

		CString::size_type uPos = sWork.find('/');

		if(uPos == CString::npos)
		{
			srHost = sWork;
			srPath = "/";
		}
		else
		{
			srHost = sWork.substr(0, uPos);
			srPath = sWork.substr(uPos + 1);
		}

		uPos = srHost.find(':');

		if(uPos != CString::npos)
		{
			unsigned long long uTmp = CString(srHost.substr(uPos + 1)).ToULongLong();

			if(uTmp > 0 && uTmp <= numeric_limits<unsigned short>::max())
			{
				urPort = (unsigned short)uTmp;
				srHost = srHost.substr(0, uPos);
			}
			else
				return false;
		}

		// validate host + path:
		if(srHost.empty()) return false;

		for(CString::size_type p = 0; p < srHost.size(); p++)
		{
			if(!isalnum(srHost[p]) && srHost[p] != '.' && srHost[p] != '-')
			{
				return false;
			}
		}

		for(CString::size_type p = 0; p < srPath.size(); p++)
		{
			if(!srPath[p] || srPath[p] == '\n' || srPath[p] == '\r')
			{
				return false;
			}
		}

		return true;
	}

private:
	CString m_request;
	CString m_buffer;
	unsigned int m_numRedir;

protected:
	CModule *m_pMod;
	unsigned int m_maxRedirs;
	unsigned int m_maxBuf;
	MCString m_extraReqHeaders;

	void MakeRequestHeaders(bool bPost, const CString& sHost, const CString& sPath, unsigned short uPort, bool bSSL)
	{
		m_request = CString(bPost ? "POST " : "GET ") + sPath + " HTTP/1.1\r\n";
		m_request += "Host: " + sHost + ((uPort == 80 && !bSSL) || (uPort == 443 && bSSL) ? CString("") : ":" + CString(uPort)) + "\r\n";
		m_request += "User-Agent: Mozilla/5.0 (" + CZNC::GetTag() + ")\r\n";

		for(MCString::const_iterator it = m_extraReqHeaders.begin(); it != m_extraReqHeaders.end(); it++)
		{
			m_request += it->first + ": " + it->second + "\r\n";
		}

		m_request += "Connection: Close\r\n";
	}

	void Get(const CString& sHost, const CString& sPath, unsigned short uPort = 80, bool bSSL = false)
	{
		MakeRequestHeaders(false, sHost, sPath, uPort, bSSL);
		m_request += "\r\n";

		DEBUG("[Twitter] Connecting to [" << sHost << "]:" << uPort << " (SSL = " << bSSL << ")");
		Connect(sHost, uPort, bSSL);
	}

	void Post(const MCString& mPostData, const CString& sHost, const CString& sPath, unsigned short uPort = 80, bool bSSL = false)
	{
		MakeRequestHeaders(true, sHost, sPath, uPort, bSSL);

		CString sPostData;

		for(MCString::const_iterator it = mPostData.begin(); it != mPostData.end(); it++)
		{
			if(it != mPostData.begin()) sPostData += "&";
			sPostData += URLEscape(it->first) + "=" + URLEscape(it->second);
		}

		m_request += "Content-Type: application/x-www-form-urlencoded\r\n";
		m_request += "Content-Length: " + CString(sPostData.size()) + "\r\n";
		m_request += "\r\n";
		m_request += sPostData;

		DEBUG("[Twitter] Connecting to [" << sHost << "]:" << uPort << " (SSL = " << bSSL << ")");
		Connect(sHost, uPort, bSSL);
	}

	void Connected()
	{
		m_buffer.clear();
		DEBUG("[Twitter] Sending request: " << m_request);
		Write(m_request);
		m_request.clear();
	}

	virtual void Timeout()
	{
		m_request.clear();
		Close();
	}

	void Disconnected()
	{
		unsigned int uResponseCode;

		if(sscanf(m_buffer.c_str(), "HTTP/1.%*c %u ", &uResponseCode) == 1)
		{
			CString::size_type uPos = m_buffer.find("\r\n\r\n");
			if(uPos == CString::npos) uPos = m_buffer.find("\n\n");

			DEBUG("[Twitter] Response: " << m_buffer);

			if(uPos != CString::npos)
			{
				VCString vHeadersTemp;
				map<const CString, CString> mHeaders;

				CString(m_buffer.substr(0, uPos)).Split("\n", vHeadersTemp, false, "", "", false, true);

				for(VCString::const_iterator it = vHeadersTemp.begin(); it != vHeadersTemp.end(); it++)
				{
					CString sVal = it->Token(1, true, ":");
					sVal.Trim();

					mHeaders[it->Token(0, false, ":")] = sVal;
				}

				if(uResponseCode >= 300 && uResponseCode < 400 && mHeaders.find("Location") != mHeaders.end() && m_numRedir < m_maxRedirs)
				{
					bool bSSL; unsigned short uPort;
					CString sHost, sPath;

					if(CrackURL(mHeaders["Location"], sHost, uPort, sPath, bSSL))
					{
						m_numRedir++;
						Get(sHost, sPath, uPort, bSSL);
					}
					else
						OnRequestError(-3);
				}
				else
				{
					OnRequestDone(uResponseCode, mHeaders, m_buffer.substr(uPos + 2));
				}
			}
			else
				OnRequestError(-2);
		}
		else
			OnRequestError(-1);

		Close();
	}

#if (VERSION_MAJOR == 0 && VERSION_MINOR <= 80)
	void ReadData(const char *data, int len)
#else
	void ReadData(const char *data, size_t len)
#endif
	{
		if(m_buffer.size() + len > m_maxBuf)
		{
			// make sure our buffers don't EVER take up too much memory.
			// we just abort stuff in this case.
			m_buffer.clear();
			Close();
		}
		else
		{
			m_buffer.append(data, len);
		}
	}

	virtual void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse) = 0;
	virtual void OnRequestError(int iErrorCode) = 0;
};


/************************************************************************/
/* UTF-8 STUFF                                                          */
/************************************************************************/

static CString Iso88591toUtf8(const CString& sString)
{
	CString sResult;
	sResult.reserve(sString.size() * 2);

	for(CString::size_type p = 0; p < sString.size(); p++)
	{
		unsigned char c = sString[p];

		if(c < 0x80)
		{
			sResult += c;
		}
		else if(c < 0xC0)
		{
			sResult += '\xC2';
			sResult += c;
		}
		else
		{
			sResult += '\xC3';
			sResult += (c - 64);
		}
	}

	return sResult;
}

namespace twiconv
{
	typedef wchar_t ucs4_t;
	typedef void* conv_t;

#define RET_ILSEQ -1
#define RET_TOOFEW(X) -2
#define RET_TOOSMALL -3
#define RET_ILUNI -4

	/*
	* Copyright (C) 1999-2001, 2004 Free Software Foundation, Inc.
	* This file is part of the GNU LIBICONV Library.
	*
	* The GNU LIBICONV Library is free software; you can redistribute it
	* and/or modify it under the terms of the GNU Library General Public
	* License as published by the Free Software Foundation; either version 2
	* of the License, or (at your option) any later version.
	**/

	static int
		utf8_mbtowc (conv_t conv, ucs4_t *pwc, const unsigned char *s, int n)
	{
		unsigned char c = s[0];

		if (c < 0x80) {
			*pwc = c;
			return 1;
		} else if (c < 0xc2) {
			return RET_ILSEQ;
		} else if (c < 0xe0) {
			if (n < 2)
				return RET_TOOFEW(0);
			if (!((s[1] ^ 0x80) < 0x40))
				return RET_ILSEQ;
			*pwc = ((ucs4_t) (c & 0x1f) << 6)
				| (ucs4_t) (s[1] ^ 0x80);
			return 2;
		} else if (c < 0xf0) {
			if (n < 3)
				return RET_TOOFEW(0);
			if (!((s[1] ^ 0x80) < 0x40 && (s[2] ^ 0x80) < 0x40
				&& (c >= 0xe1 || s[1] >= 0xa0)))
				return RET_ILSEQ;
			*pwc = ((ucs4_t) (c & 0x0f) << 12)
				| ((ucs4_t) (s[1] ^ 0x80) << 6)
				| (ucs4_t) (s[2] ^ 0x80);
			return 3;
		} else if (c < 0xf8 && sizeof(ucs4_t)*8 >= 32) {
			if (n < 4)
				return RET_TOOFEW(0);
			if (!((s[1] ^ 0x80) < 0x40 && (s[2] ^ 0x80) < 0x40
				&& (s[3] ^ 0x80) < 0x40
				&& (c >= 0xf1 || s[1] >= 0x90)))
				return RET_ILSEQ;
			*pwc = ((ucs4_t) (c & 0x07) << 18)
				| ((ucs4_t) (s[1] ^ 0x80) << 12)
				| ((ucs4_t) (s[2] ^ 0x80) << 6)
				| (ucs4_t) (s[3] ^ 0x80);
			return 4;
		} else if (c < 0xfc && sizeof(ucs4_t)*8 >= 32) {
			if (n < 5)
				return RET_TOOFEW(0);
			if (!((s[1] ^ 0x80) < 0x40 && (s[2] ^ 0x80) < 0x40
				&& (s[3] ^ 0x80) < 0x40 && (s[4] ^ 0x80) < 0x40
				&& (c >= 0xf9 || s[1] >= 0x88)))
				return RET_ILSEQ;
			*pwc = ((ucs4_t) (c & 0x03) << 24)
				| ((ucs4_t) (s[1] ^ 0x80) << 18)
				| ((ucs4_t) (s[2] ^ 0x80) << 12)
				| ((ucs4_t) (s[3] ^ 0x80) << 6)
				| (ucs4_t) (s[4] ^ 0x80);
			return 5;
		} else if (c < 0xfe && sizeof(ucs4_t)*8 >= 32) {
			if (n < 6)
				return RET_TOOFEW(0);
			if (!((s[1] ^ 0x80) < 0x40 && (s[2] ^ 0x80) < 0x40
				&& (s[3] ^ 0x80) < 0x40 && (s[4] ^ 0x80) < 0x40
				&& (s[5] ^ 0x80) < 0x40
				&& (c >= 0xfd || s[1] >= 0x84)))
				return RET_ILSEQ;
			*pwc = ((ucs4_t) (c & 0x01) << 30)
				| ((ucs4_t) (s[1] ^ 0x80) << 24)
				| ((ucs4_t) (s[2] ^ 0x80) << 18)
				| ((ucs4_t) (s[3] ^ 0x80) << 12)
				| ((ucs4_t) (s[4] ^ 0x80) << 6)
				| (ucs4_t) (s[5] ^ 0x80);
			return 6;
		} else
			return RET_ILSEQ;
	}

	static int
		utf8_wctomb (conv_t conv, unsigned char *r, ucs4_t wc, int n) /* n == 0 is acceptable */
	{
		int count;
		if (wc < 0x80)
			count = 1;
		else if (wc < 0x800)
			count = 2;
		else if (wc < 0x10000)
			count = 3;
		else if (wc < 0x200000)
			count = 4;
		else if (wc < 0x4000000)
			count = 5;
		else if (wc <= 0x7fffffff)
			count = 6;
		else
			return RET_ILUNI;
		if (n < count)
			return RET_TOOSMALL;
		switch (count) { /* note: code falls through cases! */
	case 6: r[5] = 0x80 | (wc & 0x3f); wc = wc >> 6; wc |= 0x4000000;
	case 5: r[4] = 0x80 | (wc & 0x3f); wc = wc >> 6; wc |= 0x200000;
	case 4: r[3] = 0x80 | (wc & 0x3f); wc = wc >> 6; wc |= 0x10000;
	case 3: r[2] = 0x80 | (wc & 0x3f); wc = wc >> 6; wc |= 0x800;
	case 2: r[1] = 0x80 | (wc & 0x3f); wc = wc >> 6; wc |= 0xc0;
	case 1: r[0] = (unsigned char)wc;
		}
		return count;
	}
};

// returned ar_length will only be valid if true was returned.
static bool IsStrValidUTF8(const CString& sString, size_t &ar_length)
{
	const unsigned char *pStart = (unsigned char*)sString.c_str();
	CString::size_type p = 0, uLen = sString.size();
	wchar_t dummy;

	ar_length = 0;

	while(p < uLen)
	{
		int consumed = twiconv::utf8_mbtowc(NULL, &dummy, (unsigned char*)(pStart + p), uLen - p);

		if(consumed <= 0)
			return false;

		ar_length++;
		p += consumed;
	}

	return true;
}

static wstring Utf8ToWide(const string& sString)
{
	if(!sString.empty())
	{
		// a wide string can't have more characters than
		// the same UTF-8 string has bytes, so this should be safe.
		wchar_t *szBuf = new wchar_t[sString.size() + 1 + 6];
		// we add 6 to avoid buffer overruns at any cost (see below).
		*szBuf = 0;

		const unsigned char *p = (unsigned char*)sString.c_str();
		wchar_t *b = szBuf, *bMax = szBuf + sString.size();

		while(*p && b <= bMax)
		{
			int consumed = twiconv::utf8_mbtowc(NULL, b, p, 6);

			if(consumed <= 0)
				return L"";

			p += consumed;
			b++;
		}

		if(b <= bMax)
			*b = 0;
		else
			*bMax = 0;

		wstring sResult(szBuf);
		delete[] szBuf;

		return sResult;
	}

	return L"";
}

static CString WideToUtf8(const wstring& sWString)
{
	if(sWString.size() > 0)
	{
		// find out how large our buffer needs to be.
		size_t uBufSize = 0;
		unsigned char szTmp[6];

		for(wstring::size_type p = 0; p < sWString.size(); p++)
		{
			int iBytes = twiconv::utf8_wctomb(NULL, &szTmp[0], sWString[p], 6);

			if(iBytes <= 0)
				return "";

			uBufSize += (unsigned int)iBytes;
		}

		if(uBufSize > 0)
		{
			char *szBuf = new char[uBufSize + 1];
			unsigned char *b = (unsigned char*)szBuf;

			*szBuf = 0;

			for(wstring::size_type p = 0; p < sWString.size(); p++)
			{
				int iBytes = twiconv::utf8_wctomb(NULL, b, sWString[p], 6);

				if(iBytes <= 0)
					break;

				b += iBytes;
			}

			*b = 0;

			CString sResult(szBuf);
			delete[] szBuf;
			return sResult;
		}
	}

	return "";
}

/************************************************************************/
/* UTF-8 STUFF FOR XML                                                  */
/************************************************************************/

static CString Utf8Xml_Encode(const CString& sString)
{
	return sString.Replace_n("&", "&amp;")
		.Replace_n("<", "&lt;")
		.Replace_n(">", "&gt;")
		.Replace_n("\"", "&quot;");
}

#define FAST_ISDIGIT(C) (C >= '0' && C <= '9')
#define FAST_ISDIGITX(C) (FAST_ISDIGIT(C) || (C >= 'a' && C <= 'f') || (C >= 'A' && C <= 'F'))

static CString Utf8Xml_Decode(const CString& sString)
{
	wstring swStr;
	swStr.reserve(sString.size());

	CString::size_type p = sString.find('&'), pPrev = 0;

	do
	{
		if(p == CString::npos)
		{
			// handle rest of the str...
			swStr += Utf8ToWide(sString.substr(pPrev));
			break;
		}
		else
		{
			swStr += Utf8ToWide(sString.substr(pPrev, p - pPrev));
		}

		bool bIgnore = true;

		CString::size_type pEnd = sString.find(';', p);
		if(pEnd != CString::npos)
		{
			const string sEntity = sString.substr(p + 1, pEnd - p - 1);

			if(sEntity.size() >= 2 && sEntity[0] == '#')
			{
				bool bHex = (sEntity[1] == 'x');
				bool bOk = true;

				for(CString::size_type ep = 2; bOk && ep < sEntity.size(); ep++)
				{
					bOk = (bHex ? FAST_ISDIGITX(sEntity[ep]) : FAST_ISDIGIT(sEntity[ep]));
				}

				if(bOk && (!bHex || sEntity.size() >= 3))
				{
					const unsigned long long lle = strtoull(sEntity.c_str() + (bHex ? 2 : 1), NULL, (bHex ? 16 : 10));

					if(lle > 0 && lle <= numeric_limits<unsigned short>::max())
					{
						swStr += (wchar_t)lle;
						bIgnore = false;
					}
				}
			}
			else if(sEntity == "amp") { swStr += L'&'; bIgnore = false; }
			else if(sEntity == "gt") { swStr += L'>'; bIgnore = false; }
			else if(sEntity == "lt") { swStr += L'<'; bIgnore = false; }
			else if(sEntity == "quot") { swStr += L'"'; bIgnore = false; }
		}
		else
			pEnd = p + 1;

		if(!bIgnore)
		{
			pPrev = pEnd + 1;
		}

		p = sString.find('&', pEnd);

	} while(true);

	return WideToUtf8(swStr);
}

static CString Utf8Xml_NamedEntityDecode(const CString& sString)
{
	return sString.Replace_n("&quot;", "\"")
		.Replace_n("&gt;", ">")
		.Replace_n("&lt;", "<")
		.Replace_n("&amp;", "&");
}


/************************************************************************/
/* XML STUFF                                                            */
/************************************************************************/

class CXMLException
{
protected:
	CString m_message;
	size_t m_pos;
public:
	CXMLException(const CString& sMessage, size_t iPos)
	{
		m_message = sMessage;
		m_pos = iPos;
	}
	const CString GetMessage() const { return m_message; }
};

class CXMLParser;
class CXMLTag;
typedef CSmartPtr<CXMLTag> PXMLTag;

class CXMLTag
{
	friend class CXMLParser;
protected:
	CString m_name;
	map<const CString, CString> m_attributes;
	vector<PXMLTag> m_children;
	CString m_text;

	CXMLTag()
	{
	}
public:
	const CString& GetName() const
	{
		return m_name;
	}

	const CString GetAttribute(const CString& sName) const
	{
		map<const CString, CString>::const_iterator it = m_attributes.find(sName);
		return (it != m_attributes.end() ? it->second : "");
	}

	const PXMLTag GetChildByName(const CString& sTagName) const
	{
		for(vector<PXMLTag>::const_iterator it = m_children.begin(); it != m_children.end(); it++)
		{
			if((*it)->m_name.Equals(sTagName))
			{
				return *it;
			}
		}
		return PXMLTag();
	}

	const CString GetChildText(const CString& sTagName) const
	{
		const PXMLTag xTag = GetChildByName(sTagName);
		return (xTag ? xTag->m_text : "");
	}

	const vector<PXMLTag>::const_iterator BeginChildren() const
	{
		return m_children.begin();
	}

	const vector<PXMLTag>::const_iterator EndChildren() const
	{
		return m_children.end();
	}
};

class CXMLParser
{
protected:
	// will miss some things such as the bar in <foo lol="wat" bar>, but whatever.
	static void ParseAttributes(const CString& sTagContents, map<const CString, CString>& mAttributes)
	{
		CString::size_type pos = sTagContents.find(" ");
		bool bInName = true, bWaitingForVal = false, bInVal = false;
		char cQuote = 0;
		CString::size_type valStartPos = 0;
		CString sName;

		while(pos != CString::npos && pos < sTagContents.size())
		{
			if(bInName && isspace(sTagContents[pos]))
			{
				pos++;
			}
			else if(bInName && sTagContents[pos] == '=')
			{
				bInName = false;
				bWaitingForVal = true;
				pos = sTagContents.find_first_of("'\"", pos + 1);
			}
			else if(bInName)
			{
				sName += sTagContents[pos];
				pos++;
			}
			else if(bWaitingForVal && (sTagContents[pos] == '"' || sTagContents[pos] == '\''))
			{
				cQuote = sTagContents[pos];
				bInVal = true;
				bWaitingForVal = false;
				valStartPos = pos + 1;
				pos = sTagContents.find(cQuote, pos + 1);
			}
			else if(bInVal && sTagContents[pos] == cQuote)
			{
				bInVal = false;
				bInName = true;
				mAttributes[sName] = sTagContents.substr(valStartPos, pos - valStartPos);
				mAttributes[sName] = Utf8Xml_Decode(mAttributes[sName]);
				sName = "";

				pos++;
			}
			else
				throw CXMLException("internal problem while parsing attributes", 0);
		}

		if(bInVal || bWaitingForVal)
		{
			throw CXMLException("Couldn't parse some tag attributes: <" + sTagContents + ">", 0);
		}
	}
public:
	static PXMLTag ParseString(const CString& sXmlString)
	{
		stack<PXMLTag> m_openTags;
		stack<PXMLTag> m_openTagParent;

		PXMLTag xParent, xRoot;
		bool bEnding = false;

		CString::size_type pos = sXmlString.find("<");
		CString::size_type iTextStartPos = CString::npos;
		unsigned int iIteration = 0, iTextStartPosIteration = 0;

		while(pos != CString::npos)
		{
			if(bEnding)
			{
				throw CXMLException("Multiple root tags?", pos);
			}

			iIteration++;
			CString::size_type tagendpos = sXmlString.find(">", pos + 1);

			if(tagendpos == CString::npos)
			{
				throw CXMLException("No terminating > for open <", pos);
			}

			if(tagendpos == pos + 1)
			{
				throw CXMLException("Empty tag", pos);
			}

			const CString sTagContents = sXmlString.substr(pos + 1, tagendpos - pos - 1);
			CString sTagName = sTagContents.Token(0).Replace_n("\r", "").Replace_n("\n", "");

			if(sTagName.substr(0, 3) == "!--")
			{
				// skip comments.
				tagendpos = sXmlString.find("-->", pos) + 2;

				if(tagendpos == CString::npos)
				{
					throw CXMLException("Unterminated comment", pos);
				}
			}
			else if(sTagName[0] == '?')
			{
				// skip <?xml stuff without any further checks.
			}
			else if(sTagName[0] != '/')
			{
				// found start tag
				PXMLTag xNew(new CXMLTag());
				xNew->m_name = sTagName;

				ParseAttributes(sTagContents, xNew->m_attributes);

				// look out for <img /> style tags:
				if(sTagContents[sTagContents.size() - 1] != '/')
				{
					m_openTags.push(xNew);
					if(xParent) m_openTagParent.push(xParent);
					xParent = xNew;

					// save the position in case this tag has no child tags
					// and we want to extract text from it.
					iTextStartPos = tagendpos + 1;
					iTextStartPosIteration = iIteration;
				}
				else if(xParent)
				{
					xParent->m_children.push_back(xNew);
				}
				else
				{
					xRoot = xNew;
				}
			}
			else
			{
				// found end tag
				sTagName.erase(0, 1);

				if(m_openTags.size() == 0 || !m_openTags.top()->m_name.Equals(sTagName))
				{
					throw CXMLException("Ending tag for '" + CString(sTagName) + "', which is not open", pos);
				}

				// take the now-closed tag off the stack:
				PXMLTag xClosedTag = m_openTags.top();

				m_openTags.pop();

				// if no other tags have been found inbetween, extract text:
				if(iIteration == iTextStartPosIteration + 1)
				{
					xClosedTag->m_text = sXmlString.substr(iTextStartPos, pos - iTextStartPos);
					xClosedTag->m_text = Utf8Xml_Decode(xClosedTag->m_text);
				}

				// no parent = root tag. if this happens, we've walked the tree and are done.
				if(m_openTagParent.empty())
				{
					xRoot = xClosedTag;
					bEnding = true;
				}
				else
				{
					// re-set old parent:
					xParent = m_openTagParent.top();
					m_openTagParent.pop();

					// otherwise, save the new child and to the next tag...
					xParent->m_children.push_back(xClosedTag);
				}
			}

			pos = sXmlString.find("<", tagendpos + 1);
		}

		if(m_openTags.size() != 0)
		{
			throw CXMLException("Found unclosed tags", 0);
		}

		return xRoot;
	}
};


/************************************************************************/
/* TWITTER HTTP REQUEST                                                 */
/************************************************************************/

class CTwitterHTTPSock : public CSimpleHTTPSock
{
protected:
	bool m_timedOut;
	CString m_method;
	bool m_needsAuth;
	CString m_host;
	bool m_bHideErrors;

	CTwitterHTTPSock(CTwitterModule *pModInstance, const CString& sMethod, bool bSilentErrors = true) :
		CSimpleHTTPSock(pModInstance), m_method(sMethod), m_bHideErrors(bSilentErrors)
	{
		m_timedOut = false;
		m_needsAuth = true;
		m_host = "api.twitter.com";
	}

	void Timeout()
	{
		if(!m_bHideErrors) m_pMod->PutModule("ERROR: Sorry, I failed to contact the Twitter servers. They may be down, again!");
		m_timedOut = true;

		CSimpleHTTPSock::Timeout();
	}

	CString SignString(const CString& sString)
	{
		return HMACSHA1(sString, TWITTER_CONSUMER_SECRET "&" + reinterpret_cast<CTwitterModule*>(m_pMod)->GetTokenSecret());
	}

	CString GenerateSignature(const CString& sHTTPMethod, const CString& sNormURL, const MCString& mParams)
	{
		CString sSigBaseStr;

		for(MCString::const_iterator it = mParams.begin(); it != mParams.end(); it++)
		{
			sSigBaseStr += URLEscape(it->first) + "=" + URLEscape(it->second) + "&";
		}

		if(!sSigBaseStr.empty())
		{
			sSigBaseStr.erase(sSigBaseStr.size() - 1);
			sSigBaseStr = URLEscape(sSigBaseStr);
		}

		sSigBaseStr = sHTTPMethod + "&" + URLEscape(sNormURL) + "&" + sSigBaseStr;

		DEBUG("[Twitter] OAuthSigBaseStr: -" << sSigBaseStr << "-");

		return SignString(sSigBaseStr);
	}

	CString GenerateNonce()
	{
		CString sTmp = m_method + "!" + CString(time(NULL)) + "@" + CString(getpid()) + "/" + CString(rand());
		return sTmp.MD5();
	}

	void PrepareParameters(const CString& sHTTPMethod, const CString& sNormURL, MCString& mParams, bool bAuthHeader)
	{
		MCString::iterator sigCheck = mParams.find("oauth_signature");
		if(sigCheck != mParams.end()) mParams.erase(sigCheck);

		if(m_needsAuth)
		{
			const CString sToken = reinterpret_cast<CTwitterModule*>(m_pMod)->GetToken();

			if(!sToken.empty()) mParams["oauth_token"] = sToken;
			mParams["oauth_consumer_key"] = TWITTER_CONSUMER_KEY;
			mParams["oauth_nonce"] = GenerateNonce();
			mParams["oauth_timestamp"] = CString(time(NULL));
			mParams["oauth_signature_method"] = "HMAC-SHA1";
			mParams["oauth_version"] = "1.0";
			mParams["oauth_signature"] = GenerateSignature(sHTTPMethod, sNormURL, mParams);

			if(bAuthHeader)
			{
				CString sHeader = "OAuth ";

				for(MCString::iterator it = mParams.begin(); it != mParams.end(); it++)
				{
					if(it->first.substr(0, 6) == "oauth_")
					{
						sHeader += URLEscape(it->first) + "=\"" + URLEscape(it->second) + "\",";
					}
				}
				sHeader.erase(sHeader.size() - 1);

				m_extraReqHeaders["Authorization"] = sHeader;
			}
		}
	}

	void DoRequest(const CString& sHTTPMethod, const MCString& mParams)
	{
		CString sUrl = "https://" + m_host + "/" + m_method;

		MCString mParamsCopy(mParams);
		PrepareParameters(sHTTPMethod, sUrl, mParamsCopy, (sHTTPMethod != "POST"));

		if(sHTTPMethod == "POST")
		{
			Post(mParamsCopy, m_host, "/" + m_method, 443, true);
		}
		else
		{
			CString sQuery = "?";
			for(MCString::const_iterator it = mParams.begin(); it != mParams.end(); it++)
			{
				sQuery += URLEscape(it->first) + "=" + URLEscape(it->second) + "&";
			}
			sQuery.erase(sQuery.size() - 1);

			Get(m_host, "/" + m_method + sQuery, 443, true);
		}
	}

	void HandleCommonHTTPErrors(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse, bool bLogOutOn401)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 401 && bLogOutOn401)
		{
			pMod->EraseSession(true);
		}
		else if(!m_bHideErrors)
		{
			pMod->PutModule("ERROR: " + m_method + " returned HTTP code " + CString(uResponseCode));

			if(sResponse.Left(5) == "<?xml")
			{
				CString sInfo = sResponse.Replace_n("\r", "").Replace_n("\n", "");
				pMod->PutModule(sInfo.Left(400) + "...");
			}
		}
	}

	virtual void OnRequestError(int iErrorCode)
	{
		if(!m_bHideErrors) m_pMod->PutModule("ERROR: " + m_method + " failed (" + CString(iErrorCode) + ")");
	}
};


/************************************************************************/
/* (ACCESS) TOKEN REQUEST                                               */
/************************************************************************/

class CTRRequestToken : public CTwitterHTTPSock
{
protected:
	bool m_accessToken;
public:
	CTRRequestToken(CTwitterModule *pModInstance) :
		CTwitterHTTPSock(pModInstance, "oauth/request_token", false)
	{
		m_accessToken = false;
	}

	void Request(const CString& sAccessTokenPIN)
	{
		MCString mParams;

		if(!sAccessTokenPIN.empty())
		{
			m_method = "oauth/access_token";
			mParams["oauth_verifier"] = sAccessTokenPIN;
			m_accessToken = true;
		}

		DoRequest("POST", mParams);
	}

	void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 200)
		{
			CString sTmp(sResponse);
			VCString vPairs;

			sTmp.Trim();
			sTmp.Split("&", vPairs, false);

			for(VCString::const_iterator it = vPairs.begin(); it != vPairs.end(); it++)
			{
				CString sKey = it->Token(0, false, "="),
					sValue = it->Token(1, true, "=");

				if(sKey == "oauth_token")
				{
					pMod->m_token = sValue;
				}
				else if(sKey == "screen_name")
				{
					pMod->m_screenName = sValue;
				}
				else if(sKey == "user_id")
				{
					pMod->m_userId = sValue.ToULongLong();
				}
				else if(sKey == "oauth_token_secret")
				{
					pMod->m_tokenSecret = sValue;
				}
			}

			if(!pMod->m_token.empty() && !pMod->m_tokenSecret.empty())
			{
				if(m_accessToken)
				{
					pMod->PutModule("Welcome " + pMod->m_screenName + "! The Twitter module is now ready for action!");

					pMod->m_waitingForPIN = false;
					pMod->m_hasAccessToken = true;

					pMod->SaveSettings();
				}
				else
				{
					pMod->m_waitingForPIN = true;

					pMod->PutModule("Please open this page in your browser to authorize ZNC: http://twitter.com/oauth/authorize?oauth_callback=oob&oauth_token=" + pMod->m_token);
					pMod->PutModule("If you allowed ZNC access, now enter the PIN code from the web page!");
				}
			}
			else
			{
				pMod->PutModule("ERROR: " + m_method + " returned weird stuff.");
			}
		}
		else
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, false);
	}
};


/************************************************************************/
/* STATUS UPDATE REQUEST                                                */
/************************************************************************/

class CTRStatusUpdate : public CTwitterHTTPSock
{
protected:
	bool m_accessToken;
public:
	CTRStatusUpdate(CTwitterModule *pModInstance) :
		CTwitterHTTPSock(pModInstance, "statuses/update.xml", false)
	{
		m_accessToken = false;
	}

	void Request(const CString& sMessage)
	{
		MCString mParams;

		mParams["status"] = sMessage;

		DoRequest("POST", mParams);
	}

	void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 200)
		{
			pMod->PutModule("Tweet sent!");
		}
		else
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, true);
	}
};


/************************************************************************/
/* USER INFO REQUEST                                                    */
/************************************************************************/

class CTRUserInfo : public CTwitterHTTPSock
{
public:
	CTRUserInfo(CTwitterModule *pModInstance) :
		CTwitterHTTPSock(pModInstance, "users/show.xml", false)
	{
	}

	void Request()
	{
		MCString mParams;

		mParams["screen_name"] = reinterpret_cast<CTwitterModule*>(m_pMod)->GetScreenName();

		DoRequest("GET", mParams);
	}

	void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 200)
		{
			PXMLTag xUser;

			try
			{
				xUser = CXMLParser::ParseString(sResponse);
			}
			catch(CXMLException e)
			{
				pMod->PutModule("ERROR: " + m_method + " (xml) " + e.GetMessage());
				return;
			}

			CTable infoTable;

			infoTable.AddColumn("What");
			infoTable.AddColumn("Value");

			infoTable.AddRow();
			infoTable.SetCell("What", "URL");
			infoTable.SetCell("Value", "http://twitter.com/" + xUser->GetChildText("screen_name"));

			infoTable.AddRow();
			infoTable.SetCell("What", "Real Name");
			infoTable.SetCell("Value", xUser->GetChildText("name"));

			infoTable.AddRow();
			infoTable.SetCell("What", "Followers");
			infoTable.SetCell("Value", xUser->GetChildText("followers_count"));

			infoTable.AddRow();
			infoTable.SetCell("What", "Following");
			infoTable.SetCell("Value", xUser->GetChildText("friends_count"));

			infoTable.AddRow();
			infoTable.SetCell("What", "Tweets");
			infoTable.SetCell("Value", xUser->GetChildText("statuses_count"));

			pMod->PutModule(infoTable);

			if(PXMLTag xStatus = xUser->GetChildByName("status"))
			{
				pMod->PutModule("Last Tweet: " + xStatus->GetChildText("text") + " [" + xStatus->GetChildText("created_at") + "]");
			}
		}
		else
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, true);
	}
};


/************************************************************************/
/* USER INFO REQUEST                                                    */
/************************************************************************/

class CTRRateLimit : public CTwitterHTTPSock
{
public:
	CTRRateLimit(CTwitterModule *pModInstance) :
		CTwitterHTTPSock(pModInstance, "account/rate_limit_status.xml", false)
	{
	}

	void Request()
	{
		MCString mParams;
		DoRequest("GET", mParams);
	}

	void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 200)
		{
			PXMLTag xHash;

			try
			{
				xHash = CXMLParser::ParseString(sResponse);
			}
			catch(CXMLException e)
			{
				pMod->PutModule("ERROR: " + m_method + " (xml) " + e.GetMessage());
				return;
			}

			CTable infoTable;

			infoTable.AddColumn("What");
			infoTable.AddColumn("Value");

			infoTable.AddRow();
			infoTable.SetCell("What", "Remaining Hits");
			infoTable.SetCell("Value", xHash->GetChildText("remaining-hits") + " / " + xHash->GetChildText("hourly-limit"));

			infoTable.AddRow();
			infoTable.SetCell("What", "Reset Time");
			infoTable.SetCell("Value", CTwitterModule::FormatTweetTime(strtoull(xHash->GetChildText("reset-time-in-seconds").c_str(), NULL, 10), true));

			pMod->PutModule(infoTable);
		}
		else
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, true);
	}
};


/************************************************************************/
/*      FEED REQUEST                                                    */
/************************************************************************/

class CTRFeed : public CTwitterHTTPSock
{
protected:
	bool m_initial;
	bool m_countSupported;
	int m_feedId;
	ETwitterFeedType m_feedType;
public:
	CTRFeed(CTwitterModule *pModInstance, ETwitterFeedType type, int iFeedId) :
		CTwitterHTTPSock(pModInstance, "", true)
	{
		m_countSupported = true;
		m_initial = false;
		m_feedId = iFeedId;
		m_feedType = type;

		if(type == TWFT_MENTIONS)
		{
			m_method = "statuses/mentions.atom";
		}
		else if(type == TWFT_SEARCH)
		{
			m_method = "search.atom";
			m_host = "search.twitter.com";
			m_needsAuth = false;
			m_countSupported = false;
		}
		else if(type == TWFT_TIMELINE)
		{
			m_method = "statuses/friends_timeline.atom";
		}
		else if(type == TWFT_USER)
		{
			m_method = "statuses/user_timeline.atom";
			m_needsAuth = (pModInstance->IsAuthed()); // needs auth for protected users only.
		}
	}

	void Request(bool bInitial, uint64_t iSinceId, const CString& sPayload)
	{
		MCString mParams;

		if(iSinceId > 0)
		{
			mParams["since_id"] = CString(iSinceId);
		}

		m_initial = bInitial;

		if(m_initial && m_countSupported)
		{
			mParams["count"] = "1";
		}

		if(m_feedType == TWFT_SEARCH)
		{
			mParams["q"] = sPayload;
			mParams["show_user"] = "true";
		}
		else if(m_feedType == TWFT_USER)
		{
			mParams["screen_name"] = sPayload;
		}

		DoRequest("GET", mParams);
	}

	void OnRequestDone(unsigned int uResponseCode, map<const CString, CString>& mHeaders, const CString& sResponse)
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pMod);

		if(uResponseCode == 200)
		{
			PXMLTag xRoot;

			try
			{
				xRoot = CXMLParser::ParseString(sResponse);
			}
			catch(CXMLException e)
			{
				pMod->PutModule("ERROR: " + m_method + " (xml) " + e.GetMessage());
				return;
			}

			if(xRoot->GetName() != "feed")
			{
				pMod->PutModule("ERROR: " + m_method + " -> no <feed> tag...");
				return;
			}

			CTwitterFeed *fFeed = pMod->GetFeedById(m_feedId);

			if(!fFeed) return;

			for(vector<PXMLTag>::const_iterator it = xRoot->BeginChildren(); it != xRoot->EndChildren(); it++)
			{
				const PXMLTag& xTag = *it;

				if(xTag->GetName() == "entry")
				{
					CString sIdTmp = xTag->GetChildText("id");
					CString sText = Utf8Xml_NamedEntityDecode(xTag->GetChildText("title")); // fix twitter bug.
					sText = sText.Replace_n("\r", "").Replace_n("\n", " ");

					CString::size_type uPos = sIdTmp.find("statuses/"), uPosAdd = 9;
					if(uPos == CString::npos) { uPos = sIdTmp.rfind(':'); uPosAdd = 1; } // for search

					if(uPos != CString::npos)
					{
						sIdTmp.erase(0, uPos + uPosAdd);
						uint64_t uId = sIdTmp.ToULongLong();
						time_t iTime = pMod->InterpretRFC3339Time(xTag->GetChildText("published"));

						if(uId > 0 && iTime > 0)
						{
							if(uId > fFeed->m_lastId)
							{
								fFeed->m_lastId = uId;
							}

							if(m_initial)
							{
								break;
							}

							pMod->QueueMessage(fFeed, iTime, sText);
						}
					}
				}
			}

			fFeed->m_lastUpdate = time(NULL);
		}
		else if(uResponseCode == 400)
		{
			PXMLTag xHash;

			try
			{
				xHash = CXMLParser::ParseString(sResponse);
			}
			catch(CXMLException e)
			{
				pMod->PutModule("ERROR: " + m_method + " (xml/error) " + e.GetMessage());
				return;
			}

			pMod->PutModule("ERROR: Feed " + CString(m_feedId) + " returned an error: " + xHash->GetChildText("error"));
			pMod->PutModule("Disabling updates on this feed for 15 minutes.");

			CTwitterFeed *fFeed = pMod->GetFeedById(m_feedId);

			if(fFeed)
			{
				fFeed->m_lastUpdate = time(NULL) + 60 * 15;
			}
		}
		else if(uResponseCode == 503 && m_feedType == TWFT_SEARCH)
		{
			CTwitterFeed *fFeed = pMod->GetFeedById(m_feedId);

			if(fFeed)
			{
				// The Retry-After header's value is the number of seconds your
				// application should wait before submitting another query.
				fFeed->m_lastUpdate = time(NULL) + atoi(mHeaders["Retry-After"].c_str());
			}
		}
		else if(uResponseCode == 502) // "twitter is over capacity"
		{
			CTwitterFeed *fFeed = pMod->GetFeedById(m_feedId);

			// cut them servers some slack:
			if(fFeed)
			{
				fFeed->m_lastUpdate = time(NULL) + 5 * 60;
			}
		}
		else if(m_needsAuth)
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, true);
		else
			HandleCommonHTTPErrors(uResponseCode, mHeaders, sResponse, false);
	}
};


/************************************************************************/
/*       TIMER IMPLEMENTATION                                           */
/************************************************************************/

class CModTwitterTimer : public CTimer
{
public:
	CModTwitterTimer(CModule* pModule, unsigned int uInterval, unsigned int uCycles, const CString& sLabel, const CString& sDescription) : CTimer(pModule, uInterval, uCycles, sLabel, sDescription) {}
	~CModTwitterTimer() {}
protected:
	void RunJob()
	{
		CTwitterModule *pMod = reinterpret_cast<CTwitterModule*>(m_pModule);

		pMod->TimerAction();
	}
};


/************************************************************************/
/*       CTwitterModule implementation                                  */
/************************************************************************/

static bool _feedQueueSortByID(const CTwitterFeed& a, const CTwitterFeed& b)
{
	return (a.m_id < b.m_id);
}

void CTwitterModule::OnModCommand(const CString& sCommand)
{
	const CString sCmd = sCommand.Token(0).AsUpper();

	if(sCmd == "HELP")
	{
		CTable CmdTable;

		CmdTable.AddColumn("Command");
		CmdTable.AddColumn("Description");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "LOGIN");
		CmdTable.SetCell("Description", "Use this command to initially set up the client.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "TWEET <message>");
		CmdTable.SetCell("Description", "Posts a tweet to Twitter! You can also use /me <message> in this window.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "STATUS");
		CmdTable.SetCell("Description", "Shows basic info about the logged in user.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "WATCH (timeline|mentions|user <screenname>|search) [#channel|nick]");
		CmdTable.SetCell("Description", "Creates a feed to watch. user + search do not need a login. No target = this window. See also: CHANGE.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "WATCH");
		CmdTable.SetCell("Description", "Lists all active feeds.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "CHANGE <id> (prefix|target|query|colors) <new val>");
		CmdTable.SetCell("Description", "Changes a feed's settings, <id> is the number from the WATCH list. Colors = (on|off). Query only applies to searches.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "STYLE (user|@user|hashtag|link|timestamp|text) ([bold] [underline] [fore[,back]]|off)");
		CmdTable.SetCell("Description", "Sets color and text style. Example: 'STYLE hashtag underline 4' would make all #hashtags red & underlined.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "STYLE");
		CmdTable.SetCell("Description", "Shows active styles.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "DELETE <id>");
		CmdTable.SetCell("Description", "Deletes the feed with the number <id> from the WATCH list.");

		CmdTable.AddRow();
		CmdTable.SetCell("Command", "HELP");
		CmdTable.SetCell("Description", "This help.");

		PutModule(CmdTable);
	}
	else if(sCmd == "WATCH" || sCmd == "SHOW")
	{
		const CString sSubCmd = sCommand.Token(1, false).AsLower();

		if((sSubCmd.empty() || sCmd == "SHOW") && m_feeds.size() > 0)
		{
			CTable tbl;
			static const char* feedTypeNames[_TWFT_MAX] = { "", "Timeline", "Mentions", "User", "Search" };

			tbl.AddColumn("ID");
			tbl.AddColumn("Type");
			tbl.AddColumn("Param");
			tbl.AddColumn("Target");
			tbl.AddColumn("Prefix");
			tbl.AddColumn("Updated");

			sort(m_feeds.begin(), m_feeds.end(), _feedQueueSortByID);

			for(vector<CTwitterFeed>::const_iterator it = m_feeds.begin(); it != m_feeds.end(); it++)
			{
				tbl.AddRow();
				tbl.SetCell("ID", CString(it->m_id));
				tbl.SetCell("Type", feedTypeNames[it->m_type]);
				tbl.SetCell("Param", it->m_payload.empty() ? "-" : it->m_payload);
				tbl.SetCell("Target", it->m_target.empty() ? CString(CZNC::Get().GetStatusPrefix() + m_sModName) : it->m_target);
				tbl.SetCell("Prefix", it->m_prefix);
				tbl.SetCell("Updated", (it->m_lastUpdate == 0 ? CString("never") : FormatTweetTime(it->m_lastUpdate)));
			}

			PutModule(tbl);
		}
		else if(sSubCmd.empty() || sCmd == "SHOW")
		{
			PutModule("ERROR: No watches/feeds set up.");
		}
		else if(sSubCmd == "timeline" || sSubCmd == "mentions" || sSubCmd == "user" || sSubCmd == "search")
		{
			if(!m_hasAccessToken && (sSubCmd == "timeline" || sSubCmd == "mentions"))
			{
				PutModule("ERROR: timeline and mentions need a logged in user. Use the LOGIN command.");
				return;
			}

			const CString sToken2 = sCommand.Token(2),
				sToken3 = sCommand.Token(3);

			if(sSubCmd == "user" && sToken2.empty())
			{
				PutModule("ERROR: No user name specified.");
				return;
			}

			CTwitterFeed fNew(
				(sSubCmd == "timeline" ? TWFT_TIMELINE :
				(sSubCmd == "mentions" ? TWFT_MENTIONS :
				(sSubCmd == "user" ? TWFT_USER :
				(sSubCmd == "search" ? TWFT_SEARCH : _TWFT_MAX)))));
			fNew.m_id = (m_nextFeedId++);
			fNew.m_lastId = 0;
			fNew.m_payload = (sSubCmd == "user" ? sToken2 : "");
			fNew.m_target = (sSubCmd == "user" ? sToken3 : sToken2);

			m_feeds.push_back(fNew);

			SaveSettings();

			PutModule("Added!");
		}
		else
		{
			PutModule("Command not understood. Have a look at HELP.");
		}
	}
	else if(sCmd == "CHANGE" || sCmd == "DELETE" || sCmd == "REMOVE")
	{
		int id = sCommand.Token(1).ToInt();
		vector<CTwitterFeed>::iterator it;

		for(it = m_feeds.begin(); it != m_feeds.end(); it++)
		{
			if(it->m_id == id)
				break;
		}

		if(it == m_feeds.end())
		{
			PutModule("ERROR: No feed with ID " + CString(id) + " found.");
			return;
		}

		if(sCmd != "CHANGE")
		{
			m_feeds.erase(it);
			SaveSettings();
			PutModule("Feed deleted.");
			return;
		}

		const CString sWhat = sCommand.Token(2).AsLower();
		const CString sNew = sCommand.Token(3, true);

		if(sWhat == "prefix")
		{
			it->m_prefix = sNew;
			PutModule("Prefix changed.");
		}
		else if(sWhat == "target")
		{
			it->m_target = sNew;
			PutModule("Sending feed messages to " + (it->m_target.empty() ? CZNC::Get().GetStatusPrefix() + m_sModName : it->m_target) + " from now on.");
		}
		else if(sWhat == "colors" || sWhat == "color")
		{
			it->m_colors = (sNew == "1" || sNew == "true" || sNew == "on");
			PutModule("Colors are now '" + CString(it->m_colors ? "on" : "off") + "'.");
		}
		else if(sWhat == "query" && it->m_type == TWFT_SEARCH && !sNew.empty())
		{
			it->m_payload = sNew;
			PutModule("Query changed.");
		}
		else
		{
			PutModule("Command not understood. Have a look at HELP.");
		}

		SaveSettings();
	}
	else if(sCmd == "STYLE")
	{
		const CString sWhat = sCommand.Token(1).AsLower();
		bool bChangedSth = false;

		if(sWhat.empty())
		{
			CString sMsg = "Active styles: ";

			for(map<const CString, CFontStyle>::iterator it = m_styles.begin(); it != m_styles.end(); it++)
			{
				sMsg += it->second.GetStartCode() + it->first + it->second.GetEndCode() + " / ";
			}

			sMsg.erase(sMsg.size() - 3);

			PutModule(sMsg);
			return;
		}

		map<const CString, CFontStyle>::iterator it = m_styles.find(sWhat);

		if(it != m_styles.end())
		{
			it->second = CFontStyle();

			for(size_t p = 2; p < 5; p++)
			{
				const CString sStyle = sCommand.Token(p);
				int l_fore = -1, l_back = -1;

				if(sStyle == "bold")
					{ it->second.bBold = true; bChangedSth = true; }
				else if(sStyle == "underline" || sStyle == "underlined")
					{ it->second.bUnderline = true;  bChangedSth = true; }
				else if(sscanf(sStyle.c_str(), "%i,%i", &l_fore, &l_back) == 2 ||
					sscanf(sStyle.c_str(), "%i", &l_fore) == 1)
				{
					it->second.iForeClr = (l_fore > 15 ? 15 : l_fore);
					it->second.iBackClr = (l_back > 15 ? 15 : l_back);
					bChangedSth = true;
				}
				else if(sStyle == "off")
					bChangedSth = true;
			}
		}

		if(!bChangedSth)
		{
			PutModule("Command not understood. Have a look at HELP.");
		}
		else
		{
			PutModule("Changed style for " + it->second.GetStartCode() + sWhat);
			SaveSettings();
		}
	}
	else if(sCmd == "TWEET")
	{
		CString sMessage = sCommand.Token(1, true);
		SendTweet(sMessage);
	}
	else if(sCmd == "LOGIN")
	{
		if(m_hasAccessToken && sCommand.Token(1).AsLower() != "force")
		{
			PutModule("We are already authenticated with Twitter (user: " + m_screenName + "). Use LOGIN FORCE to ignore. Also check the HELP command!");
		}
		else
		{
			PutModule("Logging in to Twitter...");

			EraseSession(false);

			CTRRequestToken *pReq = new CTRRequestToken(this);
			pReq->Request("");
		}
	}
	else if(sCmd == "LOGOUT")
	{
		EraseSession(false);

		PutModule("Login data erased.");
	}
	else if(sCmd == "STATUS")
	{
		if(m_hasAccessToken)
		{
			PutModule("Getting status...");

			CTRUserInfo *pReq = new CTRUserInfo(this);
			pReq->Request();
		}
		else
		{
			PutModule("Not logged in. Use the LOGIN command.");
		}
	}
	else if(sCmd == "RATELIMIT")
	{
		if(m_hasAccessToken)
		{
			PutModule("Getting status...");

			CTRRateLimit *pReq = new CTRRateLimit(this);
			pReq->Request();
		}
		else
		{
			PutModule("Not logged in. Use the LOGIN command.");
		}
	}
	else if(m_waitingForPIN)
	{
		unsigned long long pin = sCommand.Token(0).ToULongLong();

		if(pin > 0)
		{
			PutModule("Checking PIN...");

			CTRRequestToken *pReq = new CTRRequestToken(this);
			pReq->Request(CString(pin));
		}
		else if(sCommand.Token(0).AsUpper() == "CANCEL")
		{
			m_waitingForPIN = false;
			m_token = m_tokenSecret = m_screenName = "";

			PutModule("Auth process cancelled. Use LOGIN to start over.");
		}
		else
		{
			PutModule("ERROR: This didn't look like a PIN code. Type CANCEL to start over.");
		}
	}
	else
	{
		PutModule("Unknown command! Try HELP or TWEET <message>.");
	}
}

void CTwitterModule::OnModCTCP(const CString& sMessage)
{
	if(sMessage.Token(0) == "ACTION")
	{
		SendTweet(sMessage.Token(1, true));
	}
}

void CTwitterModule::SendTweet(CString sMessage)
{
	size_t iUtf8Len = 0;

	if(!m_hasAccessToken)
	{
		PutModule("ERROR: Not logged in. Please use LOGIN to login!");
		return;
	}

	if(!IsStrValidUTF8(sMessage, iUtf8Len))
	{
		sMessage = Iso88591toUtf8(sMessage);

		if(!IsStrValidUTF8(sMessage, iUtf8Len))
		{
			PutModule("ERROR: Your client didn't send a valid UTF-8 or ISO-8859-1 encoded message!");
			return;
		}
	}

	if(iUtf8Len > 140)
	{
		PutModule("ERROR: Your message has " + CString(iUtf8Len) + " characters. Maximum allowed length is 140 characters.");
	}
	else
	{
		PutModule("Sending tweet...");

		CTRStatusUpdate *pReq = new CTRStatusUpdate(this);
		pReq->Request(sMessage);
	}
}

void CTwitterModule::EraseSession(bool bErrorMessage)
{
	m_hasAccessToken = m_waitingForPIN = false;
	m_token = m_tokenSecret = m_screenName = "";

	SaveSettings();

	if(bErrorMessage)
	{
		PutModule("ERROR: Session has expired. Please use LOGIN to login again.");
	}
}

bool CTwitterModule::OnLoad(const CString& sArgs, CString& sMessage)
{
	LoadSettings();

	AddTimer(new CModTwitterTimer(this, 1, 0, "TwitterModuleTimer", ""));

	return true;
}

void CTwitterModule::SaveSettings()
{
	ClearNV();

	if(m_hasAccessToken && !m_token.empty() && !m_tokenSecret.empty())
	{
		SetNV("token", m_token, false);
		SetNV("secret", m_tokenSecret, false);
		SetNV("screen_name", m_screenName, false);
	}

	CString sFeeds = "<feeds>";
	for(vector<CTwitterFeed>::const_iterator it = m_feeds.begin(); it != m_feeds.end(); it++)
	{
		sFeeds += "<feed type=\"" + CString(it->m_type) + "\">";

		if(!it->m_payload.empty()) sFeeds += "<payload>" + Utf8Xml_Encode(it->m_payload) + "</payload>";
		if(!it->m_prefix.empty()) sFeeds += "<prefix>" + Utf8Xml_Encode(it->m_prefix) + "</prefix>";
		if(!it->m_target.empty()) sFeeds += "<target>" + Utf8Xml_Encode(it->m_target) + "</target>";

		sFeeds += "</feed>";
	}
	sFeeds += "</feeds>";

	SetNV("feeds", sFeeds, false);

	CString sStyles = "<styles>";
	for(map<const CString, CFontStyle>::const_iterator it = m_styles.begin(); it != m_styles.end(); it++)
	{
		sStyles += "<style name=\"" + Utf8Xml_Encode(it->first) + "\">";

		sStyles += "<bold>" + CString(it->second.bBold ? 1 : 0) + "</bold>";
		sStyles += "<underline>" + CString(it->second.bUnderline ? 1 : 0) + "</underline>";
		sStyles += "<forecolor>" + CString(it->second.iForeClr) + "</forecolor>";
		sStyles += "<backcolor>" + CString(it->second.iBackClr) + "</backcolor>";

		sStyles += "</style>";
	}
	sStyles += "</styles>";

	SetNV("styles", sStyles, true);
}


void CTwitterModule::LoadSettings()
{
	LoadRegistry();

	m_token = GetNV("token");
	m_tokenSecret = GetNV("secret");

	if(!m_token.empty() && !m_tokenSecret.empty())
	{
		m_hasAccessToken = true;

		m_screenName = GetNV("screen_name");
	}
	else // ensure consistent state...
	{
		m_token = m_tokenSecret = "";
	}

	PXMLTag xFeeds;

	try
	{
		xFeeds = CXMLParser::ParseString(GetNV("feeds"));
	}
	catch (CXMLException ex)
	{
		PutModule("Warning: Couldn't read feeds from disk.");
	}

	if(xFeeds)
	{
		for(vector<PXMLTag>::const_iterator it = xFeeds->BeginChildren(); it != xFeeds->EndChildren(); it++)
		{
			const PXMLTag& xFeed = *it;

			int iType = xFeed->GetAttribute("type").ToInt();

			if(iType > 0 && iType < _TWFT_MAX)
			{
				CTwitterFeed fNew((ETwitterFeedType)iType);

				fNew.m_id = (m_nextFeedId++);
				fNew.m_lastId = 0;
				fNew.m_payload = xFeed->GetChildText("payload");
				fNew.m_prefix = xFeed->GetChildText("prefix");
				fNew.m_target = xFeed->GetChildText("target");

				m_feeds.push_back(fNew);
			}
		}
	}

	PXMLTag xStyles;

	try
	{
		xStyles = CXMLParser::ParseString(GetNV("styles"));
	}
	catch (CXMLException ex)
	{
		PutModule("Warning: Couldn't read styles from disk.");
	}

	if(xStyles)
	{
		for(vector<PXMLTag>::const_iterator it = xStyles->BeginChildren(); it != xStyles->EndChildren(); it++)
		{
			const PXMLTag& xStyle = *it;
			map<const CString, CFontStyle>::iterator found = m_styles.find((*it)->GetAttribute("name"));

			if(found != m_styles.end())
			{
				found->second.bBold = (xStyle->GetChildText("bold") == "1");
				found->second.bUnderline = (xStyle->GetChildText("underline") == "1");
				found->second.iBackClr = xStyle->GetChildText("backcolor").ToInt();
				found->second.iForeClr = xStyle->GetChildText("forecolor").ToInt();

				if(found->second.iBackClr > 15) found->second.iBackClr = 15;
				if(found->second.iForeClr > 15) found->second.iForeClr = 15;
				if(found->second.iBackClr < -1) found->second.iBackClr = -1;
				if(found->second.iForeClr < -1) found->second.iForeClr = -1;
			}
		}
	}

	if(m_hasAccessToken && m_pUser && m_pUser->IsUserAttached())
	{
		CTRUserInfo *pReq = new CTRUserInfo(this);
		pReq->Request();
	}
}

CTwitterFeed *CTwitterModule::GetFeedById(int id)
{
	for(vector<CTwitterFeed>::iterator it = m_feeds.begin(); it != m_feeds.end(); it++)
	{
		if(it->m_id == id)
			return &(*it);
	}
	return NULL;
}

static bool _feedQueueSortByLastUpdate(const CTwitterFeed& a, const CTwitterFeed& b)
{
	return (a.m_lastUpdate < b.m_lastUpdate);
}

void CTwitterModule::TimerAction()
{
	int iMsgsSent = 0;
	bool bAllowBunch = (m_msgQueueLastSent < time(NULL) - 10);

	while(!m_msgQueue.empty())
	{
		vector<pair<time_t, CString> >::iterator it = m_msgQueue.begin();

		if(it->second.substr(0, 10) == "PRIVMSG  :")
		{
			// message to *twitter, no rate limiting required.
			PutModule(it->second.substr(10));
		}
		else if((iMsgsSent < 5 && bAllowBunch) || (m_msgQueueLastSent < time(NULL)))
		{
			iMsgsSent++;
			PutIRC(it->second);
			if(m_pUser) m_pUser->PutUser(":" + m_pUser->GetIRCNick().GetNickMask() + " " + it->second);
			m_msgQueueLastSent = time(NULL);
		}
		else
			break;

		m_msgQueue.erase(it);
	}

	// look at updates...
	sort(m_feeds.begin(), m_feeds.end(), _feedQueueSortByLastUpdate);

	// this rate limiting thing here is not very smart.
	// we essentially have a limit of 150 calls per hour per IP/account.
	// but we don't use that. Instead, we send one rate-limited request
	// every sixty seconds...
	// read: http://apiwiki.twitter.com/Rate-limiting

	for(vector<CTwitterFeed>::iterator it = m_feeds.begin(); it != m_feeds.end(); it++)
	{
		bool bRateLimited = (it->m_type != TWFT_SEARCH);

		if(it->m_type == TWFT_SEARCH || it->m_type == TWFT_USER)
		{
			if(it->m_payload.empty())
			{
				continue;
			}
		}

		if(it->m_lastUpdate <= time(NULL) - 60 && (!bRateLimited || m_lastRateLimitedCall < time(NULL) - 30))
		{
			CTRFeed *req = new CTRFeed(this, it->m_type, it->m_id);
			req->Request(it->m_lastId == 0, it->m_lastId, it->m_payload);

			DEBUG("REQUESTING " + CString(it->m_id) + " [RL = " + CString(bRateLimited) + "]");

			it->m_lastUpdate = time(NULL);

			if(bRateLimited) m_lastRateLimitedCall = time(NULL);
		}
	}
}

time_t CTwitterModule::InterpretRFC3339Time(const CString& sRFC3339)
{
	unsigned int year, mon, day, hour, min, tz_h = 0, tz_m = 0;
	char tz_sign = '+';
	float sec;

	if(sscanf(sRFC3339.c_str(), "%u-%u-%uT%u:%u:%f%c%u:%u",
		&year, &mon, &day, &hour, &min, &sec, &tz_sign, &tz_h, &tz_m) == 9 ||
		sscanf(sRFC3339.c_str(), "%u-%u-%uT%u:%u:%fZ", &year, &mon, &day, &hour, &min, &sec) == 6)
	{
		struct tm in_time; memset(&in_time, 0, sizeof(in_time)); in_time.tm_isdst = -1;

		in_time.tm_year = year - 1900; in_time.tm_mon = mon - 1; in_time.tm_mday = day;
		in_time.tm_hour = hour; in_time.tm_min = min; in_time.tm_sec = (int)sec;

		time_t in_time_tmp = mktime(&in_time);

		if(in_time_tmp > 0)
		{
			time_t gm_time = in_time_tmp - (tz_sign == '-' ? -1 : 1) * (time_t)(tz_h * 3600 + tz_m * 60);

			time_t now = time(NULL);
			tm *ptm;
			ptm = gmtime(&now);
			time_t now_gmt = mktime(ptm) - (ptm->tm_isdst != 0 ? 3600 : 0);
			time_t local_gmt_offset = (now - now_gmt);

			time_t local_time = gm_time + local_gmt_offset;

			local_time += (time_t)(m_pUser->GetTimezoneOffset() * 60 * 60);

			return local_time;
		}
	}

	return 0;
}

CString CTwitterModule::FormatTweetTime(time_t iTime, bool bAllowFuture)
{
	CString sTime = "error";
	time_t iDelta = time(NULL) - iTime;

	if(iDelta < 0 && !bAllowFuture)
	{
		sTime = "from the future!";
	}
	else if(iDelta < 60 && iDelta > 0)
	{
		sTime = "less than one minute ago";
	}
	else if(iDelta < 120 && iDelta > 0)
	{
		sTime = "one minute ago";
	}
	else if(iDelta <= 600 && iDelta > 0)
	{
		sTime = CString(iDelta / 60) + " minutes ago";
	}
	else if(iDelta <= 86400 && iDelta > 0)
	{
		sTime = CString::ToTimeStr(iDelta);
	}
	else
	{
		char szTimeBuf[500];
		tm *ptm = localtime(&iTime);

		if(strftime(&szTimeBuf[0], 499, "%a, %m %B %H:%M:%S", ptm) > 0)
		{
			sTime = szTimeBuf;
		}
	}

	return sTime;
}

static bool _msgQueueSort(const pair<time_t, CString>& a, const pair<time_t, CString>& b)
{
	return (a.first < b.first);
}

void CTwitterModule::QueueMessage(CTwitterFeed *fFeed, time_t iTime, const CString& sMessage)
{
	if(fFeed->m_colors)
	{
		CString sColoredMessage;
		VCString sTokens;

		sColoredMessage = "\x03\x03"; // reset colors
		if(!fFeed->m_prefix.empty()) sColoredMessage += fFeed->m_prefix;

		sMessage.Split(" ", sTokens, false, "", "", false, true);

		CString sStyle;

		for(VCString::const_iterator it = sTokens.begin(); it != sTokens.end(); it++)
		{
			const CString sOldStyle(sStyle);

			if(it == sTokens.begin())
				sStyle = "user";
			else if(!it->empty() && (*it)[0] == '#')
				sStyle = "hashtag";
			else if(!it->empty() && (*it)[0] == '@')
				sStyle = "@user";
			else if(it->Left(7) == "http://" || it->Left(8) == "https://")
				sStyle = "link";
			else
				sStyle = "text";

			if(sStyle != sOldStyle)
			{
				if(!sOldStyle.empty())
				{
					sColoredMessage += m_styles[sOldStyle].GetEndCode();
					sColoredMessage += " ";
				}
				sColoredMessage += m_styles[sStyle].GetStartCode();
				sColoredMessage += *it;
			}
			else
			{
				sColoredMessage += " " + *it;
			}
		}

		if(!sStyle.empty())
		{
			sColoredMessage += m_styles[sStyle].GetEndCode();
		}

		sColoredMessage += " " + m_styles["timestamp"].GetStartCode() + "[" + FormatTweetTime(iTime) + "]";

		m_msgQueue.push_back(pair<time_t, CString>(iTime, "PRIVMSG " + fFeed->m_target + " :" +  sColoredMessage));
	}
	else
	{
		m_msgQueue.push_back(pair<time_t, CString>(iTime, "PRIVMSG " + fFeed->m_target + " :" +  sMessage));
	}

	sort(m_msgQueue.begin(), m_msgQueue.end(), _msgQueueSort);
}

CTwitterModule::~CTwitterModule()
{
}

/************************************************************************/
/* ZNC export definition                                                */
/************************************************************************/

MODULEDEFS(CTwitterModule, "Implements a simple twitter client.")
