# public-resolvers

This is an extensive list of public DNS resolvers supporting the
DNSCrypt and DNS-over-HTTP2 protocols.

This list is maintained by Frank Denis <j @ dnscrypt [.] info>

Warning: it includes servers that may censor content, servers that don't
verify DNSSEC records, and servers that will collect and monetize your
queries.

Adjust the `require_*` options in dnscrypt-proxy to filter that list
according to your needs.

To use that list, add this to the `[sources]` section of your
`dnscrypt-proxy.toml` configuration file:

    [sources.'public-resolvers']
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md', 'https://cdn.jsdelivr.net/gh/DNSCrypt/dnscrypt-resolvers@master/v3/public-resolvers.md']
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    cache_file = 'public-resolvers.md'

--


## a-and-a

Andrews & Arnold non-filtering resolver.
No logging, DNSSEC validation. Homepage: https://www.aa.net.uk/dns/
Operated by Andrews & Arnold. Service page: https://www.aa.net.uk/dns/

sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjIADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjMADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ


## a-and-a-ipv6

Andrews & Arnold non-filtering resolver.
IPv6 endpoint. No logging, DNSSEC validation. Homepage: https://www.aa.net.uk/dns/
Operated by Andrews & Arnold. Service page: https://www.aa.net.uk/dns/

sdns://AgcAAAAAAAAAEFsyMDAxOjhiMDo6MjAyMl0ADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAEFsyMDAxOjhiMDo6MjAyM10ADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ


## adfilter-adl

Hosted in Adelaide, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.
Operated by ADFilter. Service page: https://adfilter.com/

sdns://AgMAAAAAAAAADzEwMy4yNDkuMjM4LjEyNCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBhZGwuYWRmaWx0ZXIubmV0Ci9kbnMtcXVlcnk


## adfilter-adl-ipv6

Hosted in Adelaide, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.
Operated by ADFilter. Service page: https://adfilter.com/

sdns://AgMAAAAAAAAAGFsyNDA0Ojk0MDA6NjkwMzoyMTAwOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBhZGwuYWRmaWx0ZXIubmV0Ci9kbnMtcXVlcnk


## adfilter-per

Hosted in Perth, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.
Operated by ADFilter. Service page: https://adfilter.com/

sdns://AgMAAAAAAAAADTIwMy4yOS4yNDEuNzYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQQcGVyLmFkZmlsdGVyLm5ldAovZG5zLXF1ZXJ5


## adfilter-per-ipv6

Hosted in Perth, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.
Operated by ADFilter. Service page: https://adfilter.com/

sdns://AgMAAAAAAAAAGFsyNDA0Ojk0MDA6NDFhOTo0ODAwOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBwZXIuYWRmaWx0ZXIubmV0Ci9kbnMtcXVlcnk


## adfilter-syd

Hosted in Sydney, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.
Operated by ADFilter. Service page: https://adfilter.com/

sdns://AgMAAAAAAAAADjExMi4yMTMuMzIuMjE5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EHN5ZC5hZGZpbHRlci5uZXQKL2Rucy1xdWVyeQ


## adguard-dns

AdGuard DNS Default public resolver.
Available through servers in multiple locations around the world.
Blocks ads, trackers, phishing and malicious domains.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20
sdns://AQMAAAAAAAAAETk0LjE0MC4xNS4xNTo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20


## adguard-dns-doh

AdGuard DNS Default public resolver.
Available through servers in multiple locations around the world.
Blocks ads, trackers, phishing and malicious domains.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNCCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KQw5NC4xNDAuMTQuMTQKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNSCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KQw5NC4xNDAuMTUuMTUKL2Rucy1xdWVyeQ


## adguard-dns-doh-ipv6

AdGuard DNS Default public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks ads, trackers, phishing and malicious domains.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgMAAAAAAAAAE1syYTEwOjUwYzA6OmFkMTpmZl0gmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikTZG5zLmFkZ3VhcmQtZG5zLmNvbQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAE1syYTEwOjUwYzA6OmFkMjpmZl0gmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikTZG5zLmFkZ3VhcmQtZG5zLmNvbQovZG5zLXF1ZXJ5


## adguard-dns-family

AdGuard DNS Family Protection resolver.
Available through servers in multiple locations around the world.
Blocks ads, trackers, phishing, malicious and adult domains. Enforces safe search where available.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNTo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ
sdns://AQMAAAAAAAAAETk0LjE0MC4xNS4xNjo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ


## adguard-dns-family-doh

AdGuard DNS Family Protection resolver.
Available through servers in multiple locations around the world.
Blocks ads, trackers, phishing, malicious and adult domains. Enforces safe search where available.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNSCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KQw5NC4xNDAuMTQuMTUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNiCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KQw5NC4xNDAuMTUuMTYKL2Rucy1xdWVyeQ


## adguard-dns-family-doh-ipv6

AdGuard DNS Family Protection resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks ads, trackers, phishing, malicious and adult domains. Enforces safe search where available.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgMAAAAAAAAAFFsyYTEwOjUwYzA6OmJhZDE6ZmZdIJs0-sPjbn4rH-5IR6c3ZiLUziyHN4wuotRgRyPdP_YpFmZhbWlseS5hZGd1YXJkLWRucy5jb20KL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAFFsyYTEwOjUwYzA6OmJhZDI6ZmZdIJs0-sPjbn4rH-5IR6c3ZiLUziyHN4wuotRgRyPdP_YpFmZhbWlseS5hZGd1YXJkLWRucy5jb20KL2Rucy1xdWVyeQ


## adguard-dns-family-ipv6

AdGuard DNS Family Protection resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks ads, trackers, phishing, malicious and adult domains. Enforces safe search where available.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAGVsyYTEwOjUwYzA6OmJhZDE6ZmZdOjU0NDMguDFd17FLbuMgpHDcLtaxqjmMyeWG-F1FRda4ybUAWrohMi5kbnNjcnlwdC5mYW1pbHkubnMxLmFkZ3VhcmQuY29t
sdns://AQMAAAAAAAAAGVsyYTEwOjUwYzA6OmJhZDI6ZmZdOjU0NDMguDFd17FLbuMgpHDcLtaxqjmMyeWG-F1FRda4ybUAWrohMi5kbnNjcnlwdC5mYW1pbHkubnMxLmFkZ3VhcmQuY29t


## adguard-dns-ipv6

AdGuard DNS Default public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks ads, trackers, phishing and malicious domains.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAGFsyYTEwOjUwYzA6OmFkMTpmZl06NTQ0MyDRK0fyUtzywrv4mRCG6vec5EldixbIoMQyLlLKPzkIcyIyLmRuc2NyeXB0LmRlZmF1bHQubnMxLmFkZ3VhcmQuY29t
sdns://AQMAAAAAAAAAGFsyYTEwOjUwYzA6OmFkMjpmZl06NTQ0MyDRK0fyUtzywrv4mRCG6vec5EldixbIoMQyLlLKPzkIcyIyLmRuc2NyeXB0LmRlZmF1bHQubnMxLmFkZ3VhcmQuY29t


## adguard-dns-unfiltered

AdGuard DNS Non-filtering public resolver.
Available through servers in multiple locations around the world.
Does not block or rewrite domains.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQcAAAAAAAAAEjk0LjE0MC4xNC4xNDA6NTQ0MyC16ETWuDo-PhJo62gfvqcN48X6aNvWiBQdvy7AZrLa-iUyLmRuc2NyeXB0LnVuZmlsdGVyZWQubnMxLmFkZ3VhcmQuY29t
sdns://AQcAAAAAAAAAEjk0LjE0MC4xNC4xNDE6NTQ0MyC16ETWuDo-PhJo62gfvqcN48X6aNvWiBQdvy7AZrLa-iUyLmRuc2NyeXB0LnVuZmlsdGVyZWQubnMxLmFkZ3VhcmQuY29t


## adguard-dns-unfiltered-doh

AdGuard DNS Non-filtering public resolver.
Available through servers in multiple locations around the world.
Does not block or rewrite domains.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgcAAAAAAAAADTk0LjE0MC4xNC4xNDAgmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikNOTQuMTQwLjE0LjE0MAovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADTk0LjE0MC4xNC4xNDEgmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikNOTQuMTQwLjE0LjE0MQovZG5zLXF1ZXJ5


## adguard-dns-unfiltered-doh-ipv6

AdGuard DNS Non-filtering public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Does not block or rewrite domains.
Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html

sdns://AgcAAAAAAAAAEVsyYTEwOjUwYzA6OjE6ZmZdIJs0-sPjbn4rH-5IR6c3ZiLUziyHN4wuotRgRyPdP_YpGnVuZmlsdGVyZWQuYWRndWFyZC1kbnMuY29tCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAEVsyYTEwOjUwYzA6OjI6ZmZdIJs0-sPjbn4rH-5IR6c3ZiLUziyHN4wuotRgRyPdP_YpGnVuZmlsdGVyZWQuYWRndWFyZC1kbnMuY29tCi9kbnMtcXVlcnk


## adguard-dns-unfiltered-ipv6

AdGuard DNS Non-filtering public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Does not block or rewrite domains.

Operated by AdGuard. Service page: https://adguard-dns.io/en/public-dns.html
Warning: This server is incompatible with anonymization.

sdns://AQcAAAAAAAAAFlsyYTEwOjUwYzA6OjE6ZmZdOjU0NDMgtehE1rg6Pj4SaOtoH76nDePF-mjb1ogUHb8uwGay2volMi5kbnNjcnlwdC51bmZpbHRlcmVkLm5zMS5hZGd1YXJkLmNvbQ
sdns://AQcAAAAAAAAAFlsyYTEwOjUwYzA6OjI6ZmZdOjU0NDMgtehE1rg6Pj4SaOtoH76nDePF-mjb1ogUHb8uwGay2volMi5kbnNjcnlwdC51bmZpbHRlcmVkLm5zMS5hZGd1YXJkLmNvbQ


## alidns-doh

Alibaba Cloud Public DNS resolver.
Operated by Alibaba Cloud for mainland China, with domestic, Hong Kong and overseas access nodes.
Homepage: https://alidns.com

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAACTIyMy41LjUuNSCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAkyMjMuNS41LjUKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAACTIyMy42LjYuNiCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAkyMjMuNi42LjYKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAADTEyMC41NS4yMDMuNDQgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANMTIwLjU1LjIwMy40NAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAACzQ3LjEwOC4wLjYzIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwCzQ3LjEwOC4wLjYzCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADTM5LjEwMy4yNi4yMDQgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANMzkuMTAzLjI2LjIwNAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAADzEzOS4xMjkuMTM3LjEzNyCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMA8xMzkuMTI5LjEzNy4xMzcKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAADjEyMy4xODQuMTk4LjIyIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwDjEyMy4xODQuMTk4LjIyCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADjExMy4xNDIuODMuMTMyIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwDjExMy4xNDIuODMuMTMyCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADDE4Mi40MC43MC4xMiCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAwxODIuNDAuNzAuMTIKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAADTguMTI5LjE1Mi4yMzAgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANOC4xMjkuMTUyLjIzMAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAACjEuNzEuMjAuMzcgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzAKMS43MS4yMC4zNwovZG5zLXF1ZXJ5


## alidns-doh-ipv6

Alibaba Cloud Public DNS resolver.
IPv6 endpoint. Operated by Alibaba Cloud for mainland China, with domestic, Hong Kong and overseas access nodes.
Homepage: https://alidns.com

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAADlsyNDAwOjMyMDA6OjFdIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwCTIyMy41LjUuNQovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAAE1syNDAwOjMyMDA6YmFiYTo6MV0gmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzAJMjIzLjUuNS41Ci9kbnMtcXVlcnk


## artikel10-doh-ipv4

Artikel10 no-log resolver.
DNSSEC-validating and non-filtering, operated by the Artikel10 association. Homepage: https://artikel10.org

sdns://AgcAAAAAAAAADjIxNy4xOTcuOTEuMTUzIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EWRucy5hcnRpa2VsMTAub3JnCi9kbnMtcXVlcnk


## artikel10-doh-ipv6

Artikel10 no-log resolver.
IPv6 endpoint. DNSSEC-validating and non-filtering, operated by the Artikel10 association. Homepage: https://artikel10.org

sdns://AgcAAAAAAAAAF1syMDAxOjY3YzoxNDAxOjIxMjA6OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EWRucy5hcnRpa2VsMTAub3JnCi9kbnMtcXVlcnk


## blahdns-de-doh

BlahDNS ad-blocking resolver in Germany.
No logging. Blocks ads, trackers and malware. DNSSEC ready, QNAME minimization, no EDNS Client Subnet.
Maintained by BlahDNS. Project page: https://blahdns.com/

sdns://AgMAAAAAAAAADTc4LjQ2LjI0NC4xNDMAEmRvaC1kZS5ibGFoZG5zLmNvbQovZG5zLXF1ZXJ5


## bortzmeyer

Stéphane Bortzmeyer resolver in France.
Non-logging public resolver operated by Stéphane Bortzmeyer. Policy: https://www.bortzmeyer.org/doh-bortzmeyer-fr-policy.html Technical notes: https://www.bortzmeyer.org/doh-mon-resolveur.html

sdns://AgcAAAAAAAAADDE5My43MC44NS4xMSAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLhFkb2guYm9ydHptZXllci5mcgEv


## bortzmeyer-ipv6

Stéphane Bortzmeyer resolver in France.
IPv6 endpoint. Non-logging public resolver operated by Stéphane Bortzmeyer. Policy: https://www.bortzmeyer.org/doh-bortzmeyer-fr-policy.html Technical notes: https://www.bortzmeyer.org/doh-mon-resolveur.html

sdns://AgcAAAAAAAAAGVsyMDAxOjQxZDA6MzAyOjIyMDA6OjE4MF0gMu27Ecwlj74zws0koUknDwvm9Eb1cmSzvRwluYUzJy4RZG9oLmJvcnR6bWV5ZXIuZnIBLw


## cira-family

CIRA Canadian Shield Family resolver.
Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Adds sexual-content blocking to the Protected malware, phishing, botnet and scam protection.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Family' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjMwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLHWZhbWlseS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjMwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLHWZhbWlseS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-family-ipv6

CIRA Canadian Shield Family resolver.
IPv6 endpoint. Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Adds sexual-content blocking to the Protected malware, phishing, botnet and scam protection.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Family' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjozMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsdZmFtaWx5LmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjozMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsdZmFtaWx5LmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ


## cira-private

CIRA Canadian Shield Private resolver.
Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Provides DNS resolution without added threat or family-content filtering.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Private' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjEwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLHnByaXZhdGUuY2FuYWRpYW5zaGllbGQuY2lyYS5jYQovZG5zLXF1ZXJ5
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjEwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLHnByaXZhdGUuY2FuYWRpYW5zaGllbGQuY2lyYS5jYQovZG5zLXF1ZXJ5


## cira-private-ipv6

CIRA Canadian Shield Private resolver.
IPv6 endpoint. Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Provides DNS resolution without added threat or family-content filtering.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Private' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjoxMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsecHJpdmF0ZS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjoxMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsecHJpdmF0ZS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-protected

CIRA Canadian Shield Protected resolver.
Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Blocks malware, phishing, botnet and scam domains.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Protected' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjIwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLIHByb3RlY3RlZC5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjIwIMlfeyD2_NOf06B6LkQlJCO2NP2-NeHgRdlk3upiYRXLIHByb3RlY3RlZC5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-protected-ipv6

CIRA Canadian Shield Protected resolver.
IPv6 endpoint. Operated by the Canadian Internet Registration Authority for Canadian users on Canadian-hosted servers. Blocks malware, phishing, botnet and scam domains.

Operated by the Canadian Internet Registration Authority. Service page: https://www.cira.ca/en/canadian-shield/
Info: Not anonymous, but CIRA says it does not sell user data or use it for advertising. The 'Protected' name is one that CIRA uses for this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjoyMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsgcHJvdGVjdGVkLmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjoyMF0gyV97IPb805_ToHouRCUkI7Y0_b414eBF2WTe6mJhFcsgcHJvdGVjdGVkLmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ


## circl-doh

CIRCL Luxembourg public resolver.
Operated by CIRCL, the Computer Incident Response Center Luxembourg. Hosted in Bettembourg, Luxembourg. https://www.circl.lu/

sdns://AgYAAAAAAAAADTE4NS4xOTQuOTQuNzEADGRucy5jaXJjbC5sdQovZG5zLXF1ZXJ5


## circl-doh-ipv6

CIRCL Luxembourg public resolver.
IPv6 endpoint. Operated by CIRCL, the Computer Incident Response Center Luxembourg. Hosted in Bettembourg, Luxembourg. https://www.circl.lu/

sdns://AgYAAAAAAAAAElsyYTAwOjU5ODA6OTQ6OjcxXQAMZG5zLmNpcmNsLmx1Ci9kbnMtcXVlcnk


## cisco

Cisco OpenDNS public resolver.
Available through servers in multiple locations around the world.
Part of Cisco consumer and Umbrella DNS services.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAADjIwOC42Ny4yMjAuMjIwILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-doh

Cisco OpenDNS public resolver.
Available through servers in multiple locations around the world.
Part of Cisco consumer and Umbrella DNS services.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AgAAAAAAAAAADDE0Ni4xMTIuNDEuMiCYZO337qhZZ1J0sPrfvSaTZamrnrp3PahnSUxalKQ33w9kb2gub3BlbmRucy5jb20KL2Rucy1xdWVyeQ


## cisco-familyshield

Cisco OpenDNS FamilyShield resolver.
Available through servers in multiple locations around the world.
Preconfigured to block adult content.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

Currently incompatible with DNS anonymization.

sdns://AQEAAAAAAAAADjIwOC42Ny4yMjAuMTIzILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-familyshield-ipv6

Cisco OpenDNS FamilyShield resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Preconfigured to block adult content.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAAEVsyNjIwOjExOTozNTo6MzVdILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-ipv6

Cisco OpenDNS public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Part of Cisco consumer and Umbrella DNS services.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAAD1syNjIwOjA6Y2NjOjoyXSC3NRFAIG8iXT4r2CLX_WkeocM8yNZmjQy-BL-rykP7eRsyLmRuc2NyeXB0LWNlcnQub3BlbmRucy5jb20


## cisco-ipv6-doh

Cisco OpenDNS public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Part of Cisco consumer and Umbrella DNS services.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AgAAAAAAAAAAEFsyNjIwOjExOTpmYzo6Ml0gmGTt9-6oWWdSdLD6370mk2Wpq566dz2oZ0lMWpSkN98PZG9oLm9wZW5kbnMuY29tCi9kbnMtcXVlcnk


## cisco-sandbox

Cisco OpenDNS Sandbox.
Available through servers in multiple locations around the world.

Warning: Doesn't work any more in some countries such as France and Portugal.

Operated by Cisco OpenDNS. Service page: https://www.opendns.com/
Warning: This server is incompatible with anonymization.

sdns://AQEAAAAAAAAADDE0Ni4xMTIuNDEuNCC3NRFAIG8iXT4r2CLX_WkeocM8yNZmjQy-BL-rykP7eRsyLmRuc2NyeXB0LWNlcnQub3BlbmRucy5jb20


## cleanbrowsing-adult

CleanBrowsing Adult Filter.
Available through servers in multiple locations around the world.
Blocks adult, pornographic and explicit sites. Allows proxy and VPN domains and mixed-content sites. Google and Bing are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAEzE4NS4yMjguMTY4LjEwOjg0NDMgvKwy-tVDaRcfCDLWB1AnwyCM7vDo6Z-UGNx3YGXUjykRY2xlYW5icm93c2luZy5vcmc


## cleanbrowsing-adult-doh

CleanBrowsing Adult Filter.
Available through servers in multiple locations around the world.
Blocks adult, pornographic and explicit sites. Allows proxy and VPN domains and mixed-content sites. Google and Bing are set to Safe Mode.
Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EWNsZWFuYnJvd3Npbmcub3JnES9kb2gvYWR1bHQtZmlsdGVy
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFjbGVhbmJyb3dzaW5nLm9yZxEvZG9oL2FkdWx0LWZpbHRlcg


## cleanbrowsing-adult-ipv6

CleanBrowsing Adult Filter.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks adult, pornographic and explicit sites. Allows proxy and VPN domains and mixed-content sites. Google and Bing are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6MTo6MV06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw
sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6Mjo6MV06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cleanbrowsing-family

CleanBrowsing Family Filter.
Available through servers in multiple locations around the world.
Blocks adult and explicit sites, proxy and VPN bypass domains, and mixed-content sites. Google, Bing and YouTube are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFDE4NS4yMjguMTY4LjE2ODo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn


## cleanbrowsing-family-doh

CleanBrowsing Family Filter.
Available through servers in multiple locations around the world.
Blocks adult and explicit sites, proxy and VPN bypass domains, and mixed-content sites. Google, Bing and YouTube are set to Safe Mode.
Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EWNsZWFuYnJvd3Npbmcub3JnEi9kb2gvZmFtaWx5LWZpbHRlcg
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFjbGVhbmJyb3dzaW5nLm9yZxIvZG9oL2ZhbWlseS1maWx0ZXI


## cleanbrowsing-family-ipv6

CleanBrowsing Family Filter.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks adult and explicit sites, proxy and VPN bypass domains, and mixed-content sites. Google, Bing and YouTube are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFFsyYTBkOjJhMDA6MTo6XTo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn
sdns://AQMAAAAAAAAAFFsyYTBkOjJhMDA6Mjo6XTo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn


## cleanbrowsing-security

CleanBrowsing Security Filter.
Available through servers in multiple locations around the world.
Blocks phishing, spam, malware and other malicious domains, without adult-content filtering.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAEjE4NS4yMjguMTY4Ljk6ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cleanbrowsing-security-doh

CleanBrowsing Security Filter.
Available through servers in multiple locations around the world.
Blocks phishing, spam, malware and other malicious domains, without adult-content filtering.
Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EWNsZWFuYnJvd3Npbmcub3JnFC9kb2gvc2VjdXJpdHktZmlsdGVy
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFjbGVhbmJyb3dzaW5nLm9yZxQvZG9oL3NlY3VyaXR5LWZpbHRlcg


## cleanbrowsing-security-ipv6

CleanBrowsing Security Filter.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks phishing, spam, malware and other malicious domains, without adult-content filtering.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/
Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6MTo6Ml06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw
sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6Mjo6Ml06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cloudflare

Cloudflare 1.1.1.1 public resolver.
Available through servers in multiple locations around the world.
Non-filtering.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgcAAAAAAAAABzEuMC4wLjEAEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAABzEuMC4wLjEABzEuMC4wLjEKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADDE2Mi4xNTkuMzYuMQAMMTYyLjE1OS4zNi4xCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADDE2Mi4xNTkuNDYuMQAMMTYyLjE1OS40Ni4xCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADjEwNC4xNi4xMzIuMjI5ABJkbnMuY2xvdWRmbGFyZS5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4xMzMuMjI5ABJkbnMuY2xvdWRmbGFyZS5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4yNDkuMjQ5ABJjbG91ZGZsYXJlLWRucy5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4yNDguMjQ5ABJjbG91ZGZsYXJlLWRucy5jb20KL2Rucy1xdWVyeQ


## cloudflare-family

Cloudflare 1.1.1.1 for Families resolver.
Available through servers in multiple locations around the world.
Blocks malware and adult-content domains.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgMAAAAAAAAABzEuMC4wLjMABzEuMC4wLjMKL2Rucy1xdWVyeQ


## cloudflare-family-ipv6

Cloudflare 1.1.1.1 for Families resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks malware and adult-content domains.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExM10AGlsyNjA2OjQ3MDA6NDcwMDo6MTExM106NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwM10AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwM106NDQzCi9kbnMtcXVlcnk


## cloudflare-ipv6

Cloudflare 1.1.1.1 public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Non-filtering.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExMV0AGlsyNjA2OjQ3MDA6NDcwMDo6MTExMV06NDQzCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwMV0AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwMV06NDQzCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ODRlNV0AEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ODVlNV0AEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ZjhmOV0AEmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ZjlmOV0AEmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5


## cloudflare-security

Cloudflare 1.1.1.1 security resolver.
Available through servers in multiple locations around the world.
Blocks malware domains.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgMAAAAAAAAABzEuMC4wLjIABzEuMC4wLjIKL2Rucy1xdWVyeQ


## cloudflare-security-ipv6

Cloudflare 1.1.1.1 security resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Blocks malware domains.
Operated by Cloudflare. Service page: https://developers.cloudflare.com/1.1.1.1/

sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExMl0AGlsyNjA2OjQ3MDA6NDcwMDo6MTExMl06NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwMl0AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwMl06NDQzCi9kbnMtcXVlcnk


## comodo-02

Comodo Dome Shield - https://cdome.comodo.com/shield/
Available through servers in multiple locations around the world.
Operated by Comodo. Service page: https://cdome.comodo.com/shield/

sdns://AQUAAAAAAAAACjguMjAuMjQ3LjIg0sJUqpYcHsoXmZb1X7yAHwg2xyN5q1J-zaiGG-Dgs7AoMi5kbnNjcnlwdC1jZXJ0LnNoaWVsZC0yLmRuc2J5Y29tb2RvLmNvbQ
sdns://AQUAAAAAAAAACzguMjAuMjQ3LjIwINLCVKqWHB7KF5mW9V-8gB8INscjeatSfs2ohhvg4LOwKDIuZG5zY3J5cHQtY2VydC5zaGllbGQtMi5kbnNieWNvbW9kby5jb20
sdns://AQUAAAAAAAAACjguMjYuNTYuMjYg0sJUqpYcHsoXmZb1X7yAHwg2xyN5q1J-zaiGG-Dgs7AoMi5kbnNjcnlwdC1jZXJ0LnNoaWVsZC0yLmRuc2J5Y29tb2RvLmNvbQ


## comss.one

Comss.one ad-blocking resolver.
DNS with ad-blocking and anti-phishing filters, popular among Russian-speaking users.

sdns://AgMAAAAAAAAADjgzLjIyMC4xNjkuMTU1IDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuDWRucy5jb21zcy5vbmUKL2Rucy1xdWVyeQ


## controld-block-malware

Control D Free DNS Malware resolver.
Available through servers in multiple locations around the world.
Blocks known dangerous domains. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMQ


## controld-block-malware-ad

Control D Free DNS Ads & Tracking resolver.
Available through servers in multiple locations around the world.
Blocks malware, ads and trackers. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMg


## controld-block-malware-ad-social

Control D Free DNS Social resolver.
Available through servers in multiple locations around the world.
Blocks malware, ads, trackers and major social-media services. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMw


## controld-family-friendly

Control D Free DNS Family Friendly resolver.
Available through servers in multiple locations around the world.
Blocks malware, ads, trackers, adult content and drug-related domains. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tBy9mYW1pbHk


## controld-uncensored

Control D Free DNS Uncensored resolver.
Available through servers in multiple locations around the world.
Attempts to unblock domains censored in various countries. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tCy91bmNlbnNvcmVk


## controld-unfiltered

Control D Free DNS Unfiltered resolver.
Available through servers in multiple locations around the world.
Does not block or rewrite domains. No query logging. https://controld.com/free-dns
Operated by Control D. Service page: https://controld.com/free-dns

sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMA


## cs-austria

CryptoStorm Vienna, Austria resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTk0LjE5OC40MS4yMzUgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-austria6

CryptoStorm Vienna, Austria resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyOTphMTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-barcelona

CryptoStorm Barcelona, Spain resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4xNDIuMTE1IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-barcelona6

CryptoStorm Barcelona, Spain resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozNToxNzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-belgium

CryptoStorm Brussels, Belgium resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMzYuMTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-belgium6

CryptoStorm Brussels, Belgium resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyMDAxOmFjODoyNzoxMDM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-berlin

CryptoStorm Berlin, Germany resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMTcuNzUgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-berlin6

CryptoStorm Berlin, Germany resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozNjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-ch

CryptoStorm Switzerland resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5MC4yMTEuMjU1LjIyNyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ch6

CryptoStorm Switzerland resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAGVsyYTAyOjI5Yjg6ZGMwMToyMjIwOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-czech

CryptoStorm Prague, Czech Republic resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzIxNy4xMzguMjIwLjI0MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-czech6

CryptoStorm Prague, Czech Republic resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozMzo3Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dc

CryptoStorm Washington, DC resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADDE5OC43LjU4LjIyNyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-dc6

CryptoStorm Washington, DC resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAG1syNjA0OjlhMDA6MjAxMDphMGJiOjY6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-de

CryptoStorm Frankfurt, Germany resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAACzE0Ni43MC44Mi4zIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-de6

CryptoStorm Frankfurt, Germany resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MWQ6OTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dus

CryptoStorm Düsseldorf, Germany resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjg5LjE2My4yMjEuMTgxIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dus6

CryptoStorm Düsseldorf, Germany resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjRiYTA6ZmZlZDo3Njo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-finland

CryptoStorm Finland resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTgzLjE0My4yNDIuNDMgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-finland6

CryptoStorm Finland resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFlsyYTBkOjU2MDA6MTQyOjExOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-fl

CryptoStorm Miami, FL resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjE0Ni43MC4yNDAuMjAzIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-fl6

CryptoStorm Miami, FL resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6NjoxMjM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-fr

CryptoStorm France resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE2My4xNzIuMzQuNTYgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-fr6

CryptoStorm France resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAGFsyMDAxOmJjODozMmQ3OjIwMGM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ga

CryptoStorm Atlanta, GA resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzEzMC4xOTUuMjEyLjIxMSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ga6

CryptoStorm Atlanta, GA resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTQ1OjU6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-hungary

CryptoStorm Budapest, Hungary resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTg2LjEwNi43NC4yMTkgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-hungary6

CryptoStorm Budapest, Hungary resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyNjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-il

CryptoStorm Chicago, IL resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5NS4yNDIuMjEyLjEzMSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-il6

CryptoStorm Chicago, IL resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTQ0OjE6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-la

CryptoStorm Los Angeles, CA resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5NS4yMDYuMTA0LjIwMyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-la6

CryptoStorm Los Angeles, CA resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6NGY6NTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-london

CryptoStorm London, England resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTc4LjEyOS4yNDguNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-london6

CryptoStorm London, England resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjFiNDA6NTAwMDphMjo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-manchester

CryptoStorm Manchester, England resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE5NS4xMi40OC4xNzEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-manchester6

CryptoStorm Manchester, England resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo4Yjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-md

CryptoStorm Moldova resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3Ni4xMjMuNC4yMzEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-md6

CryptoStorm Moldova resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjY3ODo2ZDQ6NTAyMzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-milan

CryptoStorm Milan, Italy resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzIxNy4xMzguMjE5LjIxOSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-milan6

CryptoStorm Milan, Italy resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyNDphMTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-montreal

CryptoStorm Montreal, Canada resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3Ni4xMTMuNzQuMTkgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-montreal6

CryptoStorm Montreal, Canada resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MTk6NTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nl

CryptoStorm Netherlands resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE4NS4xMDcuODAuODQgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-nl6

CryptoStorm Netherlands resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFlsyYTAwOjE3Njg6NjAwMTo4Ojo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-norway

CryptoStorm Oslo, Norway resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjkxLjIxOS4yMTUuMjI3IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-norway6

CryptoStorm Oslo, Norway resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozODo5NDo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nv

CryptoStorm Las Vegas, NV resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADDc5LjExMC41My41MSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-nv6

CryptoStorm Las Vegas, NV resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MzoxOTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nyc

CryptoStorm New York City, NY resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE0Ni43MC4xNTQuNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-nyc6

CryptoStorm New York City, NY resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MjQ6NTQ6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ore

CryptoStorm Oregon resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3OS42MS4yMjMuNDcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-ore6

CryptoStorm Oregon resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syNjA1OjZjODA6NTpkOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-poland

CryptoStorm Warsaw, Poland resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMTEuOTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-poland6

CryptoStorm Warsaw, Poland resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTM6NzE6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-pt

CryptoStorm Portugal resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjkxLjIwNS4yMzAuMjI0IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-pt6

CryptoStorm Portugal resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syYTA2OjMwNDA6OmVjNDo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-ro

CryptoStorm Romania resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE0Ni43MC42Ni4yMjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-sea

CryptoStorm Seattle, WA resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADDY0LjEyMC41LjI1MSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-sea6

CryptoStorm Seattle, WA resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAGFsyNjA3OmY1YjI6MTphMDBiOmI6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-serbia

CryptoStorm Belgrade, Serbia resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4xOTMuMjE5IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-serbia6

CryptoStorm Belgrade, Serbia resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo3ZDo0Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-singapore

CryptoStorm Singapore resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4xNTEuMTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-singapore6

CryptoStorm Singapore resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MWY6Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-swe

CryptoStorm Sweden resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADzEyOC4xMjcuMTA0LjEwOCAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-swe6

CryptoStorm Sweden resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syYTAwOjcxNDI6MToxOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-sydney

CryptoStorm Sydney, Australia resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4yMzQuMjUxIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-sydney6

CryptoStorm Sydney, Australia resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo4NDo0ZDo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-tokyo

CryptoStorm Tokyo, Japan resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADDE0Ni43MC4zMS40MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-tokyo6

CryptoStorm Tokyo, Japan resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo0MDpkZjo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-tx

CryptoStorm Dallas, TX resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADTIwOS41OC4xNDcuMzYgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-tx6

CryptoStorm Dallas, TX resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAG1syNjA2Ojk4ODA6MjEwMDphMDA2OjM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-vancouver

CryptoStorm Vancouver, Canada resolver.
Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAADjE5Ni4yNDAuNzkuMTYzIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-vancouver6

CryptoStorm Vancouver, Canada resolver.
IPv6 endpoint. Operated by CryptoStorm. https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTAyOjU3NDA6MjQ6NDU6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## dct-de

DCT Berlin resolver.
IPv4-only. Non-logging, non-filtering, DNSSEC-validating. Berlin, Germany.

sdns://AQcAAAAAAAAADzE5NC4xNjQuMTk0LjIxNiACT6z2dYj94msaKqctjIpBaeDHG2JVOfPTqDH_0KzZkBYyLmRuc2NyeXB0LWNlcnQuZGN0LWRl


## dct-de2

DCT Karlsruhe resolver.
IPv4-only. Non-logging, non-filtering, DNSSEC-validating. Karlsruhe, Germany.

sdns://AQcAAAAAAAAAETgyLjE2NS42MS41Mjo1MzUzIK8y9dKpNBKXneNlbwmpHZZBUvqfBXnojiW6Gdtp8p7PFzIuZG5zY3J5cHQtY2VydC5kY3QtZGUy


## dct-fr

DCT Paris resolver.
IPv4-only. Non-logging, non-filtering, DNSSEC-validating. Paris, France.

sdns://AQcAAAAAAAAADTQ1LjE0Ny45OC4yMjMgxrLxuUBUIK0uhJptc75BSbkhou5kHDMi2p4AHf0zHgMWMi5kbnNjcnlwdC1jZXJ0LmRjdC1mcg


## deffer-dns.au

deffer-dns.au Sydney resolver.
Hosted on AWS in Sydney. DNSSEC, non-logged, uncensored.

sdns://AQcAAAAAAAAADTUyLjY1LjIzNS4xMjkg5Q00RDDBkwx3fUaa0_etjz4iH3lLBOqsg95bYDmV07MdMi5kbnNjcnlwdC1jZXJ0LmRlZmZlci1kbnMuYXU


## dns.digitale-gesellschaft.ch

Digital Society Switzerland public resolver.
Operated by Digitale Gesellschaft. Homepage: https://www.digitale-gesellschaft.ch

sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDKgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQgMu27Ecwlj74zws0koUknDwvm9Eb1cmSzvRwluYUzJy4cZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDOgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQgMu27Ecwlj74zws0koUknDwvm9Eb1cmSzvRwluYUzJy4cZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5


## dns.digitale-gesellschaft.ch-ipv6

Digital Society Switzerland public resolver.
IPv6 endpoint. Operated by Digitale Gesellschaft. Homepage: https://www.digitale-gesellschaft.ch

sdns://AgcAAAAAAAAAD1syYTA1OmZjODQ6OjQyXaCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdCAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLhxkbnMuZGlnaXRhbGUtZ2VzZWxsc2NoYWZ0LmNoCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAD1syYTA1OmZjODQ6OjQzXaCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdCAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLhxkbnMuZGlnaXRhbGUtZ2VzZWxsc2NoYWZ0LmNoCi9kbnMtcXVlcnk


## dns.digitalsize.net

DigitalSize non-tracking resolver.
Non-filtering, DNSSEC enabled, QNAME minimization and no EDNS Client Subnet. https://dns.digitalsize.net
Hosted in Germany.

sdns://AgcAAAAAAAAADjk0LjEzMC4xMzUuMjAzIDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuE2Rucy5kaWdpdGFsc2l6ZS5uZXQKL2Rucy1xdWVyeQ


## dns.digitalsize.net-ipv6

DigitalSize non-tracking resolver.
IPv6 endpoint. Non-filtering, DNSSEC enabled, QNAME minimization and no EDNS Client Subnet. https://dns.digitalsize.net
Hosted in Germany.

sdns://AgcAAAAAAAAAGVsyYTAxOjRmODoxM2I6MzQwNzo6ZmFjZV0gMu27Ecwlj74zws0koUknDwvm9Eb1cmSzvRwluYUzJy4TZG5zLmRpZ2l0YWxzaXplLm5ldAovZG5zLXF1ZXJ5


## dns.sb

DNS.SB public resolver.
Available through servers in multiple locations around the world.
Operated by xTom. No logs, no filtering, supports DNSSEC. Homepage: https://dns.sb

sdns://AgcAAAAAAAAADzE4NS4yMjIuMjIyLjIyMiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA8xODUuMjIyLjIyMi4yMjIKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAACzQ1LjExLjQ1LjExIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50CzQ1LjExLjQ1LjExCi9kbnMtcXVlcnk


## dns4all-ipv4

DNS4All public resolver by SIDN Labs.
No logs, DNSSEC validation. Filters domains sanctioned by the EU. Homepage: https://dns4all.eu

sdns://AgMAAAAAAAAACTE5NC4wLjUuMwAOZG9oLmRuczRhbGwuZXUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAACjE5NC4wLjUuNjQAEGRvaDY0LmRuczRhbGwuZXUKL2Rucy1xdWVyeQ


## dns4all-ipv6

DNS4All public resolver by SIDN Labs.
IPv6 endpoint. No logs, DNSSEC validation. Filters domains sanctioned by the EU. Homepage: https://dns4all.eu

sdns://AgMAAAAAAAAAD1syMDAxOjY3ODo4OjozXQAOZG9oLmRuczRhbGwuZXUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAEFsyMDAxOjY3ODo4Ojo2NF0AEGRvaDY0LmRuczRhbGwuZXUKL2Rucy1xdWVyeQ


## dns4eu

DNS4EU Public Service resolver.
Free EU-focused resolver for individual citizens, operated by a consortium led by Whalebone. This was previously advertised as the unfiltered option, but an April 17, 2026 Paris court order requires DNS4EU to block access to specific sports-piracy domains from French territory.

Operated by the DNS4EU consortium led by Whalebone. Service page: https://www.joindns4.eu/for-public
Note: the service uses name servers from CloudNS, a European company, but appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAADDg2LjU0LjExLjEwMCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBZ1bmZpbHRlcmVkLmpvaW5kbnM0LmV1Ci9kbnMtcXVlcnk


## dns4eu-ipv6

DNS4EU Public Service resolver.
IPv6 endpoint. Free EU-focused resolver for individual citizens, operated by a consortium led by Whalebone. This was previously advertised as the unfiltered option, but an April 17, 2026 Paris court order requires DNS4EU to block access to specific sports-piracy domains from French territory.

Operated by the DNS4EU consortium led by Whalebone. Service page: https://www.joindns4.eu/for-public
Note: the service uses name servers from CloudNS, a European company, but appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAAGVsyYTEzOjEwMDE6Ojg2OjU0OjExOjEwMF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQWdW5maWx0ZXJlZC5qb2luZG5zNC5ldQovZG5zLXF1ZXJ5


## dns4eu-protective

DNS4EU Protective resolver.
Free EU-focused resolver for individual citizens, operated by a consortium led by Whalebone. Filters fraudulent and malicious domains.

Operated by the DNS4EU consortium led by Whalebone. Service page: https://www.joindns4.eu/for-public
Note: the service uses name servers from CloudNS, a European company, but appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAACjg2LjU0LjExLjEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQWcHJvdGVjdGl2ZS5qb2luZG5zNC5ldQovZG5zLXF1ZXJ5


## dns4eu-protective-ipv6

DNS4EU Protective resolver.
IPv6 endpoint. Free EU-focused resolver for individual citizens, operated by a consortium led by Whalebone. Filters fraudulent and malicious domains.

Operated by the DNS4EU consortium led by Whalebone. Service page: https://www.joindns4.eu/for-public
Note: the service uses name servers from CloudNS, a European company, but appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAAF1syYTEzOjEwMDE6Ojg2OjU0OjExOjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50FnByb3RlY3RpdmUuam9pbmRuczQuZXUKL2Rucy1xdWVyeQ


## dnsbunker

A DNS resolver located in Germany.

Designed to block ads, malware, and surveillance. No logs.
Operated by DNSBunker.

https://dnsbunker.org

sdns://AgMAAAAAAAAADjE4NS4yNTAuMjUwLjYxILTgqMmLCq5DtzgwN6zNEaHJZJcfa3T8vDcM0DD7Mo3dDWRuc2J1bmtlci5vcmcKL2Rucy1xdWVyeQ


## dnsbunker-ipv6

A DNS resolver located in Germany.

Designed to block ads, malware, and surveillance. No logs.
Operated by DNSBunker.

https://dnsbunker.org

sdns://AgMAAAAAAAAAElsyYTBhOjUxYzE6YTplYTo6XSC04KjJiwquQ7c4MDeszRGhyWSXH2t0_Lw3DNAw-zKN3Q1kbnNidW5rZXIub3JnCi9kbnMtcXVlcnk


## dnscry.pt-adelaide-ipv4

dnscry.pt Adelaide resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE3NS40NS4xODIuMTc5INrqhBrttZo1M0gvzeimP08i_dgL6qmBxe5EeP8lJ-1yGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-adelaide-ipv6

dnscry.pt Adelaide resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNDA0Ojk0MDA6NjhmMToxMDA6OjUzXSDa6oQa7bWaNTNIL83opj9PIv3YC-qpgcXuRHj_JSftchkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-allendale-ipv4

dnscry.pt Allendale resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIzLjEyOS4xODAuMTk1IKm-U_x4R3Sq3vo6kns77CwIZAOFd7Jj36snssV3txj4GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-allendale-ipv6

dnscry.pt Allendale resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmY3YTM6MDo1MjAwOjphXSCpvlP8eEd0qt76OpJ7O-wsCGQDhXeyY9-rJ7LFd7cY-BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-allentown-ipv4

dnscry.pt Allentown resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjEzNy4yNTMuMjQg3Z0YI7udXIjKWcPC5GdTm4Uk6D1x2DuyYuj2OZz2cKQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-allentown-ipv6

dnscry.pt Allentown resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHFsyNjAyOmZjMjQ6MTk6NzRiMDo1Mjg1OjoxMl0g3Z0YI7udXIjKWcPC5GdTm4Uk6D1x2DuyYuj2OZz2cKQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam-ipv4

dnscry.pt Amsterdam resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5OC4xNDAuMTQxLjQ2IFqbafOxgXuKwOgYxQ6XUqHWkMUt_5LI2nDkdVFU5hm7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-amsterdam-ipv6

dnscry.pt Amsterdam resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTAzOjk0ZTM6MjIyYjo6MTAzMl0gWptp87GBe4rA6BjFDpdSodaQxS3_ksjacOR1UVTmGbsZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam02-ipv4

dnscry.pt Amsterdam 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1Ljg2LjE2Mi4xMTAgblxXPJozaH3d0T9h_69Op1nnYQYbW4yIWd8ypOORnK8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam02-ipv6

dnscry.pt Amsterdam 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syYTA3OmVmYzA6MTAwMTphNWNlOjpiNGI0XSBuXFc8mjNofd3RP2H_r06nWedhBhtbjIhZ3zKk45GcrxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-amsterdam03-ipv4

dnscry.pt Amsterdam 03 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjEzNy4yNDkuMjYgCA4-g3tus39pqm78_CoOc8byRBbLfuc5ceEiFNFWnN4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam03-ipv6

dnscry.pt Amsterdam 03 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjAyOmZjMjQ6MTI6OTg3Mzo6YWIxXSAIDj6De26zf2mqbvz8Kg5zxvJEFst-5zlx4SIU0Vac3hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ashburn-ipv4

dnscry.pt Ashburn resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjc3LjI0Ny4xMjcuMTA3IJOWzrgz5XhvHJtWLbFAFhcg9_e11cQSpjMcGFMUsHxJGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ashburn-ipv6

dnscry.pt Ashburn resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBhOjhkYzA6YTA2Nzo6YV0gk5bOuDPleG8cm1YtsUAWFyD397XVxBKmMxwYUxSwfEkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-atlanta-ipv4

dnscry.pt Atlanta resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3MC4yNDkuMjM3LjE1NCDi7_UCIU8-uBI-dM7qpE0Y0Qo8GpJTDcSX578fvK7jOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-atlanta-ipv6

dnscry.pt Atlanta resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAwOjRjMDA6ODA6ODo6YV0g4u_1AiFPPrgSPnTO6qRNGNEKPBqSUw3El-e_H7yu4zoZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-auckland-ipv4

dnscry.pt Auckland resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS45OS4xMzMuMTEyIBWQZQSuMzmL_YANsdr26wFOHmJCYEtA2P2JI6w1-0ezGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-auckland-ipv6

dnscry.pt Auckland resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHFsyYTA2OjEyODA6YmVlMToyOjplZTEyOjIwOF0gFZBlBK4zOYv9gA2x2vbrAU4eYkJgS0DY_YkjrDX7R7MZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bangkok-ipv4

dnscry.pt Bangkok resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4zOC4yNTAuNTUgEjXzbTecQJr5ruYRxd59ymIETJxVoNbSFO_b4Inq2rEZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bengaluru-ipv4

dnscry.pt Bengaluru resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xOTEuMTgyLjIxNiDM3lhIXzCtFbHampFM4K_NDUnKalgxd72L-5ye1X4qExkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bengaluru-ipv6

dnscry.pt Bengaluru resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyNDAxOmQ0ZTA6MTpmN2ZkOjo1M10gzN5YSF8wrRWx2pqRTOCvzQ1JympYMXe9i_ucntV-KhMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-berkeleysprings-ipv4

dnscry.pt Berkeley Springs resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5My40Mi4yNDYuMTA4IG5N2yfzGMQ1q8RRYo9wan2kMr83Ce2OkCMpO8LYUi2kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-berkeleysprings-ipv6

dnscry.pt Berkeley Springs resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6Mzc6MTo6Yzk4NDo0YmEzXSBuTdsn8xjENavEUWKPcGp9pDK_NwntjpAjKTvC2FItpBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bratislava-ipv4

dnscry.pt Bratislava resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjk1LjEzMS4yMDIuMTA1ICNqYnU4LMuHNFVgCP5Zn1414WbRxXWqmbQoFp-KjKepGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bratislava-ipv6

dnscry.pt Bratislava resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTA1OjU1MDI6OjU5MDY6OTdmODoyZDBlOjFdICNqYnU4LMuHNFVgCP5Zn1414WbRxXWqmbQoFp-KjKepGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bremen-ipv4

dnscry.pt Bremen resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTg5LjEwNi43OC4xMDYg5rO6aG7DsML6-9pTiRkTTzCr8CZBVmBkFs2IYK2YdtwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bremen-ipv6

dnscry.pt Bremen resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OmRlMDQ6MTA6MTIxMjo6XSDms7pobsOwwvr72lOJGRNPMKvwJkFWYGQWzYhgrZh23BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-brisbane-ipv4

dnscry.pt Brisbane resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQzLjIyNC4xODAuMTM3IB3DhQdApTRyuMIvRSQEdBBZ3zMUZPTPK9hsuS3Nq7c5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-brisbane-ipv6

dnscry.pt Brisbane resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAIlsyNDA0Ojk0MDA6MTowOjIxNjozZWZmOmZlZjY6NzE5NF0gHcOFB0ClNHK4wi9FJAR0EFnfMxRk9M8r2Gy5Lc2rtzkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bucharest-ipv4

dnscry.pt Bucharest resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS45My4yMjEuMTY3IM1gfKbFYfG7eLZj6F7rEF7PGZC7Tl2D_LD9v8cmoW1kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bucharest-ipv6

dnscry.pt Bucharest resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTBkOjllYzI6MDpmMDNkOjpjNDllXSDNYHymxWHxu3i2Y-he6xBezxmQu05dg_yw_b_HJqFtZBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-calgary-ipv4

dnscry.pt Calgary resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjEzMy42NC4xMjEgbJWMdhm3m3L0MIztiezBT4P4H5YobsrhNoVKl3JcBa0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-calgary-ipv6

dnscry.pt Calgary resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyNjAyOmZlZDI6ZmUwOjI4Mzo6MV0gbJWMdhm3m3L0MIztiezBT4P4H5YobsrhNoVKl3JcBa0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-capetown-ipv4

dnscry.pt Cape Town resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMi4yMTYuNzkuMjM3IJeYEgmw0_mHXWlOVJhedHpxLeu21h-A31qF-WEQd1UpGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-capetown-ipv6

dnscry.pt Cape Town resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYzBmOmVmMTg6OWZmZjoxOmJmZjo6YV0gl5gSCbDT-YddaU5UmF50enEt67bWH4DfWoX5YRB3VSkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-capetown02-ipv4

dnscry.pt Cape Town 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xMTkuMjMzLjI0NSCTQusYfmQsz9gFttgE8_3ul6EewFvX-ADgVYrMeEa_oxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-capetown02-ipv6

dnscry.pt Cape Town 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYzBmOmYwMzA6MTAwMDoyMzM6OjI0NV0gk0LrGH5kLM_YBbbYBPP97pehHsBb1_gA4FWKzHhGv6MZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chicago-ipv4

dnscry.pt Chicago resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjQxLjIwNC4yMDQgbQ_3dUnLx_3R3UeHibflzQIDKCqMGcViiAPftt2eDbIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chicago-ipv6

dnscry.pt Chicago resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAH1syNjAyOmZlYTc6ZTBjOmU6YmZmOjY6NzA6MTk0Y10gbQ_3dUnLx_3R3UeHibflzQIDKCqMGcViiAPftt2eDbIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chisinau-ipv4

dnscry.pt Chișinău resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE3Ni4xMjMuMTAuMTA1IEJtkG567ZvN_tTXhVcSyywcrDRhziwxmbnyohp5u8gPGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-chisinau-ipv6

dnscry.pt Chișinău resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyMDAxOjY3ODo2ZDQ6NTA4MDo6M2RlYToxMDldIEJtkG567ZvN_tTXhVcSyywcrDRhziwxmbnyohp5u8gPGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-copenhagen-ipv4

dnscry.pt Copenhagen resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5Mi4xMjEuMTE5LjE5IPMMGZXMQPoEo3KJ0yo8OVLp0jhi3Betxpxazt5hwpuKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-copenhagen-ipv6

dnscry.pt Copenhagen resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAI1syMDAxOjY3YzpiZWM6Yjo0M2E6MWFmZjpmZWIxOmViNWRdIPMMGZXMQPoEo3KJ0yo8OVLp0jhi3Betxpxazt5hwpuKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-coventry-ipv4

dnscry.pt Coventry resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjE1NS4zNy4xNjUgYEA416mXWNYoWStCKdnM315FgosLrba3F2QBhYR_SZAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-coventry-ipv6

dnscry.pt Coventry resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTBkOmQ4YzA6MDpmMDQzOjo2OTI3XSBgQDjXqZdY1ihZK0Ip2czfXkWCiwuttrcXZAGFhH9JkBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-dallas-ipv4

dnscry.pt Dallas resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjIzMC4yNTMuOTgg1OKRDMWAtnBoieTPNbjK-OrVjcuML2vQMc6gh-ZmYpAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dallas-ipv6

dnscry.pt Dallas resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmZiOTQ6MTozOTo6YV0g1OKRDMWAtnBoieTPNbjK-OrVjcuML2vQMc6gh-ZmYpAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-denver-ipv4

dnscry.pt Denver resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzIxNi4xMjAuMjAxLjEwNSD_srgVun60gzUrte8QS0YJAqSBHZ_X6PpY_bOU1eMegxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-denver-ipv6

dnscry.pt Denver resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6NjpmMDE2OjozYTI1XSD_srgVun60gzUrte8QS0YJAqSBHZ_X6PpY_bOU1eMegxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-detroit-ipv4

dnscry.pt Detroit resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDY2LjE4Ny43LjE0MCBpn2OKcwbE01MLSkSXcaPKLf8IOmKbuE9GGZvAOBwaNRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-detroit-ipv6

dnscry.pt Detroit resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAI1syNjA2OjY1YzA6NDA6NDo1ZjM6NTRjNDo4ZDEwOjliOThdIGmfY4pzBsTTUwtKRJdxo8ot_wg6Ypu4T0YZm8A4HBo1GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-dhaka-ipv4

dnscry.pt Dhaka resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xNzQuNTEuNzEgJb3-qelH318uGaZ6Kh3u586eQ6d1Szyyr8fo_lm78kAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dhaka-ipv6

dnscry.pt Dhaka resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyMDAxOmRmMTo4ZjQwOjUxOjphXSAlvf6p6UffXy4ZpnoqHe7nzp5Dp3VLPLKvx-j-WbvyQBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-doh-adelaide-ipv4

dnscry.pt Adelaide DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE3NS40NS4xODIuMTc5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2FkbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-adelaide-ipv6

dnscry.pt Adelaide DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNDA0Ojk0MDA6NjhmMToxMDA6OjUzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9hZGwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-allendale-ipv4

dnscry.pt Allendale DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjIzLjEyOS4xODAuMTk1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2FxeDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-allendale-ipv6

dnscry.pt Allendale DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjAyOmY3YTM6MDo1MjAwOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9hcXgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-allentown-ipv4

dnscry.pt Allentown DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIzLjEzNy4yNTMuMjQgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYWJlMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-allentown-ipv6

dnscry.pt Allentown DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHFsyNjAyOmZjMjQ6MTk6NzRiMDo1Mjg1OjoxMl0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYWJlMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-amsterdam-ipv4

dnscry.pt Amsterdam DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5OC4xNDAuMTQxLjQ2IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2FtczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-amsterdam-ipv6

dnscry.pt Amsterdam DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFlsyYTAzOjk0ZTM6MjIyYjo6MTAzMl0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYW1zMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-amsterdam02-ipv4

dnscry.pt Amsterdam 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTQ1Ljg2LjE2Mi4xMTAgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYW1zMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-amsterdam02-ipv6

dnscry.pt Amsterdam 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syYTA3OmVmYzA6MTAwMTphNWNlOjpiNGI0XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9hbXMwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-amsterdam03-ipv4

dnscry.pt Amsterdam 03 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIzLjEzNy4yNDkuMjYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYW1zMDMuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-amsterdam03-ipv6

dnscry.pt Amsterdam 03 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjAyOmZjMjQ6MTI6OTg3Mzo6YWIxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9hbXMwMy5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-ashburn-ipv4

dnscry.pt Ashburn DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjc3LjI0Ny4xMjcuMTA3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2FibjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-ashburn-ipv6

dnscry.pt Ashburn DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syYTBhOjhkYzA6YTA2Nzo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYWJuMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-atlanta-ipv4

dnscry.pt Atlanta DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE3MC4yNDkuMjM3LjE1NCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9hdGwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-atlanta-ipv6

dnscry.pt Atlanta DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNjAwOjRjMDA6ODA6ODo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYXRsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-auckland-ipv4

dnscry.pt Auckland DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE4NS45OS4xMzMuMTEyIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2FrbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-auckland-ipv6

dnscry.pt Auckland DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHFsyYTA2OjEyODA6YmVlMToyOjplZTEyOjIwOF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYWtsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-bangkok-ipv4

dnscry.pt Bangkok DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTEwMy4zOC4yNTAuNTWg30aaPpn6wYjqSAcYK4n7YhtDsxXWOysRWeCTKYibCbugNp0c-FjjCcAqooJMN2PhLAWXXgMpG_8rtGJWe8vpPyEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYmtrMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-bengaluru-ipv4

dnscry.pt Bengaluru DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE2MC4xOTEuMTgyLjIxNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9ibHIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-bengaluru-ipv6

dnscry.pt Bengaluru DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFlsyNDAxOmQ0ZTA6MTpmN2ZkOjo1M10gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYmxyMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-berkeleysprings-ipv4

dnscry.pt Berkeley Springs DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5My40Mi4yNDYuMTA4IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2JlaTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-berkeleysprings-ipv6

dnscry.pt Berkeley Springs DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syNjA2OjY2ODA6Mzc6MTo6Yzk4NDo0YmEzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9iZWkwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-bratislava-ipv4

dnscry.pt Bratislava DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjk1LjEzMS4yMDIuMTA1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2J0czAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-bratislava-ipv6

dnscry.pt Bratislava DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHVsyYTA1OjU1MDI6OjU5MDY6OTdmODoyZDBlOjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2J0czAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-bremen-ipv4

dnscry.pt Bremen DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTg5LjEwNi43OC4xMDYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYnJlMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-bremen-ipv6

dnscry.pt Bremen DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTA2OmRlMDQ6MTA6MTIxMjo6XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9icmUwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-brisbane-ipv4

dnscry.pt Brisbane DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjQzLjIyNC4xODAuMTM3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2JuZTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-brisbane-ipv6

dnscry.pt Brisbane DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAIlsyNDA0Ojk0MDA6MTowOjIxNjozZWZmOmZlZjY6NzE5NF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPYm5lMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-bucharest-ipv4

dnscry.pt Bucharest DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE4NS45My4yMjEuMTY3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2J1aDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-bucharest-ipv6

dnscry.pt Bucharest DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyYTBkOjllYzI6MDpmMDNkOjpjNDllXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9idWgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-calgary-ipv4

DNSCry.pt Calgary - DoH, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIzLjEzMy42NC4xMjEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPeXljMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-calgary-ipv6

DNSCry.pt Calgary - DoH, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AgcAAAAAAAAAFlsyNjAyOmZlZDI6ZmUwOjI4Mzo6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPeXljMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-capetown-ipv4

dnscry.pt Cape Town DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwMi4yMTYuNzkuMjM3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2NwdDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-capetown-ipv6

dnscry.pt Cape Town DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGVsyYzBmOmVmMTg6OWZmZjoxOmJmZjo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPY3B0MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-capetown02-ipv4

dnscry.pt Cape Town 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE2MC4xMTkuMjMzLjI0NSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9jcHQwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-capetown02-ipv6

dnscry.pt Cape Town 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGVsyYzBmOmYwMzA6MTAwMDoyMzM6OjI0NV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPY3B0MDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-chicago-ipv4

dnscry.pt Chicago DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTQ1LjQxLjIwNC4yMDQgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPb3JkMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-chicago-ipv6

dnscry.pt Chicago DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAH1syNjAyOmZlYTc6ZTBjOmU6YmZmOjY6NzA6MTk0Y10gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPb3JkMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-chisinau-ipv4

dnscry.pt Chișinău DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE3Ni4xMjMuMTAuMTA1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2tpdjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-chisinau-ipv6

dnscry.pt Chișinău DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHVsyMDAxOjY3ODo2ZDQ6NTA4MDo6M2RlYToxMDldIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2tpdjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-copenhagen-ipv4

dnscry.pt Copenhagen DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5Mi4xMjEuMTE5LjE5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2NwaDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-copenhagen-ipv6

dnscry.pt Copenhagen DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAI1syMDAxOjY3YzpiZWM6Yjo0M2E6MWFmZjpmZWIxOmViNWRdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2NwaDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-coventry-ipv4

dnscry.pt Coventry DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTQ1LjE1NS4zNy4xNjUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPY3Z0MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-coventry-ipv6

dnscry.pt Coventry DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyYTBkOmQ4YzA6MDpmMDQzOjo2OTI3XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9jdnQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-dallas-ipv4

dnscry.pt Dallas DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIzLjIzMC4yNTMuOTggjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZGZ3MDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dallas-ipv6

dnscry.pt Dallas DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNjAyOmZiOTQ6MTozOTo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZGZ3MDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-denver-ipv4

dnscry.pt Denver DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzIxNi4xMjAuMjAxLjEwNSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9kZW4wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-denver-ipv6

dnscry.pt Denver DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjA3OmE2ODA6NjpmMDE2OjozYTI1XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9kZW4wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-detroit-ipv4

dnscry.pt Detroit DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDY2LjE4Ny43LjE0MCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9kdHcwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-detroit-ipv6

dnscry.pt Detroit DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAI1syNjA2OjY1YzA6NDA6NDo1ZjM6NTRjNDo4ZDEwOjliOThdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2R0dzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-dhaka-ipv4

dnscry.pt Dhaka DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTEwMy4xNzQuNTEuNzEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZGFjMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dhaka-ipv6

dnscry.pt Dhaka DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyMDAxOmRmMTo4ZjQwOjUxOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9kYWMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-dublin-ipv4

dnscry.pt Dublin DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5NC4yNi4yMTMuMTUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZHViMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dublin-ipv6

dnscry.pt Dublin DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTA5OmNkNDY6Zjo0MjllOjo1XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9kdWIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-dusseldorf-ipv4

dnscry.pt Düsseldorf DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTUuMTc1LjE4MC4xNzEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZHVzMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dusseldorf-ipv6

dnscry.pt Düsseldorf DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyYTBmOjYyODQ6NDMwMDoxMDE6OjEyYTVdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2R1czAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-dusseldorf02-ipv4

dnscry.pt Düsseldorf 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTM3LjExNC41OC4xMTUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZHVzMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dusseldorf02-ipv6

dnscry.pt Düsseldorf 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFlsyYTA2OmRlMDA6NDAxOjIyNzo6Ml0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZHVzMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dusseldorf03-ipv4

dnscry.pt Düsseldorf 03 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTExOC45MS4xODQuODkgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZHVzMDMuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-dusseldorf03-ipv6

dnscry.pt Düsseldorf 03 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEVsyYTBkOmQ5MDA6MTEwOjpdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2R1czAzLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-ebenecity02-ipv4

dnscry.pt Ebène City 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDE5Ni40Ni41MC45MyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9tcnUwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-ebenecity02-ipv6

dnscry.pt Ebène City 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyMDAxOjQ3MDoxZjIzOjEzOTo6YjpiXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9tcnUwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-eygelshoven-ipv4

dnscry.pt Eygelshoven DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDkzLjk1LjExNS4yMSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9leWcwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-eygelshoven-ipv6

dnscry.pt Eygelshoven DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADlsyYTEwOmNhODA6OmFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2V5ZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-flint-ipv4

dnscry.pt Flint DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE0Ny4xODkuMTQwLjEzNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9mbnQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-flint-ipv6

dnscry.pt Flint DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syNjA2OjY2ODA6Mjk6MTo6NTg1OTphMzdiXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9mbnQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-frankfurt-ipv4

dnscry.pt Frankfurt DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjgyLjEyMC42MSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9mcmEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-frankfurt-ipv6

dnscry.pt Frankfurt DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syYTBlOjZhODA6Mzo2Njk6Ol0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZnJhMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-frankfurt02-ipv4

dnscry.pt Frankfurt 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTQ1LjE0Ny41MS4xMjMgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZnJhMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-frankfurt02-ipv6

dnscry.pt Frankfurt 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyYTA3OmQ4ODQ6MTAwOjozNDRdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2ZyYTAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-fremont02-ipv4

dnscry.pt Fremont 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDE2Ny44OC40OC4xOCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9mZXQwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-fremont02-ipv6

dnscry.pt Fremont 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjAyOmZlZDI6NzE5ODo3YWYxOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9mZXQwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-gdansk-ipv4

dnscry.pt Gdańsk DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTgyLjExOC4yMS4xODkgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZ2RuMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-gdansk-ipv6

dnscry.pt Gdańsk DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEFsyYTA1Ojk0MDQ6Ojg5OV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZ2RuMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-geneva-ipv4

dnscry.pt Geneva DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjkwLjU5LjE5MyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9ndmEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-geneva-ipv6

dnscry.pt Geneva DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEFsyYTA1Ojk0MDY6OmFlMV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZ3ZhMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-grandrapids-ipv4

dnscry.pt Grand Rapids DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE4NS4xNjUuNDQuMTY0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2dycjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-grandrapids-ipv6

dnscry.pt Grand Rapids DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNjAyOmY5NjQ6MToyNDo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZ3JyMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-hafnarfjordur-ipv4

dnscry.pt Hafnarfjordur DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5Mi43MS4yMTguMTIxIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hhZjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hafnarfjordur-ipv6

dnscry.pt Hafnarfjordur DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFlsyYTAzOmY4MDozNTQ6MzZhMTo6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaGFmMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-halifax-ipv4

dnscry.pt Halifax DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDIzLjE5MS44MC40MyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95aHowMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-halifax-ipv6

dnscry.pt Halifax DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjAyOmZjMWM6ZmEwOjI5OjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95aHowMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-hanoi-ipv4

dnscry.pt Hanoi DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTEwMy4xOTkuMTYuOTMgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaGFuMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-hanoi-ipv6

dnscry.pt Hanoi DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNDA0OmZiYzA6MDoxMWM4OjphMzI0XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9oYW4wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-helsinki-ipv4

dnscry.pt Helsinki DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjM3LjIyOC4xMjkuMTYwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hlbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-helsinki-ipv6

dnscry.pt Helsinki DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTA2OjE3MDA6MTozYTo6Y2JhXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9oZWwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-hochiminhcity-ipv4

dnscry.pt Ho-Chi-Minh City DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE2NS45OS4xMzEuOTUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc2duMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-hochiminhcity-ipv6

dnscry.pt Ho-Chi-Minh City DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyNDAwOmQ3NjA6MDozNDM6OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NnbjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hongkong-ipv4

dnscry.pt Hong Kong DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzk2LjkuMjI4LjI3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hrZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hongkong-ipv6

dnscry.pt Hong Kong DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGVsyMDAxOmRmMTo4MDE6YTAyMjo6YzQ6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaGtnMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-hongkong02-ipv4

dnscry.pt Hong Kong 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjIxNi4yNTAuOTcuMTQ4IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hrZzAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hongkong02-ipv6

dnscry.pt Hong Kong 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syNDA2OmVmODA6MToyMTczOjpiNWZdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hrZzAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hongkong03-ipv4

dnscry.pt Hong Kong 03 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjQ1LjEyMy4xODguMTI5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hrZzAzLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hongkong03-ipv6

dnscry.pt Hong Kong 03 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syNDA2OjQzMDA6YmFlOjZiMDg6OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2hrZzAzLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-houston-ipv4

dnscry.pt Houston DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjIwOS4xMzUuMTcwLjUxIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lhaDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-houston-ipv6

dnscry.pt Houston DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyNjAyOmY5ZjM6MDoyOjoxOTNdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lhaDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-hudiksvall-ipv4

dnscry.pt Hudiksvall DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTk1LjE0My4xOTYuMTYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaHV2MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-hudiksvall-ipv6

dnscry.pt Hudiksvall DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHFsyYTAzOmQ3ODA6MDoxOTY6OjNlODQ6NTZhZl0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaHV2MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-ikeja-ipv4

dnscry.pt Ikeja DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE2Ny44OC41MS4yNDUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbG9zMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-ikeja-ipv6

dnscry.pt Ikeja DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyYTAxOmUyODE6YWMwMTpmZDBkOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9sb3MwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-indianapolis-ipv4

dnscry.pt Indianapolis DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5OC4xMzQuMTA3LjgyIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2luZDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-indianapolis-ipv6

dnscry.pt Indianapolis DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNjA1OmZhODA6MToxNzo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaW5kMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-islamabad-ipv4

dnscry.pt Islamabad DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwMy45OS4xMzMuMTEwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lzYjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-islamabad-ipv6

dnscry.pt Islamabad DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyMDAxOmRmMjpkNDA6Mjk6OjJdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lzYjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-istanbul-ipv4

dnscry.pt Istanbul DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5My4yMjguMS4xOTkgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPaXN0MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-istanbul-ipv6

dnscry.pt Istanbul DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyYTEyOmUzNDI6MzAwOjpkYWNhOjYzZWFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lzdDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-jacksonville-ipv4

dnscry.pt Jacksonville DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzEwNC4yMjUuMTI5LjEwNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qYXgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-jacksonville-ipv6

dnscry.pt Jacksonville DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjA3OmE2ODA6NDpmMDAzOjplYzMyXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qYXgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-jakarta-ipv4

dnscry.pt Jakarta DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE1MS4yNDMuMjIyLjk0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2prdDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-jakarta-ipv6

dnscry.pt Jakarta DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHlsyNDA3OjZhYzA6Mzo1OjEyMzQ6NDMyMTo4OToxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qa3QwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-johannesburg-ipv4

dnscry.pt Johannesburg DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE2OS4yMzkuMTI4LjEyNCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qbmIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-johannesburg-ipv6

dnscry.pt Johannesburg DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyYzBmOmY1MzA6OmQwMDoxODhdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2puYjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-johannesburg02-ipv4

dnscry.pt Johannesburg 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE2MC4xMTkuMjM0LjE1NiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qbmIwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-johannesburg02-ipv6

dnscry.pt Johannesburg 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syYzBmOmYwMzA6NjA4MDoxOjoxNTZdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2puYjAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-johor-ipv4

dnscry.pt Johor DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTQ1LjI0OS45MS4xNTAgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPamhiMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-johor-ipv6

dnscry.pt Johor DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyMDAxOmRmNDoxODQwOjlmOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9qaGIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-kansascity-ipv4

dnscry.pt Kansas City DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIzLjE1MC40MC4xMjEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWNpMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-kansascity-ipv6

dnscry.pt Kansas City DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGVsyNjAyOjJiNzpkMDE6YzI5NTo6YjoxOF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWNpMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-kyiv02-ipv4

dnscry.pt Kyiv 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE4NS4xMjYuMjU1LjMwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2lldjAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-kyiv02-ipv6

dnscry.pt Kyiv 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTAxOmY1MDA6MjoxNTAwOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9pZXYwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-lasvegas-ipv4

dnscry.pt Las Vegas DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzY2LjE4Ny40LjM5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xhczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-lasvegas-ipv6

dnscry.pt Las Vegas DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAJlsyNjA2OjY1YzA6MTA6MjBlOjE2MjE6ZDk2MzoxMzFjOmJkNGNdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xhczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-libertylake-ipv4

dnscry.pt Liberty Lake DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDIzLjE4NC40OC4xOSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9sbGswMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-libertylake-ipv6

dnscry.pt Liberty Lake DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyNjAyOmZjMjQ6MjA6NDg6OmFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xsazAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-lisbon-ipv4

dnscry.pt Lisbon DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDE0My4yMC4xMi4zMiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9saXMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-lisbon-ipv6

dnscry.pt Lisbon DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyYTBmOmM0NDI6ODAwMDo6MzJdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xpczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-lisbon02-ipv4

dnscry.pt Lisbon 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDkxLjIwOS4xNi45OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9saXMwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-lisbon02-ipv6

dnscry.pt Lisbon 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAD1syYTBmOmM0NDQ6Ojk4XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9saXMwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-london-ipv4

dnscry.pt London DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjY3Ljg0LjEzMiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9sb24wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-london-ipv6

dnscry.pt London DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNDAxOjgzNjA6YTI6NDo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbG9uMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-losangeles-ipv4

dnscry.pt Los Angeles DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwNC4xNTYuMTU0LjExIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xheDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-losangeles-ipv6

dnscry.pt Los Angeles DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAElsyNjAyOmY3Zjg6NzpkOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9sYXgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-losangeles02-ipv4

dnscry.pt Los Angeles 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwNC4yMDAuNjcuMTk0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xheDAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-losangeles02-ipv6

dnscry.pt Los Angeles 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syNjAyOmZmNzU6NzpiNzk6OmI0YjRdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2xheDAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-madrid-ipv4

dnscry.pt Madrid DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTUuMTM0LjExOC4xOTggjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWFkMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-madrid-ipv6

dnscry.pt Madrid DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syYTAzOmM3YzA6NTI6MjY0MToxODA6OjEzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9tYWQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-manchester-ipv4

dnscry.pt Manchester DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjIxNi4yNDUuMTQwLjIwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21hbjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-manchester-ipv6

dnscry.pt Manchester DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syYTBhOjhkYzA6NjA1ODo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWFuMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-marseille-ipv4

dnscry.pt Marseille DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjQ1LjE0MC4xNjQuMTI3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21yczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-marseille-ipv6

dnscry.pt Marseille DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyYTA2OmU4ODE6NzAwMDo6Yjg1Mzo0OTVdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21yczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-melbourne-ipv4

dnscry.pt Melbourne DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwMy4xMDguMjI4LjE1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21lbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-melbourne-ipv6

dnscry.pt Melbourne DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNDAyOjczNDA6ODAwMDo6NV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWVsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-miami-ipv4

dnscry.pt Miami DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEyOC4yNTQuMjA3LjUwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21pYTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-miami-ipv6

dnscry.pt Miami DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAElsyNjAyOmY3Zjg6NjphOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9taWEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-milan-ipv4

dnscry.pt Milan DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTgyLjExOC4xNi4xMjEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbWlsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-milan-ipv6

dnscry.pt Milan DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTAyOjI3YWU6ODAwMDo6MmExXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9taWwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-molln-ipv4

dnscry.pt Mölln DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTkxLjEwOC44MC4xNTkgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbW9lMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-molln-ipv6

dnscry.pt Mölln DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syYTA1OjkwMTo2OjEwNDg6Ol0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbW9lMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-montreal-ipv4

dnscry.pt Montreal DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE0Ny4xODkuMTM2LjE4MyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95bXEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-montreal-ipv6

dnscry.pt Montreal DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyNjA2OjY2ODA6NDU6MTo6Zjc4Yzo5YjBdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3ltcTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-moscow-ipv4

dnscry.pt Moscow DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjkzLjE4My4xMDYuMjIyIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D21vdzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-moscow-ipv6

dnscry.pt Moscow DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAElsyYTAzOmUzNDA6MzozOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9tb3cwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-mumbai02-ipv4

DNSCry.pt Mumbai 02 - DoH, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AgcAAAAAAAAADDE1Ny4yMC4yNy43OSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9ib20wMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-mumbai02-ipv6

dnscry.pt Mumbai 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEVsyNjAyOmZhMDg6NTo6NzVdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2JvbTAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-munich-ipv4

dnscry.pt Munich DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5NC4zOS4yMDUuMTAgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbXVjMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-munich-ipv6

dnscry.pt Munich DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyYTBjOjhmYzA6MTc0OTo2NjoxODo6MTZdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D211YzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-naaldwijk-ipv4

dnscry.pt Naaldwijk DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzQ1Ljk1LjM4LjI5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D25hdzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-newcastle-ipv4

dnscry.pt Newcastle DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzgyLjIyLjIwLjM0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D25jbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-newcastle-ipv6

dnscry.pt Newcastle DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyYTAzOjU4NDA6MTIzOjg6OmFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D25jbDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-newyork-ipv4

dnscry.pt New York DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5OS4xMTkuMTM3Ljc0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D255YzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-newyork-ipv6

dnscry.pt New York DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAElsyNjAyOmY3Zjg6MjpjOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9ueWMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-nuremberg-ipv4

dnscry.pt Nuremberg DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIwMi42MS4yMzYuNjcgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbnVlMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-nuremberg-ipv6

dnscry.pt Nuremberg DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAJVsyYTAzOjQwMDA6NWM6NTE6MjRiOTo1MWZmOmZlODA6ZjNhN10gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPbnVlMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-ogden-ipv4

dnscry.pt Ogden DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwNy4xODIuMTczLjgzIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D29nZDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-ogden-ipv6

dnscry.pt Ogden DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjA3OmYyZDg6NDAxYjoxMDQ1OjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9vZ2QwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-oradea-ipv4

dnscry.pt Oradea DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE4NS4yMDcuMTI1LjEwMCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9vbXIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-oradea-ipv6

dnscry.pt Oradea DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHVsyYTBkOjgxNDQ6MDpmNjoyOTE1OmFmOjA6MThdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D29tcjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-ottoville-ipv4

dnscry.pt Ottoville DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzEwNC4yMzQuMjMxLjIzOSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9vdHQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-ottoville-ipv6

dnscry.pt Ottoville DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNjAyOmY5NTM6NjoyNTo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPb3R0MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-paris-ipv4

dnscry.pt Paris DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzg5LjExNy4yLjE3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3BhcjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-paris-ipv6

dnscry.pt Paris DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHlsyNDAyOmQwYzA6MjI6NmNkMDo0OjQ6NDo1YjgxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9wYXIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-perth-ipv4

dnscry.pt Perth DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjIwMy4yOS4yNDAuMjQ5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3BlcjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-perth-ipv6

dnscry.pt Perth DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAIlsyNDA0Ojk0MDA6NDowOjIxNjozZWZmOmZlZTY6YTc2Ml0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPcGVyMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-phoenix-ipv4

dnscry.pt Phoenix DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE3My4yNDkuMjA1LjE5OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9waHgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-phoenix-ipv6

dnscry.pt Phoenix DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syNjA3OjkwMDA6NzAwOjEwMzA6OmFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3BoeDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-portedwards-ipv4

dnscry.pt Port Edwards DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE3Ni4xMTEuMjE5LjEyNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9wZWQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-portedwards-ipv6

dnscry.pt Port Edwards DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyMDAxOjQ3MDoxZjExOjJiYjo6YjIzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9wZWQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-portland-ipv4

dnscry.pt Portland DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzEwMy4xMjQuMTA2LjIzMyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9wZHgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-portland-ipv6

dnscry.pt Portland DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAIVsyNDAyOmQwYzA6MTY6YTFlNjowOmI4OTM6YmY3OmRkXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9wZHgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-prague-ipv4

dnscry.pt Prague DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE5NS4xMjMuMjQ1LjE5IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3ByZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-prague-ipv6

dnscry.pt Prague DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEFsyYTA1Ojk0MDM6Ojk5OV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPcHJnMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-redditch-ipv4

dnscry.pt Redditch DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjY3Ljg1LjIxOSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9yZGQwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-redditch-ipv6

dnscry.pt Redditch DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNDAxOjgzNjA6YTM6ZTo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPcmRkMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-riga-ipv4

dnscry.pt Riga DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE5NS4xMjMuMjEyLjIwMCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9yaXgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-riga-ipv6

dnscry.pt Riga DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAEVsyYTAyOjI3YWM6OjEyNDldIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3JpeDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-saltlakecity-ipv4

dnscry.pt Salt Lake City DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwMy4xMTQuMTYyLjY1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NsYzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-saltlakecity-ipv6

dnscry.pt Salt Lake City DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAIVsyNDAyOmQwYzA6MTg6YzhmZjowOmI4OTM6YmY3OmRkXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zbGMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-sandefjord-ipv4

dnscry.pt Sandefjord DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5NC4zMi4xMDcuNDggjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdHJmMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-sandefjord-ipv6

dnscry.pt Sandefjord DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTAzOjk0ZTA6MjcxZjo6NWIxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90cmYwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-sanjose-ipv4

dnscry.pt San Jose DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE4NS4xMDYuOTYuMjEwIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NqYzAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-sanjose-ipv6

dnscry.pt San Jose DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syNjA3OmYzNTg6MWE6ZTo6OGFhMjo5MzMzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zamMwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-santaclara-ipv4

dnscry.pt Santa Clara DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE3Ni4xMTEuMjIzLjE2NyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zamMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-santaclara-ipv6

dnscry.pt Santa Clara DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syNjA2OjY2ODA6MzU6MTo6NTA2ZDo4Y2UyXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zamMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-saopaulo-ipv4

dnscry.pt São Paulo DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIwNy4xODAuMy4xODkgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc2FvMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-saopaulo-ipv6

dnscry.pt São Paulo DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAIFsyYTBjOjlhNDA6OGY0MDowOjIwNzoxODA6MzoxODldIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NhbzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-seattle-ipv4

dnscry.pt Seattle DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzIwOS4xODIuMjI1LjEwMyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zZWEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-seattle-ipv6

dnscry.pt Seattle DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjA3OmE2ODA6OTpmMDA1Ojo4NmU3XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zZWEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-seoul02-ipv4

dnscry.pt Seoul 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE1MS4yNDUuMTA2LjE4MSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zZWwwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-seoul02-ipv6

dnscry.pt Seoul 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNDA2OmVmODA6NTo0OGE5OjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zZWwwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-singapore-ipv4

dnscry.pt Singapore DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE1Ny4yMC4xMDUuMTE1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NpbjAzLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-singapore-ipv6

dnscry.pt Singapore DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMzpmOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zaW4wMy5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-singapore02-ipv4

dnscry.pt Singapore 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTEwMy4xNzkuNDQuNzMgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc2luMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-singapore02-ipv6

dnscry.pt Singapore 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNDAxOjQ1MjA6MTEyMjo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc2luMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-sofia-ipv4

dnscry.pt Sofia DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzc5LjEyNC43LjQzIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NvZjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-sofia-ipv6

dnscry.pt Sofia DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syYTAxOjg3NDA6MTo4NjM6OjNiOGNdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NvZjAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-spokane-ipv4

dnscry.pt Spokane DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTEwNC4zNi44Ni4xODEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPZ2VnMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-spokane-ipv6

dnscry.pt Spokane DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyNjA2OmE4YzA6MzoyMDI6OmFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D2dlZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-stockholm-ipv4

dnscry.pt Stockholm DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDE5NS43Mi42MC42NiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zdG8wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-stockholm-ipv6

dnscry.pt Stockholm DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syYTA3OmUwNDM6MTo1ZDo6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc3RvMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-stockholm02-ipv4

dnscry.pt Stockholm 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE4NS4yMzEuMTAwLjEwNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zdG8wMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-stockholm02-ipv6

dnscry.pt Stockholm 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAKFsyYTBjOjU3MDA6MzEzMzo2NTA6OTZkNTo5OWZmOmZlOGI6NzRmNF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc3RvMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-sydney02-ipv4

dnscry.pt Sydney 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5NS4xMTQuMTQuNzQgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPc3lkMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-sydney02-ipv6

dnscry.pt Sydney 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNDAyOjczNDA6NTAwMDo2MjAwOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA9zeWQwMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-taipeh-ipv4

dnscry.pt Taipeh DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzEwMy4xMzEuMTg5LjE5MSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90cGUwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-taipeh-ipv6

dnscry.pt Taipeh DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyNDAzOmNmYzA6MTAwNDo6YjViOjQ3ZmZdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3RwZTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-tallinn-ipv4

dnscry.pt Tallinn DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE4NS4xOTQuNTMuMjIgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdGxsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-tallinn-ipv6

dnscry.pt Tallinn DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAElsyYTA0OjZmMDA6NDo6MTdhXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90bGwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tampa-ipv4

dnscry.pt Tampa DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE2NS4xNDAuMTE3LjI0OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90cGEwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tampa-ipv6

dnscry.pt Tampa DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGVsyNjAyOmZjYzA6MjIyMjo5ZDJlOjo1M10gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdHBhMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-taos-ipv4

dnscry.pt Taos DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjYzLjEzMy4yMjMuMTM4IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3RzbTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-taos-ipv6

dnscry.pt Taos DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAG1syNjA2OjY2ODA6NTM6MTo6ODQ2YTpiZDc5XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90c20wMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tbilisi-ipv4

dnscry.pt Tbilisi DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADzE5NC4xMzUuMTE5LjE1OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90YnMwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tbilisi-ipv6

dnscry.pt Tbilisi DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGlsyYTEyOmUzNDA6MzAwOjoxNzY4OmE5NWZdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3RiczAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-thessaloniki-ipv4

dnscry.pt Thessaloniki DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzg1LjkwLjE5Ny43IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NrZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-thessaloniki-ipv6

dnscry.pt Thessaloniki DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFFsyYTEyOjZmYzM6ODAwMDo6MTldIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3NrZzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-timisoara-ipv4

dnscry.pt Timișoara DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjEzNC40OC4yNSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90c3IwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-timisoara-ipv6

dnscry.pt Timișoara DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHlsyYTBjOjlmMDA6MjpkOTI4OjZmMGE6YjRlMjo6XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90c3IwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tirana-ipv4

dnscry.pt Tirana DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE4NS43NS4yNDMuODAgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdGlhMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-tirana-ipv6

dnscry.pt Tirana DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHVsyYTEzOjk0MDM6OjdhNmE6NTMwNjoxZTM1OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3RpYTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-tokyo-ipv4

dnscry.pt Tokyo DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDQ1LjY3Ljg2LjEyMyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90eW8wMy5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tokyo-ipv6

dnscry.pt Tokyo DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMjpkOjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90eW8wMy5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tokyo02-ipv4

dnscry.pt Tokyo 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDEwMy4xNzkuNDUuNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA90eW8wMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tokyo02-ipv6

dnscry.pt Tokyo 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAE1syNDAxOjQ1MjA6MzAxZTo6YV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdHlvMDIuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-toronto-ipv4

dnscry.pt Toronto DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjE3Mi45My4xNjcuMjE0IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3l5ejAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-toronto-ipv6

dnscry.pt Toronto DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAGFsyNjA2OjYwODA6MjAwMToxMDk5OjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95eXowMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-toronto02-ipv4

dnscry.pt Toronto 02 DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADjEwMy4xNDQuMTc3LjU3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3l5ejAyLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-toronto02-ipv6

dnscry.pt Toronto 02 DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjAyOmZlZDI6ZmEwOjRhOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95eXowMi5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-tuusula-ipv4

dnscry.pt Tuusula DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTY1LjIxLjI1Mi4yMDEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdHV1MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-tuusula-ipv6

dnscry.pt Tuusula DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syYTAxOjRmOTpjMDExOmI4NGU6OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3R1dTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-valdivia-ipv4

dnscry.pt Valdivia DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTIxNi43My4xNTkuMjYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPemFsMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-valdivia-ipv6

dnscry.pt Valdivia DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTA2OmEwMDY6ZDFkMTo6MTE2XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA96YWwwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-vancouver-ipv4

dnscry.pt Vancouver DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADDIzLjE1NC44MS45MiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95dnIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-vancouver-ipv6

dnscry.pt Vancouver DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyNjAyOmZlZDI6ZmIwOjZkOjoxXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA95dnIwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-vienna-ipv4

dnscry.pt Vienna DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTgzLjEzOC41NS4xODYgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdmllMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-vienna-ipv6

dnscry.pt Vienna DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syYTBkOmYzMDI6MTEwOjY1MTc6OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3ZpZTAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-vilnius-ipv4

dnscry.pt Vilnius DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE2Mi4yNTQuODYuMTMgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPdm5vMDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-vilnius-ipv6

dnscry.pt Vilnius DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAF1syYTEzOjk0MDE6MDoxOjozZDU4OjFdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3ZubzAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-warsaw-ipv4

dnscry.pt Warsaw DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAADTE5NS4zLjIyMS4xNjIgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQPd2F3MDEuZG5zY3J5LnB0Ci9kbnMtcXVlcnk


## dnscry.pt-doh-warsaw-ipv6

dnscry.pt Warsaw DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAHlsyYTAzOmNmYzA6ODAwMDoyNjo6YzMwMzpkZGEyXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA93YXcwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-doh-zurich-ipv4

dnscry.pt Zürich DoH resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAACzk0LjI2LjM1LjU3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50D3pyaDAxLmRuc2NyeS5wdAovZG5zLXF1ZXJ5


## dnscry.pt-doh-zurich-ipv6

dnscry.pt Zürich DoH resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
https://www.dnscry.pt

sdns://AgcAAAAAAAAAFVsyYTAyOjI5Yjg6ODAwMTo0OjphXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdA96cmgwMS5kbnNjcnkucHQKL2Rucy1xdWVyeQ


## dnscry.pt-dublin-ipv4

dnscry.pt Dublin resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4yNi4yMTMuMTUgEzWgsAQfbmA1ppXryEJ6vQ3Vvc2Kk2oRkdjodTEYvPQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dublin-ipv6

dnscry.pt Dublin resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA5OmNkNDY6Zjo0MjllOjo1XSATNaCwBB9uYDWmlevIQnq9DdW9zYqTahGR2Oh1MRi89BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-dusseldorf-ipv4

dnscry.pt Düsseldorf resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTUuMTc1LjE4MC4xNzEg_5w5GH6bnmpKPcqtR58x5VHe2qD5-mSZeGIsqaukhr4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf-ipv6

dnscry.pt Düsseldorf resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTBmOjYyODQ6NDMwMDoxMDE6OjEyYTVdIP-cORh-m55qSj3KrUefMeVR3tqg-fpkmXhiLKmrpIa-GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-dusseldorf02-ipv4

DNSCry.pt Düsseldorf 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTM3LjExNC41OC4xMTUgWAo_MyYybZGGBQKsA41WpC5TjjpfvgviHteGEKBXNIwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf02-ipv6

dnscry.pt Düsseldorf 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTA2OmRlMDA6NDAxOjIyNzo6Ml0gWAo_MyYybZGGBQKsA41WpC5TjjpfvgviHteGEKBXNIwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf03-ipv4

DNSCry.pt Düsseldorf 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTExOC45MS4xODQuODkgBVOdxEWkG9yUyaviAaCbPJMqAG36WK_rVLkYvKSqCgwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf03-ipv6

dnscry.pt Düsseldorf 03 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyYTBkOmQ5MDA6MTEwOjpdIAVTncRFpBvclMmr4gGgmzyTKgBt-liv61S5GLykqgoMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ebenecity02-ipv4

dnscry.pt Ebène City 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE5Ni40Ni41MC45MyCvOC_dXQNKuRJd-tsXi_v7zzQpqJumDnGU0NP-zaCcOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ebenecity02-ipv6

dnscry.pt Ebène City 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyMDAxOjQ3MDoxZjIzOjEzOTo6YjpiXSCvOC_dXQNKuRJd-tsXi_v7zzQpqJumDnGU0NP-zaCcOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-eygelshoven-ipv4

dnscry.pt Eygelshoven resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDkzLjk1LjExNS4yMSDit1FyUAiu0W-x936EJIC1keajbwu1pvb6yVKVj0KVYhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-eygelshoven-ipv6

dnscry.pt Eygelshoven resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADlsyYTEwOmNhODA6OmFdIOK3UXJQCK7Rb7H3foQkgLWR5qNvC7Wm9vrJUpWPQpViGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-flint-ipv4

dnscry.pt Flint resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE0Ny4xODkuMTQwLjEzNiCL7wgLXnE-35sDhXk5N1RNpUfWmM2aUBcMFlst7FPdnRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-flint-ipv6

dnscry.pt Flint resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6Mjk6MTo6NTg1OTphMzdiXSCL7wgLXnE-35sDhXk5N1RNpUfWmM2aUBcMFlst7FPdnRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-frankfurt-ipv4

dnscry.pt Frankfurt resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjgyLjEyMC42MSD79MPkuIliP7zrXMgYVK5wcSD_shP7dPfHx9haFaux6RkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-frankfurt-ipv6

dnscry.pt Frankfurt resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBlOjZhODA6Mzo2Njk6Ol0g-_TD5LiJYj-861zIGFSucHEg_7IT-3T3x8fYWhWrsekZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-frankfurt02-ipv4

dnscry.pt Frankfurt 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjE0Ny41MS4xMjMgIXwiAp3nzMSapyRop7AbWNG8rFfD1aGhvvGSXFdfv24ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-frankfurt02-ipv6

dnscry.pt Frankfurt 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTA3OmQ4ODQ6MTAwOjozNDRdICF8IgKd58zEmqckaKewG1jRvKxXw9Whob7xklxXX79uGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-fremont02-ipv4

dnscry.pt Fremont 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE2Ny44OC40OC4xOCDXa6t5njAKDHZ2JWPfQ-9XAbho3aZHomYynHy8m3QnThkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-fremont02-ipv6

dnscry.pt Fremont 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjAyOmZlZDI6NzE5ODo3YWYxOjoxXSDXa6t5njAKDHZ2JWPfQ-9XAbho3aZHomYynHy8m3QnThkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-gdansk-ipv4

dnscry.pt Gdańsk resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgyLjExOC4yMS4xODkgqFjzKHAuUbpDR2JSbSp7myEtbvT4E4MX5CczpKEWt4UZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-gdansk-ipv6

dnscry.pt Gdańsk resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDQ6Ojg5OV0gqFjzKHAuUbpDR2JSbSp7myEtbvT4E4MX5CczpKEWt4UZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-geneva-ipv4

dnscry.pt Geneva resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjkwLjU5LjE5MyApCKLNC-QxtyiyCC4AQIb36KxxFcalmSGG9V_CLDDyVxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-geneva-ipv6

dnscry.pt Geneva resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDY6OmFlMV0gKQiizQvkMbcosgguAECG9-iscRXGpZkhhvVfwiww8lcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-grandrapids-ipv4

dnscry.pt Grand Rapids resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xNjUuNDQuMTY0IIAGv2tc1niHTIQfcnX5-ElHTfAJySTEfHKDgxBlM4O9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-grandrapids-ipv6

dnscry.pt Grand Rapids resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmY5NjQ6MToyNDo6YV0ggAa_a1zWeIdMhB9ydfn4SUdN8AnJJMR8coODEGUzg70ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hafnarfjordur-ipv4

dnscry.pt Hafnarfjordur resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5Mi43MS4yMTguMTIxIDvH8Abx1KvD57UbwdFAZO0i7FlRjk9HkQUFyT0k1LbSGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hafnarfjordur-ipv6

dnscry.pt Hafnarfjordur resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTAzOmY4MDozNTQ6MzZhMTo6MV0gO8fwBvHUq8PntRvB0UBk7SLsWVGOT0eRBQXJPSTUttIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-halifax-ipv4

dnscry.pt Halifax resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE5MS44MC40MyCcn0gUE1BHqKv8Nwyv454nRdFBh7XysXqqIFgEgFMfMhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-halifax-ipv6

dnscry.pt Halifax resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZjMWM6ZmEwOjI5OjoxXSCcn0gUE1BHqKv8Nwyv454nRdFBh7XysXqqIFgEgFMfMhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hanoi-ipv4

dnscry.pt Hanoi resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xOTkuMTYuOTMg6iF-oJet7zyL2odP--IayA5Wrz6t94RPc7PXF53V82cZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hanoi-ipv6

dnscry.pt Hanoi resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNDA0OmZiYzA6MDoxMWM4OjphMzI0XSDqIX6gl63vPIvah0_74hrIDlavPq33hE9zs9cXndXzZxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-helsinki-ipv4

dnscry.pt Helsinki resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjM3LjIyOC4xMjkuMTYwIPlYPWSML8DlYbkp1ycL3CBER_3aJHp7GLvX_TRvbojGGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-helsinki-ipv6

dnscry.pt Helsinki resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OjE3MDA6MTozYTo6Y2JhXSD5WD1kjC_A5WG5KdcnC9wgREf92iR6exi71_00b26IxhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hochiminhcity-ipv4

dnscry.pt Ho Chi Minh City resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE2NS45OS4xMzEuOTUg7B186ItTKGEYyZyKq9XgSnChmigBrnFCxeTBzRfaWOsZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hochiminhcity-ipv6

dnscry.pt Ho Chi Minh City resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNDAwOmQ3NjA6MDozNDM6OjFdIOwdfOiLUyhhGMmciqvV4EpwoZooAa5xQsXkwc0X2ljrGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong-ipv4

dnscry.pt Hong Kong resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzk2LjkuMjI4LjI3ICMJK8RA3cOKDpDZjSR9PqVXj2mGf43CHMa6fO7ZzCWmGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong-ipv6

dnscry.pt Hong Kong resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyMDAxOmRmMTo4MDE6YTAyMjo6YzQ6YV0gIwkrxEDdw4oOkNmNJH0-pVePaYZ_jcIcxrp87tnMJaYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hongkong02-ipv4

dnscry.pt Hong Kong 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIxNi4yNTAuOTcuMTQ4IE051A_5owd3KFF0cKbFZ57YasyL72DAOxmbF3SJUX2kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong02-ipv6

dnscry.pt Hong Kong 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNDA2OmVmODA6MToyMTczOjpiNWZdIE051A_5owd3KFF0cKbFZ57YasyL72DAOxmbF3SJUX2kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong03-ipv4

dnscry.pt Hong Kong 03 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQ1LjEyMy4xODguMTI5IAtxIfzDy0d11GLJHr7HPkdtPwGbimmNUM0gUa0gfjHIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong03-ipv6

dnscry.pt Hong Kong 03 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNDA2OjQzMDA6YmFlOjZiMDg6OjFdIAtxIfzDy0d11GLJHr7HPkdtPwGbimmNUM0gUa0gfjHIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-houston-ipv4

dnscry.pt Houston resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIwOS4xMzUuMTcwLjUxIPSBxTHLVPyC6r5TAAsl-mj-phfwQypedBkfja2kZ4yMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-houston-ipv6

dnscry.pt Houston resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjAyOmY5ZjM6MDoyOjoxOTNdIPSBxTHLVPyC6r5TAAsl-mj-phfwQypedBkfja2kZ4yMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hudiksvall-ipv4

dnscry.pt Hudiksvall resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTk1LjE0My4xOTYuMTYgN-023_u1yfCZ1TutJJBNC1uM4lZOrlklDvYGy1BFWdIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hudiksvall-ipv6

dnscry.pt Hudiksvall resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHFsyYTAzOmQ3ODA6MDoxOTY6OjNlODQ6NTZhZl0gN-023_u1yfCZ1TutJJBNC1uM4lZOrlklDvYGy1BFWdIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ikeja-ipv4

dnscry.pt Ikeja resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE2Ny44OC41MS4yNDUgguLn-RnYHhHkgS3ScOYQgjt31X6KEyKwkBMXpS_gBoQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ikeja-ipv6

dnscry.pt Ikeja resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTAxOmUyODE6YWMwMTpmZDBkOjoxXSCC4uf5GdgeEeSBLdJw5hCCO3fVfooTIrCQExelL-AGhBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-indianapolis-ipv4

dnscry.pt Indianapolis resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5OC4xMzQuMTA3LjgyILqgPhElxsX559lZkTVLRzyhORvg9vq6WOEZ8NemWLN8GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-indianapolis-ipv6

dnscry.pt Indianapolis resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjA1OmZhODA6MToxNzo6YV0guqA-ESXGxfnn2VmRNUtHPKE5G-D2-rpY4Rnw16ZYs3wZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-istanbul-ipv4

dnscry.pt Istanbul resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5My4yMjguMS4xOTkgXK0o7fAtGbbqsMWn6eFc8pQ3_Tf3YrD64C9ZuBjV-l0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-istanbul-ipv6

dnscry.pt Istanbul resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTEyOmUzNDI6MzAwOjpkYWNhOjYzZWFdIFytKO3wLRm26rDFp-nhXPKUN_0392Kw-uAvWbgY1fpdGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-jacksonville-ipv4

dnscry.pt Jacksonville resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwNC4yMjUuMTI5LjEwNiAKQZEj8OAMOEB3ZaY36Jovz59wKeyFhBAMV6eOK384rhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-jacksonville-ipv6

dnscry.pt Jacksonville resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6NDpmMDAzOjplYzMyXSAKQZEj8OAMOEB3ZaY36Jovz59wKeyFhBAMV6eOK384rhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-jakarta-ipv4

dnscry.pt Jakarta resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE1MS4yNDMuMjIyLjk0IMp-kt2QTVeHxfHuzsBm8Y-j_LnTTldhKbHfA61KITsfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-jakarta-ipv6

dnscry.pt Jakarta resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyNDA3OjZhYzA6Mzo1OjEyMzQ6NDMyMTo4OToxXSDKfpLdkE1Xh8Xx7s7AZvGPo_y5005XYSmx3wOtSiE7HxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-johannesburg-ipv4

dnscry.pt Johannesburg resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2OS4yMzkuMTI4LjEyNCDPBt-20rnrKqM3G3-ZKudPSvU9-zClzYY5-F2KRJSgsBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-johannesburg-ipv6

dnscry.pt Johannesburg resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYzBmOmY1MzA6OmQwMDoxODhdIM8G37bSuesqozcbf5kq509K9T37MKXNhjn4XYpElKCwGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-johannesburg02-ipv4

dnscry.pt Johannesburg 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xMTkuMjM0LjE1NiAFeFrCOd-Rm2fijlXta1tVv6IZudJxcJLtf4ReuGpInBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-johannesburg02-ipv6

dnscry.pt Johannesburg 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYzBmOmYwMzA6NjA4MDoxOjoxNTZdIAV4WsI535GbZ-KOVe1rW1W_ohm50nFwku1_hF64akicGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-johor-ipv4

DNSCry.pt Johor - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjI0OS45MS4xNTAgHONiOhMA1VOPBBcvrkvy9IW-Q0dhA1aY-g5rKbpy9noZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-johor-ipv6

dnscry.pt Johor resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyMDAxOmRmNDoxODQwOjlmOjphXSAc42I6EwDVU48EFy-uS_L0hb5DR2EDVpj6DmspunL2ehkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-kansascity-ipv4

dnscry.pt Kansas City resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjE1MC40MC4xMjEgQprQrFLF3Y2975ylDjnD8kdKAJLUvauubVrBGueEkcgZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kansascity-ipv6

dnscry.pt Kansas City resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyNjAyOjJiNzpkMDE6YzI5NTo6YjoxOF0gQprQrFLF3Y2975ylDjnD8kdKAJLUvauubVrBGueEkcgZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kyiv02-ipv4

dnscry.pt Kyiv 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xMjYuMjU1LjMwIEIlrpRjjslwYRvDmYBYK2kQydPruVX2Q7UZ1wndsrOwGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lasvegas-ipv4

dnscry.pt Las Vegas resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzY2LjE4Ny40LjM5IKRyCGsVY-zFWu2VBI5UX4ItKdMFTZTubX8xHnY7u0KLGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lasvegas-ipv6

dnscry.pt Las Vegas resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAJlsyNjA2OjY1YzA6MTA6MjBlOjE2MjE6ZDk2MzoxMzFjOmJkNGNdIKRyCGsVY-zFWu2VBI5UX4ItKdMFTZTubX8xHnY7u0KLGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-libertylake-ipv4

dnscry.pt Liberty Lake resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE4NC40OC4xOSCwg3q2XK6z70eHJhi0H7whWQ_ZWQylhMItvqKpd9GtzRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-libertylake-ipv6

dnscry.pt Liberty Lake resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjAyOmZjMjQ6MjA6NDg6OmFdILCDerZcrrPvR4cmGLQfvCFZD9lZDKWEwi2-oql30a3NGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lisbon-ipv4

dnscry.pt Lisbon resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE0My4yMC4xMi4zMiCptEWfvxpDpSX_nr_GMuH01abYaJsHdFswBbbAEI9aSxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lisbon-ipv6

dnscry.pt Lisbon resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTBmOmM0NDI6ODAwMDo6MzJdIKm0RZ-_GkOlJf-ev8Yy4fTVpthomwd0WzAFtsAQj1pLGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lisbon02-ipv4

dnscry.pt Lisbon 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDkxLjIwOS4xNi45OCAGvEQ0hj1cw5V6NbFAljIPcHjo22MzFVFq2cpPXKKu5BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lisbon02-ipv6

dnscry.pt Lisbon 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAD1syYTBmOmM0NDQ6Ojk4XSAGvEQ0hj1cw5V6NbFAljIPcHjo22MzFVFq2cpPXKKu5BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-london-ipv4

dnscry.pt London resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg0LjEzMiCPZtxEvrtixgzqLZkrkl_-HL7-Cau2YUCEF2vb8sox7hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-london-ipv6

dnscry.pt London resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjgzNjA6YTI6NDo6YV0gj2bcRL67YsYM6i2ZK5Jf_hy-_gmrtmFAhBdr2_LKMe4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-losangeles-ipv4

dnscry.pt Los Angeles resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNC4xNTYuMTU0LjExIED6lUqafS2hgKJM7y56Ban4s50FPfMiamoZXHGKqfhBGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-losangeles-ipv6

dnscry.pt Los Angeles resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6NzpkOjphXSBA-pVKmn0toYCiTO8uegWp-LOdBT3zImpqGVxxiqn4QRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-losangeles02-ipv4

dnscry.pt Los Angeles 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNC4yMDAuNjcuMTk0IIhxeSuGQHwchZdstQqcoKD_RAuV4w8Qr_1XmXFZucGEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-losangeles02-ipv6

dnscry.pt Los Angeles 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNjAyOmZmNzU6NzpiNzk6OmI0YjRdIIhxeSuGQHwchZdstQqcoKD_RAuV4w8Qr_1XmXFZucGEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-madrid-ipv4

dnscry.pt Madrid resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTUuMTM0LjExOC4xOTggF4pp6ab33hO4Nb9tp8zuU8Drkh2GcvzYZikut4DIHN8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-madrid-ipv6

dnscry.pt Madrid resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syYTAzOmM3YzA6NTI6MjY0MToxODA6OjEzXSAXimnppvfeE7g1v22nzO5TwOuSHYZy_NhmKS63gMgc3xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-manchester-ipv4

dnscry.pt Manchester resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIxNi4yNDUuMTQwLjIwIOUvdbEOhupyl3_MymoToO-zVeHubT5q6UveXcvkAHAzGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-manchester-ipv6

dnscry.pt Manchester resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBhOjhkYzA6NjA1ODo6YV0g5S91sQ6G6nKXf8zKahOg77NV4e5tPmrpS95dy-QAcDMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-marseille-ipv4

dnscry.pt Marseille resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQ1LjE0MC4xNjQuMTI3IM3cVPGKJ3KsfAsDGsEDpItjlU2H7A9I0igL0qYzpoqjGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-marseille-ipv6

dnscry.pt Marseille resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTA2OmU4ODE6NzAwMDo6Yjg1Mzo0OTVdIM3cVPGKJ3KsfAsDGsEDpItjlU2H7A9I0igL0qYzpoqjGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-melbourne-ipv4

dnscry.pt Melbourne resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMDguMjI4LjE1ILAWh1FyQgZtjFxK9KuFzaJfUBQpjrxnlDNMaUiEo5UWGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-melbourne-ipv6

dnscry.pt Melbourne resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAyOjczNDA6ODAwMDo6NV0gsBaHUXJCBm2MXEr0q4XNol9QFCmOvGeUM0xpSISjlRYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-miami-ipv4

dnscry.pt Miami resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEyOC4yNTQuMjA3LjUwIIOGZgtvk9SmJ8GODlVlvGnZKIbEK66_WlJnYWU6rED7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-miami-ipv6

dnscry.pt Miami resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6NjphOjphXSCDhmYLb5PUpifBjg5VZbxp2SiGxCuuv1pSZ2FlOqxA-xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-milan-ipv4

dnscry.pt Milan resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgyLjExOC4xNi4xMjEguySFBuKaH6g5ZUYPPs59A9TRvbZUDtnj_NPoHOXQ0oAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-milan-ipv6

dnscry.pt Milan resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAyOjI3YWU6ODAwMDo6MmExXSC7JIUG4pofqDllRg8-zn0D1NG9tlQO2eP80-gc5dDSgBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-molln-ipv4

dnscry.pt Mölln resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTkxLjEwOC44MC4xNTkgMM6jepDoFl1PnnXwNjbqe-V8hUotmrrq7KhwJbik6A0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-molln-ipv6

dnscry.pt Mölln resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTA1OjkwMTo2OjEwNDg6Ol0gMM6jepDoFl1PnnXwNjbqe-V8hUotmrrq7KhwJbik6A0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-montreal-ipv4

dnscry.pt Montreal resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE0Ny4xODkuMTM2LjE4MyCsCFB6EkMJdZLQ-IlsBbtjtSlasCfsTx7Q6u0bOI8OwBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-montreal-ipv6

dnscry.pt Montreal resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyNjA2OjY2ODA6NDU6MTo6Zjc4Yzo5YjBdIKwIUHoSQwl1ktD4iWwFu2O1KVqwJ-xPHtDq7Rs4jw7AGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-moscow-ipv4

dnscry.pt Moscow resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjkzLjE4My4xMDYuMjIyIBQ6uCceRUNVJGFB1kGltuW_Jr2Nsizvc06BfMI30iIBGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-moscow-ipv6

dnscry.pt Moscow resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyYTAzOmUzNDA6MzozOjoxXSAUOrgnHkVDVSRhQdZBpbblvya9jbIs73NOgXzCN9IiARkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-mumbai02-ipv4

dnscry.pt Mumbai 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE1Ny4yMC4yNy43OSCWqeT_u1nn0f3mZBAXCN7K40kyMWyMgma2VqLqJhijIhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-mumbai02-ipv6

dnscry.pt Mumbai 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyNjAyOmZhMDg6NTo6NzVdIJap5P-7WefR_eZkEBcI3srjSTIxbIyCZrZWouomGKMiGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-munich-ipv4

dnscry.pt Munich resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4zOS4yMDUuMTAgQtC7u79NGEO2MGscsRWQJwJZy8mvvDwc1gpY_VjEf2IZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-munich-ipv6

dnscry.pt Munich resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTBjOjhmYzA6MTc0OTo2NjoxODo6MTZdIELQu7u_TRhDtjBrHLEVkCcCWcvJr7w8HNYKWP1YxH9iGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-naaldwijk-ipv4

dnscry.pt Naaldwijk resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzQ1Ljk1LjM4LjI5IATeNz_ePk9x72RgPo1MpzBkWVILwaCh3CWv3Mc8YE9dGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newcastle-ipv4

dnscry.pt Newcastle resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzgyLjIyLjIwLjM0IOUWyz2JlvdgmwUcA2muhgWH_eVtovNL-1xkdLFdATbqGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newcastle-ipv6

dnscry.pt Newcastle resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTAzOjU4NDA6MTIzOjg6OmFdIOUWyz2JlvdgmwUcA2muhgWH_eVtovNL-1xkdLFdATbqGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newyork-ipv4

dnscry.pt New York resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5OS4xMTkuMTM3Ljc0INFsbz5k1cESSOnC4MrzZhh7fnwunh6S-wAtXIo9me68GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newyork-ipv6

dnscry.pt New York resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6MjpjOjphXSDRbG8-ZNXBEkjpwuDK82YYe358Lp4ekvsALVyKPZnuvBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-nuremberg-ipv4

dnscry.pt Nuremberg resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIwMi42MS4yMzYuNjcgr2UzWGeubsFSZXP-_a8P2GA-gsZJ81sKZuhdsgsGqscZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-nuremberg-ipv6

dnscry.pt Nuremberg resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAJVsyYTAzOjQwMDA6NWM6NTE6MjRiOTo1MWZmOmZlODA6ZjNhN10gr2UzWGeubsFSZXP-_a8P2GA-gsZJ81sKZuhdsgsGqscZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ogden-ipv4

dnscry.pt Ogden resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNy4xODIuMTczLjgzIEKIFoJ_rsdGy6WtY-lA2RFoVLxHUNT_zox8rttFjbrcGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ogden-ipv6

dnscry.pt Ogden resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmYyZDg6NDAxYjoxMDQ1OjphXSBCiBaCf67HRsulrWPpQNkRaFS8R1DU_86MfK7bRY263BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-oradea-ipv4

dnscry.pt Oradea resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE4NS4yMDcuMTI1LjEwMCCoZlXh1Sm1peBjoxfhUmGFB81xNvwp3QBWF6AsdDMmiBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-oradea-ipv6

dnscry.pt Oradea resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTBkOjgxNDQ6MDpmNjoyOTE1OmFmOjA6MThdIKhmVeHVKbWl4GOjF-FSYYUHzXE2_CndAFYXoCx0MyaIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ottoville-ipv4

dnscry.pt Ottoville resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwNC4yMzQuMjMxLjIzOSBVJyZb_D0SazeybnfWj5DWZ8NUgxii-zg9r-N8VNSWtBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ottoville-ipv6

dnscry.pt Ottoville resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmY5NTM6NjoyNTo6YV0gVScmW_w9Ems3sm531o-Q1mfDVIMYovs4Pa_jfFTUlrQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-paris-ipv4

DNSCry.pt Paris - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzg5LjExNy4yLjE3IMC4eSuCrbghtvVsoGHUaT3eBNQLsYxXjNdz_WsChD95GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-paris-ipv6

DNSCry.pt Paris - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyNDAyOmQwYzA6MjI6NmNkMDo0OjQ6NDo1YjgxXSDAuHkrgq24Ibb1bKBh1Gk93gTUC7GMV4zXc_1rAoQ_eRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-perth-ipv4

dnscry.pt Perth resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIwMy4yOS4yNDAuMjQ5IA7UI7_5dEF7rldqU_Pw_R_ZqCjOI5CRHcdKI8hWLfF5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-perth-ipv6

dnscry.pt Perth resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAIlsyNDA0Ojk0MDA6NDowOjIxNjozZWZmOmZlZTY6YTc2Ml0gDtQjv_l0QXuuV2pT8_D9H9moKM4jkJEdx0ojyFYt8XkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-phoenix-ipv4

dnscry.pt Phoenix resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3My4yNDkuMjA1LjE5OCC8oS3spDUHuz_Bcd1uE7Wfa0PSQ0Rpt4atEc1zB6JnRhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-phoenix-ipv6

dnscry.pt Phoenix resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNjA3OjkwMDA6NzAwOjEwMzA6OmFdILyhLeykNQe7P8Fx3W4TtZ9rQ9JDRGm3hq0RzXMHomdGGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-portedwards-ipv4

dnscry.pt Port Edwards resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3Ni4xMTEuMjE5LjEyNiDzuja5nmAyDvA5jakqkuLQEtb245xsAhNwJYDLkKraKhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portedwards-ipv6

dnscry.pt Port Edwards resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyMDAxOjQ3MDoxZjExOjJiYjo6YjIzXSDzuja5nmAyDvA5jakqkuLQEtb245xsAhNwJYDLkKraKhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portland-ipv4

dnscry.pt Portland resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwMy4xMjQuMTA2LjIzMyCN5S36eWstGFliH6xl8Mg2gyF99cqzMzgoJfAtWVYJnhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portland-ipv6

dnscry.pt Portland resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAIVsyNDAyOmQwYzA6MTY6YTFlNjowOmI4OTM6YmY3OmRkXSCN5S36eWstGFliH6xl8Mg2gyF99cqzMzgoJfAtWVYJnhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-prague-ipv4

dnscry.pt Prague resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5NS4xMjMuMjQ1LjE5ID_cR_36ozMvCvR_yzODoHfX8nlpO7p7IBsbqZU5pQIEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-prague-ipv6

dnscry.pt Prague resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDM6Ojk5OV0gP9xH_fqjMy8K9H_LM4Ogd9fyeWk7unsgGxuplTmlAgQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-redditch-ipv4

dnscry.pt Redditch resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg1LjIxOSDF35bt83M1j2hvqqgOyB1Rv_pQ0LYZCpGkTuXWt6JGlBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-redditch-ipv6

dnscry.pt Redditch resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjgzNjA6YTM6ZTo6YV0gxd-W7fNzNY9ob6qoDsgdUb_6UNC2GQqRpE7l1reiRpQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-riga-ipv4

dnscry.pt Riga resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5NS4xMjMuMjEyLjIwMCCKpSwU2DoHr1tktJRs4UIiLfoXBly8F7WmgX74sIHRyhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-riga-ipv6

dnscry.pt Riga resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyYTAyOjI3YWM6OjEyNDldIIqlLBTYOgevW2S0lGzhQiIt-hcGXLwXtaaBfviwgdHKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-saltlakecity-ipv4

dnscry.pt Salt Lake City resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMTQuMTYyLjY1IKbTxlVrc12BNolzMCksgqjW75nTqlnHp95UlrGWqm-UGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-saltlakecity-ipv6

dnscry.pt Salt Lake City resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAIVsyNDAyOmQwYzA6MTg6YzhmZjowOmI4OTM6YmY3OmRkXSCm08ZVa3NdgTaJczApLIKo1u-Z06pZx6feVJaxlqpvlBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-sandefjord-ipv4

dnscry.pt Sandefjord resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4zMi4xMDcuNDggXTsyJ8l_6LJ4TCwKbGyVeIVM1yLzf8sxL2PmKjZIMvcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sandefjord-ipv6

dnscry.pt Sandefjord resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAzOjk0ZTA6MjcxZjo6NWIxXSBdOzInyX_osnhMLApsbJV4hUzXIvN_yzEvY-YqNkgy9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-sanjose-ipv4

dnscry.pt San Jose resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xMDYuOTYuMjEwIKy8EjwvpVvM65kKWYoFFmszWMa4PjE_LRLkUiKeZHk0GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-sanjose-ipv6

dnscry.pt San Jose resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA3OmYzNTg6MWE6ZTo6OGFhMjo5MzMzXSCsvBI8L6VbzOuZClmKBRZrM1jGuD4xPy0S5FIinmR5NBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-santaclara-ipv4

dnscry.pt Santa Clara resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3Ni4xMTEuMjIzLjE2NyCmqAI-1fpR1qtHZyAx3vJJ7SpKXkdmPAnZZ5ga25JckxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-santaclara-ipv6

dnscry.pt Santa Clara resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6MzU6MTo6NTA2ZDo4Y2UyXSCmqAI-1fpR1qtHZyAx3vJJ7SpKXkdmPAnZZ5ga25JckxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-saopaulo-ipv4

dnscry.pt São Paulo resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIwNy4xODAuMy4xODkgplVKYTDMupV0eXZK_DVKmotrH4f_qz6A1HNbC2cy6u0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-saopaulo-ipv6

dnscry.pt São Paulo resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAIFsyYTBjOjlhNDA6OGY0MDowOjIwNzoxODA6MzoxODldIKZVSmEwzLqVdHl2Svw1SpqLax-H_6s-gNRzWwtnMurtGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-seattle-ipv4

dnscry.pt Seattle resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzIwOS4xODIuMjI1LjEwMyAbREpgYMxYxNqglLJnR6df63qELMlAVMwxGlsjPMMThhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seattle-ipv6

dnscry.pt Seattle resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6OTpmMDA1Ojo4NmU3XSAbREpgYMxYxNqglLJnR6df63qELMlAVMwxGlsjPMMThhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seoul02-ipv4

dnscry.pt Seoul 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE1MS4yNDUuMTA2LjE4MSBwVhEso4MPh30F1CUaDbHgxoo6R_u5SkGxPgsGUYTi4hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seoul02-ipv6

dnscry.pt Seoul 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNDA2OmVmODA6NTo0OGE5OjoxXSBwVhEso4MPh30F1CUaDbHgxoo6R_u5SkGxPgsGUYTi4hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-singapore-ipv4

dnscry.pt Singapore resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE1Ny4yMC4xMDUuMTE1IF-A7YB2q_Cn7QZ946XHFuDvAUNlRXLcIcLv6zH5glrGGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-singapore-ipv6

dnscry.pt Singapore resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMzpmOjphXSBfgO2Adqvwp-0GfeOlxxbg7wFDZUVy3CHC7-sx-YJaxhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-singapore02-ipv4

dnscry.pt Singapore 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xNzkuNDQuNzMgICxK5c5XamgK_BNMTtSKyEnZM4D44NPAIHddngTPbGUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-singapore02-ipv6

dnscry.pt Singapore 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjQ1MjA6MTEyMjo6YV0gICxK5c5XamgK_BNMTtSKyEnZM4D44NPAIHddngTPbGUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sofia-ipv4

dnscry.pt Sofia resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzc5LjEyNC43LjQzIGjOJralcFGh38dFov6MP6OkkaSPIlSCbku5I7J2NZUfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-sofia-ipv6

dnscry.pt Sofia resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTAxOjg3NDA6MTo4NjM6OjNiOGNdIGjOJralcFGh38dFov6MP6OkkaSPIlSCbku5I7J2NZUfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-spokane-ipv4

dnscry.pt Spokane resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwNC4zNi44Ni4xODEg_ifyAp41KOphKBVIwROBjWV91n9fuUzlzUqXCIklST0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-spokane-ipv6

dnscry.pt Spokane resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjA2OmE4YzA6MzoyMDI6OmFdIP4n8gKeNSjqYSgVSMETgY1lfdZ_X7lM5c1KlwiJJUk9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-stockholm-ipv4

dnscry.pt Stockholm resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE5NS43Mi42MC42NiAqThz9JMW562Y5eX01kif1fVYVwbkzJh7rexM9MiNAXRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-stockholm-ipv6

dnscry.pt Stockholm resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTA3OmUwNDM6MTo1ZDo6MV0gKk4c_STFuetmOXl9NZIn9X1WFcG5MyYe63sTPTIjQF0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-stockholm02-ipv4

dnscry.pt Stockholm 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE4NS4yMzEuMTAwLjEwNiCzmNivOsptNftnJUN65dxCnu6v2Bw_IJra5tw5OPKDlxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-stockholm02-ipv6

dnscry.pt Stockholm 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAKFsyYTBjOjU3MDA6MzEzMzo2NTA6OTZkNTo5OWZmOmZlOGI6NzRmNF0gs5jYrzrKbTX7ZyVDeuXcQp7ur9gcPyCa2ubcOTjyg5cZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sydney02-ipv4

dnscry.pt Sydney 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NS4xMTQuMTQuNzQgfD7v3z2SLbLGuO4Wo8-HYVxwRz44PitWMFgp81gvSjUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sydney02-ipv6

dnscry.pt Sydney 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNDAyOjczNDA6NTAwMDo2MjAwOjphXSB8Pu_fPZItssa47hajz4dhXHBHPjg-K1YwWCnzWC9KNRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-taipeh-ipv4

dnscry.pt Taipeh resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwMy4xMzEuMTg5LjE5MSAl1jOdIay4Ch7r2CgrehwgnU1olQWj8A7t2WAMmoGbMxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-taipeh-ipv6

dnscry.pt Taipeh resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyNDAzOmNmYzA6MTAwNDo6YjViOjQ3ZmZdICXWM50hrLgKHuvYKCt6HCCdTWiVBaPwDu3ZYAyagZszGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-tallinn-ipv4

dnscry.pt Tallinn resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4NS4xOTQuNTMuMjIgr0WageGep9cjA5yYpY30Z6EsTYHZnSlV-PCfvZssTNcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tallinn-ipv6

dnscry.pt Tallinn resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyYTA0OjZmMDA6NDo6MTdhXSCvRZqB4Z6n1yMDnJiljfRnoSxNgdmdKVX48J-9myxM1xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tampa-ipv4

dnscry.pt Tampa resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2NS4xNDAuMTE3LjI0OCBfK4fFWjW65PRF3_42MZM1Ly9t0ZLHdDA_0uy63rk0zBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tampa-ipv6

dnscry.pt Tampa resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyNjAyOmZjYzA6MjIyMjo5ZDJlOjo1M10gXyuHxVo1uuT0Rd_-NjGTNS8vbdGSx3QwP9Lsut65NMwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-taos-ipv4

dnscry.pt Taos resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjYzLjEzMy4yMjMuMTM4IIggy47qNTs0s0PnLuDK5UcpSJt_t7XVmTr0tWn1QlqNGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-taos-ipv6

dnscry.pt Taos resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6NTM6MTo6ODQ2YTpiZDc5XSCIIMuO6jU7NLND5y7gyuVHKUibf7e11Zk69LVp9UJajRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tbilisi-ipv4

dnscry.pt Tbilisi resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5NC4xMzUuMTE5LjE1OCDyc4Y3cWcjNurZ3aEWt1p-gc0TsZr8cUxFjtCnfn37vBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tbilisi-ipv6

dnscry.pt Tbilisi resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTEyOmUzNDA6MzAwOjoxNzY4OmE5NWZdIPJzhjdxZyM26tndoRa3Wn6BzROxmvxxTEWO0Kd-ffu8GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-thessaloniki-ipv4

dnscry.pt Thessaloniki resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzg1LjkwLjE5Ny43IB6Oc_XPh4AEeGLWqykjAhmnE6HZ7kGkX4mduwATCk-9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-thessaloniki-ipv6

dnscry.pt Thessaloniki resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTEyOjZmYzM6ODAwMDo6MTldIB6Oc_XPh4AEeGLWqykjAhmnE6HZ7kGkX4mduwATCk-9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-timisoara-ipv4

dnscry.pt Timișoara resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjEzNC40OC4yNSDMuhfc1PfFxgp4ZbNQKp6bPc46GjmBvoitb_MrP20o9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-timisoara-ipv6

dnscry.pt Timișoara resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyYTBjOjlmMDA6MjpkOTI4OjZmMGE6YjRlMjo6XSDMuhfc1PfFxgp4ZbNQKp6bPc46GjmBvoitb_MrP20o9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tirana-ipv4

dnscry.pt Tirana resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4NS43NS4yNDMuODAgHCajtEAcNP8fNSrJTpYm19z1aig0HfXVylKkdVDxQk4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tirana-ipv6

dnscry.pt Tirana resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTEzOjk0MDM6OjdhNmE6NTMwNjoxZTM1OjFdIBwmo7RAHDT_HzUqyU6WJtfc9WooNB311cpSpHVQ8UJOGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-tokyo-ipv4

dnscry.pt Tokyo resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg2LjEyMyBDK5aRHZnKfdd6Q9ufEJY83WAQ9X5z7OAQa5CeptBCYBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo-ipv6

dnscry.pt Tokyo resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMjpkOjphXSBDK5aRHZnKfdd6Q9ufEJY83WAQ9X5z7OAQa5CeptBCYBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo02-ipv4

dnscry.pt Tokyo 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDEwMy4xNzkuNDUuNiDfai5sp1im-BPHwbM1GCnTqn20FIbQfuvvybKsGf0pjhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo02-ipv6

dnscry.pt Tokyo 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjQ1MjA6MzAxZTo6YV0g32oubKdYpvgTx8GzNRgp06p9tBSG0H7r78myrBn9KY4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-toronto-ipv4

dnscry.pt Toronto resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE3Mi45My4xNjcuMjE0IKm0Ncdvi-mr_zZSF_DC1GyI11gxqnT2FOSCqJr06wZrGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-toronto-ipv6

dnscry.pt Toronto resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA2OjYwODA6MjAwMToxMDk5OjphXSCptDXHb4vpq_82UhfwwtRsiNdYMap09hTkgqia9OsGaxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-toronto02-ipv4

dnscry.pt Toronto 02 resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xNDQuMTc3LjU3IJwdTj8y2VV_9iktRICq-3zzk_tPsQFh-8H_f3MHqAYnGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-toronto02-ipv6

dnscry.pt Toronto 02 resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZlZDI6ZmEwOjRhOjoxXSCcHU4_MtlVf_YpLUSAqvt885P7T7EBYfvB_39zB6gGJxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tuusula-ipv4

dnscry.pt Tuusula resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTY1LjIxLjI1Mi4yMDEgIhe-u4w5oFAMptmgzUFqc-mgyjjRlnH70fwVqSiHJfkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tuusula-ipv6

dnscry.pt Tuusula resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTAxOjRmOTpjMDExOmI4NGU6OjFdICIXvruMOaBQDKbZoM1BanPpoMo40ZZx-9H8FakohyX5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-valdivia-ipv4

dnscry.pt Valdivia resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIxNi43My4xNTkuMjYgnpr1thxYT4SkWK38OEbiPOQa3NSVayBN7f8BkMVREC8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-valdivia-ipv6

dnscry.pt Valdivia resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OmEwMDY6ZDFkMTo6MTE2XSCemvW2HFhPhKRYrfw4RuI85Brc1JVrIE3t_wGQxVEQLxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vancouver-ipv4

dnscry.pt Vancouver resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE1NC44MS45MiAGyG9Uh1Ra0QN3Ge2n_OYHW8h263tF9bF2GwyXRAaC7xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vancouver-ipv6

dnscry.pt Vancouver resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZlZDI6ZmIwOjZkOjoxXSAGyG9Uh1Ra0QN3Ge2n_OYHW8h263tF9bF2GwyXRAaC7xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vienna-ipv4

dnscry.pt Vienna resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgzLjEzOC41NS4xODYg3kyI1rUYwQymzbrF1c5fYhw1rWmOTm8L6i1aISwm6y4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-vienna-ipv6

dnscry.pt Vienna resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTBkOmYzMDI6MTEwOjY1MTc6OjFdIN5MiNa1GMEMps26xdXOX2IcNa1pjk5vC-otWiEsJusuGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-vientiane-ipv4

dnscry.pt Vientiane resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwMy4yMjguMTAxLjE3OCDsBgKLhj_vw4R4VLAYAe0lINIZEMImGhQboH6ssbjp4xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vientiane-ipv6

dnscry.pt Vientiane resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyNDAwOjgxYzA6ZGMwMTo4NTo6Ml0g7AYCi4Y_78OEeFSwGAHtJSDSGRDCJhoUG6B-rLG46eMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-vilnius-ipv4

dnscry.pt Vilnius resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE2Mi4yNTQuODYuMTMg4nDDbNqRwkkkZWTJ5c82d1sbs0NeQCbn-aFldCI2mn4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-vilnius-ipv6

dnscry.pt Vilnius resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTEzOjk0MDE6MDoxOjozZDU4OjFdIOJww2zakcJJJGVkyeXPNndbG7NDXkAm5_mhZXQiNpp-GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-warsaw-ipv4

dnscry.pt Warsaw resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NS4zLjIyMS4xNjIg9OBpbJKxZJGY-YUI3xWNXp-k_MgEzf9NFZruBsmXR7oZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-warsaw-ipv6

dnscry.pt Warsaw resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyYTAzOmNmYzA6ODAwMDoyNjo6YzMwMzpkZGEyXSD04GlskrFkkZj5hQjfFY1en6T8yATN_00Vmu4GyZdHuhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-zurich-ipv4

dnscry.pt Zürich resolver.
IPv4 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAACzk0LjI2LjM1LjU3IJbocwoaxDfkvzxom8VH94Wu_45-fdzt-FlN9QhGtumPGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-zurich-ipv6

dnscry.pt Zürich resolver.
IPv6 endpoint. Operated by dnscry.pt. No query logs, no intentional filtering, blocking, redirecting or rewriting, DNSSEC validation.
All dnscry.pt resolvers can also be used as Anonymized DNSCrypt relays.
https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAyOjI5Yjg6ODAwMTo0OjphXSCW6HMKGsQ35L88aJvFR_eFrv-Ofn3c7fhZTfUIRrbpjxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscrypt.ca-ipv4

dnscrypt.ca Canadian resolver.
Unfiltered, DNSSEC-validating and no logs. https://dnscrypt.ca/
Maintained by dnscrypt.ca. Service page: https://dnscrypt.ca/

sdns://AQcAAAAAAAAAEzE4NS4xMTEuMTg4LjQ2Ojg0NDMgC-tbTwd-08e_JtBJmgsvjAG9i10itE-LBNCwjTflezQiMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeXB0LmNhLTEtaXB2NA


## dnscrypt.ca-ipv4-doh

dnscrypt.ca Canadian resolver.
Unfiltered, DNSSEC-validating and no logs. https://dnscrypt.ca/
Maintained by dnscrypt.ca. Service page: https://dnscrypt.ca/

sdns://AgcAAAAAAAAADjE4NS4xMTEuMTg4LjQ2IDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuEGRuczEuZG5zY3J5cHQuY2EKL2Rucy1xdWVyeQ


## dnsforfamily

DNS for Family safe-search resolver.
Blocks adult, gambling, drug, malware, scam/phishing, proxy/anonymizer and advertising domains; its blacklist is updated daily. Enforces safe search in Google, YouTube, Brave, Ecosia, Bing, DuckDuckGo and Yandex. Social sites such as Facebook and Instagram are not blocked. No DNS queries are logged. Free service.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAADjk0LjEzMC4xODAuMjI1ILtn1Ada3rLi6VNcj4pB-I5eHBqFzFbs_XFRHG-6KenTEGRuc2ZvcmZhbWlseS5jb20
sdns://AQMAAAAAAAAADDc4LjQ3LjY0LjE2MSATJeLOABXNSYcSJIoqR5_iUYz87Y4OecMLB84aEAKPrRBkbnNmb3JmYW1pbHkuY29t


## dnsforfamily-doh

DNS for Family safe-search resolver.
Blocks adult, gambling, drug, malware, scam/phishing, proxy/anonymizer and advertising domains; its blacklist is updated daily. Enforces safe search in Google, YouTube, Brave, Ecosia, Bing, DuckDuckGo and Yandex. Social sites such as Facebook and Instagram are not blocked. No DNS queries are logged. Free service.

Provided by: https://dnsforfamily.com

sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLhhkbnMtZG9oLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ


## dnsforfamily-doh-no-safe-search

DNS for Family no-safe-search resolver.
Blocks adult, gambling, drug, malware, scam/phishing, proxy/anonymizer and advertising domains; its blacklist is updated daily. Unlike the default DNS for Family resolvers, this variant does not enforce safe search in Google, YouTube, Brave, Ecosia, Bing, DuckDuckGo or Yandex. Social sites such as Facebook and Instagram are not blocked. No DNS queries are logged. Free service.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLidkbnMtZG9oLW5vLXNhZmUtc2VhcmNoLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ


## dnsforfamily-no-safe-search

DNS for Family no-safe-search resolver.
Blocks adult, gambling, drug, malware, scam/phishing, proxy/anonymizer and advertising domains; its blacklist is updated daily. Unlike the default DNS for Family resolvers, this variant does not enforce safe search in Google, YouTube, Brave, Ecosia, Bing, DuckDuckGo or Yandex. Social sites such as Facebook and Instagram are not blocked. No DNS queries are logged. Free service.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAADzEzNS4xODEuMTkzLjIyMiDrxcZ_hFtGE6tfATvQZYjxgl5pTY_e2cRH_ms8bEWofBBkbnNmb3JmYW1pbHkuY29t


## dnsforfamily-v6

DNS for Family safe-search resolver.
IPv6 endpoint. Blocks adult, gambling, drug, malware, scam/phishing, proxy/anonymizer and advertising domains; its blacklist is updated daily. Enforces safe search in Google, YouTube, Brave, Ecosia, Bing, DuckDuckGo and Yandex. Social sites such as Facebook and Instagram are not blocked. No DNS queries are logged. Free service.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAAF1syYTAxOjRmODoxYzE3OjRkZjg6OjFdIBMl4s4AFc1JhxIkiipHn-JRjPztjg55wwsHzhoQAo-tEGRuc2ZvcmZhbWlseS5jb20


## dnsforge.de

DNSforge ad-blocking resolver.
Public resolver in Germany, running Pi-hole for ad blocking. Non-logging, supports DNSSEC. https://dnsforge.de
Maintained by DNSforge. Service page: https://dnsforge.de/

sdns://AgMAAAAAAAAADDE3Ni45LjkzLjE5OCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAACzE3Ni45LjEuMTE3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50C2Ruc2ZvcmdlLmRlCi9kbnMtcXVlcnk


## dnsforge.de-ipv6

DNSforge ad-blocking resolver.
IPv6 endpoint. Public resolver in Germany, running Pi-hole for ad blocking. Non-logging, supports DNSSEC. https://dnsforge.de
Maintained by DNSforge. Service page: https://dnsforge.de/

sdns://AgMAAAAAAAAAGFsyYTAxOjRmODoxNTE6MzRhYTo6MTk4XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAGFsyYTAxOjRmODoxNDE6MzE2ZDo6MTE3XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5


## dnsforge.de-nofilter

DNSforge non-filtering resolver.
Public resolver in Germany. Non-logging, supports DNSSEC. https://dnsforge.de
Maintained by DNSforge. Service page: https://dnsforge.de/

sdns://AgcAAAAAAAAADzEzOC4xOTkuMTQ5LjI0OSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADDc4LjQ3LjcxLjE5NCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5


## dnsforge.de-nofilter-ipv6

DNSforge non-filtering resolver.
IPv6 endpoint. Public resolver in Germany. Non-logging, supports DNSSEC. https://dnsforge.de
Maintained by DNSforge. Service page: https://dnsforge.de/

sdns://AgcAAAAAAAAAGFsyYTAxOjRmODpjMTc6N2FhNTo6MjQ5XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAGVsyYTAxOjRmODpjMDEzOmFhZTk6OjE5NF0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQRYmxhbmsuZG5zZm9yZ2UuZGUKL2Rucy1xdWVyeQ


## dnshome-de

dnsHome.de public resolver in Germany.
No logging, no filtering, supports DNSSEC. Maintained by dnsHome.de.
Homepage: https://dnshome.de/

sdns://AgcAAAAAAAAAACAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLg5kbnMuZG5zaG9tZS5kZQovZG5zLXF1ZXJ5


## dnslow.me

dnslow.me privacy-first filtering resolver.
Open-source project with advertising and threat blocking. More info on the homepage (https://dnslow.me) and GitHub (https://github.com/PeterDaveHello/dnslow.me)

sdns://AgAAAAAAAAAAACCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAlkbnNsb3cubWUKL2Rucy1xdWVyeQ


## dnspod

DNSPod Public DNS resolver.
Available through servers in multiple locations.
Operated by Tencent Cloud DNSPod for users in China. Overseas access to the free Public DNS service may be unreliable.
Homepage: https://dnspod.cn

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAADDEyMC41My41My41MwAMMTIwLjUzLjUzLjUzCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAACjEuMTIuMTIuMTIACjEuMTIuMTIuMTIKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAACjEuMTIuMzQuNTYACjEuMTIuMTIuMTIKL2Rucy1xdWVyeQ


## doh-cleanbrowsing-adult

CleanBrowsing Adult Filter.
Available through servers in multiple locations around the world.
Blocks adult, pornographic and explicit sites. Allows proxy and VPN domains and mixed-content sites. Google and Bing are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnEi9kb2gvYWR1bHQtZmlsdGVyLw


## doh-cleanbrowsing-family

CleanBrowsing Family Filter.
Available through servers in multiple locations around the world.
Blocks adult and explicit sites, proxy and VPN bypass domains, and mixed-content sites. Google, Bing and YouTube are set to Safe Mode.

Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnEy9kb2gvZmFtaWx5LWZpbHRlci8


## doh-cleanbrowsing-security

CleanBrowsing Security Filter.
Available through servers in multiple locations around the world.
Blocks phishing, malware and malicious domains. Does not block adult content.
Operated by CleanBrowsing. Service page: https://cleanbrowsing.org/filters/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnFS9kb2gvc2VjdXJpdHktZmlsdGVyLw


## doh-crypto-sx

crypto.sx public resolver.
Available through servers in multiple locations around the world.
Maintained by Frank Denis. Cached via Cloudflare. No logs, no censorship, DNSSEC. https://crypto.sx

sdns://AgcAAAAAAAAACzEwNC4yMS42Ljc4AA1kb2guY3J5cHRvLnN4Ci9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADjE3Mi42Ny4xMzQuMTU3AA1kb2guY3J5cHRvLnN4Ci9kbnMtcXVlcnk


## doh-crypto-sx-ipv6

crypto.sx public resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Maintained by Frank Denis. Cached via Cloudflare. No logs, no censorship, DNSSEC. https://crypto.sx

sdns://AgcAAAAAAAAAGlsyNjA2OjQ3MDA6MzAzNzo6NjgxNTo2NGVdABJkb2gtaXB2Ni5jcnlwdG8uc3gKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAG1syNjA2OjQ3MDA6MzAzNjo6YWM0Mzo4NjlkXQASZG9oLWlwdjYuY3J5cHRvLnN4Ci9kbnMtcXVlcnk


## doh.appliedprivacy.net

Applied Privacy public resolver.
Operated by the Foundation for Applied Privacy (https://appliedprivacy.net).
Hosted in Vienna, Austria.

Non-logging, non-filtering, supports DNSSEC.

sdns://AgcAAAAAAAAAACCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBZkb2guYXBwbGllZHByaXZhY3kubmV0Bi9xdWVyeQ


## doh.ffmuc.net

Freifunk Munich open resolver.
Operated by Freifunk Munich with nodes in Germany. Non-logging, non-filtering, non-censoring.
https://ffmuc.net/

sdns://AgcAAAAAAAAACjUuMS42Ni4yNTUgMu27Ecwlj74zws0koUknDwvm9Eb1cmSzvRwluYUzJy4NZG9oLmZmbXVjLm5ldAovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADjE4NS4xNTAuOTkuMjU1IDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuDWRvaC5mZm11Yy5uZXQKL2Rucy1xdWVyeQ


## doh.ffmuc.net-v6

Freifunk Munich open resolver.
IPv6 endpoint. Operated by Freifunk Munich with nodes in Germany. Non-logging, non-filtering, non-censoring.
https://ffmuc.net/

sdns://AgcAAAAAAAAAFVsyMDAxOjY3ODplNjg6ZjAwMDo6XSAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLg1kb2guZmZtdWMubmV0Ci9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFVsyMDAxOjY3ODplZDA6ZjAwMDo6XSAy7bsRzCWPvjPCzSShSScPC-b0RvVyZLO9HCW5hTMnLg1kb2guZmZtdWMubmV0Ci9kbnMtcXVlcnk


## doh.ibksturm

ibksturm OpenNIC resolver in Switzerland.
No logs, DNSSEC. OpenNIC-based resolver operated by ibksturm.

sdns://AgcAAAAAAAAAAAAUaWJrc3R1cm0uc3lub2xvZ3kubWUKL2Rucy1xdWVyeQ


## doh.tiar.app

Tiarap Singapore filtering resolver.
Operated by id-gmail. No logging, blocks ads, trackers and malware, supports DNSSEC. https://doh.tiar.app

sdns://AQMAAAAAAAAAEzE3NC4xMzguMjkuMTc1OjE0NDMgAwQlHXHuBS3jFzDIgtQkjjhnDVSRDp1KT5rvzJC7Ne8YMi5kbnNjcnlwdC1jZXJ0LnRpYXIuYXBw


## doh.tiar.app-doh

Tiarap Singapore filtering resolver.
Operated by id-gmail. No logging, blocks ads, trackers and malware, supports DNSSEC. https://doh.tiar.app

sdns://AgMAAAAAAAAADjE3NC4xMzguMjkuMTc1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50DGRvaC50aWFyLmFwcAovZG5zLXF1ZXJ5


## doh.tiarap.org

Tiarap Cloudflare-cached filtering resolver.
Available through servers in multiple locations around the world.
Operated by id-gmail. No logging, blocks ads, trackers and malware, no EDNS Client Subnet, supports DNSSEC. https://doh.tiarap.org

sdns://AgMAAAAAAAAADDEwNC4yMS42NS42MAAOZG9oLnRpYXJhcC5vcmcKL2Rucy1xdWVyeQ


## doh.tiarap.org-ipv6

Tiarap Cloudflare-cached filtering resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Operated by id-gmail. No logging, blocks ads, trackers and malware, no EDNS Client Subnet, supports DNSSEC. https://doh.tiarap.org

sdns://AgMAAAAAAAAAG1syNjA2OjQ3MDA6MzAzNDo6NjgxNTo0MTNjXQAOZG9oLnRpYXJhcC5vcmcKL2Rucy1xdWVyeQ


## dorriere-fr

Nicolas Derriere recursive-to-root resolver.
Hosted in France. DNSSEC, no logs, no filters.
Homepage: https://nicolas-dorriere.fr/blog/it-was-dns.html

sdns://AQcAAAAAAAAAETkwLjQ2LjIwNi4yNDg6NDQzIBliqCXeEXeous1YRa1T3AIXMpYmK-Cz4yaK62AyQiOcRzIuZG5zY3J5cHQtY2VydC5kbnNjcnlwdC1yZWN1cnNpdmUtdG8tcm9vdC11ZHAtb25seS5uaWNvbGFzLWRvcnJpZXJlLmZy


## dremaxx

Dremaxx Open resolver. Non-filtering, no logs, DNSSEC validation. Recursive.
Available through servers in Zurich, Dusseldorf and Houston.
Resolves on its own (not a frontend to another public resolver). IPv4 endpoint.
Operated by Yannick Dreher. Homepage: https://dremaxx.de/en/dns-resolvers

sdns://AgcAAAAAAAAADTE4NS40NC44Mi4xNTggjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQUb3Blbi5kbnMuZHJlbWF4eC5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADTE5NC4yOC45OS4yNDggjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQUb3Blbi5kbnMuZHJlbWF4eC5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjE4NS4xMjEuMTY5LjQ3IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50FG9wZW4uZG5zLmRyZW1heHguY29tCi9kbnMtcXVlcnk


## dremaxx-family

Dremaxx Family resolver. Blocks adult content, no logs, DNSSEC validation. Recursive.
Available through servers in Zurich, Dusseldorf and Houston.
Blocks about 489,000 adult domains (OISD NSFW list, refreshed hourly); no ad, tracker or malware filtering. IPv4 endpoint.
Blocked names are rewritten, so clients validating DNSSEC themselves get SERVFAIL for blocked signed domains.
Operated by Yannick Dreher. Homepage: https://dremaxx.de/en/dns-resolvers

sdns://AgMAAAAAAAAADTE4NS40NC44Mi4xNTAgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQWZmFtaWx5LmRucy5kcmVtYXh4LmNvbQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAACjYyLjMuNTAuNDIgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQWZmFtaWx5LmRucy5kcmVtYXh4LmNvbQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAADjE4NS4xMjEuMTY5LjQ1IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50FmZhbWlseS5kbnMuZHJlbWF4eC5jb20KL2Rucy1xdWVyeQ


## dremaxx-family-ipv6

Dremaxx Family resolver. Blocks adult content, no logs, DNSSEC validation. Recursive.
Available through servers in Zurich, Dusseldorf and Houston.
IPv6 endpoint (AS218835). Blocks about 489,000 adult domains (OISD NSFW list, refreshed hourly); no ad, tracker or malware filtering.
Blocked names are rewritten, so clients validating DNSSEC themselves get SERVFAIL for blocked signed domains.
Operated by Yannick Dreher. Homepage: https://dremaxx.de/en/dns-resolvers

sdns://AgMAAAAAAAAAFVsyYTBjOjlhNDA6ZTEwMDo6ZjUzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBZmYW1pbHkuZG5zLmRyZW1heHguY29tCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAFVsyYTBjOjlhNDA6ZTEwMTo6ZjUzXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBZmYW1pbHkuZG5zLmRyZW1heHguY29tCi9kbnMtcXVlcnk


## dremaxx-ipv6

Dremaxx Open resolver. Non-filtering, no logs, DNSSEC validation. Recursive.
Available through servers in Zurich, Dusseldorf and Houston.
IPv6 endpoint (AS218835). Resolves on its own (not a frontend to another public resolver).
Operated by Yannick Dreher. Homepage: https://dremaxx.de/en/dns-resolvers

sdns://AgcAAAAAAAAAFFsyYTBjOjlhNDA6ZTEwMDo6NTNdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50FG9wZW4uZG5zLmRyZW1heHguY29tCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFFsyYTBjOjlhNDA6ZTEwMTo6NTNdIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50FG9wZW4uZG5zLmRyZW1heHguY29tCi9kbnMtcXVlcnk


## ekinao-doh-ipv4

Operated by https://www.ekinao.com
No logging, no filtering, DNSSEC validation enabled, no EDNS.
Service page: https://www.ekinao.com/publicdns.html

sdns://AgcAAAAAAAAADTE2NC43MC4xMTQuNTEgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQOZG5zLmVraW5hby5jb20KL2Rucy1xdWVyeQ


## ekinao-doh-ipv6

Operated by https://www.ekinao.com
No logging, no filtering, DNSSEC validation enabled, no EDNS.
Service page: https://www.ekinao.com/publicdns.html

sdns://AgcAAAAAAAAAH1syMDAxOjJjMDoxMDA6NDA5OjE0OmNhZmU6ZDk6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQOZG5zLmVraW5hby5jb20KL2Rucy1xdWVyeQ


## fdn

FDN public resolver.
Operated in France by FDN, the French Data Network non-profit ISP. https://www.fdn.fr/

sdns://AgcAAAAAAAAADDgwLjY3LjE2OS40MCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdApuczEuZmRuLmZyCi9kbnMtcXVlcnk


## fdn-ipv6

FDN public resolver.
IPv6 endpoint. Operated in France by FDN, the French Data Network non-profit ISP. https://www.fdn.fr/

sdns://AgcAAAAAAAAAElsyMDAxOjkxMDo4MDA6OjEyXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdApuczAuZmRuLmZyCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAElsyMDAxOjkxMDo4MDA6OjQwXSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdApuczEuZmRuLmZyCi9kbnMtcXVlcnk


## google

Google Public DNS resolver.
Available through servers in multiple locations around the world.
Service operated by Google.
Operated by Google Public DNS. Service page: https://developers.google.com/speed/public-dns

sdns://AgUAAAAAAAAABzguOC44LjggalBisNF41VbxY7E7Gw8ZQ10CWIKRzHVYnf7m6xHI1cMHOC44LjguOAovZG5zLXF1ZXJ5
sdns://AgUAAAAAAAAABzguOC40LjQgalBisNF41VbxY7E7Gw8ZQ10CWIKRzHVYnf7m6xHI1cMHOC44LjQuNAovZG5zLXF1ZXJ5


## google-ipv6

Google Public DNS resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. Service operated by Google.
Operated by Google Public DNS. Service page: https://developers.google.com/speed/public-dns

sdns://AgUAAAAAAAAAFlsyMDAxOjQ4NjA6NDg2MDo6ODg4OF0galBisNF41VbxY7E7Gw8ZQ10CWIKRzHVYnf7m6xHI1cMaWzIwMDE6NDg2MDo0ODYwOjo4ODg4XTo0NDMKL2Rucy1xdWVyeQ
sdns://AgUAAAAAAAAAFlsyMDAxOjQ4NjA6NDg2MDo6ODg0NF0galBisNF41VbxY7E7Gw8ZQ10CWIKRzHVYnf7m6xHI1cMaWzIwMDE6NDg2MDo0ODYwOjo4ODQ0XTo0NDMKL2Rucy1xdWVyeQ


## he

Hurricane Electric public resolver.
Available through servers in multiple locations.
Service operated by Hurricane Electric. Unknown logging policy. https://he.net/

sdns://AgUAAAAAAAAACzc0LjgyLjQyLjQyIDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuDG9yZG5zLmhlLm5ldAovZG5zLXF1ZXJ5


## ibksturm

ibksturm OpenNIC resolver in Switzerland.
No logs, DNSSEC. OpenNIC-based resolver operated by ibksturm.

sdns://AQcAAAAAAAAAEzIxMy4xOTYuMTkxLjk2Ojg0NDMgHJ1Xm4-iOYHncRNo6suy63ko3F1S-OCNwCd3GGQWb64YMi5kbnNjcnlwdC1jZXJ0Lmlia3N0dXJt


## iij

Internet Initiative Japan public resolver.
Operated by Internet Initiative Japan in Tokyo. Blocks child pornography. https://www.iij.ad.jp/

sdns://AgEAAAAAAAAACjEwMy4yLjU3LjUgjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQRcHVibGljLmRucy5paWouanAKL2Rucy1xdWVyeQ


## ksol.io-ns2-dnscrypt-ipv4

ksol.io ns2 resolver in Hungary.
No logging, no filtering, DNSSEC enforced, no EDNS Client Subnet, padding enabled. Uses the `dnscrypt-server-docker` default unbound configuration.

sdns://AQcAAAAAAAAADjE5My4yMDEuMTg4LjQ4IBERKdQJgLSjqCSK99e2f_WRTQzEq9__DeXlQFvxxhZ6GzIuZG5zY3J5cHQtY2VydC5uczIua3NvbC5pbw


## ksol.io-ns2-dnscrypt-ipv6

ksol.io ns2 resolver in Hungary.
IPv6 endpoint. No logging, no filtering, DNSSEC enforced, no EDNS Client Subnet, padding enabled. Uses the `dnscrypt-server-docker` default unbound configuration.

sdns://AQcAAAAAAAAAFFsyYTAxOjZlZTA6MTo6MjQxOjFdIBERKdQJgLSjqCSK99e2f_WRTQzEq9__DeXlQFvxxhZ6GzIuZG5zY3J5cHQtY2VydC5uczIua3NvbC5pbw


## la-contre-voie

La Contre-Voie non-filtering public resolver.
Located in Falkenstein, Germany. DNSSEC validation. Keeps connection logs for 14 days.
Does not keep DNS query contents.
Operated by La Contre-Voie. Service page: https://lacontrevoie.fr/services/doh/

sdns://AgUAAAAAAAAADDE3OC4xMDUuMTYuNiCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBNkb2gubGFjb250cmV2b2llLmZyCi9kbnMtcXVlcnk


## libredns

LibreDNS public resolver in Germany.
No logging, but no DNS padding and no DNSSEC support. https://libredns.gr/
Operated by LibreOps. Service page: https://libredns.gr/

sdns://AgIAAAAAAAAADjExNi4yMDIuMTc2LjI2IDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuD2RvaC5saWJyZWRucy5ncgovZG5zLXF1ZXJ5


## libredns-noads

LibreDNS ad-blocking resolver in Germany.
No logging, but no DNS padding and no DNSSEC support. Uses StevenBlack's hosts list: https://github.com/StevenBlack/hosts
Operated by LibreOps. Service page: https://libredns.gr/

sdns://AgIAAAAAAAAADjExNi4yMDIuMTc2LjI2IDLtuxHMJY--M8LNJKFJJw8L5vRG9XJks70cJbmFMycuD2RvaC5saWJyZWRucy5ncgYvbm9hZHM


## mullvad-adblock-doh

Mullvad Ads & Trackers resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable. Blocks ads and trackers.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi4zABdhZGJsb2NrLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-adblock-doh-ipv6

Mullvad Ads & Trackers resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable. Blocks ads and trackers.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAADlsyYTA3OmUzNDA6OjNdABdhZGJsb2NrLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-all-doh

Mullvad all-filter resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable. Blocks ads, trackers, malware, adult content, gambling and social media.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi45ABNhbGwuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## mullvad-all-doh-ipv6

Mullvad all-filter resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable. Blocks ads, trackers, malware, adult content, gambling and social media.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAADlsyYTA3OmUzNDA6OjldABNhbGwuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## mullvad-base-doh

Mullvad base filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable. Blocks ads, trackers and malware.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi40ABRiYXNlLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-base-doh-ipv6

Mullvad base filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable. Blocks ads, trackers and malware.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAADlsyYTA3OmUzNDA6OjRdABRiYXNlLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-doh

Mullvad non-filtering public resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgcAAAAAAAAACzE5NC4yNDIuMi4yAA9kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-doh-ipv6

Mullvad non-filtering public resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgcAAAAAAAAADlsyYTA3OmUzNDA6OjJdAA9kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-extend-doh

Mullvad extended filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable. Blocks ads, trackers, malware and social media.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi41ABhleHRlbmRlZC5kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-extend-doh-ipv6

Mullvad extended filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable. Blocks ads, trackers, malware and social media.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAADlsyYTA3OmUzNDA6OjVdABhleHRlbmRlZC5kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-family-doh

Mullvad family filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
No logging, DNSSEC-capable. Blocks ads, trackers, malware, adult content and gambling.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi42ABZmYW1pbHkuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## mullvad-family-doh-ipv6

Mullvad family filtering resolver. - Deprecated, will be shot down on 11/02/2026
Available through servers in multiple locations around the world.
IPv6 endpoint. No logging, DNSSEC-capable. Blocks ads, trackers, malware, adult content and gambling.
Operated by Mullvad. Service page: https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgMAAAAAAAAADlsyYTA3OmUzNDA6OjZdABZmYW1pbHkuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## nextdns

NextDNS non-filtering private DNS resolver.
Available through servers in multiple locations around the world.
Cloud-based service that gives users control over what is allowed and blocked. DNSSEC, non-logging, no filters.

Operated by NextDNS. Service page: https://www.nextdns.io/

sdns://AgcAAAAAAAAACjQ1LjkwLjMwLjAgmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikWYW55Y2FzdC5kbnMubmV4dGRucy5pbwovZG5zLXF1ZXJ5


## nextdns-ipv6

NextDNS non-filtering private DNS resolver.
Available through servers in multiple locations around the world.
IPv6 endpoint. DNSSEC, non-logging, no filters.

Operated by NextDNS. Service page: https://www.nextdns.io/

sdns://AgcAAAAAAAAADVsyYTA3OmE4YzA6Ol0gmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikWYW55Y2FzdC5kbnMubmV4dGRucy5pbwovZG5zLXF1ZXJ5


## nextdns-ultralow

NextDNS ultralow-latency resolver.
Available through servers in multiple locations around the world.
Cloud-based service that gives users control over what is allowed and blocked. DNSSEC, non-logging, no filters.

Operated by NextDNS. Service page: https://www.nextdns.io/
The "-ultralow" variant uses bootstrap servers to select a server location.

sdns://AgcAAAAAAAAAACCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KQ5kbnMubmV4dGRucy5pbw8vZG5zY3J5cHQtcHJveHk


## nic.cz

CZ.NIC open resolver.
DNSSEC-validating, no logging, no filtering. https://nic.cz
Operated by CZ.NIC. Service page: https://www.nic.cz/odvr/

sdns://AgcAAAAAAAAADDE4NS40My4xMzUuMSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAtvZHZyLm5pYy5jegovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAACzE5My4xNy40Ny4xIIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50C29kdnIubmljLmN6Ci9kbnMtcXVlcnk


## nic.cz-ipv6

CZ.NIC open resolver.
IPv6 endpoint. DNSSEC-validating, no logging, no filtering. https://nic.cz
Operated by CZ.NIC. Service page: https://www.nic.cz/odvr/

sdns://AgcAAAAAAAAAE1syMDAxOjE0OGY6ZmZmZTo6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQLb2R2ci5uaWMuY3oKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAE1syMDAxOjE0OGY6ZmZmZjo6MV0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQLb2R2ci5uaWMuY3oKL2Rucy1xdWVyeQ


## njalla-doh

Njalla public resolver in Sweden.
Operated by Njalla. Non-logging. https://njal.la

sdns://AgYAAAAAAAAADDk1LjIxNS4xOS41MyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdAtkbnMubmphbC5sYQovZG5zLXF1ZXJ5


## nwps.fi

NWPS.fi public resolver in Helsinki.
No filters, no logs, DNSSEC.
Operated by NWPS.fi. Service page: https://nwps.fi/dnscrypt.php

sdns://AQcAAAAAAAAAEzk1LjIxNi4xMzguMTQxOjg0NDMguorzbtc_JWEU0KBhGLZWuvInIeGd-R5CcEHYS-SIz7cXMi5kbnNjcnlwdC1jZXJ0Lm53cHMuZmk


## olilo-doh

Olilo public resolver. Two nodes in London.
No logging, no filtering, DNSSEC validation. No EDNS Client Subnet.
Operated by Olilo (AS212683). DNS service: https://dns.as212683.net

sdns://AgcAAAAAAAAADDUuMTgyLjExNS43NCCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBkbnMuYXMyMTI2ODMubmV0Ci9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADDUuMTgyLjExNS43NSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBkbnMuYXMyMTI2ODMubmV0Ci9kbnMtcXVlcnk


## olilo-doh-ipv6

Olilo public resolver. Two nodes in London.
IPv6 endpoint. No logging, no filtering, DNSSEC validation. No EDNS Client Subnet.
Operated by Olilo (AS212683). DNS service: https://dns.as212683.net

sdns://AgcAAAAAAAAAElsyYTExOjI2NDY6MToyOjo0XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBkbnMuYXMyMTI2ODMubmV0Ci9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAElsyYTExOjI2NDY6MToyOjo1XSCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBBkbnMuYXMyMTI2ODMubmV0Ci9kbnMtcXVlcnk


## pidoh-mapledns

MapleDNS public recursive resolver. Blocks ads, trackers and malware. DNSSEC validating. No query logging. DoH and DoT. No plain DNS.
Available through servers in multiple locations around the world.

sdns://AgMAAAAAAAAADzE4OC4yNDUuMTkyLjE5NiA2nRz4WOMJwCqigkw3Y-EsBZdeAykb_yu0YlZ7y-k_IRJwaWRvaC5tYXBsZWRucy5uZXQKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADjE3Mi45My4xNjcuMTc2IDadHPhY4wnAKqKCTDdj4SwFl14DKRv_K7RiVnvL6T8hEnBpZG9oLm1hcGxlZG5zLm5ldAovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAADjIzLjI1Mi4xMjMuMTg3IDadHPhY4wnAKqKCTDdj4SwFl14DKRv_K7RiVnvL6T8hEnBpZG9oLm1hcGxlZG5zLm5ldAovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAADjEwOS45NC4xNzEuMjM1IDadHPhY4wnAKqKCTDdj4SwFl14DKRv_K7RiVnvL6T8hEnBpZG9oLm1hcGxlZG5zLm5ldAovZG5zLXF1ZXJ5


## pidoh-mapledns-ipv6

MapleDNS public recursive resolver. IPv6. Blocks ads, trackers and malware. DNSSEC validating. No query logging. DoH and DoT. No plain DNS.
Available through servers in multiple locations around the world.

sdns://AgMAAAAAAAAAFlsyYTAxOjRmODpjMTc6Y2UyZDo6MV0gNp0c-FjjCcAqooJMN2PhLAWXXgMpG_8rtGJWe8vpPyEScGlkb2gubWFwbGVkbnMubmV0Ci9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAGFsyNjA2OjYwODA6MjAwMToxMGM1OjphXSA2nRz4WOMJwCqigkw3Y-EsBZdeAykb_yu0YlZ7y-k_IRJwaWRvaC5tYXBsZWRucy5uZXQKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAGFsyNjA3OmYyZDg6ODQxNjoxMTM0OjphXSA2nRz4WOMJwCqigkw3Y-EsBZdeAykb_yu0YlZ7y-k_IRJwaWRvaC5tYXBsZWRucy5uZXQKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAF1syYTAzOmQ5YzI6MTAwOjEyY2Q6OmFdIDadHPhY4wnAKqKCTDdj4SwFl14DKRv_K7RiVnvL6T8hEnBpZG9oLm1hcGxlZG5zLm5ldAovZG5zLXF1ZXJ5


## plan9dns-fl

plan9-dns Miami resolver.
pluton.plan9-dns.com, operated by jlongua and hosted on Vultr in Miami, Florida, USA. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAAEzE0OS4yOC4xMDEuMTE5Ojg0NDMgVaFV4a8StIfx8fnCxDxVlxppqm-hJYyCKqtMtQENnCwkMi5kbnNjcnlwdC1jZXJ0LnBsdXRvbi5wbGFuOS1kbnMuY29t


## plan9dns-fl-ipv6

plan9-dns Miami resolver.
IPv6 endpoint. pluton.plan9-dns.com, operated by jlongua and hosted on Vultr in Miami, Florida, USA. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAALFsyMDAxOjE5ZjA6OTAwMjpkZTQ6NTQwMDo0ZmY6ZmUwODo3ZGUzXTo4NDQzIFWhVeGvErSH8fH5wsQ8VZcaaapvoSWMgiqrTLUBDZwsJDIuZG5zY3J5cHQtY2VydC5wbHV0b24ucGxhbjktZG5zLmNvbQ


## plan9dns-mx

plan9-dns Mexico City resolver.
helios.plan9-dns.com, operated by jlongua and hosted on Vultr in Mexico City, Mexico. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAAEzIxNi4yMzguODAuMjE5Ojg0NDMgKmPCui35rtOj9yk7c07sEtC_Khyo_9_HcpO23GCroNskMi5kbnNjcnlwdC1jZXJ0LmhlbGlvcy5wbGFuOS1kbnMuY29t


## plan9dns-mx-doh

plan9-dns Mexico City resolver.
helios.plan9-dns.com, operated by jlongua and hosted on Vultr in Mexico City, Mexico. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AgcAAAAAAAAADjIxNi4yMzguODAuMjE5IJs0-sPjbn4rH-5IR6c3ZiLUziyHN4wuotRgRyPdP_YpFGhlbGlvcy5wbGFuOS1kbnMuY29tCi9kbnMtcXVlcnk


## plan9dns-mx-doh-ipv6

plan9-dns Mexico City resolver.
IPv6 endpoint. helios.plan9-dns.com, operated by jlongua and hosted on Vultr in Mexico City, Mexico. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AgcAAAAAAAAAKFsyMDAxOjE5ZjA6YjQwMDoxZDhjOjU0MDA6NGZmOmZlMTE6YjE1YV0gmzT6w-Nufisf7khHpzdmItTOLIc3jC6i1GBHI90_9ikUaGVsaW9zLnBsYW45LWRucy5jb20KL2Rucy1xdWVyeQ


## plan9dns-mx-ipv6

plan9-dns Mexico City resolver.
IPv6 endpoint. helios.plan9-dns.com, operated by jlongua and hosted on Vultr in Mexico City, Mexico. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAALVsyMDAxOjE5ZjA6YjQwMDoxZDhjOjU0MDA6NGZmOmZlMTE6YjE1YV06ODQ0MyAqY8K6Lfmu06P3KTtzTuwS0L8qHKj_38dyk7bcYKug2yQyLmRuc2NyeXB0LWNlcnQuaGVsaW9zLnBsYW45LWRucy5jb20


## plan9dns-nj

plan9-dns New Jersey resolver.
kronos.plan9-dns.com, operated by jlongua and hosted on Vultr in Piscataway, New Jersey, USA. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAAEjIwNy4yNDYuODcuOTY6ODQ0MyCwmQlIDpKk8SiiyrJbPgKhHxCrBJLb8ZWlu6tvr1KvkyQyLmRuc2NyeXB0LWNlcnQua3Jvbm9zLnBsYW45LWRucy5jb20


## plan9dns-nj.ipv6

plan9-dns New Jersey resolver.
IPv6 endpoint. kronos.plan9-dns.com, operated by jlongua and hosted on Vultr in Piscataway, New Jersey, USA. No logs, no filtering, DNSSEC. Project page: https://jlongua.github.io/plan9-dns/

sdns://AQcAAAAAAAAAKlsyMDAxOjE5ZjA6NTozYmQ3OjU0MDA6NGZmOmZlMDU6ZGE4M106ODQ0MyCwmQlIDpKk8SiiyrJbPgKhHxCrBJLb8ZWlu6tvr1KvkyQyLmRuc2NyeXB0LWNlcnQua3Jvbm9zLnBsYW45LWRucy5jb20


## qihoo360-doh

Qihoo 360 public resolver.
Operated by Qihoo 360. Has logs; GFW filtering rules are applied. Homepage: https://sdns.360.net

sdns://AgAAAAAAAAAAACD6FZeNKdZtjheTM0R4As184g4uTh98W5hVNgufwCLevgpkb2guMzYwLmNuCi9kbnMtcXVlcnk


## quad9-dnscrypt-ip4-filter-ecs-pri

Quad9 Secure + ECS resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation, EDNS Client Subnet and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.11, 149.112.112.11.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQMAAAAAAAAADTkuOS45LjExOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQMAAAAAAAAAEzE0OS4xMTIuMTEyLjExOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip4-filter-pri

Quad9 Secure resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.9, 149.112.112.9, 149.112.112.112.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQMAAAAAAAAADDkuOS45Ljk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAEjE0OS4xMTIuMTEyLjk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAFDE0OS4xMTIuMTEyLjExMjo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ


## quad9-dnscrypt-ip4-nofilter-ecs-pri

Quad9 No Threat Blocking + ECS resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation and EDNS Client Subnet. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.12, 149.112.112.12.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQcAAAAAAAAADTkuOS45LjEyOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQcAAAAAAAAAEzE0OS4xMTIuMTEyLjEyOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip4-nofilter-pri

Quad9 No Threat Blocking resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.10, 149.112.112.10.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQcAAAAAAAAADTkuOS45LjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQcAAAAAAAAAEzE0OS4xMTIuMTEyLjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip6-filter-ecs-pri

Quad9 Secure + ECS resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation, EDNS Client Subnet and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::11, 2620:fe::fe:11.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQMAAAAAAAAAElsyNjIwOmZlOjoxMV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-dnscrypt-ip6-filter-pri

Quad9 Secure resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::fe, 2620:fe::9, 2620:fe::fe:9.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQMAAAAAAAAAElsyNjIwOmZlOjpmZV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAEVsyNjIwOmZlOjo5XTo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ
sdns://AQMAAAAAAAAAFFsyNjIwOmZlOjpmZTo5XTo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ


## quad9-dnscrypt-ip6-nofilter-ecs-pri

Quad9 No Threat Blocking + ECS resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation and EDNS Client Subnet. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::12, 2620:fe::fe:12.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQcAAAAAAAAAElsyNjIwOmZlOjoxMl06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQcAAAAAAAAAFVsyNjIwOmZlOjpmZToxMl06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-dnscrypt-ip6-nofilter-pri

Quad9 No Threat Blocking resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::10, 2620:fe::fe:10.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AQcAAAAAAAAAElsyNjIwOmZlOjoxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQcAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-doh-ip4-port443-filter-ecs-pri

Quad9 Secure + ECS resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation, EDNS Client Subnet and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.11, 149.112.112.11.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgMAAAAAAAAACDkuOS45LjExILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczExLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADjE0OS4xMTIuMTEyLjExILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczExLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip4-port443-filter-pri

Quad9 Secure resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.9, 149.112.112.9, 149.112.112.112.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgMAAAAAAAAABzkuOS45LjkgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8SZG5zOS5xdWFkOS5uZXQ6NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAADTE0OS4xMTIuMTEyLjkgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8SZG5zOS5xdWFkOS5uZXQ6NDQzCi9kbnMtcXVlcnk


## quad9-doh-ip4-port443-nofilter-ecs-pri

Quad9 No Threat Blocking + ECS resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation and EDNS Client Subnet. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.12, 149.112.112.12.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgcAAAAAAAAACDkuOS45LjEyILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEyLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjE0OS4xMTIuMTEyLjEyILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEyLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip4-port443-nofilter-pri

Quad9 No Threat Blocking resolver.
Available through servers in multiple locations around the world.
Service with DNSSEC validation. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 9.9.9.10, 149.112.112.10.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgcAAAAAAAAACDkuOS45LjEwILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEwLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjE0OS4xMTIuMTEyLjEwILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEwLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip6-port443-filter-ecs-pri

Quad9 Secure + ECS resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation, EDNS Client Subnet and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::11, 2620:fe::fe:11.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgMAAAAAAAAADVsyNjIwOmZlOjoxMV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTEucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAEFsyNjIwOmZlOjpmZToxMV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTEucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## quad9-doh-ip6-port443-filter-pri

Quad9 Secure resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation and malicious-domain blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::fe, 2620:fe::9, 2620:fe::fe:9.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgMAAAAAAAAADVsyNjIwOmZlOjpmZV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8RZG5zLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADFsyNjIwOmZlOjo5XSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxFkbnMucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAD1syNjIwOmZlOjpmZTo5XSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxJkbnM5LnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip6-port443-nofilter-ecs-pri

Quad9 No Threat Blocking + ECS resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation and EDNS Client Subnet. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::12, 2620:fe::fe:12.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgcAAAAAAAAADVsyNjIwOmZlOjoxMl0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTIucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAEFsyNjIwOmZlOjpmZToxMl0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTIucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## quad9-doh-ip6-port443-nofilter-pri

Quad9 No Threat Blocking resolver.
Available through servers in multiple locations around the world.
IPv6 service with DNSSEC validation. Does not perform security blocking. Quad9 says it does not log client IP addresses. Service addresses: 2620:fe::10, 2620:fe::fe:10.
Operated by Quad9 Foundation. Service page: https://quad9.net/service/service-addresses-and-features/

sdns://AgcAAAAAAAAADVsyNjIwOmZlOjoxMF0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTAucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAEFsyNjIwOmZlOjpmZToxMF0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTAucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## restena-doh-ipv4

RESTENA no-log resolver.
DNSSEC-validating and non-filtering.
Operated by RESTENA. Homepage: https://www.restena.lu

sdns://AgcAAAAAAAAACzE1OC42NC4xLjI5IFu-VnwzuH-_lDuVxbNpQAXPH2I1byMEB2hd7keNdtjLEWRuc3B1Yi5yZXN0ZW5hLmx1Ci9kbnMtcXVlcnk


## restena-doh-ipv6

RESTENA no-log resolver.
IPv6 endpoint. DNSSEC-validating and non-filtering.
Operated by RESTENA. Homepage: https://www.restena.lu

sdns://AgcAAAAAAAAAEFsyMDAxOmExODoxOjoyOV0gW75WfDO4f7-UO5XFs2lABc8fYjVvIwQHaF3uR4122MsRZG5zcHViLnJlc3RlbmEubHUKL2Rucy1xdWVyeQ


## rethinkdns-doh

RethinkDNS public resolver.
Available through servers in multiple locations around the world.
No logging, no filtering. `sky.rethinkdns.com` is a Cloudflare-hosted stub resolver; `max.rethinkdns.com` is a recursive resolver hosted on Fly.io. The stub strips identification parameters from the request and proxies to another recursive resolver.
Operated by RethinkDNS. Service page: https://rethinkdns.com/

sdns://AgYAAAAAAAAAACBuYqDv1goE2T8vhktURCcXpmbAOMjHBUavYxnk9GovcxJza3kucmV0aGlua2Rucy5jb20KL2Rucy1xdWVyeQ
sdns://AgYAAAAAAAAAACCbNPrD425-Kx_uSEenN2Yi1M4shzeMLqLUYEcj3T_2KRJtYXgucmV0aGlua2Rucy5jb20KL2Rucy1xdWVyeQ


## safesurfer-doh

SafeSurfer family-safety resolver.
Blocks adult websites, CSAM and related family-safety categories. Free to use, with paid options available at my.safesurfer.io for custom blocking with additional content categories. Paid users can review their own logs.
Operated by Safe Surfer. Service page: https://helpdesk.safesurfer.io/
Account holder logs are anonymized and used for filter improvement. Data is never sold. https://safesurfer.io

Warning: this server is incompatible with DNS anonymization.

sdns://AgAAAAAAAAAADjM1LjIyNy4yMjYuMTQyIGpQYrDReNVW8WOxOxsPGUNdAliCkcx1WJ3-5usRyNXDEWRvaC5zYWZlc3VyZmVyLmlvCi9kbnMtcXVlcnk


## safesurfer-doh-ipv6

SafeSurfer family-safety resolver.
IPv6 endpoint. Blocks adult websites, CSAM and related family-safety categories. Free to use, with paid options available at my.safesurfer.io for custom blocking with additional content categories. Paid users can review their own logs.
Operated by Safe Surfer. Service page: https://helpdesk.safesurfer.io/
Account holder logs are anonymized and used for filter improvement. Data is never sold. https://safesurfer.io

Warning: this server is incompatible with DNS anonymization.

sdns://AgAAAAAAAAAAFFsyNjAwOjE5MDE6MDo1YTgyOjpdIGpQYrDReNVW8WOxOxsPGUNdAliCkcx1WJ3-5usRyNXDEWRvaC5zYWZlc3VyZmVyLmlvCi9kbnMtcXVlcnk


## safesurfer-doh-secondary-ipv4

SafeSurfer family-safety resolver.
Secondary IPv4 endpoint. Blocks adult websites, CSAM and related family-safety categories. Free to use, with paid options available at my.safesurfer.io for custom blocking with additional content categories. Paid users can review their own logs.
Operated by Safe Surfer. Service page: https://helpdesk.safesurfer.io/
Account holder logs are anonymized and used for filter improvement. Data is never sold. https://safesurfer.io

Warning: this server is incompatible with DNS anonymization.

sdns://AgAAAAAAAAAADDQuMTUwLjE2OC41NyCMUDOXP_5P8e8KqSmE_JMoG6epJ474v2QSJriY0Q1OdBRkbnMuc2FmZXN1cmZlci5jby5uegovZG5zLXF1ZXJ5


## safesurfer-doh-secondary-ipv6

SafeSurfer family-safety resolver.
Secondary IPv6 endpoint. Blocks adult websites, CSAM and related family-safety categories. Free to use, with paid options available at my.safesurfer.io for custom blocking with additional content categories. Paid users can review their own logs.
Operated by Safe Surfer. Service page: https://helpdesk.safesurfer.io/
Account holder logs are anonymized and used for filter improvement. Data is never sold. https://safesurfer.io

Warning: this server is incompatible with DNS anonymization.

sdns://AgAAAAAAAAAAE1syNjAzOjEwMzA6Nzo3OjozYl0gjFAzlz_-T_HvCqkphPyTKBunqSeO-L9kEia4mNENTnQUZG5zLnNhZmVzdXJmZXIuY28ubnoKL2Rucy1xdWVyeQ


## saldns01-conoha-ipv4

salDNS Tokyo experimental resolver.
Hosted on ConoHa VPS Tokyo region. No logs, no filtering. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFDE2My40NC4xMjQuMjA0OjUwNDQzIGvWmxvhx79edG-xPZxrQR1g9jFOofVRDbPFCGWVGV1PIjIuZG5zY3J5cHQtY2VydC5zYWxkbnMwMS50eXBlcS5vcmc


## saldns02-conoha-ipv4

salDNS Tokyo experimental resolver.
Hosted on ConoHa VPS Tokyo region. No logs, no filtering. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFTE2MC4yNTEuMjE0LjE3Mjo1MDQ0MyB7SI0q4_Ff8lFRUCbjPtcAQ3HfdWlLxyGDUUNc3NUZdiIyLmRuc2NyeXB0LWNlcnQuc2FsZG5zMDIudHlwZXEub3Jn


## saldns03-conoha-ipv4

salDNS Tokyo experimental resolver.
Hosted on ConoHa VPS Tokyo region. No logs, no filtering. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFDE2MC4yNTEuMTY4LjI1OjUwNDQzIFl1NfOwMd24kRlr0mXR4rKo-c_jMV7DBUVooDEY1xFeIjIuZG5zY3J5cHQtY2VydC5zYWxkbnMwMy50eXBlcS5vcmc


## scaleway-ams

Scaleway Amsterdam resolver.
DEV1-S instance donated by Scaleway.com. DNSSEC, non-logged, uncensored.
Maintained by Frank Denis (@jedisct1) and hosted by Scaleway. Provider: https://www.scaleway.com/

sdns://AQcAAAAAAAAADTUxLjE1LjEyMi4yNTAg6Q3ZfapcbHgiHKLF7QFoli0Ty1Vsz3RXs1RUbxUrwZAcMi5kbnNjcnlwdC1jZXJ0LnNjYWxld2F5LWFtcw


## scaleway-ams-ipv6

Scaleway Amsterdam resolver.
IPv6-only DEV1-S instance donated by Scaleway.com. DNSSEC, non-logged, uncensored.
Maintained by Frank Denis (@jedisct1) and hosted by Scaleway. Provider: https://www.scaleway.com/

sdns://AQcAAAAAAAAAJlsyMDAxOmJjODoxNjQwOjFjZTI6ZGMwMDpmZjpmZTI4OjViMTddIOkN2X2qXGx4Ihyixe0BaJYtE8tVbM90V7NUVG8VK8GQHDIuZG5zY3J5cHQtY2VydC5zY2FsZXdheS1hbXM


## scaleway-fr

Scaleway Paris resolver.
DEV1-S instance donated by Scaleway.com. DNSSEC, non-logged, uncensored.
Maintained by Frank Denis (@jedisct1) and hosted by Scaleway. Provider: https://www.scaleway.com/

sdns://AQcAAAAAAAAADjIxMi40Ny4yMjguMTM2IOgBuE6mBr-wusDOQ0RbsV66ZLAvo8SqMa4QY2oHkDJNHzIuZG5zY3J5cHQtY2VydC5mci5kbnNjcnlwdC5vcmc


## scaleway-fr-ipv6

Scaleway Paris resolver.
IPv6-only DEV1-S instance donated by Scaleway.com. DNSSEC, non-logged, uncensored.
Maintained by Frank Denis (@jedisct1) and hosted by Scaleway. Provider: https://www.scaleway.com/

sdns://AQcAAAAAAAAAJVsyMDAxOmJjODo3MTA6NTgxODpkYzAwOmZmOmZlNWI6M2Y2M10g6AG4TqYGv7C6wM5DRFuxXrpksC-jxKoxrhBjageQMk0fMi5kbnNjcnlwdC1jZXJ0LmZyLmRuc2NyeXB0Lm9yZw


## searx-se-ipv4

searx.se Swedish resolver.
IPv4 endpoint. No filtering, no logging.
Operated by the searx.se project. Service page: https://searx.se/

sdns://AQcAAAAAAAAAEzE4NS4xOTUuMjM2LjE2OjU0NDMgL5FKFwxJ_35yPTqBA_GxELJMhgzr8RCbThTPXO_0OgEYMi5kbnNjcnlwdC1jZXJ0LnNlYXJ4LWNj


## searx-se-ipv6

searx.se Swedish resolver.
IPv6 endpoint. No filtering, no logging.
Operated by the searx.se project. Service page: https://searx.se/

sdns://AQcAAAAAAAAAGlsyYTA5OmIyODA6ZmUwMTplOjphXTo1NDQzIC-RShcMSf9-cj06gQPxsRCyTIYM6_EQm04Uz1zv9DoBGDIuZG5zY3J5cHQtY2VydC5zZWFyeC1jYw


## serbica

Serbica public resolver in the Netherlands.
Provided by https://litepay.ch

sdns://AQcAAAAAAAAAEzE4NS42Ni4xNDMuMTc4OjUzNTMg-Y2MQmGOXiggAEKulN-ITGEn_Kj3TIP1UK1X2wh3o7wXMi5kbnNjcnlwdC1jZXJ0LnNlcmJpY2E


## sfw.scaleway-fr

Scaleway family-safety resolver.
Uses deep learning to block adult websites. Free, DNSSEC, no logs.
Maintained by Frank Denis (@jedisct1) and hosted by Scaleway. Provider: https://www.scaleway.com/

sdns://AQMAAAAAAAAADzE2My4xNzIuMTgwLjEyNSDfYnO_x1IZKotaObwMhaw_-WRF1zZE9mJygl01WPGh_x8yLmRuc2NyeXB0LWNlcnQuc2Z3LnNjYWxld2F5LWZy


## switch

SWITCH Swiss public resolver.
Provided by SWITCH in Switzerland. Protects against malware, but does not block ads.
Operated by SWITCH. Service page: https://www.switch.ch/

sdns://AgMAAAAAAAAADTEzMC41OS4zMS4yNDggsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8NMTMwLjU5LjMxLjI0OAovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAADTEzMC41OS4zMS4yNTEgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8NMTMwLjU5LjMxLjI1MQovZG5zLXF1ZXJ5


## switch-ipv6

SWITCH Swiss public resolver.
IPv6 endpoint. Provided by SWITCH in Switzerland. Protects against malware, but does not block ads.
Operated by SWITCH. Service page: https://www.switch.ch/

sdns://AgMAAAAAAAAAElsyMDAxOjYyMDowOmZmOjoyXSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxZbMjAwMTo2MjA6MDpmZjo6Ml06NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAElsyMDAxOjYyMDowOmZmOjozXSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxZbMjAwMTo2MjA6MDpmZjo6M106NDQzCi9kbnMtcXVlcnk


## uncensoreddns-dk-ipv4

UncensoredDNS Denmark resolver.
Also known as censurfridns. Unicast service hosted in Denmark, run by Thomas Steen Rasmussen. No logs, no filtering. https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAADDg5LjIzMy40My43MQAZdW5pY2FzdC51bmNlbnNvcmVkZG5zLm9yZwovZG5zLXF1ZXJ5


## uncensoreddns-dk-ipv6

UncensoredDNS Denmark resolver.
IPv6 endpoint. Also known as censurfridns. Unicast service hosted in Denmark, run by Thomas Steen Rasmussen. No logs, no filtering. https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAAElsyYTAxOjNhMDo1Mzo1Mzo6XQAZdW5pY2FzdC51bmNlbnNvcmVkZG5zLm9yZwovZG5zLXF1ZXJ5


## uncensoreddns-ipv4

UncensoredDNS public resolver.
Available through servers in Denmark and the United States.
Also known as censurfridns. Run by Thomas Steen Rasmussen. No logs, no filtering. https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAADjkxLjIzOS4xMDAuMTAwABlhbnljYXN0LnVuY2Vuc29yZWRkbnMub3JnCi9kbnMtcXVlcnk


## uncensoreddns-ipv6

UncensoredDNS public resolver.
Available through servers in Denmark and the United States.
IPv6 endpoint. Also known as censurfridns. Run by Thomas Steen Rasmussen. No logs, no filtering. https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAAEVsyMDAxOjY3YzoyOGE0OjpdABlhbnljYXN0LnVuY2Vuc29yZWRkbnMub3JnCi9kbnMtcXVlcnk


## wikimedia

Wikimedia DNS resolver.
Available through servers in multiple locations around the world.
Caching recursive public resolver run by the Wikimedia Foundation Site Reliability Engineering Traffic team. Helps secure DNS lookups for Wikimedia projects and other websites.
Operated by Wikimedia DNS. Service page: https://wikimedia-dns.org/

sdns://AgcAAAAAAAAADjE4NS43MS4xMzguMTM4IIxQM5c__k_x7wqpKYT8kygbp6knjvi_ZBImuJjRDU50EXdpa2ltZWRpYS1kbnMub3JnCi9kbnMtcXVlcnk


## yandex

Yandex Public DNS Basic resolver.
Available through servers in multiple locations.
Service operated by Yandex.
Operated by Yandex. Service page: https://dns.yandex.com/

sdns://AgUAAAAAAAAACTc3Ljg4LjguMSAfoX_ObDDtbw3sSwas9BpsjE_wMgInWystIWh0TbH3mAk3Ny44OC44LjEKL2Rucy1xdWVyeQ
sdns://AgUAAAAAAAAACTc3Ljg4LjguOCAfoX_ObDDtbw3sSwas9BpsjE_wMgInWystIWh0TbH3mAk3Ny44OC44LjgKL2Rucy1xdWVyeQ


## yandex-ipv6

Yandex Public DNS Basic resolver.
Available through servers in multiple locations.
IPv6 service operated by Yandex.
Operated by Yandex. Service page: https://dns.yandex.com/

sdns://AgUAAAAAAAAAE1syYTAyOjZiODo6ZmVlZDpmZl0gH6F_zmww7W8N7EsGrPQabIxP8DICJ1srLSFodE2x95gJNzcuODguOC4xCi9kbnMtcXVlcnk
sdns://AgUAAAAAAAAAF1syYTAyOjZiODowOjE6OmZlZWQ6ZmZdIB-hf85sMO1vDexLBqz0GmyMT_AyAidbKy0haHRNsfeYCTc3Ljg4LjguMQovZG5zLXF1ZXJ5


## yandex-safe

Yandex Public DNS Safe resolver.
Available through servers in multiple locations.
Service operated by Yandex with malware filtering.
Operated by Yandex. Service page: https://dns.yandex.com/

sdns://AgEAAAAAAAAACTc3Ljg4LjguMiAfoX_ObDDtbw3sSwas9BpsjE_wMgInWystIWh0TbH3mAk3Ny44OC44LjIKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAACjc3Ljg4LjguODggH6F_zmww7W8N7EsGrPQabIxP8DICJ1srLSFodE2x95gKNzcuODguOC44OAovZG5zLXF1ZXJ5


## yandex-safe-ipv6

Yandex Public DNS Safe resolver.
Available through servers in multiple locations.
IPv6 service operated by Yandex with malware filtering.
Operated by Yandex. Service page: https://dns.yandex.com/

sdns://AgEAAAAAAAAAFFsyYTAyOjZiODo6ZmVlZDpiYWRdIB-hf85sMO1vDexLBqz0GmyMT_AyAidbKy0haHRNsfeYCTc3Ljg4LjguMgovZG5zLXF1ZXJ5
sdns://AgEAAAAAAAAAGFsyYTAyOjZiODowOjE6OmZlZWQ6YmFkXSAfoX_ObDDtbw3sSwas9BpsjE_wMgInWystIWh0TbH3mAk3Ny44OC44LjIKL2Rucy1xdWVyeQ


## yunzheng

YunZheng LAB public resolver.
Available through servers in Asia and Europe.
Service with DNSSEC validation and no filtering. No per-query logs are kept. Service addresses: 177.177.83.83, 2602:f3ff:83::83. DoH, DoT and DoQ on dns.yunzheng.space.
Operated by YunZheng LAB (AS204921), a non-profit educational and research laboratory. Service page: https://orbit.yunzheng.space/public-resolver/ Privacy policy: https://orbit.yunzheng.space/public-resolver/privacy/

sdns://AgcAAAAAAAAADTE3Ny4xNzcuODMuODMAEmRucy55dW56aGVuZy5zcGFjZQovZG5zLXF1ZXJ5


## yunzheng-dns64

YunZheng LAB public resolver, DNS64.
Available through servers in Asia and Europe.
Service with DNSSEC validation and no filtering, plus DNS64 (RFC 6147) on the well-known prefix 64:ff9b::/96: a name with no AAAA record is answered with an address built from its A record, for IPv6-only networks whose NAT64 gateway uses that prefix. No per-query logs are kept. Service addresses: 177.177.83.64, 2602:f3ff:83::64. DoH, DoT and DoQ on dns64.dns.yunzheng.space.
Operated by YunZheng LAB (AS204921), a non-profit educational and research laboratory. Service page: https://orbit.yunzheng.space/public-resolver/ Privacy policy: https://orbit.yunzheng.space/public-resolver/privacy/

sdns://AgcAAAAAAAAADTE3Ny4xNzcuODMuNjQAGGRuczY0LmRucy55dW56aGVuZy5zcGFjZQovZG5zLXF1ZXJ5


## yunzheng-filtered

YunZheng LAB public resolver, filtering.
Available through servers in Asia and Europe.
Service with DNSSEC validation. Advertising, tracking and known-malware domains are refused and answered with a notice page. No per-query logs are kept. Service addresses: 177.177.83.84, 2602:f3ff:83::84. DoH, DoT and DoQ on filter.dns.yunzheng.space.
Operated by YunZheng LAB (AS204921), a non-profit educational and research laboratory. Service page: https://orbit.yunzheng.space/public-resolver/ Privacy policy: https://orbit.yunzheng.space/public-resolver/privacy/

sdns://AgMAAAAAAAAADTE3Ny4xNzcuODMuODQAGWZpbHRlci5kbnMueXVuemhlbmcuc3BhY2UKL2Rucy1xdWVyeQ

