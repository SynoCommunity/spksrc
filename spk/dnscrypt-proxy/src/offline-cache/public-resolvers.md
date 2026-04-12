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
    urls = ['https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md', 'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md']
    minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
    cache_file = 'public-resolvers.md'

--


## a-and-a

Non-filtering, No-logging, DNSSEC DoH operated by Andrews & Arnold LTD.
Homepage: https://www.aa.net.uk/dns/

sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjIADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjMADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ


## a-and-a-ipv6

Non-filtering, No-logging, DNSSEC DoH over IPv6 operated by Andrews & Arnold LTD.
Homepage: https://www.aa.net.uk/dns/

sdns://AgcAAAAAAAAAEFsyMDAxOjhiMDo6MjAyMl0ADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAEFsyMDAxOjhiMDo6MjAyM10ADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ


## adfilter-adl

Hosted in Adelaide, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.

sdns://AgMAAAAAAAAADjE2My40Ny4xMTcuMTc2IJB40hpWwOCJHZBiIbaZIzG90XFy6w8z3aB9XGXG4Uw5EGFkbC5hZGZpbHRlci5uZXQKL2Rucy1xdWVyeQ


## adfilter-adl-ipv6

Hosted in Adelaide, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.

sdns://AgMAAAAAAAAAHlsyNDAwOmM0MDE6OjUwNTQ6ZmY6ZmUxYjpiMDM2XSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMORBhZGwuYWRmaWx0ZXIubmV0Ci9kbnMtcXVlcnk


## adfilter-per

Hosted in Perth, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.

sdns://AgMAAAAAAAAADTIwMy4yOS4yNDEuNzYgkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkQcGVyLmFkZmlsdGVyLm5ldAovZG5zLXF1ZXJ5


## adfilter-per-ipv6

Hosted in Perth, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.

sdns://AgMAAAAAAAAAGFsyNDA0Ojk0MDA6NDFhOTo0ODAwOjoxXSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMORBwZXIuYWRmaWx0ZXIubmV0Ci9kbnMtcXVlcnk


## adfilter-syd

Hosted in Sydney, Australia.

Blocks ads, malware, trackers and more. No persistent logs. DNSSEC. No EDNS Client-Subnet.

sdns://AgMAAAAAAAAADjExMi4yMTMuMzIuMjE5IJB40hpWwOCJHZBiIbaZIzG90XFy6w8z3aB9XGXG4Uw5EHN5ZC5hZGZpbHRlci5uZXQKL2Rucy1xdWVyeQ


## adguard-dns

Remove ads and protect your computer from malware

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20
sdns://AQMAAAAAAAAAETk0LjE0MC4xNS4xNTo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20


## adguard-dns-doh

Remove ads and protect your computer from malware (over DoH)

sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNCCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTQuMTQKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNSCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTUuMTUKL2Rucy1xdWVyeQ


## adguard-dns-doh-ipv6

Remove ads and protect your computer from malware (over DoH, over IPv6)

sdns://AgMAAAAAAAAAE1syYTEwOjUwYzA6OmFkMTpmZl0gmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkTZG5zLmFkZ3VhcmQtZG5zLmNvbQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAE1syYTEwOjUwYzA6OmFkMjpmZl0gmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkTZG5zLmFkZ3VhcmQtZG5zLmNvbQovZG5zLXF1ZXJ5


## adguard-dns-family

AdGuard DNS with safesearch and adult content blocking

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNTo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ
sdns://AQMAAAAAAAAAETk0LjE0MC4xNS4xNjo1NDQzILgxXdexS27jIKRw3C7Wsao5jMnlhvhdRUXWuMm1AFq6ITIuZG5zY3J5cHQuZmFtaWx5Lm5zMS5hZGd1YXJkLmNvbQ


## adguard-dns-family-doh

AdGuard DNS with safesearch and adult content blocking (over DoH)

sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNSCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTQuMTUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNiCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTUuMTYKL2Rucy1xdWVyeQ


## adguard-dns-family-doh-ipv6

AdGuard DNS with safesearch and adult content blocking (over DoH, over IPv6)

sdns://AgMAAAAAAAAAFFsyYTEwOjUwYzA6OmJhZDE6ZmZdIJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZFmZhbWlseS5hZGd1YXJkLWRucy5jb20KL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAFFsyYTEwOjUwYzA6OmJhZDI6ZmZdIJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZFmZhbWlseS5hZGd1YXJkLWRucy5jb20KL2Rucy1xdWVyeQ


## adguard-dns-family-ipv6

AdGuard DNS with safesearch and adult content blocking (over IPv6)

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAGVsyYTEwOjUwYzA6OmJhZDE6ZmZdOjU0NDMguDFd17FLbuMgpHDcLtaxqjmMyeWG-F1FRda4ybUAWrohMi5kbnNjcnlwdC5mYW1pbHkubnMxLmFkZ3VhcmQuY29t
sdns://AQMAAAAAAAAAGVsyYTEwOjUwYzA6OmJhZDI6ZmZdOjU0NDMguDFd17FLbuMgpHDcLtaxqjmMyeWG-F1FRda4ybUAWrohMi5kbnNjcnlwdC5mYW1pbHkubnMxLmFkZ3VhcmQuY29t


## adguard-dns-ipv6

Remove ads and protect your computer from malware (over IPv6)

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAGFsyYTEwOjUwYzA6OmFkMTpmZl06NTQ0MyDRK0fyUtzywrv4mRCG6vec5EldixbIoMQyLlLKPzkIcyIyLmRuc2NyeXB0LmRlZmF1bHQubnMxLmFkZ3VhcmQuY29t
sdns://AQMAAAAAAAAAGFsyYTEwOjUwYzA6OmFkMjpmZl06NTQ0MyDRK0fyUtzywrv4mRCG6vec5EldixbIoMQyLlLKPzkIcyIyLmRuc2NyeXB0LmRlZmF1bHQubnMxLmFkZ3VhcmQuY29t


## adguard-dns-unfiltered

AdGuard public DNS servers without filters

Warning: This server is incompatible with anonymization.

sdns://AQcAAAAAAAAAEjk0LjE0MC4xNC4xNDA6NTQ0MyC16ETWuDo-PhJo62gfvqcN48X6aNvWiBQdvy7AZrLa-iUyLmRuc2NyeXB0LnVuZmlsdGVyZWQubnMxLmFkZ3VhcmQuY29t
sdns://AQcAAAAAAAAAEjk0LjE0MC4xNC4xNDE6NTQ0MyC16ETWuDo-PhJo62gfvqcN48X6aNvWiBQdvy7AZrLa-iUyLmRuc2NyeXB0LnVuZmlsdGVyZWQubnMxLmFkZ3VhcmQuY29t


## adguard-dns-unfiltered-doh

AdGuard public DNS servers without filters (over DoH)

sdns://AgcAAAAAAAAADTk0LjE0MC4xNC4xNDAgmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkNOTQuMTQwLjE0LjE0MAovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADTk0LjE0MC4xNC4xNDEgmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkNOTQuMTQwLjE0LjE0MQovZG5zLXF1ZXJ5


## adguard-dns-unfiltered-doh-ipv6

AdGuard public DNS servers without filters (over DoH, over IPv6)

sdns://AgcAAAAAAAAAEVsyYTEwOjUwYzA6OjE6ZmZdIJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZGnVuZmlsdGVyZWQuYWRndWFyZC1kbnMuY29tCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAEVsyYTEwOjUwYzA6OjI6ZmZdIJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZGnVuZmlsdGVyZWQuYWRndWFyZC1kbnMuY29tCi9kbnMtcXVlcnk


## adguard-dns-unfiltered-ipv6

AdGuard public DNS servers without filters (over IPv6)

Warning: This server is incompatible with anonymization.

sdns://AQcAAAAAAAAAFlsyYTEwOjUwYzA6OjE6ZmZdOjU0NDMgtehE1rg6Pj4SaOtoH76nDePF-mjb1ogUHb8uwGay2volMi5kbnNjcnlwdC51bmZpbHRlcmVkLm5zMS5hZGd1YXJkLmNvbQ
sdns://AQcAAAAAAAAAFlsyYTEwOjUwYzA6OjI6ZmZdOjU0NDMgtehE1rg6Pj4SaOtoH76nDePF-mjb1ogUHb8uwGay2volMi5kbnNjcnlwdC51bmZpbHRlcmVkLm5zMS5hZGd1YXJkLmNvbQ


## alidns-doh

A public DNS resolver that supports DoH/DoT in mainland China, provided by Alibaba-Cloud.
Homepage: https://alidns.com

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAACTIyMy41LjUuNSCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAkyMjMuNS41LjUKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAACTIyMy42LjYuNiCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAkyMjMuNi42LjYKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAADTEyMC41NS4yMDMuNDQgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANMTIwLjU1LjIwMy40NAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAACzQ3LjEwOC4wLjYzIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwCzQ3LjEwOC4wLjYzCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADTM5LjEwMy4yNi4yMDQgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANMzkuMTAzLjI2LjIwNAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAADzEzOS4xMjkuMTM3LjEzNyCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMA8xMzkuMTI5LjEzNy4xMzcKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAACzQ3LjEyMi44LjExIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwCzQ3LjEyMi44LjExCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADjEyMy4xODQuMTk4LjIyIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwDjEyMy4xODQuMTk4LjIyCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADjExMy4xNDIuODMuMTMyIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwDjExMy4xNDIuODMuMTMyCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAADDE4Mi40MC43MC4xMiCY49XlNq8pWM0vfxT3BO9KJ20l4zzWXy5l9eTycnwTMAwxODIuNDAuNzAuMTIKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAADTguMTI5LjE1Mi4yMzAgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzANOC4xMjkuMTUyLjIzMAovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAACjEuNzEuMjAuMzcgmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzAKMS43MS4yMC4zNwovZG5zLXF1ZXJ5


## alidns-doh-ipv6

A public DNS resolver over IPv6 that supports DoH/DoT in mainland China, provided by Alibaba-Cloud.
Homepage: https://alidns.com

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAADlsyNDAwOjMyMDA6OjFdIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwCTIyMy41LjUuNQovZG5zLXF1ZXJ5
sdns://AgAAAAAAAAAAE1syNDAwOjMyMDA6YmFiYTo6MV0gmOPV5TavKVjNL38U9wTvSidtJeM81l8uZfXk8nJ8EzAJMjIzLjUuNS41Ci9kbnMtcXVlcnk


## blahdns-sg-doh

DNS-over-HTTPS server. No Logging, filters ads, trackers and malware. DNSSEC ready, QNAME Minimization, No EDNS Client-Subnet.

sdns://AgMAAAAAAAAADjQ2LjI1MC4yMjYuMjQyABJkb2gtc2cuYmxhaGRucy5jb20KL2Rucy1xdWVyeQ


## bortzmeyer

Non-logging DoH server in France operated by Stéphane Bortzmeyer.

https://www.bortzmeyer.org/doh-bortzmeyer-fr-policy.html

sdns://AgcAAAAAAAAADDE5My43MC44NS4xMSDWHZbr-z-hkJbiwALjYDv3_arvsicE2oZoBiu-hu1LkxFkb2guYm9ydHptZXllci5mcgEv


## bortzmeyer-ipv6

Non-logging DoH server in France operated by Stéphane Bortzmeyer (IPv6 only).

https://www.bortzmeyer.org/doh-bortzmeyer-fr-policy.html

sdns://AgcAAAAAAAAAGVsyMDAxOjQxZDA6MzAyOjIyMDA6OjE4MF0g1h2W6_s_oZCW4sAC42A79_2q77InBNqGaAYrvobtS5MRZG9oLmJvcnR6bWV5ZXIuZnIBLw


## brahma-world

DNS-over-HTTPS server. Non Logging, filters ads, trackers and malware. DNSSEC ready, QNAME Minimization, No EDNS Client-Subnet.

Hosted in Nuremberg, Germany. (https://dns.brahma.world)

sdns://AgMAAAAAAAAADTE1Ny45MC4xMjQuNjIgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQQZG5zLmJyYWhtYS53b3JsZAovZG5zLXF1ZXJ5


## brahma-world-ipv6

DNS-over-HTTPS server. Non Logging, filters ads, trackers and malware. DNSSEC ready, QNAME Minimization, No EDNS Client-Subnet.

Hosted in Nuremberg, Germany. (https://dns.brahma.world)

sdns://AgMAAAAAAAAAF1syYTAxOjRmODoxYzFjOmY1ZTE6OjFdILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0EGRucy5icmFobWEud29ybGQKL2Rucy1xdWVyeQ


## cira-family

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Family - Malware and phishing protection plus blocking pornographic content

Info: Not anonymous but does not sell or share data. The 'family' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjMwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTHWZhbWlseS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjMwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTHWZhbWlseS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-family-ipv6

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Family - Malware and phishing protection plus blocking pornographic content - IPV6

Info: Not anonymous but does not sell or share data. The 'family' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjozMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MdZmFtaWx5LmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjozMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MdZmFtaWx5LmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ


## cira-private

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Private - DNS resolution only

Info: Not anonymous but does not sell or share data. The 'private' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjEwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTHnByaXZhdGUuY2FuYWRpYW5zaGllbGQuY2lyYS5jYQovZG5zLXF1ZXJ5
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjEwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTHnByaXZhdGUuY2FuYWRpYW5zaGllbGQuY2lyYS5jYQovZG5zLXF1ZXJ5


## cira-private-ipv6

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Private - DNS resolution only - IPV6

Info: Not anonymous but does not sell or share data. The 'private' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjoxMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MecHJpdmF0ZS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjoxMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MecHJpdmF0ZS5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-protected

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Protected - Malware and phishing protection

Info: Not anonymous but does not sell or share data. The 'protected' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIxLjIwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTIHByb3RlY3RlZC5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk
sdns://AgEAAAAAAAAADjE0OS4xMTIuMTIyLjIwIAhEQFg7uYrZyKqQhlnZIgC2akFQCoq_4RXI_l5iJDPTIHByb3RlY3RlZC5jYW5hZGlhbnNoaWVsZC5jaXJhLmNhCi9kbnMtcXVlcnk


## cira-protected-ipv6

Canadian Internet Registration Authority (CIRA) Canadian Shield DNS resolver - Protected - Malware and phishing protection - IPV6

Info: Not anonymous but does not sell or share data. The 'protected' name is one that CIRA designates themselves to this resolver.

sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJCOjoyMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MgcHJvdGVjdGVkLmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAAE1syNjIwOjEwQTo4MEJDOjoyMF0gCERAWDu5itnIqpCGWdkiALZqQVAKir_hFcj-XmIkM9MgcHJvdGVjdGVkLmNhbmFkaWFuc2hpZWxkLmNpcmEuY2EKL2Rucy1xdWVyeQ


## circl-doh

DoH server operated by CIRCL, Computer Incident Response Center Luxembourg.

Hosted in Bettembourg, Luxembourg.

sdns://AgYAAAAAAAAADTE4NS4xOTQuOTQuNzEADGRucy5jaXJjbC5sdQovZG5zLXF1ZXJ5


## circl-doh-ipv6

DoH server operated by CIRCL, Computer Incident Response Center Luxembourg.

Hosted in Bettembourg, Luxembourg.

sdns://AgYAAAAAAAAAElsyYTAwOjU5ODA6OTQ6OjcxXQAMZG5zLmNpcmNsLmx1Ci9kbnMtcXVlcnk


## cisco

Remove your DNS blind spot (DNSCrypt protocol)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAADjIwOC42Ny4yMjAuMjIwILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-doh

Remove your DNS blind spot (DoH protocol)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AgAAAAAAAAAADDE0Ni4xMTIuNDEuMiCYZO337qhZZ1J0sPrfvSaTZamrnrp3PahnSUxalKQ33w9kb2gub3BlbmRucy5jb20KL2Rucy1xdWVyeQ


## cisco-familyshield

Block websites not suitable for children (DNSCrypt protocol)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

Currently incompatible with DNS anonymization.

sdns://AQEAAAAAAAAADjIwOC42Ny4yMjAuMTIzILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-familyshield-ipv6

Block websites not suitable for children (IPv6)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAAEVsyNjIwOjExOTozNTo6MzVdILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ


## cisco-ipv6

Cisco OpenDNS over IPv6 (DNSCrypt protocol)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AQEAAAAAAAAAD1syNjIwOjA6Y2NjOjoyXSC3NRFAIG8iXT4r2CLX_WkeocM8yNZmjQy-BL-rykP7eRsyLmRuc2NyeXB0LWNlcnQub3BlbmRucy5jb20


## cisco-ipv6-doh

Cisco OpenDNS over IPv6 (DoH protocol)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: modifies your queries to include a copy of your network
address when forwarding them to a selection of companies and organizations.

sdns://AgAAAAAAAAAAEFsyNjIwOjExOTpmYzo6Ml0gmGTt9-6oWWdSdLD6370mk2Wpq566dz2oZ0lMWpSkN98PZG9oLm9wZW5kbnMuY29tCi9kbnMtcXVlcnk


## cisco-sandbox

Cisco OpenDNS Sandbox (anycast)

Warning: Doesn't work any more in some countries such as France and Portugal.

Warning: This server is incompatible with anonymization.

sdns://AQEAAAAAAAAADDE0Ni4xMTIuNDEuNCC3NRFAIG8iXT4r2CLX_WkeocM8yNZmjQy-BL-rykP7eRsyLmRuc2NyeXB0LWNlcnQub3BlbmRucy5jb20


## cleanbrowsing-adult

Blocks access to adult, pornographic and explicit sites. It does
not block proxy or VPNs, nor mixed-content sites. Sites like Reddit
are allowed. Google and Bing are set to the Safe Mode.

Warning: This server is incompatible with anonymization.

By https://cleanbrowsing.org/

sdns://AQMAAAAAAAAAEzE4NS4yMjguMTY4LjEwOjg0NDMgvKwy-tVDaRcfCDLWB1AnwyCM7vDo6Z-UGNx3YGXUjykRY2xlYW5icm93c2luZy5vcmc


## cleanbrowsing-adult-doh

Blocks access to adult, pornographic and explicit sites over DoH. It does
not block proxy or VPNs, nor mixed-content sites. Sites like Reddit
are allowed. Google and Bing are set to the Safe Mode.

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwoPn_N_AuYyy3OHAlwH5XkIo9Nxt8ldjN0DkN4jHtlDoSoCso0AXN1mJZ2xEYZeoXy7YLPI9UcGhjjZAqZL54Sv34IOaSTdvwPj_u_RiUGT7gQuBqadbySK2eIW2kKyiPLBAZEWNsZWFuYnJvd3Npbmcub3JnES9kb2gvYWR1bHQtZmlsdGVy
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OKD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6EqArKNAFzdZiWdsRGGXqF8u2CzyPVHBoY42QKmS-eEr9-CDmkk3b8D4_7v0YlBk-4ELgamnW8kitniFtpCsojywQGRFjbGVhbmJyb3dzaW5nLm9yZxEvZG9oL2FkdWx0LWZpbHRlcg


## cleanbrowsing-adult-ipv6

Blocks access to adult, pornographic and explicit sites over IPv6. It does
not block proxy or VPNs, nor mixed-content sites. Sites like Reddit
are allowed. Google and Bing are set to the Safe Mode.

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6MTo6MV06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw
sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6Mjo6MV06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cleanbrowsing-family

Blocks access to adult, pornographic and explicit sites. It also
blocks proxy and VPN domains that are used to bypass the filters.
Mixed content sites (like Reddit) are also blocked. Google, Bing and
Youtube are set to the Safe Mode.

Warning: This server is incompatible with anonymization.

By https://cleanbrowsing.org/

sdns://AQMAAAAAAAAAFDE4NS4yMjguMTY4LjE2ODo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn


## cleanbrowsing-family-doh

Blocks access to adult, pornographic and explicit sites over DoH. It also
blocks proxy and VPN domains that are used to bypass the filters.
Mixed content sites (like Reddit) are also blocked. Google, Bing and
Youtube are set to the Safe Mode.

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwoPn_N_AuYyy3OHAlwH5XkIo9Nxt8ldjN0DkN4jHtlDoSoCso0AXN1mJZ2xEYZeoXy7YLPI9UcGhjjZAqZL54Sv34IOaSTdvwPj_u_RiUGT7gQuBqadbySK2eIW2kKyiPLBAZEWNsZWFuYnJvd3Npbmcub3JnEi9kb2gvZmFtaWx5LWZpbHRlcg
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OKD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6EqArKNAFzdZiWdsRGGXqF8u2CzyPVHBoY42QKmS-eEr9-CDmkk3b8D4_7v0YlBk-4ELgamnW8kitniFtpCsojywQGRFjbGVhbmJyb3dzaW5nLm9yZxIvZG9oL2ZhbWlseS1maWx0ZXI


## cleanbrowsing-family-ipv6

Blocks access to adult, pornographic and explicit sites over IPv6. It also
blocks proxy and VPN domains that are used to bypass the filters.
Mixed content sites (like Reddit) are also blocked. Google, Bing and
Youtube are set to the Safe Mode.

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFFsyYTBkOjJhMDA6MTo6XTo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn
sdns://AQMAAAAAAAAAFFsyYTBkOjJhMDA6Mjo6XTo4NDQzILysMvrVQ2kXHwgy1gdQJ8MgjO7w6OmflBjcd2Bl1I8pEWNsZWFuYnJvd3Npbmcub3Jn


## cleanbrowsing-security

Blocks only phishing, spam and malicious domains.

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAEjE4NS4yMjguMTY4Ljk6ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cleanbrowsing-security-doh

Blocks only phishing, spam and malicious domains over DoH.

sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwoPn_N_AuYyy3OHAlwH5XkIo9Nxt8ldjN0DkN4jHtlDoSoCso0AXN1mJZ2xEYZeoXy7YLPI9UcGhjjZAqZL54Sv34IOaSTdvwPj_u_RiUGT7gQuBqadbySK2eIW2kKyiPLBAZEWNsZWFuYnJvd3Npbmcub3JnFC9kb2gvc2VjdXJpdHktZmlsdGVy
sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OKD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6EqArKNAFzdZiWdsRGGXqF8u2CzyPVHBoY42QKmS-eEr9-CDmkk3b8D4_7v0YlBk-4ELgamnW8kitniFtpCsojywQGRFjbGVhbmJyb3dzaW5nLm9yZxQvZG9oL3NlY3VyaXR5LWZpbHRlcg


## cleanbrowsing-security-ipv6

Blocks only phishing, spam and malicious domains over IPv6.

Warning: This server is incompatible with anonymization.

sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6MTo6Ml06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw
sdns://AQMAAAAAAAAAFVsyYTBkOjJhMDA6Mjo6Ml06ODQ0MyC8rDL61UNpFx8IMtYHUCfDIIzu8Ojpn5QY3HdgZdSPKRFjbGVhbmJyb3dzaW5nLm9yZw


## cloudflare

Cloudflare DNS (anycast) - aka 1.1.1.1 / 1.0.0.1

sdns://AgcAAAAAAAAABzEuMC4wLjEAEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAABzEuMC4wLjEABzEuMC4wLjEKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADDE2Mi4xNTkuMzYuMQAMMTYyLjE1OS4zNi4xCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADDE2Mi4xNTkuNDYuMQAMMTYyLjE1OS40Ni4xCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADjEwNC4xNi4xMzIuMjI5ABJkbnMuY2xvdWRmbGFyZS5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4xMzMuMjI5ABJkbnMuY2xvdWRmbGFyZS5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4yNDkuMjQ5ABJjbG91ZGZsYXJlLWRucy5jb20KL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAADjEwNC4xNi4yNDguMjQ5ABJjbG91ZGZsYXJlLWRucy5jb20KL2Rucy1xdWVyeQ


## cloudflare-family

Cloudflare DNS (anycast) with malware protection and parental control - aka 1.1.1.3 / 1.0.0.3

sdns://AgMAAAAAAAAABzEuMC4wLjMABzEuMC4wLjMKL2Rucy1xdWVyeQ


## cloudflare-family-ipv6

Cloudflare DNS over IPv6 (anycast) with malware protection and parental control

sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExM10AGlsyNjA2OjQ3MDA6NDcwMDo6MTExM106NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwM10AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwM106NDQzCi9kbnMtcXVlcnk


## cloudflare-ipv6

Cloudflare DNS over IPv6 (anycast)

sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExMV0AGlsyNjA2OjQ3MDA6NDcwMDo6MTExMV06NDQzCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwMV0AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwMV06NDQzCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ODRlNV0AEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ODVlNV0AEmRucy5jbG91ZGZsYXJlLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ZjhmOV0AEmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAFlsyNjA2OjQ3MDA6OjY4MTA6ZjlmOV0AEmNsb3VkZmxhcmUtZG5zLmNvbQovZG5zLXF1ZXJ5


## cloudflare-security

Cloudflare DNS (anycast) with malware blocking - aka 1.1.1.2 / 1.0.0.2

sdns://AgMAAAAAAAAABzEuMC4wLjIABzEuMC4wLjIKL2Rucy1xdWVyeQ


## cloudflare-security-ipv6

Cloudflare DNS over IPv6 (anycast) with malware blocking

sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTExMl0AGlsyNjA2OjQ3MDA6NDcwMDo6MTExMl06NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAFlsyNjA2OjQ3MDA6NDcwMDo6MTAwMl0AGlsyNjA2OjQ3MDA6NDcwMDo6MTAwMl06NDQzCi9kbnMtcXVlcnk


## comodo-02

Comodo Dome Shield (anycast) - https://cdome.comodo.com/shield/

sdns://AQUAAAAAAAAACjguMjAuMjQ3LjIg0sJUqpYcHsoXmZb1X7yAHwg2xyN5q1J-zaiGG-Dgs7AoMi5kbnNjcnlwdC1jZXJ0LnNoaWVsZC0yLmRuc2J5Y29tb2RvLmNvbQ
sdns://AQUAAAAAAAAACzguMjAuMjQ3LjIwINLCVKqWHB7KF5mW9V-8gB8INscjeatSfs2ohhvg4LOwKDIuZG5zY3J5cHQtY2VydC5zaGllbGQtMi5kbnNieWNvbW9kby5jb20
sdns://AQUAAAAAAAAACjguMjYuNTYuMjYg0sJUqpYcHsoXmZb1X7yAHwg2xyN5q1J-zaiGG-Dgs7AoMi5kbnNjcnlwdC1jZXJ0LnNoaWVsZC0yLmRuc2J5Y29tb2RvLmNvbQ


## comss.one

Comss.one DNS - DNS with adblock filters and antiphishing, gaining popularity among russian-speaking users.

sdns://AgMAAAAAAAAADjgzLjIyMC4xNjkuMTU1IOVh_sR8Wh3NwumyfOVEFrzdxzIG9bZ6Vl2nNfJprop5DWRucy5jb21zcy5vbmUKL2Rucy1xdWVyeQ


## controld-block-malware

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This DNS blocks Malware domains.

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMQ


## controld-block-malware-ad

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This DNS blocks Malware, Ads & Tracking domains.

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMg


## controld-block-malware-ad-social

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This DNS blocks Malware, Ads & Tracking and Social Networks domains.

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMw


## controld-family-friendly

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This DNS blocks Malware, Ads & Tracking, Adult Content and Drugs domains.

sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tBy9mYW1pbHk


## controld-uncensored

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This DNS unblocks censored domains from various countries.

sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tCy91bmNlbnNvcmVk


## controld-unfiltered

ControlD Free DNS. Take CONTROL of your Internet. Block unwanted content, bypass geo-restrictions and be more productive. DoH protocol and No logging. - https://controld.com/free-dns

This is a Unfiltered DNS, no DNS record blocking or manipulation here, if you want to block Malware, Ads & Tracking or Social Network domains, use the other ControlD DNS configs.

sdns://AgcAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMA


## cs-austria

Wien, Austria DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTk0LjE5OC40MS4yMzUgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-austria6

Wien, Austria IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyOTphMTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-barcelona

Barcelona, Spain DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4xNDIuMTE1IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-barcelona6

Barcelona, Spain IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozNToxNzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-belgium

Brussels, Belgium DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMzYuMTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-belgium6

Brussels, Belgium IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyMDAxOmFjODoyNzoxMDM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-berlin

Berlin, Germany DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMTcuNzUgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-berlin6

Berlin, Germany IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozNjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-brazil

Sao Paulo, Brazil DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjE3Ny41NC4xNDUuMTMxIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-brazil6

Sao Paulo, Brazil IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syODA0OjM5MWM6MDo3Ojo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-ch

Switzerland DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5MC4yMTEuMjU1LjIyNyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ch6

Switzerland IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAGVsyYTAyOjI5Yjg6ZGMwMToyMjIwOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-czech

Prague, Czech Republic DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzIxNy4xMzguMjIwLjI0MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-czech6

Prague, Czech Republic IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozMzo3Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dc

US - Washington, DC DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADDE5OC43LjU4LjIyNyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-dc6

US - Washington, DC IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAG1syNjA0OjlhMDA6MjAxMDphMGJiOjY6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-de

Frankfurt, Germany DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAACzE0Ni43MC44Mi4zIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-de6

Frankfurt, Germany IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MWQ6OTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dus

Dusseldorf, Germany DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjg5LjE2My4yMjEuMTgxIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-dus6

Dusseldorf, Germany IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjRiYTA6ZmZlZDo3Njo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-finland

Finland DNSCrypt server provided by https://cryptostorm.is

sdns://AQcAAAAAAAAADTgzLjE0My4yNDIuNDMgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-finland6

Finland IPv6 DNSCrypt server provided by https://cryptostorm.is

sdns://AQcAAAAAAAAAFlsyYTBkOjU2MDA6MTQyOjExOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-fl

US - Miami, FL DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjE0Ni43MC4yNDAuMjAzIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-fl6

US - Miami, FL IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6NjoxMjM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-fr

France DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE2My4xNzIuMzQuNTYgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-fr6

France IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAGFsyMDAxOmJjODozMmQ3OjIwMGM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ga

US - Atlanta, GA DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzEzMC4xOTUuMjEyLjIxMSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ga6

US - Atlanta, GA IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTQ1OjU6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-hungary

Budapest, Hungary DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTg2LjEwNi43NC4yMTkgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-hungary6

Budapest, Hungary IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyNjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-il

US - Chicago, IL DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5NS4yNDIuMjEyLjEzMSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-il6

US - Chicago, IL IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTQ0OjE6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-india

India DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE2NS4yMzEuMjUzLjE2MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-india6

India IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjQ3MDoxZjI5OjIwNDo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-la

US - Los Angeles, CA DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzE5NS4yMDYuMTA0LjIwMyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-la6

US - Los Angeles, CA IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6NGY6NTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-london

London, England DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTc4LjEyOS4yNDguNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-london6

London, England IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjFiNDA6NTAwMDphMjo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-manchester

Manchester, England DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE5NS4xMi40OC4xNzEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-manchester6

Manchester, England IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo4Yjo2MTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-md

Moldova DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3Ni4xMjMuNC4yMzEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-md6

Moldova IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAF1syMDAxOjY3ODo2ZDQ6NTAyMzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-milan

Milan, Italy DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzIxNy4xMzguMjE5LjIxOSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-milan6

Milan, Italy IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODoyNDphMTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-montreal

Montreal, Canada DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3Ni4xMTMuNzQuMTkgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-montreal6

Montreal, Canada IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MTk6NTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nl

Netherlands DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE4NS4xMDcuODAuODQgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-nl6

Netherlands IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFlsyYTAwOjE3Njg6NjAwMTo4Ojo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-norway

Oslo, Norway DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjkxLjIxOS4yMTUuMjI3IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-norway6

Oslo, Norway IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODozODo5NDo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nv

US - Las Vegas, NV DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADDc5LjExMC41My41MSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-nv6

US - Las Vegas, NV IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MzoxOTo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-nyc

US - New York City, NY DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE0Ni43MC4xNTQuNjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-nyc6

US - New York City, NY IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MjQ6NTQ6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-ore

US - Oregon DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE3OS42MS4yMjMuNDcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-ore6

US - Oregon IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syNjA1OjZjODA6NTpkOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-poland

Warsaw, Poland DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4yMTEuOTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-poland6

Warsaw, Poland IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTBkOjU2MDA6MTM6NzE6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-pt

Portugal DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjkxLjIwNS4yMzAuMjI0IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-pt6

Portugal IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syYTA2OjMwNDA6OmVjNDo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-ro

Romania DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTE0Ni43MC42Ni4yMjcgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-sea

US - Seattle, WA DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADDY0LjEyMC41LjI1MSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-sea6

US - Seattle, WA IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAGFsyNjA3OmY1YjI6MTphMDBiOmI6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-serbia

Belgrade, Serbia DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4xOTMuMjE5IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-serbia6

Belgrade, Serbia IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo3ZDo0Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-singapore

Singapore DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTM3LjEyMC4xNTEuMTEgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-singapore6

Singapore IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyYTBkOjU2MDA6MWY6Nzo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-sk

South Korea DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjEwOC4xODEuNTAuMjE4IDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-sk6

South Korea IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syNDA2OjRmNDA6NDpjOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-swe

Sweden DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADzEyOC4xMjcuMTA0LjEwOCAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-swe6

Sweden IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAE1syYTAwOjcxNDI6MToxOjo1M10gMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-sydney

Sydney, Australia DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjM3LjEyMC4yMzQuMjUxIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-sydney6

Sydney, Australia IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo4NDo0ZDo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-tokyo

Tokyo, Japan DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADDE0Ni43MC4zMS40MyAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-tokyo6

Tokyo, Japan IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFFsyMDAxOmFjODo0MDpkZjo6NTNdIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-tx

US - Dallas, TX DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADTIwOS41OC4xNDcuMzYgMTNyrVlWMsJBa4cvCY-FG925ZShMbL6aTxkJZDDbqVoeMi5kbnNjcnlwdC1jZXJ0LmNyeXB0b3N0b3JtLmlz


## cs-tx6

US - Dallas, TX IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAG1syNjA2Ojk4ODA6MjEwMDphMDA2OjM6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## cs-vancouver

Vancouver, Canada DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAADjE5Ni4yNDAuNzkuMTYzIDEzcq1ZVjLCQWuHLwmPhRvduWUoTGy-mk8ZCWQw26laHjIuZG5zY3J5cHQtY2VydC5jcnlwdG9zdG9ybS5pcw


## cs-vancouver6

Vancouver, Canada IPv6 DNSCrypt server provided by https://cryptostorm.is/

sdns://AQcAAAAAAAAAFVsyYTAyOjU3NDA6MjQ6NDU6OjUzXSAxM3KtWVYywkFrhy8Jj4Ub3bllKExsvppPGQlkMNupWh4yLmRuc2NyeXB0LWNlcnQuY3J5cHRvc3Rvcm0uaXM


## dct-de

DNSCrypt | IPv4 only | Non-logging | Non-filtering | DNSSEC | Berlin, Germany.

sdns://AQcAAAAAAAAADzE5NC4xNjQuMTk0LjIxNiACT6z2dYj94msaKqctjIpBaeDHG2JVOfPTqDH_0KzZkBYyLmRuc2NyeXB0LWNlcnQuZGN0LWRl


## dct-fr

DNSCrypt | IPv4 only | Non-logging | Non-filtering | DNSSEC | Paris, France.

sdns://AQcAAAAAAAAADTE4NS4yNTMuNTQuNjIgDEozVZI02DFe_DtXEu4eGw6xIm0ijfq6Zxs2adJV2ucWMi5kbnNjcnlwdC1jZXJ0LmRjdC1mcg


## deffer-dns.au

DNSSEC/Non-logged/Uncensored in Sydney (AWS).
Encrypted DNS Server image by jedisct1, maintaned by DeffeR.

sdns://AQcAAAAAAAAADTUyLjY1LjIzNS4xMjkg5Q00RDDBkwx3fUaa0_etjz4iH3lLBOqsg95bYDmV07MdMi5kbnNjcnlwdC1jZXJ0LmRlZmZlci1kbnMuYXU


## digitalprivacy.diy-dnscrypt-ipv4

IPv4 server | No filter | No logs | DNSSEC | Nuremberg, Germany (netcup) | Maintained by https://digitalprivacy.diy/

sdns://AQcAAAAAAAAAEjM3LjIyMS4xOTQuODQ6NDQzNCCiyGRvm0TcyJmI7lTXstgh-8AoAAiFcTQQp7Od_brTYCIyLmRuc2NyeXB0LWNlcnQuZGlnaXRhbHByaXZhY3kuZGl5


## dns.digitale-gesellschaft.ch

Public DoH resolver operated by the Digital Society (https://www.digitale-gesellschaft.ch).
Hosted in Zurich, Switzerland.

Non-logging, non-filtering, supports DNSSEC.

sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDIgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDMgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5


## dns.digitale-gesellschaft.ch-ipv6

Public IPv6 DoH resolver operated by the Digital Society (https://www.digitale-gesellschaft.ch).
Hosted in Zurich, Switzerland.

Non-logging, non-filtering, supports DNSSEC.

sdns://AgcAAAAAAAAAD1syYTA1OmZjODQ6OjQyXSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBxkbnMuZGlnaXRhbGUtZ2VzZWxsc2NoYWZ0LmNoCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAD1syYTA1OmZjODQ6OjQzXSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBxkbnMuZGlnaXRhbGUtZ2VzZWxsc2NoYWZ0LmNoCi9kbnMtcXVlcnk


## dns.digitalsize.net

A public, non-tracking, non-filtering DNS resolver with DNSSEC enabled, QNAME minimization and no EDNS client subnet (https://dns.digitalsize.net).
Hosted in Germany.

sdns://AgcAAAAAAAAADjk0LjEzMC4xMzUuMjAzINYdluv7P6GQluLAAuNgO_f9qu-yJwTahmgGK76G7UuTE2Rucy5kaWdpdGFsc2l6ZS5uZXQKL2Rucy1xdWVyeQ


## dns.digitalsize.net-ipv6

A public, non-tracking, non-filtering DNS resolver with DNSSEC enabled, QNAME minimization and no EDNS client subnet (https://dns.digitalsize.net).
Hosted in Germany.

sdns://AgcAAAAAAAAAGVsyYTAxOjRmODoxM2I6MzQwNzo6ZmFjZV0g1h2W6_s_oZCW4sAC42A79_2q77InBNqGaAYrvobtS5MTZG5zLmRpZ2l0YWxzaXplLm5ldAovZG5zLXF1ZXJ5


## dns.sb

DoH server runned by xTom.com. No logs, no filtering, supports DNSSEC.

Homepage: https://dns.sb

sdns://AgcAAAAAAAAADzE4NS4yMjIuMjIyLjIyMiBxTYz1ZnaR2ko2iI9x2OF2TdwrFQh9ysFQPDks4-jgAA8xODUuMjIyLjIyMi4yMjIKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAACzQ1LjExLjQ1LjExIHFNjPVmdpHaSjaIj3HY4XZN3CsVCH3KwVA8OSzj6OAACzQ1LjExLjQ1LjExCi9kbnMtcXVlcnk


## dns4all-ipv4

A DoH resolver operated by sidnlabs.nl. No-logs, DNSSEC. Filters domains sanctioned by the EU.
Homepage: https://dns4all.eu

sdns://AgMAAAAAAAAACTE5NC4wLjUuMwAOZG9xLmRuczRhbGwuZXUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAACjE5NC4wLjUuNjQAEGRvcTY0LmRuczRhbGwuZXUKL2Rucy1xdWVyeQ


## dns4all-ipv6

A DoH resolver operated by sidnlabs.nl over IPv6. No-logs, DNSSEC. Filters domains sanctioned by the EU.
Homepage: https://dns4all.eu

sdns://AgMAAAAAAAAAD1syMDAxOjY3ODo4OjozXQAOZG9xLmRuczRhbGwuZXUKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAAEFsyMDAxOjY3ODo4Ojo2NF0AEGRvcTY0LmRuczRhbGwuZXUKL2Rucy1xdWVyeQ


## dns4eu

DNS4EU is a European Union-sponsored DNS infastructure project.

This is the unfiltered option.

Note: the service uses name servers from CloudNS, a European company, but
appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgcAAAAAAAAADDg2LjU0LjExLjEwMCCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBZ1bmZpbHRlcmVkLmpvaW5kbnM0LmV1Ci9kbnMtcXVlcnk


## dns4eu-ipv6

DNS4EU is a European Union-sponsored DNS infastructure project.

This is the unfiltered option.

It will be accessed over IPv6.

Note: the service uses name servers from CloudNS, a European company, but
appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgcAAAAAAAAAGVsyYTEzOjEwMDE6Ojg2OjU0OjExOjEwMF0gsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQWdW5maWx0ZXJlZC5qb2luZG5zNC5ldQovZG5zLXF1ZXJ5


## dns4eu-protective

This variant filters websites with fraudulent or malicious content.

Note: the service uses name servers from CloudNS, a European company, but
appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAACjg2LjU0LjExLjEgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQWcHJvdGVjdGl2ZS5qb2luZG5zNC5ldQovZG5zLXF1ZXJ5


## dns4eu-protective-ipv6

This variant filters websites with fraudulent or malicious content.

It will be accessed over IPv6.

Note: the service uses name servers from CloudNS, a European company, but
appears to rely significantly on non-EU infrastructure and service providers.

sdns://AgMAAAAAAAAAF1syYTEzOjEwMDE6Ojg2OjU0OjExOjFdILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0FnByb3RlY3RpdmUuam9pbmRuczQuZXUKL2Rucy1xdWVyeQ


## dnsbunker

A DNS resolver located in Germany.

Designed to block ads, malware, and surveillance. No logs.

https://dnsbunker.org

sdns://AgMAAAAAAAAADjE1Mi41My4yMDcuMTkxILTgqMmLCq5DtzgwN6zNEaHJZJcfa3T8vDcM0DD7Mo3dDWRuc2J1bmtlci5vcmcKL2Rucy1xdWVyeQ


## dnscry.pt-adelaide-ipv4

DNSCry.pt Adelaide - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE2My40Ny4xMTkuMTgyIJvE6sAeDFZzkpKZy9SFWlUunIB9NyaxQ7dSpX3_gCZ5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-adelaide-ipv6

DNSCry.pt Adelaide - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAJVsyNDAwOmM0MDE6MTAwMjoxMTpiZWU6Y2VlOjk1OGM6ODczYl0gm8TqwB4MVnOSkpnL1IVaVS6cgH03JrFDt1Klff-AJnkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-allendale-ipv4

DNSCry.pt Allendale - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDM4LjI0Ny4zLjEwNyAi9eUB5T3gcSitFeYv8NjxugJJpqqQLBdit8yf-lFZXRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-allendale-ipv6

DNSCry.pt Allendale - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmY3YTM6MDo1MjAwOjphXSAi9eUB5T3gcSitFeYv8NjxugJJpqqQLBdit8yf-lFZXRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-amsterdam-ipv4

DNSCry.pt Amsterdam - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5OC4xNDAuMTQxLjQ2IFqbafOxgXuKwOgYxQ6XUqHWkMUt_5LI2nDkdVFU5hm7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-amsterdam-ipv6

DNSCry.pt Amsterdam - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTAzOjk0ZTM6MjIyYjo6MTAzMl0gWptp87GBe4rA6BjFDpdSodaQxS3_ksjacOR1UVTmGbsZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam02-ipv4

DNSCry.pt Amsterdam 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1Ljg2LjE2Mi4xMTAgblxXPJozaH3d0T9h_69Op1nnYQYbW4yIWd8ypOORnK8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam02-ipv6

DNSCry.pt Amsterdam 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syYTA3OmVmYzA6MTAwMTphNWNlOjpiNGI0XSBuXFc8mjNofd3RP2H_r06nWedhBhtbjIhZ3zKk45GcrxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-amsterdam03-ipv4

DNSCry.pt Amsterdam 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjEzNy4yNDkuMjYgCA4-g3tus39pqm78_CoOc8byRBbLfuc5ceEiFNFWnN4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-amsterdam03-ipv6

DNSCry.pt Amsterdam 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjAyOmZjMjQ6MTI6OTg3Mzo6YWIxXSAIDj6De26zf2mqbvz8Kg5zxvJEFst-5zlx4SIU0Vac3hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ashburn-ipv4

DNSCry.pt Ashburn - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjc3LjI0Ny4xMjcuMTA3IJOWzrgz5XhvHJtWLbFAFhcg9_e11cQSpjMcGFMUsHxJGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ashburn-ipv6

DNSCry.pt Ashburn - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBhOjhkYzA6YTA2Nzo6YV0gk5bOuDPleG8cm1YtsUAWFyD397XVxBKmMxwYUxSwfEkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-athens-ipv4

DNSCry.pt Athens - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4NS4yMzQuNTIuODcg7sJacnOa_EK646WTMceomii6ew1ZjD2YPZq6T3cbAZYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-athens-ipv6

DNSCry.pt Athens - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA5OmNkNDM6Zjo0MmExOjo1XSDuwlpyc5r8QrrjpZMxx6iaKLp7DVmMPZg9mrpPdxsBlhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-atlanta-ipv4

DNSCry.pt Atlanta - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3MC4yNDkuMjM3LjE1NCDi7_UCIU8-uBI-dM7qpE0Y0Qo8GpJTDcSX578fvK7jOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-atlanta-ipv6

DNSCry.pt Atlanta - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAwOjRjMDA6ODA6ODo6YV0g4u_1AiFPPrgSPnTO6qRNGNEKPBqSUw3El-e_H7yu4zoZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-auckland-ipv4

DNSCry.pt Auckland - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS45OS4xMzMuMTEyIBWQZQSuMzmL_YANsdr26wFOHmJCYEtA2P2JI6w1-0ezGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-auckland-ipv6

DNSCry.pt Auckland - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHFsyYTA2OjEyODA6YmVlMToyOjplZTEyOjIwOF0gFZBlBK4zOYv9gA2x2vbrAU4eYkJgS0DY_YkjrDX7R7MZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-baku-ipv4

DNSCry.pt Baku - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4MC4xNDkuNDQuMjIgzFqKs9NlDJYf28HgAJmVod3LGm6J7S5RqKIX639xBoYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-baku-ipv6

DNSCry.pt Baku - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAzOjkwYzA6MTk1Ojo5MV0gzFqKs9NlDJYf28HgAJmVod3LGm6J7S5RqKIX639xBoYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bangkok-ipv4

DNSCry.pt Bangkok - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4zOC4yNTAuNTUgmyEE_QCPk3imzvq1TSrfaxT0J9tVNtTMZhj4ImtEIC0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bangkok-ipv6

DNSCry.pt Bangkok - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syMDAxOmRmMTo4OGMwOjIwMDo6MTRdIJshBP0Aj5N4ps76tU0q32sU9CfbVTbUzGYY-CJrRCAtGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-barcelona-ipv4

DNSCry.pt Barcelona - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzQ2LjI4LjcxLjUyIBs2p0t-oLFUHVS5zHeDdaphgwku_vIv97hyz9I47Nk7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-barcelona-ipv6

DNSCry.pt Barcelona - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTEyOjZmYzQ6ODAwMDo6ODldIBs2p0t-oLFUHVS5zHeDdaphgwku_vIv97hyz9I47Nk7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bengaluru-ipv4

DNSCry.pt Bengaluru - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xOTEuMTgyLjIxNiDM3lhIXzCtFbHampFM4K_NDUnKalgxd72L-5ye1X4qExkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bengaluru-ipv6

DNSCry.pt Bengaluru - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyNDAxOmQ0ZTA6MTpmN2ZkOjo1M10gzN5YSF8wrRWx2pqRTOCvzQ1JympYMXe9i_ucntV-KhMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-berkeleysprings-ipv4

DNSCry.pt Berkeley Springs - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5My40Mi4yNDYuMTA4IG5N2yfzGMQ1q8RRYo9wan2kMr83Ce2OkCMpO8LYUi2kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-berkeleysprings-ipv6

DNSCry.pt Berkeley Springs - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6Mzc6MTo6Yzk4NDo0YmEzXSBuTdsn8xjENavEUWKPcGp9pDK_NwntjpAjKTvC2FItpBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bogota-ipv4

DNSCry.pt Bogotá - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy41Ny4yNTAuNTQgGczZZmZn2G8wpYy_sRNY7bSEhs8NX7LYbgXPgpAF-4oZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-bogota-ipv6

DNSCry.pt Bogotá - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAzOmY4MDo1Nzo5OGIxOjoxXSAZzNlmZmfYbzCljL-xE1jttISGzw1fsthuBc-CkAX7ihkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bratislava-ipv4

DNSCry.pt Bratislava - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjk1LjEzMS4yMDIuMTA1ICNqYnU4LMuHNFVgCP5Zn1414WbRxXWqmbQoFp-KjKepGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bratislava-ipv6

DNSCry.pt Bratislava - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTA1OjU1MDI6OjU5MDY6OTdmODoyZDBlOjFdICNqYnU4LMuHNFVgCP5Zn1414WbRxXWqmbQoFp-KjKepGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-brisbane-ipv4

DNSCry.pt Brisbane - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQzLjIyNC4xODAuMTM3IB3DhQdApTRyuMIvRSQEdBBZ3zMUZPTPK9hsuS3Nq7c5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-brisbane-ipv6

DNSCry.pt Brisbane - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAIlsyNDA0Ojk0MDA6MTowOjIxNjozZWZmOmZlZjY6NzE5NF0gHcOFB0ClNHK4wi9FJAR0EFnfMxRk9M8r2Gy5Lc2rtzkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-brussels-ipv4

DNSCry.pt Brussels - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5Mi4xMjEuMTcwLjE1MSAT1-NSdE3OfjoVPgHNxNnBX5TUCfS8OtUxrRV9UpJZBxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-brussels-ipv6

DNSCry.pt Brussels - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAzOmY4MDozMjo1MmQ5OjoxXSAT1-NSdE3OfjoVPgHNxNnBX5TUCfS8OtUxrRV9UpJZBxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-bucharest-ipv4

DNSCry.pt Bucharest - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS45My4yMjEuMTY3IM1gfKbFYfG7eLZj6F7rEF7PGZC7Tl2D_LD9v8cmoW1kGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-bucharest-ipv6

DNSCry.pt Bucharest - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTBkOjllYzI6MDpmMDNkOjpjNDllXSDNYHymxWHxu3i2Y-he6xBezxmQu05dg_yw_b_HJqFtZBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-budapest-ipv4

DNSCry.pt Budapest - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5My4yMDEuMTg1LjE0NiBdvi050Zmb0yESkHlDex2F8myjvbUF0hLsH0YB9jIPjxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-budapest-ipv6

DNSCry.pt Budapest - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTAxOjZlZTA6MTo6ZmZmZjpiYWVdIF2-LTnRmZvTIRKQeUN7HYXybKO9tQXSEuwfRgH2Mg-PGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-calgary-ipv4

DNSCry.pt Calgary - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjEzMy42NC4xMjEgbJWMdhm3m3L0MIztiezBT4P4H5YobsrhNoVKl3JcBa0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-calgary-ipv6

DNSCry.pt Calgary - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyNjAyOmZlZDI6ZmUwOjI4Mzo6MV0gbJWMdhm3m3L0MIztiezBT4P4H5YobsrhNoVKl3JcBa0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-capetown-ipv4

DNSCry.pt Cape Town - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMi4yMTYuNzkuMjM3IJeYEgmw0_mHXWlOVJhedHpxLeu21h-A31qF-WEQd1UpGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-capetown-ipv6

DNSCry.pt Cape Town - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYzBmOmVmMTg6OWZmZjoxOmJmZjo6YV0gl5gSCbDT-YddaU5UmF50enEt67bWH4DfWoX5YRB3VSkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-capetown02-ipv4

DNSCry.pt Cape Town 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xMTkuMjMzLjI0NSCTQusYfmQsz9gFttgE8_3ul6EewFvX-ADgVYrMeEa_oxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-capetown02-ipv6

DNSCry.pt Cape Town 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYzBmOmYwMzA6MTAwMDoyMzM6OjI0NV0gk0LrGH5kLM_YBbbYBPP97pehHsBb1_gA4FWKzHhGv6MZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chicago-ipv4

DNSCry.pt Chicago - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjQxLjIwNC4yMDQgbQ_3dUnLx_3R3UeHibflzQIDKCqMGcViiAPftt2eDbIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chicago-ipv6

DNSCry.pt Chicago - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAH1syNjAyOmZlYTc6ZTBjOmU6YmZmOjY6NzA6MTk0Y10gbQ_3dUnLx_3R3UeHibflzQIDKCqMGcViiAPftt2eDbIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-chisinau-ipv4

DNSCry.pt Chișinău - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE3Ni4xMjMuMTAuMTA1IEJtkG567ZvN_tTXhVcSyywcrDRhziwxmbnyohp5u8gPGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-chisinau-ipv6

DNSCry.pt Chișinău - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyMDAxOjY3ODo2ZDQ6NTA4MDo6M2RlYToxMDldIEJtkG567ZvN_tTXhVcSyywcrDRhziwxmbnyohp5u8gPGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-copenhagen-ipv4

DNSCry.pt Copenhagen - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5Mi4xMjEuMTE5LjE5IPMMGZXMQPoEo3KJ0yo8OVLp0jhi3Betxpxazt5hwpuKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-copenhagen-ipv6

DNSCry.pt Copenhagen - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAI1syMDAxOjY3YzpiZWM6Yjo0M2E6MWFmZjpmZWIxOmViNWRdIPMMGZXMQPoEo3KJ0yo8OVLp0jhi3Betxpxazt5hwpuKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-coventry-ipv4

DNSCry.pt Coventry - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjE1NS4zNy4xNjUgYEA416mXWNYoWStCKdnM315FgosLrba3F2QBhYR_SZAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-coventry-ipv6

DNSCry.pt Coventry - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTBkOmQ4YzA6MDpmMDQzOjo2OTI3XSBgQDjXqZdY1ihZK0Ip2czfXkWCiwuttrcXZAGFhH9JkBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-dallas-ipv4

DNSCry.pt Dallas - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjIzMC4yNTMuOTgg1OKRDMWAtnBoieTPNbjK-OrVjcuML2vQMc6gh-ZmYpAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dallas-ipv6

DNSCry.pt Dallas - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmZiOTQ6MTozOTo6YV0g1OKRDMWAtnBoieTPNbjK-OrVjcuML2vQMc6gh-ZmYpAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-denver-ipv4

DNSCry.pt Denver - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzIxNi4xMjAuMjAxLjEwNSD_srgVun60gzUrte8QS0YJAqSBHZ_X6PpY_bOU1eMegxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-denver-ipv6

DNSCry.pt Denver - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6NjpmMDE2OjozYTI1XSD_srgVun60gzUrte8QS0YJAqSBHZ_X6PpY_bOU1eMegxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-detroit-ipv4

DNSCry.pt Detroit - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDY2LjE4Ny43LjE0MCBpn2OKcwbE01MLSkSXcaPKLf8IOmKbuE9GGZvAOBwaNRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-detroit-ipv6

DNSCry.pt Detroit - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAI1syNjA2OjY1YzA6NDA6NDo1ZjM6NTRjNDo4ZDEwOjliOThdIGmfY4pzBsTTUwtKRJdxo8ot_wg6Ypu4T0YZm8A4HBo1GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-dhaka-ipv4

DNSCry.pt Dhaka - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xNzQuNTEuNzEgJb3-qelH318uGaZ6Kh3u586eQ6d1Szyyr8fo_lm78kAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dhaka-ipv6

DNSCry.pt Dhaka - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyMDAxOmRmMTo4ZjQwOjUxOjphXSAlvf6p6UffXy4ZpnoqHe7nzp5Dp3VLPLKvx-j-WbvyQBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-dublin-ipv4

DNSCry.pt Dublin - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4yNi4yMTMuMTUgEzWgsAQfbmA1ppXryEJ6vQ3Vvc2Kk2oRkdjodTEYvPQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dublin-ipv6

DNSCry.pt Dublin - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA5OmNkNDY6Zjo0MjllOjo1XSATNaCwBB9uYDWmlevIQnq9DdW9zYqTahGR2Oh1MRi89BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-durham-ipv4

DNSCry.pt Durham - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDM4LjQ1LjY0LjExNyAS3jjOGrb2p9i5bpMiO0WB-XlTLq7Ek3soP2xndELQ8xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-durham-ipv6

DNSCry.pt Durham - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyMDAxOjU1MDo1YTAwOjVlYjo6ZGI1OmZhY2VdIBLeOM4atvan2LlukyI7RYH5eVMursSTeyg_bGd0QtDzGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-dusseldorf-ipv4

DNSCry.pt Düsseldorf - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTUuMTc1LjE4MC4xNzEg_5w5GH6bnmpKPcqtR58x5VHe2qD5-mSZeGIsqaukhr4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf-ipv6

DNSCry.pt Düsseldorf - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTBmOjYyODQ6NDMwMDoxMDE6OjEyYTVdIP-cORh-m55qSj3KrUefMeVR3tqg-fpkmXhiLKmrpIa-GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-dusseldorf02-ipv6

DNSCry.pt Düsseldorf 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTA2OmRlMDA6NDAxOjIyNzo6Ml0gWAo_MyYybZGGBQKsA41WpC5TjjpfvgviHteGEKBXNIwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-dusseldorf03-ipv6

DNSCry.pt Düsseldorf 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyYTBkOmQ5MDA6MTEwOjpdIAVTncRFpBvclMmr4gGgmzyTKgBt-liv61S5GLykqgoMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ebenecity-ipv4

DNSCry.pt Ebène City - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMi4yMjIuMTA2Ljk2INVM0KkXMpdK3U9cM5QmkFEp4C4EYK9p7td1k0eTupPHGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ebenecity-ipv6

DNSCry.pt Ebène City - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAH1syYzBmOmU4Zjg6MjAwMDoyMzM6OjQyNTQ6YzViMl0g1UzQqRcyl0rdT1wzlCaQUSngLgRgr2nu13WTR5O6k8cZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ebenecity02-ipv4

DNSCry.pt Ebène City 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE5Ni40Ni41MC45MyCvOC_dXQNKuRJd-tsXi_v7zzQpqJumDnGU0NP-zaCcOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ebenecity02-ipv6

DNSCry.pt Ebène City 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyMDAxOjQ3MDoxZjIzOjEzOTo6YjpiXSCvOC_dXQNKuRJd-tsXi_v7zzQpqJumDnGU0NP-zaCcOhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-eygelshoven-ipv4

DNSCry.pt Eygelshoven - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDkzLjk1LjExNS4yMSDit1FyUAiu0W-x936EJIC1keajbwu1pvb6yVKVj0KVYhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-eygelshoven-ipv6

DNSCry.pt Eygelshoven - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADlsyYTEwOmNhODA6OmFdIOK3UXJQCK7Rb7H3foQkgLWR5qNvC7Wm9vrJUpWPQpViGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-flint-ipv4

DNSCry.pt Flint - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE0Ny4xODkuMTQwLjEzNiCL7wgLXnE-35sDhXk5N1RNpUfWmM2aUBcMFlst7FPdnRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-flint-ipv6

DNSCry.pt Flint - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6Mjk6MTo6NTg1OTphMzdiXSCL7wgLXnE-35sDhXk5N1RNpUfWmM2aUBcMFlst7FPdnRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-frankfurt-ipv4

DNSCry.pt Frankfurt - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjgyLjEyMC42MSD79MPkuIliP7zrXMgYVK5wcSD_shP7dPfHx9haFaux6RkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-frankfurt-ipv6

DNSCry.pt Frankfurt - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBlOjZhODA6Mzo2Njk6Ol0g-_TD5LiJYj-861zIGFSucHEg_7IT-3T3x8fYWhWrsekZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-frankfurt02-ipv4

DNSCry.pt Frankfurt 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjE0Ny41MS4xMjMgIXwiAp3nzMSapyRop7AbWNG8rFfD1aGhvvGSXFdfv24ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-frankfurt02-ipv6

DNSCry.pt Frankfurt 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTA3OmQ4ODQ6MTAwOjozNDRdICF8IgKd58zEmqckaKewG1jRvKxXw9Whob7xklxXX79uGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-fremont02-ipv4

DNSCry.pt Fremont 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE2Ny44OC40OC4xOCDXa6t5njAKDHZ2JWPfQ-9XAbho3aZHomYynHy8m3QnThkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-fremont02-ipv6

DNSCry.pt Fremont 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjAyOmZlZDI6NzE5ODo3YWYxOjoxXSDXa6t5njAKDHZ2JWPfQ-9XAbho3aZHomYynHy8m3QnThkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-fujairah-ipv4

DNSCry.pt Fujairah - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDg5LjM2LjE2Mi43NiDhNU1G5oyXWHrkOlA7LmNa-C048h7_M6KXGUqx2sitsBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-fujairah-ipv6

DNSCry.pt Fujairah - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAJ1syYTA2OmY5MDI6NDAwMToxMDA6OTAwMDo5MDAwOmY5MGI6M2VhXSDhNU1G5oyXWHrkOlA7LmNa-C048h7_M6KXGUqx2sitsBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-gdansk-ipv4

DNSCry.pt Gdańsk - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgyLjExOC4yMS4xODkgqFjzKHAuUbpDR2JSbSp7myEtbvT4E4MX5CczpKEWt4UZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-gdansk-ipv6

DNSCry.pt Gdańsk - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDQ6Ojg5OV0gqFjzKHAuUbpDR2JSbSp7myEtbvT4E4MX5CczpKEWt4UZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-geneva-ipv4

DNSCry.pt Geneva - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjkwLjU5LjE5MyApCKLNC-QxtyiyCC4AQIb36KxxFcalmSGG9V_CLDDyVxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-geneva-ipv6

DNSCry.pt Geneva - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDY6OmFlMV0gKQiizQvkMbcosgguAECG9-iscRXGpZkhhvVfwiww8lcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-grandrapids-ipv4

DNSCry.pt Grand Rapids - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xNjUuNDQuMTY0IIAGv2tc1niHTIQfcnX5-ElHTfAJySTEfHKDgxBlM4O9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-grandrapids-ipv6

DNSCry.pt Grand Rapids - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmY5NjQ6MToyNDo6YV0ggAa_a1zWeIdMhB9ydfn4SUdN8AnJJMR8coODEGUzg70ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-guayaquil-ipv4

DNSCry.pt Guayaquil - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzIwNS4yMzUuMi4zID9X9sX_gCLkkxrgySVVTlO7BLd1b5CT1YoAp_W8jNsvGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-guayaquil-ipv6

DNSCry.pt Guayaquil - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyODAzOmMzMTA6ZmYwMjozYjE0OjoxXSA_V_bF_4Ai5JMa4MklVU5TuwS3dW-Qk9WKAKf1vIzbLxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hafnarfjordur-ipv4

DNSCry.pt Hafnarfjordur - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5Mi43MS4yMTguMTIxIDvH8Abx1KvD57UbwdFAZO0i7FlRjk9HkQUFyT0k1LbSGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hafnarfjordur-ipv6

DNSCry.pt Hafnarfjordur - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTAzOmY4MDozNTQ6MzZhMTo6MV0gO8fwBvHUq8PntRvB0UBk7SLsWVGOT0eRBQXJPSTUttIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-halifax-ipv4

DNSCry.pt Halifax - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE5MS44MC40MyCcn0gUE1BHqKv8Nwyv454nRdFBh7XysXqqIFgEgFMfMhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-halifax-ipv6

DNSCry.pt Halifax - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZjMWM6ZmEwOjI5OjoxXSCcn0gUE1BHqKv8Nwyv454nRdFBh7XysXqqIFgEgFMfMhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hanoi-ipv4

DNSCry.pt Hanoi - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xOTkuMTYuOTMg6iF-oJet7zyL2odP--IayA5Wrz6t94RPc7PXF53V82cZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hanoi-ipv6

DNSCry.pt Hanoi - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNDA0OmZiYzA6MDoxMWM4OjphMzI0XSDqIX6gl63vPIvah0_74hrIDlavPq33hE9zs9cXndXzZxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-helsinki-ipv4

DNSCry.pt Helsinki - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjM3LjIyOC4xMjkuMTYwIPlYPWSML8DlYbkp1ycL3CBER_3aJHp7GLvX_TRvbojGGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-helsinki-ipv6

DNSCry.pt Helsinki - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OjE3MDA6MTozYTo6Y2JhXSD5WD1kjC_A5WG5KdcnC9wgREf92iR6exi71_00b26IxhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hongkong-ipv4

DNSCry.pt Hong Kong - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzk2LjkuMjI4LjI3ICMJK8RA3cOKDpDZjSR9PqVXj2mGf43CHMa6fO7ZzCWmGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong-ipv6

DNSCry.pt Hong Kong - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyMDAxOmRmMTo4MDE6YTAyMjo6YzQ6YV0gIwkrxEDdw4oOkNmNJH0-pVePaYZ_jcIcxrp87tnMJaYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hongkong02-ipv6

DNSCry.pt Hong Kong 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZhNjc6MTAxOjFkOjphXSARmtgpOf59ywLMnKON-FTF_DTHPo4LkCQt_i2_JDZEZBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-hongkong03-ipv4

DNSCry.pt Hong Kong 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQ1LjEyMy4xODguMTI5IAtxIfzDy0d11GLJHr7HPkdtPwGbimmNUM0gUa0gfjHIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hongkong03-ipv6

DNSCry.pt Hong Kong 03 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNDA2OjQzMDA6YmFlOjZiMDg6OjFdIAtxIfzDy0d11GLJHr7HPkdtPwGbimmNUM0gUa0gfjHIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-houston-ipv4

DNSCry.pt Houston - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIwOS4xMzUuMTcwLjUxIPSBxTHLVPyC6r5TAAsl-mj-phfwQypedBkfja2kZ4yMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-houston-ipv6

DNSCry.pt Houston - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjAyOmY5ZjM6MDoyOjoxOTNdIPSBxTHLVPyC6r5TAAsl-mj-phfwQypedBkfja2kZ4yMGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-hudiksvall-ipv4

DNSCry.pt Hudiksvall - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTk1LjE0My4xOTYuMTYgN-023_u1yfCZ1TutJJBNC1uM4lZOrlklDvYGy1BFWdIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-hudiksvall-ipv6

DNSCry.pt Hudiksvall - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYTAzOmQ3ODA6MDoxOTY6OjM6NTZhZl0gN-023_u1yfCZ1TutJJBNC1uM4lZOrlklDvYGy1BFWdIZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ikeja-ipv4

DNSCry.pt Ikeja - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE2Ny44OC41MS4yNDUgguLn-RnYHhHkgS3ScOYQgjt31X6KEyKwkBMXpS_gBoQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ikeja-ipv6

DNSCry.pt Ikeja - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyYTAxOmUyODE6YWMwMTpmZDBkOjoxXSCC4uf5GdgeEeSBLdJw5hCCO3fVfooTIrCQExelL-AGhBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-indianapolis-ipv4

DNSCry.pt Indianapolis - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIzLjE2OC4xMzYuMTQ0ILqgPhElxsX559lZkTVLRzyhORvg9vq6WOEZ8NemWLN8GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-indianapolis-ipv6

DNSCry.pt Indianapolis - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjAyOmY5YmQ6ODA6MTE6OmFdILqgPhElxsX559lZkTVLRzyhORvg9vq6WOEZ8NemWLN8GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-islamabad-ipv4

DNSCry.pt Islamabad - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy45OS4xMzMuMTEwIFPjUb1Byf1Q1sjfnNHrBCXbDr7mAHAw49_8PNpk5kiEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-islamabad-ipv6

DNSCry.pt Islamabad - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyMDAxOmRmMjpkNDA6Mjk6OjJdIFPjUb1Byf1Q1sjfnNHrBCXbDr7mAHAw49_8PNpk5kiEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-istanbul-ipv4

DNSCry.pt Istanbul - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE4OC4xMzIuMTkyLjE2OCBcrSjt8C0Ztuqwxafp4VzylDf9N_disPrgL1m4GNX6XRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-istanbul-ipv6

DNSCry.pt Istanbul - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTEyOmUzNDI6MzAwOjpkYWNhOjYzZWFdIFytKO3wLRm26rDFp-nhXPKUN_0392Kw-uAvWbgY1fpdGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-jacksonville-ipv4

DNSCry.pt Jacksonville - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwNC4yMjUuMTI5LjEwNiAKQZEj8OAMOEB3ZaY36Jovz59wKeyFhBAMV6eOK384rhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-jacksonville-ipv6

DNSCry.pt Jacksonville - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6NDpmMDAzOjplYzMyXSAKQZEj8OAMOEB3ZaY36Jovz59wKeyFhBAMV6eOK384rhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-jakarta-ipv4

DNSCry.pt Jakarta - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE1MS4yNDMuMjIyLjk0IMp-kt2QTVeHxfHuzsBm8Y-j_LnTTldhKbHfA61KITsfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-jakarta-ipv6

DNSCry.pt Jakarta - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyNDA3OjZhYzA6Mzo1OjEyMzQ6NDMyMTo4OToxXSDKfpLdkE1Xh8Xx7s7AZvGPo_y5005XYSmx3wOtSiE7HxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-jena-ipv4

DNSCry.pt Jena - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzgxLjcuMTEuMjQ2IBvtASWQpVAO2tlQ273LY_mPl7f-D2JbYcoAHt14hJVBGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-jena-ipv6

DNSCry.pt Jena - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAyOjE4MDo2OjE6OjhiNF0gG-0BJZClUA7a2VDbvctj-Y-Xt_4PYlthygAe3XiElUEZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-johannesburg-ipv4

DNSCry.pt Johannesburg - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2OS4yMzkuMTI4LjEyNCDPBt-20rnrKqM3G3-ZKudPSvU9-zClzYY5-F2KRJSgsBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-johannesburg-ipv6

DNSCry.pt Johannesburg - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYzBmOmY1MzA6OmQwMDoxODhdIM8G37bSuesqozcbf5kq509K9T37MKXNhjn4XYpElKCwGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-johannesburg02-ipv4

DNSCry.pt Johannesburg 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2MC4xMTkuMjM0LjE1NiAFeFrCOd-Rm2fijlXta1tVv6IZudJxcJLtf4ReuGpInBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-johannesburg02-ipv6

DNSCry.pt Johannesburg 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYzBmOmYwMzA6NjA4MDoxOjoxNTZdIAV4WsI535GbZ-KOVe1rW1W_ohm50nFwku1_hF64akicGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-johor-ipv4

DNSCry.pt Johor - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTQ1LjI0OS45MS4xNTAgHONiOhMA1VOPBBcvrkvy9IW-Q0dhA1aY-g5rKbpy9noZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-johor-ipv6

DNSCry.pt Johor - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyMDAxOmRmNDoxODQwOjlmOjphXSAc42I6EwDVU48EFy-uS_L0hb5DR2EDVpj6DmspunL2ehkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-kansascity-ipv4

DNSCry.pt Kansas City - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIzLjE1MC40MC4xMjEgQprQrFLF3Y2975ylDjnD8kdKAJLUvauubVrBGueEkcgZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kansascity-ipv6

DNSCry.pt Kansas City - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyNjAyOjJiNzpkMDE6YzI5NTo6YjoxOF0gQprQrFLF3Y2975ylDjnD8kdKAJLUvauubVrBGueEkcgZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kyiv-ipv4

DNSCry.pt Kyiv - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIxNy4xMi4yMjEuNjEgskgLubDTWs4bK9zH1IXKRYSylrG8XVPGWMJpUM37vwUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kyiv-ipv6

DNSCry.pt Kyiv - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTAyOjI3YWQ6OjIwMV0gskgLubDTWs4bK9zH1IXKRYSylrG8XVPGWMJpUM37vwUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-kyiv02-ipv4

DNSCry.pt Kyiv 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xMjYuMjU1LjMwIEIlrpRjjslwYRvDmYBYK2kQydPruVX2Q7UZ1wndsrOwGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-kyiv02-ipv6

DNSCry.pt Kyiv 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAxOmY1MDA6MjoxNTAwOjphXSBCJa6UY47JcGEbw5mAWCtpEMnT67lV9kO1GdcJ3bKzsBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lagos-ipv4

DNSCry.pt Lagos - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE3Ni45Ny4xOTIuMTIgcCgpSUHINZEdZRhbgwLZOUR6fOPJU5L4bY9g88TbNusZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-lagos-ipv6

DNSCry.pt Lagos - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAH1syYTA2OmY5MDE6NDAwMToxMDA6OjJkNmM6NzM2YV0gcCgpSUHINZEdZRhbgwLZOUR6fOPJU5L4bY9g88TbNusZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-lasvegas-ipv4

DNSCry.pt Las Vegas - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzY2LjE4Ny40LjM5IKRyCGsVY-zFWu2VBI5UX4ItKdMFTZTubX8xHnY7u0KLGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lasvegas-ipv6

DNSCry.pt Las Vegas - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAJVsyNjA2OjY1YzA6MTA6MTVkOjkyZTA6YzdlNTpiNTc6NWIwMF0gpHIIaxVj7MVa7ZUEjlRfgi0p0wVNlO5tfzEedju7QosZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-libertylake-ipv4

DNSCry.pt Liberty Lake - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE4NC40OC4xOSCwg3q2XK6z70eHJhi0H7whWQ_ZWQylhMItvqKpd9GtzRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-libertylake-ipv6

DNSCry.pt Liberty Lake - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjAyOmZjMjQ6MTg6MzNmMjo6YWIxXSCwg3q2XK6z70eHJhi0H7whWQ_ZWQylhMItvqKpd9GtzRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lima02-ipv4

DNSCry.pt Lima 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDg3LjEyMS45OS4yMyBLyNV6BQU_iwNJcoib09jF8sIn-ucAJBLfUIuXHZQD1hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lima02-ipv6

DNSCry.pt Lima 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAzOjkwYzA6NTU1Ojo3Ml0gS8jVegUFP4sDSXKIm9PYxfLCJ_rnACQS31CLlx2UA9YZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-lisbon-ipv4

DNSCry.pt Lisbon - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE0My4yMC4xMi4zMiCptEWfvxpDpSX_nr_GMuH01abYaJsHdFswBbbAEI9aSxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lisbon-ipv6

DNSCry.pt Lisbon - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTBmOmM0NDI6ODAwMDo6MzJdIKm0RZ-_GkOlJf-ev8Yy4fTVpthomwd0WzAFtsAQj1pLGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-lisbon02-ipv4

DNSCry.pt Lisbon 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDkxLjIwOS4xNi45OCAGvEQ0hj1cw5V6NbFAljIPcHjo22MzFVFq2cpPXKKu5BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-lisbon02-ipv6

DNSCry.pt Lisbon 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAD1syYTBmOmM0NDQ6Ojk4XSAGvEQ0hj1cw5V6NbFAljIPcHjo22MzFVFq2cpPXKKu5BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ljubljana-ipv4

DNSCry.pt Ljubljana - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDkxLjEzMi45NC45OCACvBJyHsVWMWuLmBwYaIeKVinb5d_crmke9J6x-r52NhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ljubljana-ipv6

DNSCry.pt Ljubljana - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFlsyYTAzOmY4MDozODY6YjdmNjo6MV0gArwSch7FVjFri5gcGGiHilYp2-Xf3K5pHvSesfq-djYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-london-ipv4

DNSCry.pt London - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg0LjEzMiCPZtxEvrtixgzqLZkrkl_-HL7-Cau2YUCEF2vb8sox7hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-london-ipv6

DNSCry.pt London - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjgzNjA6YTI6NDo6YV0gj2bcRL67YsYM6i2ZK5Jf_hy-_gmrtmFAhBdr2_LKMe4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-losangeles-ipv4

DNSCry.pt Los Angeles - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNC4xNTYuMTU0LjExIED6lUqafS2hgKJM7y56Ban4s50FPfMiamoZXHGKqfhBGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-losangeles-ipv6

DNSCry.pt Los Angeles - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6NzpkOjphXSBA-pVKmn0toYCiTO8uegWp-LOdBT3zImpqGVxxiqn4QRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-losangeles02-ipv4

DNSCry.pt Los Angeles 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNC4yMDAuNjcuMTk0IIhxeSuGQHwchZdstQqcoKD_RAuV4w8Qr_1XmXFZucGEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-losangeles02-ipv6

DNSCry.pt Los Angeles 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syNjAyOmZmNzU6NzpiNzk6OmI0YjRdIIhxeSuGQHwchZdstQqcoKD_RAuV4w8Qr_1XmXFZucGEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-luxembourg-ipv4

DNSCry.pt Luxembourg - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjgwLjIwOS41NSBRqTRnzxNNFAm2RL2O30OikS0iH19NmFv0HfSfn7-8NBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-luxembourg-ipv6

DNSCry.pt Luxembourg - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAzOjkwYzA6ODU6OjEwMl0gUak0Z88TTRQJtkS9jt9DopEtIh9fTZhb9B30n5-_vDQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-madrid-ipv4

DNSCry.pt Madrid - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTUuMTM0LjExOC4xOTggF4pp6ab33hO4Nb9tp8zuU8Drkh2GcvzYZikut4DIHN8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-madrid-ipv6

DNSCry.pt Madrid - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syYTAzOmM3YzA6NTI6MjY0MToxODA6OjEzXSAXimnppvfeE7g1v22nzO5TwOuSHYZy_NhmKS63gMgc3xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-manchester-ipv4

DNSCry.pt Manchester - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIxNi4yNDUuMTQwLjIwIOUvdbEOhupyl3_MymoToO-zVeHubT5q6UveXcvkAHAzGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-manchester-ipv6

DNSCry.pt Manchester - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBhOjhkYzA6NjA1ODo6YV0g5S91sQ6G6nKXf8zKahOg77NV4e5tPmrpS95dy-QAcDMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-manila-ipv4

DNSCry.pt Manila - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4zOC4yNTEuNjAgtl072_HRTx7d__K5Jbpk-wstWHE2EtNZfxWvDIzr-aoZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-manila-ipv6

DNSCry.pt Manila - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNDAxOmYyZTA6MDoxMDI6OjE0XSC2XTvb8dFPHt3_8rklumT7Cy1YcTYS01l_Fa8MjOv5qhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-marseille-ipv4

DNSCry.pt Marseille - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjQ1LjE0MC4xNjQuMTI3IM3cVPGKJ3KsfAsDGsEDpItjlU2H7A9I0igL0qYzpoqjGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-marseille-ipv6

DNSCry.pt Marseille - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTA2OmU4ODE6NzAwMDo6Yjg1Mzo0OTVdIM3cVPGKJ3KsfAsDGsEDpItjlU2H7A9I0igL0qYzpoqjGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-melbourne-ipv4

DNSCry.pt Melbourne - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMDguMjI4LjE1ILAWh1FyQgZtjFxK9KuFzaJfUBQpjrxnlDNMaUiEo5UWGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-melbourne-ipv6

DNSCry.pt Melbourne - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAyOjczNDA6ODAwMDo6NV0gsBaHUXJCBm2MXEr0q4XNol9QFCmOvGeUM0xpSISjlRYZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-miami-ipv4

DNSCry.pt Miami - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEyOC4yNTQuMjA3LjUwIIOGZgtvk9SmJ8GODlVlvGnZKIbEK66_WlJnYWU6rED7GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-miami-ipv6

DNSCry.pt Miami - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6NjphOjphXSCDhmYLb5PUpifBjg5VZbxp2SiGxCuuv1pSZ2FlOqxA-xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-milan-ipv4

DNSCry.pt Milan - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgyLjExOC4xNi4xMjEguySFBuKaH6g5ZUYPPs59A9TRvbZUDtnj_NPoHOXQ0oAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-milan-ipv6

DNSCry.pt Milan - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAyOjI3YWU6ODAwMDo6MmExXSC7JIUG4pofqDllRg8-zn0D1NG9tlQO2eP80-gc5dDSgBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-molln-ipv4

DNSCry.pt Mölln - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTkxLjEwOC44MC4xNTkgMM6jepDoFl1PnnXwNjbqe-V8hUotmrrq7KhwJbik6A0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-molln-ipv6

DNSCry.pt Mölln - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTA1OjkwMTo2OjEwNDg6Ol0gMM6jepDoFl1PnnXwNjbqe-V8hUotmrrq7KhwJbik6A0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-montreal-ipv4

DNSCry.pt Montreal - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE0Ny4xODkuMTM2LjE4MyCsCFB6EkMJdZLQ-IlsBbtjtSlasCfsTx7Q6u0bOI8OwBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-montreal-ipv6

DNSCry.pt Montreal - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyNjA2OjY2ODA6NDU6MTo6Zjc4Yzo5YjBdIKwIUHoSQwl1ktD4iWwFu2O1KVqwJ-xPHtDq7Rs4jw7AGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-moscow-ipv4

DNSCry.pt Moscow - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjkzLjE4My4xMDYuMjIyIBQ6uCceRUNVJGFB1kGltuW_Jr2Nsizvc06BfMI30iIBGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-moscow-ipv6

DNSCry.pt Moscow - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyYTAzOmUzNDA6MzozOjoxXSAUOrgnHkVDVSRhQdZBpbblvya9jbIs73NOgXzCN9IiARkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-mumbai-ipv4

DNSCry.pt Mumbai - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMTEuMTE0LjI1IENdCfc5GHRGIG-JtMeIw2cVTN1nHG4kan0vc_aonHWDGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-mumbai-ipv6

DNSCry.pt Mumbai - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAH1syYTA2OmY5MDI6ODAwMToxMDA6OjE3NTc6ZTYxN10gQ10J9zkYdEYgb4m0x4jDZxVM3WccbiRqfS9z9qicdYMZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-mumbai02-ipv4

DNSCry.pt Mumbai 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE2NS45OS45LjIwOSCWqeT_u1nn0f3mZBAXCN7K40kyMWyMgma2VqLqJhijIhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-mumbai02-ipv6

DNSCry.pt Mumbai 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyNjAyOmZhMDg6NTo6NzVdIJap5P-7WefR_eZkEBcI3srjSTIxbIyCZrZWouomGKMiGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-munich-ipv4

DNSCry.pt Munich - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4zOS4yMDUuMTAgQtC7u79NGEO2MGscsRWQJwJZy8mvvDwc1gpY_VjEf2IZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-munich-ipv6

DNSCry.pt Munich - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTBjOjhmYzA6MTc0OTo2NjoxODo6MTZdIELQu7u_TRhDtjBrHLEVkCcCWcvJr7w8HNYKWP1YxH9iGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newcastle-ipv4

DNSCry.pt Newcastle - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzgyLjIyLjIwLjM0IOUWyz2JlvdgmwUcA2muhgWH_eVtovNL-1xkdLFdATbqGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newyork-ipv4

DNSCry.pt New York - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5OS4xMTkuMTM3Ljc0INFsbz5k1cESSOnC4MrzZhh7fnwunh6S-wAtXIo9me68GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-newyork-ipv6

DNSCry.pt New York - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjAyOmY3Zjg6MjpjOjphXSDRbG8-ZNXBEkjpwuDK82YYe358Lp4ekvsALVyKPZnuvBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-nuremberg-ipv4

DNSCry.pt Nuremberg - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIwMi42MS4yMzYuNjcgr2UzWGeubsFSZXP-_a8P2GA-gsZJ81sKZuhdsgsGqscZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-nuremberg-ipv6

DNSCry.pt Nuremberg - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAJVsyYTAzOjQwMDA6NWM6NTE6MjRiOTo1MWZmOmZlODA6ZjNhN10gr2UzWGeubsFSZXP-_a8P2GA-gsZJ81sKZuhdsgsGqscZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-ogden-ipv4

DNSCry.pt Ogden - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwNy4xODIuMTczLjgzIEKIFoJ_rsdGy6WtY-lA2RFoVLxHUNT_zox8rttFjbrcGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ogden-ipv6

DNSCry.pt Ogden - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmYyZDg6NDAxYjoxMDQ1OjphXSBCiBaCf67HRsulrWPpQNkRaFS8R1DU_86MfK7bRY263BkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-oradea-ipv4

DNSCry.pt Oradea - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE4NS4yMDcuMTI1LjEwMCCoZlXh1Sm1peBjoxfhUmGFB81xNvwp3QBWF6AsdDMmiBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-oradea-ipv6

DNSCry.pt Oradea - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTBkOjgxNDQ6MDpmNjoyOTE1OmFmOjA6MThdIKhmVeHVKbWl4GOjF-FSYYUHzXE2_CndAFYXoCx0MyaIGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-ottoville-ipv4

DNSCry.pt Ottoville - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwNC4yMzQuMjMxLjIzOSBVJyZb_D0SazeybnfWj5DWZ8NUgxii-zg9r-N8VNSWtBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-ottoville-ipv6

DNSCry.pt Ottoville - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNjAyOmY5NTM6NjoyNTo6YV0gVScmW_w9Ems3sm531o-Q1mfDVIMYovs4Pa_jfFTUlrQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-palermo-ipv4

DNSCry.pt Palermo - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTkxLjIwMS42Ny4xMDcgDFmzhcwCDBCFt-CFlncGoSihQMmToTh0ncSNWKdHby4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-palermo-ipv6

DNSCry.pt Palermo - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OmY5MDU6MToxMDA6OjQwXSAMWbOFzAIMEIW34IWWdwahKKFAyZOhOHSdxI1Yp0dvLhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-paris-ipv4

DNSCry.pt Paris - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzg5LjExNy4yLjE3IAXdC7hGEegKD86br-tVRwZTcJfJZAEFjW4jCV5lzdutGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-paris-ipv6

DNSCry.pt Paris - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyNDAyOmQwYzA6MjI6NmNkMDo0OjQ6NDo1YjgxXSAF3Qu4RhHoCg_Om6_rVUcGU3CXyWQBBY1uIwleZc3brRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-perth-ipv4

DNSCry.pt Perth - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjIwMy4yOS4yNDAuMjQ5IA7UI7_5dEF7rldqU_Pw_R_ZqCjOI5CRHcdKI8hWLfF5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-perth-ipv6

DNSCry.pt Perth - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAIlsyNDA0Ojk0MDA6NDowOjIxNjozZWZmOmZlZTY6YTc2Ml0gDtQjv_l0QXuuV2pT8_D9H9moKM4jkJEdx0ojyFYt8XkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-philadelphia-ipv4

DNSCry.pt Philadelphia - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE1NC4xNi4xNTkuMjIg2_tLIEpyMKwEhbD7PirfNwPUvZUnTM4z8F8DVkeQI3oZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-philadelphia-ipv6

DNSCry.pt Philadelphia - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjA0OmJmMDA6MjEwOjEyOjoyXSDb-0sgSnIwrASFsPs-Kt83A9S9lSdMzjPwXwNWR5AjehkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-phoenix-ipv4

DNSCry.pt Phoenix - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjk1LjEzNC4xNSCoygJlrTFX0s3MaB8gJAbSTN6FDYWMo0aJOp9Oy9btPRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-phoenix-ipv6

DNSCry.pt Phoenix - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyNjA1OjgzNDA6Mzo3OjphXSCoygJlrTFX0s3MaB8gJAbSTN6FDYWMo0aJOp9Oy9btPRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portedwards-ipv4

DNSCry.pt Port Edwards - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3Ni4xMTEuMjE5LjEyNiDzuja5nmAyDvA5jakqkuLQEtb245xsAhNwJYDLkKraKhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portedwards-ipv6

DNSCry.pt Port Edwards - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyMDAxOjQ3MDoxZjExOjJiYjo6YjIzXSDzuja5nmAyDvA5jakqkuLQEtb245xsAhNwJYDLkKraKhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portland-ipv4

DNSCry.pt Portland - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzEwMy4xMjQuMTA2LjIzMyCN5S36eWstGFliH6xl8Mg2gyF99cqzMzgoJfAtWVYJnhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-portland-ipv6

DNSCry.pt Portland - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAIVsyNDAyOmQwYzA6MTY6YTFlNjowOmI4OTM6YmY3OmRkXSCN5S36eWstGFliH6xl8Mg2gyF99cqzMzgoJfAtWVYJnhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-prague-ipv4

DNSCry.pt Prague - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE5NS4xMjMuMjQ1LjE5ID_cR_36ozMvCvR_yzODoHfX8nlpO7p7IBsbqZU5pQIEGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-prague-ipv6

DNSCry.pt Prague - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEFsyYTA1Ojk0MDM6Ojk5OV0gP9xH_fqjMy8K9H_LM4Ogd9fyeWk7unsgGxuplTmlAgQZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-queretaro-ipv4

DNSCry.pt Querétaro - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDg5LjIyMy44OC43NCAD9sK-SHZoULQx-vfHCV5RJ-PJT45xrNe6ivGRKnP_ShkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-queretaro-ipv6

DNSCry.pt Querétaro - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTAzOjkwYzA6NTQ1OjoxMWFdIAP2wr5IdmhQtDH698cJXlEn48lPjnGs17qK8ZEqc_9KGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-redditch-ipv4

DNSCry.pt Redditch - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg1LjIxOSDF35bt83M1j2hvqqgOyB1Rv_pQ0LYZCpGkTuXWt6JGlBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-redditch-ipv6

DNSCry.pt Redditch - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTA1OjQxNDA6MTk6NTM6OmFdIMXflu3zczWPaG-qqA7IHVG_-lDQthkKkaRO5da3okaUGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-riga-ipv4

DNSCry.pt Riga - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5NS4xMjMuMjEyLjIwMCCKpSwU2DoHr1tktJRs4UIiLfoXBly8F7WmgX74sIHRyhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-riga-ipv6

DNSCry.pt Riga - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAEVsyYTAyOjI3YWM6OjEyNDldIIqlLBTYOgevW2S0lGzhQiIt-hcGXLwXtaaBfviwgdHKGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-saltlakecity-ipv4

DNSCry.pt Salt Lake City - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMTQuMTYyLjY1IKbTxlVrc12BNolzMCksgqjW75nTqlnHp95UlrGWqm-UGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-saltlakecity-ipv6

DNSCry.pt Salt Lake City - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAIVsyNDAyOmQwYzA6MTg6YzhmZjowOmI4OTM6YmY3OmRkXSCm08ZVa3NdgTaJczApLIKo1u-Z06pZx6feVJaxlqpvlBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-sandefjord-ipv4

DNSCry.pt Sandefjord - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NC4zMi4xMDcuNDggXTsyJ8l_6LJ4TCwKbGyVeIVM1yLzf8sxL2PmKjZIMvcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sandefjord-ipv6

DNSCry.pt Sandefjord - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTAzOjk0ZTA6MjcxZjo6NWIxXSBdOzInyX_osnhMLApsbJV4hUzXIvN_yzEvY-YqNkgy9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-sanjose-ipv4

DNSCry.pt San Jose - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE4NS4xMDYuOTYuMjEwIKy8EjwvpVvM65kKWYoFFmszWMa4PjE_LRLkUiKeZHk0GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-sanjose-ipv6

DNSCry.pt San Jose - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA3OmYzNTg6MWE6ZTo6OGFhMjo5MzMzXSCsvBI8L6VbzOuZClmKBRZrM1jGuD4xPy0S5FIinmR5NBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-santaclara-ipv4

DNSCry.pt Santa Clara - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE3Ni4xMTEuMjIzLjE2NyCmqAI-1fpR1qtHZyAx3vJJ7SpKXkdmPAnZZ5ga25JckxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-santaclara-ipv6

DNSCry.pt Santa Clara - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6MzU6MTo6NTA2ZDo4Y2UyXSCmqAI-1fpR1qtHZyAx3vJJ7SpKXkdmPAnZZ5ga25JckxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-saopaulo-ipv4

DNSCry.pt Sao Paulo - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwOC4xODEuNjkuMTUzIKai-Qjyp6DgYnQVy1gEzvb3-NTklTiCmy4Afgv7TRJVGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-saopaulo-ipv6

DNSCry.pt Sao Paulo - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyNjA0OjY2MDA6ZmQwMDo5MTo6MWI4YjozYTNjXSCmovkI8qeg4GJ0FctYBM729_jU5JU4gpsuAH4L-00SVRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seattle-ipv4

DNSCry.pt Seattle - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzIwOS4xODIuMjI1LjEwMyAbREpgYMxYxNqglLJnR6df63qELMlAVMwxGlsjPMMThhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seattle-ipv6

DNSCry.pt Seattle - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA3OmE2ODA6OTpmMDA1Ojo4NmU3XSAbREpgYMxYxNqglLJnR6df63qELMlAVMwxGlsjPMMThhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seoul-ipv4

DNSCry.pt Seoul - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTkyLjM4LjEzNS4xMjggyHfVGamJyxLfoAWjERmO4pY3KzKkqY-vSa2UnVx_gYAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-seoul-ipv6

DNSCry.pt Seoul - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAzOjkwYzA6MTI1Ojo4OF0gyHfVGamJyxLfoAWjERmO4pY3KzKkqY-vSa2UnVx_gYAZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-seoul02-ipv4

DNSCry.pt Seoul 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE1MS4yNDUuMTA2LjE4MSBwVhEso4MPh30F1CUaDbHgxoo6R_u5SkGxPgsGUYTi4hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-seoul02-ipv6

DNSCry.pt Seoul 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNDA2OmVmODA6NTo0OGE5OjoxXSBwVhEso4MPh30F1CUaDbHgxoo6R_u5SkGxPgsGUYTi4hkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-singapore-ipv4

DNSCry.pt Singapore - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE1Ny4yMC4xMDUuMTE1IF-A7YB2q_Cn7QZ946XHFuDvAUNlRXLcIcLv6zH5glrGGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-singapore-ipv6

DNSCry.pt Singapore - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMzpmOjphXSBfgO2Adqvwp-0GfeOlxxbg7wFDZUVy3CHC7-sx-YJaxhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-singapore02-ipv4

DNSCry.pt Singapore 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwMy4xNzkuNDQuNzMgICxK5c5XamgK_BNMTtSKyEnZM4D44NPAIHddngTPbGUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-singapore02-ipv6

DNSCry.pt Singapore 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syNDAxOjQ1MjA6MTEyMjo6YV0gICxK5c5XamgK_BNMTtSKyEnZM4D44NPAIHddngTPbGUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sofia-ipv4

DNSCry.pt Sofia - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzc5LjEyNC43LjQzIGjOJralcFGh38dFov6MP6OkkaSPIlSCbku5I7J2NZUfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-sofia-ipv6

DNSCry.pt Sofia - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTAxOjg3NDA6MTo4NjM6OjNiOGNdIGjOJralcFGh38dFov6MP6OkkaSPIlSCbku5I7J2NZUfGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-spokane-ipv4

DNSCry.pt Spokane - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTEwNC4zNi44Ni4xODEg_ifyAp41KOphKBVIwROBjWV91n9fuUzlzUqXCIklST0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-spokane-ipv6

DNSCry.pt Spokane - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyNjA2OmE4YzA6MzoyMDI6OmFdIP4n8gKeNSjqYSgVSMETgY1lfdZ_X7lM5c1KlwiJJUk9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-stockholm-ipv4

DNSCry.pt Stockholm - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDE5NS43Mi42MC42NiAqThz9JMW562Y5eX01kif1fVYVwbkzJh7rexM9MiNAXRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-stockholm-ipv6

DNSCry.pt Stockholm - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTA3OmUwNDM6MTo1ZDo6MV0gKk4c_STFuetmOXl9NZIn9X1WFcG5MyYe63sTPTIjQF0ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-stockholm02-ipv4

DNSCry.pt Stockholm 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE4NS4yMzEuMTAwLjEwNiCzmNivOsptNftnJUN65dxCnu6v2Bw_IJra5tw5OPKDlxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-stockholm02-ipv6

DNSCry.pt Stockholm 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAKFsyYTBjOjU3MDA6MzEzMzo2NTA6OTZkNTo5OWZmOmZlOGI6NzRmNF0gs5jYrzrKbTX7ZyVDeuXcQp7ur9gcPyCa2ubcOTjyg5cZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sydney02-ipv4

DNSCry.pt Sydney 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE5NS4xMTQuMTQuNzQgfD7v3z2SLbLGuO4Wo8-HYVxwRz44PitWMFgp81gvSjUZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-sydney02-ipv6

DNSCry.pt Sydney 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNDAyOjczNDA6NTAwMDo2MjAwOjphXSB8Pu_fPZItssa47hajz4dhXHBHPjg-K1YwWCnzWC9KNRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-taipeh-ipv4

DNSCry.pt Taipeh - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xMzEuMTg5Ljc0IGtGsxNVXEHgu_s96iZ2A7P8t9OJCBU8Qj8QqZhvpJVsGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-taipeh-ipv6

DNSCry.pt Taipeh - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNDAzOmNmYzA6MTAwNDo6MTkyNDpiNGVmXSBrRrMTVVxB4Lv7PeomdgOz_LfTiQgVPEI_EKmYb6SVbBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tallinn-ipv4

DNSCry.pt Tallinn - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4NS4xOTQuNTMuMjIgr0WageGep9cjA5yYpY30Z6EsTYHZnSlV-PCfvZssTNcZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tallinn-ipv6

DNSCry.pt Tallinn - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAElsyYTA0OjZmMDA6NDo6MTdhXSCvRZqB4Z6n1yMDnJiljfRnoSxNgdmdKVX48J-9myxM1xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tampa-ipv4

DNSCry.pt Tampa - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE2NS4xNDAuMTE3LjI0OCBfK4fFWjW65PRF3_42MZM1Ly9t0ZLHdDA_0uy63rk0zBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tampa-ipv6

DNSCry.pt Tampa - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyNjAyOmZjYzA6MjIyMjo5ZDJlOjo1M10gXyuHxVo1uuT0Rd_-NjGTNS8vbdGSx3QwP9Lsut65NMwZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-taos-ipv4

DNSCry.pt Taos - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjYzLjEzMy4yMjMuMTM4IIggy47qNTs0s0PnLuDK5UcpSJt_t7XVmTr0tWn1QlqNGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-taos-ipv6

DNSCry.pt Taos - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAG1syNjA2OjY2ODA6NTM6MTo6ODQ2YTpiZDc5XSCIIMuO6jU7NLND5y7gyuVHKUibf7e11Zk69LVp9UJajRkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tbilisi-ipv4

DNSCry.pt Tbilisi - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADzE5NC4xMzUuMTE5LjE1OCDyc4Y3cWcjNurZ3aEWt1p-gc0TsZr8cUxFjtCnfn37vBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tbilisi-ipv6

DNSCry.pt Tbilisi - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGlsyYTEyOmUzNDA6MzAwOjoxNzY4OmE5NWZdIPJzhjdxZyM26tndoRa3Wn6BzROxmvxxTEWO0Kd-ffu8GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-telaviv-ipv4

DNSCry.pt Tel Aviv - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDUuMTg4LjIyNy4xMyC9GtlYrJYNAgOSHcPGAeLI5mm2I3F9QS4mM0Ygkku-zxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-telaviv-ipv6

DNSCry.pt Tel Aviv - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTAzOjkwYzA6MWU3OjozOV0gvRrZWKyWDQIDkh3DxgHiyOZptiNxfUEuJjNGIJJLvs8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-thessaloniki-ipv4

DNSCry.pt Thessaloniki - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAACzg1LjkwLjE5Ny43IB6Oc_XPh4AEeGLWqykjAhmnE6HZ7kGkX4mduwATCk-9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-thessaloniki-ipv6

DNSCry.pt Thessaloniki - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFFsyYTEyOjZmYzM6ODAwMDo6MTldIB6Oc_XPh4AEeGLWqykjAhmnE6HZ7kGkX4mduwATCk-9GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-timisoara-ipv4

DNSCry.pt Timișoara - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjEzNC40OC4yNSDMuhfc1PfFxgp4ZbNQKp6bPc46GjmBvoitb_MrP20o9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-timisoara-ipv6

DNSCry.pt Timișoara - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHlsyYTBjOjlmMDA6MjpkOTI4OjZmMGE6YjRlMjo6XSDMuhfc1PfFxgp4ZbNQKp6bPc46GjmBvoitb_MrP20o9xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tirana-ipv4

DNSCry.pt Tirana - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE4NS43NS4yNDMuODAgHCajtEAcNP8fNSrJTpYm19z1aig0HfXVylKkdVDxQk4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tirana-ipv6

DNSCry.pt Tirana - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAHVsyYTEzOjk0MDM6OjdhNmE6NTMwNjoxZTM1OjFdIBwmo7RAHDT_HzUqyU6WJtfc9WooNB311cpSpHVQ8UJOGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-tokyo-ipv4

DNSCry.pt Tokyo - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDQ1LjY3Ljg2LjEyMyBDK5aRHZnKfdd6Q9ufEJY83WAQ9X5z7OAQa5CeptBCYBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo-ipv6

DNSCry.pt Tokyo - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjA2OmZjNDA6NDAwMjpkOjphXSBDK5aRHZnKfdd6Q9ufEJY83WAQ9X5z7OAQa5CeptBCYBkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo02-ipv4

DNSCry.pt Tokyo 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDEwMy4xNzkuNDUuNiDfai5sp1im-BPHwbM1GCnTqn20FIbQfuvvybKsGf0pjhkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tokyo02-ipv6

DNSCry.pt Tokyo 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAE1syYTBhOjYwNDA6OTczZDo6YV0g32oubKdYpvgTx8GzNRgp06p9tBSG0H7r78myrBn9KY4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-toronto-ipv4

DNSCry.pt Toronto - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjE3Mi45My4xNjcuMjE0IKm0Ncdvi-mr_zZSF_DC1GyI11gxqnT2FOSCqJr06wZrGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-toronto-ipv6

DNSCry.pt Toronto - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGFsyNjA2OjYwODA6MjAwMToxMDk5OjphXSCptDXHb4vpq_82UhfwwtRsiNdYMap09hTkgqia9OsGaxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-toronto02-ipv4

DNSCry.pt Toronto 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADjEwMy4xNDQuMTc3LjU3IJwdTj8y2VV_9iktRICq-3zzk_tPsQFh-8H_f3MHqAYnGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-toronto02-ipv6

DNSCry.pt Toronto 02 - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZlZDI6ZmEwOjRhOjoxXSCcHU4_MtlVf_YpLUSAqvt885P7T7EBYfvB_39zB6gGJxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-tuusula-ipv4

DNSCry.pt Tuusula - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTY1LjIxLjI1Mi4yMDEgIhe-u4w5oFAMptmgzUFqc-mgyjjRlnH70fwVqSiHJfkZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-tuusula-ipv6

DNSCry.pt Tuusula - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTAxOjRmOTpjMDExOmI4NGU6OjFdICIXvruMOaBQDKbZoM1BanPpoMo40ZZx-9H8FakohyX5GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-valdivia-ipv4

DNSCry.pt Valdivia - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTIxNi43My4xNTkuMjYgnpr1thxYT4SkWK38OEbiPOQa3NSVayBN7f8BkMVREC8ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-valdivia-ipv6

DNSCry.pt Valdivia - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyYTA2OmEwMDY6ZDFkMTo6MTE2XSCemvW2HFhPhKRYrfw4RuI85Brc1JVrIE3t_wGQxVEQLxkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vancouver-ipv4

DNSCry.pt Vancouver - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADDIzLjE1NC44MS45MiAGyG9Uh1Ra0QN3Ge2n_OYHW8h263tF9bF2GwyXRAaC7xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vancouver-ipv6

DNSCry.pt Vancouver - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAFVsyNjAyOmZlZDI6ZmIwOjZkOjoxXSAGyG9Uh1Ra0QN3Ge2n_OYHW8h263tF9bF2GwyXRAaC7xkyLmRuc2NyeXB0LWNlcnQuZG5zY3J5LnB0


## dnscry.pt-vienna-ipv4

DNSCry.pt Vienna - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTgzLjEzOC41NS4xODYg3kyI1rUYwQymzbrF1c5fYhw1rWmOTm8L6i1aISwm6y4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-vienna-ipv6

DNSCry.pt Vienna - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTBkOmYzMDI6MTEwOjY1MTc6OjFdIN5MiNa1GMEMps26xdXOX2IcNa1pjk5vC-otWiEsJusuGTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-vilnius-ipv4

DNSCry.pt Vilnius - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTE2Mi4yNTQuODYuMTMg4nDDbNqRwkkkZWTJ5c82d1sbs0NeQCbn-aFldCI2mn4ZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-vilnius-ipv6

DNSCry.pt Vilnius - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAF1syYTEzOjk0MDE6MDoxOjozZDU4OjFdIOJww2zakcJJJGVkyeXPNndbG7NDXkAm5_mhZXQiNpp-GTIuZG5zY3J5cHQtY2VydC5kbnNjcnkucHQ


## dnscry.pt-yerevan-ipv4

DNSCry.pt Yerevan - DNSCrypt, no filter, no logs, DNSSEC support (IPv4 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAADTg1LjkwLjIwNy4xOTkgk1VXqXvUtR3JLu9xcONFSHTVnBWEj2rWkjgjmv9iQSoZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscry.pt-yerevan-ipv6

DNSCry.pt Yerevan - DNSCrypt, no filter, no logs, DNSSEC support (IPv6 server)

https://www.dnscry.pt

sdns://AQcAAAAAAAAAGVsyYTAzOjkwYzA6NWYxOjI5MDM6OjUzOV0gk1VXqXvUtR3JLu9xcONFSHTVnBWEj2rWkjgjmv9iQSoZMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeS5wdA


## dnscrypt.ca-ipv4

Canadian based, unfiltered, DNSSEC validating, and no logs... for your pleasure. https://dnscrypt.ca/

sdns://AQcAAAAAAAAAEzE4NS4xMTEuMTg4LjQ2Ojg0NDMgC-tbTwd-08e_JtBJmgsvjAG9i10itE-LBNCwjTflezQiMi5kbnNjcnlwdC1jZXJ0LmRuc2NyeXB0LmNhLTEtaXB2NA


## dnscrypt.ca-ipv4-doh

Canadian based, unfiltered, DNSSEC validating, and no logs... for your pleasure. https://dnscrypt.ca/

sdns://AgcAAAAAAAAADjE4NS4xMTEuMTg4LjQ2ID8EEe3pxEdwV9V-V4g7HyBbIM3A8yYxKbHuAmmiZ49jEGRuczEuZG5zY3J5cHQuY2EKL2Rucy1xdWVyeQ


## dnsforfamily

(DNSCrypt Protocol) (Now supports DNSSEC). Block adult websites, gambling websites, malwares, trackers and advertisements.
It also enforces safe search in: Google, YouTube, Bing, DuckDuckGo and Yandex.

Social websites like Facebook and Instagram are not blocked. No DNS queries are logged.

As of 26-May-2022 5.9 million websites are blocked and new websites are added to blacklist daily.
Completely free, no ads or any commercial motive. Operating for 4 years now.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAADDc4LjQ3LjY0LjE2MSATJeLOABXNSYcSJIoqR5_iUYz87Y4OecMLB84aEAKPrRBkbnNmb3JmYW1pbHkuY29t


## dnsforfamily-doh

(DoH Protocol) (Now supports DNSSEC). Block adult websites, gambling websites, malwares, trackers and advertisements.
It also enforces safe search in: Google, YouTube, Bing, DuckDuckGo and Yandex.

Social websites like Facebook and Instagram are not blocked. No DNS queries are logged.

As of 26-May-2022 5.9 million websites are blocked and new websites are added to blacklist daily.
Completely free, no ads or any commercial motive. Operating for 4 years now.

Provided by: https://dnsforfamily.com

sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyCdSDK7TI13IHsl3hdZJoLvw8pF9XncZkoO1fJI9ckzmBhkbnMtZG9oLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ


## dnsforfamily-doh-no-safe-search

(DoH Protocol) (Now supports DNSSEC) Block adult websites, gambling websites, malwares, trackers and advertisements.
Unlike other dnsforfamily servers, this one does not enforces safe search. So Google, YouTube, Bing, DuckDuckGo and Yandex are completely accessible without any restriction.

Social websites like Facebook and Instagram are not blocked. No DNS queries are logged.

As of 26-May-2022 5.9 million websites are blocked and new websites are added to blacklist daily.
Completely free, no ads or any commercial motive. Operating for 4 years now.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyCdSDK7TI13IHsl3hdZJoLvw8pF9XncZkoO1fJI9ckzmCdkbnMtZG9oLW5vLXNhZmUtc2VhcmNoLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ


## dnsforfamily-no-safe-search

(DNSCrypt Protocol) (Now supports DNSSEC) Block adult websites, gambling websites, malwares, trackers and advertisements.
Unlike other dnsforfamily servers, this one does not enforces safe search. So Google, YouTube, Bing, DuckDuckGo and Yandex are completely accessible without any restriction.

Social websites like Facebook and Instagram are not blocked. No DNS queries are logged.

As of 26-May-2022 5.9 million websites are blocked and new websites are added to blacklist daily.
Completely free, no ads or any commercial motive. Operating for 4 years now.

Warning: This server is incompatible with anonymization.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAADzEzNS4xODEuMTkzLjIyMiDrxcZ_hFtGE6tfATvQZYjxgl5pTY_e2cRH_ms8bEWofBBkbnNmb3JmYW1pbHkuY29t


## dnsforfamily-v6

(DNSCrypt Protocol) (Now supports DNSSEC) Block adult websites, gambling websites, malwares, trackers and advertisements.
It also enforces safe search in: Google, YouTube, Bing, DuckDuckGo and Yandex.

Social websites like Facebook and Instagram are not blocked. No DNS queries are logged.

As of 26-May-2022 5.9 million websites are blocked and new websites are added to blacklist daily.
Completely free, no ads or any commercial motive. Operating for 4 years now.

Provided by: https://dnsforfamily.com

sdns://AQMAAAAAAAAAF1syYTAxOjRmODoxYzE3OjRkZjg6OjFdIBMl4s4AFc1JhxIkiipHn-JRjPztjg55wwsHzhoQAo-tEGRuc2ZvcmZhbWlseS5jb20


## dnsforge.de

Public DoH resolver running with Pihole for Adblocking (https://dnsforge.de).

Non-logging, AD-filtering, supports DNSSEC. Hosted in Germany.

sdns://AgMAAAAAAAAADDE3Ni45LjkzLjE5OCCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMOQtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAACzE3Ni45LjEuMTE3IJB40hpWwOCJHZBiIbaZIzG90XFy6w8z3aB9XGXG4Uw5C2Ruc2ZvcmdlLmRlCi9kbnMtcXVlcnk


## dnsforge.de-ipv6

Public DoH resolver running with Pihole for Adblocking (https://dnsforge.de).

Non-logging, AD-filtering, supports DNSSEC. Hosted in Germany.

sdns://AgMAAAAAAAAAGFsyYTAxOjRmODoxNTE6MzRhYTo6MTk4XSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdAtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAGFsyYTAxOjRmODoxNDE6MzE2ZDo6MTE3XSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdAtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5


## dnsforge.de-nofilter

Public DoH resolver (https://dnsforge.de)

Non-logging, non-filtering, supports DNSSEC. Hosted in Germany.

sdns://AgcAAAAAAAAADzEzOC4xOTkuMTQ5LjI0OSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAADDc4LjQ3LjcxLjE5NCCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5


## dnsforge.de-nofilter-ipv6

Public DoH resolver (https://dnsforge.de)

Non-logging, non-filtering, supports DNSSEC. Hosted in Germany.

sdns://AgcAAAAAAAAAGFsyYTAxOjRmODpjMTc6N2FhNTo6MjQ5XSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdBFibGFuay5kbnNmb3JnZS5kZQovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAAGVsyYTAxOjRmODpjMDEzOmFhZTk6OjE5NF0gsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQRYmxhbmsuZG5zZm9yZ2UuZGUKL2Rucy1xdWVyeQ


## dnslow.me

dnslow.me is an open source project, also your advertisement and threat blocking, privacy-first, encrypted DNS.

All DNS requests will be protected with threat-intelligence feeds and randomly distributed to some other DNS resolvers.

More info on the [homepage](https://dnslow.me) and [GitHub](https://github.com/PeterDaveHello/dnslow.me)

sdns://AgAAAAAAAAAAACCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdAlkbnNsb3cubWUKL2Rucy1xdWVyeQ


## dnspod

A public DNS resolver that supports DoH/DoT in mainland China, provided by dnspod/Tencent-cloud.
Homepage: https://dnspod.cn

Warning: GFW filtering rules are applied by this resolver.

sdns://AgAAAAAAAAAADDEyMC41My41My41MwAMMTIwLjUzLjUzLjUzCi9kbnMtcXVlcnk
sdns://AgAAAAAAAAAACjEuMTIuMTIuMTIACjEuMTIuMTIuMTIKL2Rucy1xdWVyeQ
sdns://AgAAAAAAAAAACjEuMTIuMzQuNTYACjEuMTIuMTIuMTIKL2Rucy1xdWVyeQ


## doh-cleanbrowsing-adult

Blocks access to adult, pornographic and explicit sites. It does
not block proxy or VPNs, nor mixed-content sites. Sites like Reddit
are allowed. Google and Bing are set to the Safe Mode.

By https://cleanbrowsing.org/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnEi9kb2gvYWR1bHQtZmlsdGVyLw


## doh-cleanbrowsing-family

Blocks access to adult, pornographic and explicit sites. It also
blocks proxy and VPN domains that are used to bypass the filters.
Mixed content sites (like Reddit) are also blocked. Google, Bing and
Youtube are set to the Safe Mode.

By https://cleanbrowsing.org/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnEy9kb2gvZmFtaWx5LWZpbHRlci8


## doh-cleanbrowsing-security

Block access to phishing, malware and malicious domains. It does not block adult content.
By https://cleanbrowsing.org/

sdns://AgMAAAAAAAAAAAAVZG9oLmNsZWFuYnJvd3Npbmcub3JnFS9kb2gvc2VjdXJpdHktZmlsdGVyLw


## doh-crypto-sx

DNS-over-HTTPS server. Anycast, no logs, no censorship, DNSSEC.
Globally cached via Cloudflare.
Maintained by Frank Denis.

sdns://AgcAAAAAAAAACzEwNC4yMS42Ljc4AA1kb2guY3J5cHRvLnN4Ci9kbnMtcXVlcnk
sdns://AgcAAAAAAAAADjE3Mi42Ny4xMzQuMTU3AA1kb2guY3J5cHRvLnN4Ci9kbnMtcXVlcnk


## doh-crypto-sx-ipv6

DNS-over-HTTPS server accessible over IPv6. Anycast, no logs, no censorship, DNSSEC.
Globally cached via Cloudflare.
Maintained by Frank Denis.

sdns://AgcAAAAAAAAAGlsyNjA2OjQ3MDA6MzAzNzo6NjgxNTo2NGVdABJkb2gtaXB2Ni5jcnlwdG8uc3gKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAG1syNjA2OjQ3MDA6MzAzNjo6YWM0Mzo4NjlkXQASZG9oLWlwdjYuY3J5cHRvLnN4Ci9kbnMtcXVlcnk


## doh.appliedprivacy.net

Public DoH resolver operated by the Foundation for Applied Privacy (https://appliedprivacy.net).
Hosted in Vienna, Austria.

Non-logging, non-filtering, supports DNSSEC.

sdns://AgcAAAAAAAAAACCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMORZkb2guYXBwbGllZHByaXZhY3kubmV0Bi9xdWVyeQ


## doh.ffmuc.net

An open (non-logging, non-filtering, non-censoring) DoH resolver operated by Freifunk Munich with nodes in DE.
https://ffmuc.net/

sdns://AgcAAAAAAAAACjUuMS42Ni4yNTUgnUgyu0yNdyB7Jd4XWSaC78PKRfV53GZKDtXySPXJM5gNZG9oLmZmbXVjLm5ldAovZG5zLXF1ZXJ5


## doh.ffmuc.net-2

An open (non-logging, non-filtering, non-censoring) DoH resolver operated by Freifunk Munich with nodes in DE.
https://ffmuc.net/

sdns://AgcAAAAAAAAADjE4NS4xNTAuOTkuMjU1IJ1IMrtMjXcgeyXeF1kmgu_DykX1edxmSg7V8kj1yTOYDWRvaC5mZm11Yy5uZXQKL2Rucy1xdWVyeQ


## doh.ffmuc.net-v6

An open (non-logging, non-filtering, non-censoring) DoH resolver operated by Freifunk Munich with nodes in DE.
https://ffmuc.net/

sdns://AgcAAAAAAAAAFVsyMDAxOjY3ODplNjg6ZjAwMDo6XSCdSDK7TI13IHsl3hdZJoLvw8pF9XncZkoO1fJI9ckzmA1kb2guZmZtdWMubmV0Ci9kbnMtcXVlcnk


## doh.ffmuc.net-v6-2

An open (non-logging, non-filtering, non-censoring) DoH resolver operated by Freifunk Munich with nodes in DE.
https://ffmuc.net/

sdns://AgcAAAAAAAAAFVsyMDAxOjY3ODplZDA6ZjAwMDo6XSDWHZbr-z-hkJbiwALjYDv3_arvsicE2oZoBiu-hu1Lkw1kb2guZmZtdWMubmV0Ci9kbnMtcXVlcnk


## doh.ibksturm

Switzerland, running by ibksturm, Opennic, nologs, DNSSEC

sdns://AgcAAAAAAAAAAAAUaWJrc3R1cm0uc3lub2xvZ3kubWUKL2Rucy1xdWVyeQ


## doh.tiar.app

Non-Logging DNSCrypt server located in Singapore.
Filters out ads, trackers and malware, supports DNSSEC, provided by id-gmail.

sdns://AQMAAAAAAAAADjE3NC4xMzguMjEuMTI4IO-WgGbo2ZTwZdg-3dMa7u31bYZXRj5KykfN1_6Xw9T2HDIuZG5zY3J5cHQtY2VydC5kbnMudGlhci5hcHA


## doh.tiar.app-doh

Non-Logging DNS-over-HTTPS (HTTP/2 & HTTP/3) server located in Singapore.
Filters out ads, trackers and malware, supports DNSSEC, provided by id-gmail.

sdns://AgMAAAAAAAAADjE3NC4xMzguMjkuMTc1ILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0DGRvaC50aWFyLmFwcAovZG5zLXF1ZXJ5


## doh.tiarap.org

Non-Logging DNS-over-HTTPS server, cached via Cloudflare.
Filters out ads, trackers and malware, NO ECS, supports DNSSEC.

sdns://AgMAAAAAAAAADDEwNC4yMS42NS42MAAOZG9oLnRpYXJhcC5vcmcKL2Rucy1xdWVyeQ


## doh.tiarap.org-ipv6

Non-Logging DNS-over-HTTPS server (IPv6), cached via Cloudflare.
Filters out ads, trackers and malware, NO ECS, supports DNSSEC.

sdns://AgMAAAAAAAAAG1syNjA2OjQ3MDA6MzAzNDo6NjgxNTo0MTNjXQAOZG9oLnRpYXJhcC5vcmcKL2Rucy1xdWVyeQ


## faelix-uk-ipv4

An open (non-logging, non-filtering, no ECS) DNSCrypt resolver operated by https://faelix.net/ with IPv4 nodes anycast within AS41495 in the UK.

sdns://AQYAAAAAAAAAEjQ2LjIyNy4yMDAuNTQ6ODQ0MyB-y-8-LwGAMo1g4OHR7CPk6HfY6gmhk3AaBNazwL6L4R8yLmRuc2NyeXB0LWNlcnQucmRucy5mYWVsaXgubmV0


## faelix-uk-ipv6

An open (non-logging, non-filtering, no ECS) DNSCrypt resolver operated by https://faelix.net/ with IPv6 nodes anycast within AS41495 in the UK.

sdns://AQYAAAAAAAAAFFsyYTAxOjllMDA6OjU0XTo4NDQzIH7L7z4vAYAyjWDg4dHsI-Tod9jqCaGTcBoE1rPAvovhHzIuZG5zY3J5cHQtY2VydC5yZG5zLmZhZWxpeC5uZXQ
sdns://AQYAAAAAAAAAFFsyYTAxOjllMDA6OjU1XTo4NDQzIH7L7z4vAYAyjWDg4dHsI-Tod9jqCaGTcBoE1rPAvovhHzIuZG5zY3J5cHQtY2VydC5yZG5zLmZhZWxpeC5uZXQ


## fdn

DoH server in France operated by FDN - French Data Network (non-profit ISP)
https://www.fdn.fr/

sdns://AgcAAAAAAAAADDgwLjY3LjE2OS40MCCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdApuczEuZmRuLmZyCi9kbnMtcXVlcnk


## fdn-ipv6

DoH server in France operated by FDN - French Data Network (non-profit ISP)
https://www.fdn.fr/

sdns://AgcAAAAAAAAAElsyMDAxOjkxMDo4MDA6OjEyXSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMOQpuczAuZmRuLmZyCi9kbnMtcXVlcnk
sdns://AgcAAAAAAAAAElsyMDAxOjkxMDo4MDA6OjQwXSCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdApuczEuZmRuLmZyCi9kbnMtcXVlcnk


## google

Google DNS (anycast)

sdns://AgUAAAAAAAAABzguOC44LjggsKKKE4EwvtIbNjGjagI2607EdKSVHowYZtyvD9iPrkkHOC44LjguOAovZG5zLXF1ZXJ5
sdns://AgUAAAAAAAAABzguOC40LjQgsKKKE4EwvtIbNjGjagI2607EdKSVHowYZtyvD9iPrkkHOC44LjQuNAovZG5zLXF1ZXJ5


## google-ipv6

Google DNS (anycast)

sdns://AgUAAAAAAAAAFlsyMDAxOjQ4NjA6NDg2MDo6ODg4OF0gsKKKE4EwvtIbNjGjagI2607EdKSVHowYZtyvD9iPrkkaWzIwMDE6NDg2MDo0ODYwOjo4ODg4XTo0NDMKL2Rucy1xdWVyeQ
sdns://AgUAAAAAAAAAFlsyMDAxOjQ4NjA6NDg2MDo6ODg0NF0gsKKKE4EwvtIbNjGjagI2607EdKSVHowYZtyvD9iPrkkaWzIwMDE6NDg2MDo0ODYwOjo4ODQ0XTo0NDMKL2Rucy1xdWVyeQ


## he

Hurricane Electric DoH server (anycast)

Unknown logging policy.

sdns://AgUAAAAAAAAACzc0LjgyLjQyLjQyINYdluv7P6GQluLAAuNgO_f9qu-yJwTahmgGK76G7UuTDG9yZG5zLmhlLm5ldAovZG5zLXF1ZXJ5


## ibksturm

Switzerland, running by ibksturm, Opennic, nologs, DNSSEC

sdns://AQcAAAAAAAAAEzIxMy4xOTYuMTkxLjk2Ojg0NDMgQg5eFucIAx7hJqzl4olTm-o1y4qE7eThMBlzuZ4e_acYMi5kbnNjcnlwdC1jZXJ0Lmlia3N0dXJt


## iij

DoH server operated by Internet Initiative Japan in Tokyo. Blocks child pornography.
https://www.iij.ad.jp/

sdns://AgEAAAAAAAAACjEwMy4yLjU3LjUgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQRcHVibGljLmRucy5paWouanAKL2Rucy1xdWVyeQ


## jp.tiar.app

Non-Logging, Non-Filtering DNSCrypt server in Japan.
No ECS, Support DNSSEC

sdns://AQcAAAAAAAAAEjE3Mi4xMDQuOTMuODA6MTQ0MyAyuHY-8b9lNqHeahPAzW9IoXnjiLaZpTeNbVs8TN9UUxsyLmRuc2NyeXB0LWNlcnQuanAudGlhci5hcHA


## jp.tiar.app-doh

Non-Logging, Non-Filtering DNS-over-HTTPS server in Japan.
No ECS, Support DNSSEC

sdns://AgcAAAAAAAAADTE3Mi4xMDQuOTMuODAgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQLanAudGlhci5hcHAKL2Rucy1xdWVyeQ


## jp.tiar.app-doh-ipv6

Non-Logging, Non-Filtering DNS-over-HTTPS (IPv6) server in Japan.
No ECS, Support DNSSEC

sdns://AgcAAAAAAAAAIFsyNDAwOjg5MDI6OmYwM2M6OTFmZjpmZWRhOmM1MTRdILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0C2pwLnRpYXIuYXBwCi9kbnMtcXVlcnk


## jp.tiar.app-ipv6

Non-Logging, Non-Filtering DNSCrypt (IPv6) server in Japan.
No ECS, Support DNSSEC

sdns://AQcAAAAAAAAAJVsyNDAwOjg5MDI6OmYwM2M6OTFmZjpmZWRhOmM1MTRdOjE0NDMgMrh2PvG_ZTah3moTwM1vSKF544i2maU3jW1bPEzfVFMbMi5kbnNjcnlwdC1jZXJ0LmpwLnRpYXIuYXBw


## jp.tiarap.org

DNS-over-HTTPS Server. Non-Logging, Non-Filtering, No ECS, Support DNSSEC.
Cached via Cloudflare.

sdns://AgcAAAAAAAAAAAANanAudGlhcmFwLm9yZwovZG5zLXF1ZXJ5


## jp.tiarap.org-ipv6

DNS-over-HTTPS Server (IPv6). Non-Logging, Non-Filtering, No ECS, Support DNSSEC.
Cached via Cloudflare.

sdns://AgcAAAAAAAAAG1syNjA2OjQ3MDA6MzAzMDo6YWM0MzphZDNiXQANanAudGlhcmFwLm9yZwovZG5zLXF1ZXJ5


## ksol.io-ns2-dnscrypt-ipv4

DNSCrypt on IPv4 (UDP/TCP). No DoH, doesn't log, doesn't filter, DNSSEC enforced. No EDNS Client-Subnet, padding enabled, as per `dnscrypt-server-docker` default unbound configuration. Location: Hungary

sdns://AQcAAAAAAAAADjE5My4yMDEuMTg4LjQ4IBERKdQJgLSjqCSK99e2f_WRTQzEq9__DeXlQFvxxhZ6GzIuZG5zY3J5cHQtY2VydC5uczIua3NvbC5pbw


## ksol.io-ns2-dnscrypt-ipv6

DNSCrypt on IPv6 (UDP/TCP). No DoH, doesn't log, doesn't filter, DNSSEC enforced. No EDNS Client-Subnet, padding enabled, as per `dnscrypt-server-docker` default unbound configuration. Location: Hungary

sdns://AQcAAAAAAAAAFFsyYTAxOjZlZTA6MTo6MjQxOjFdIBERKdQJgLSjqCSK99e2f_WRTQzEq9__DeXlQFvxxhZ6GzIuZG5zY3J5cHQtY2VydC5uczIua3NvbC5pbw


## libredns

DoH server in Germany. No logging, but no DNS padding and no DNSSEC support.
https://libredns.gr/

sdns://AgIAAAAAAAAADjExNi4yMDIuMTc2LjI2IJ1IMrtMjXcgeyXeF1kmgu_DykX1edxmSg7V8kj1yTOYD2RvaC5saWJyZWRucy5ncgovZG5zLXF1ZXJ5


## libredns-noads

DoH server in Germany. No logging, but no DNS padding and no DNSSEC support.
no ads version, uses StevenBlack's host list: https://github.com/StevenBlack/hosts

sdns://AgIAAAAAAAAADjExNi4yMDIuMTc2LjI2IJ1IMrtMjXcgeyXeF1kmgu_DykX1edxmSg7V8kj1yTOYD2RvaC5saWJyZWRucy5ncgYvbm9hZHM


## mullvad-adblock-doh

Same as mullvad-doh but blocks ads and trackers.

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi4zABdhZGJsb2NrLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-all-doh

Same as mullvad-doh but blocks ads, trackers, malware, adult content, gambling, and social media.

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi45ABNhbGwuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## mullvad-base-doh

Same as mullvad-doh but blocks ads, trackers, and malware.

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi40ABRiYXNlLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5


## mullvad-doh

Public non-filtering, non-logging (audited), DNSSEC-capable, DNS-over-HTTPS resolver hosted by VPN provider Mullvad.
Anycast IPv4/IPv6 with servers in SE, DE, UK, US, AU, and SG.
https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/

sdns://AgcAAAAAAAAACzE5NC4yNDIuMi4yAA9kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-extend-doh

Same as mullvad-doh but blocks ads, trackers, malware, and social media.

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi41ABhleHRlbmRlZC5kbnMubXVsbHZhZC5uZXQKL2Rucy1xdWVyeQ


## mullvad-family-doh

Same as mullvad-doh but blocks ads, trackers, malware, adult content, and gambling.

sdns://AgMAAAAAAAAACzE5NC4yNDIuMi42ABZmYW1pbHkuZG5zLm11bGx2YWQubmV0Ci9kbnMtcXVlcnk


## nextdns

NextDNS is a cloud-based private DNS service that gives you full control
over what is allowed and what is blocked on the Internet.

DNSSEC, Anycast, Non-logging, NoFilters

https://www.nextdns.io/

sdns://AgcAAAAAAAAACjQ1LjkwLjMwLjAgmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkWYW55Y2FzdC5kbnMubmV4dGRucy5pbwovZG5zLXF1ZXJ5


## nextdns-ipv6

Connects to NextDNS over IPv6.

NextDNS is a cloud-based private DNS service that gives you full control
over what is allowed and what is blocked on the Internet.

DNSSEC, Anycast, Non-logging, NoFilters

https://www.nextdns.io/

sdns://AgcAAAAAAAAADVsyYTA3OmE4YzA6Ol0gmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkWYW55Y2FzdC5kbnMubmV4dGRucy5pbwovZG5zLXF1ZXJ5


## nextdns-ultralow

NextDNS is a cloud-based private DNS service that gives you full control
over what is allowed and what is blocked on the Internet.

https://www.nextdns.io/

To select the server location, the "-ultralow" variant relies on bootstrap servers
instead of anycast.

sdns://AgcAAAAAAAAAACCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQ5kbnMubmV4dGRucy5pbw8vZG5zY3J5cHQtcHJveHk


## nic.cz

Open, DNSSEC, No-log and No-filter DoH operated by https://nic.cz

sdns://AgcAAAAAAAAADDE4NS40My4xMzUuMSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMOQtvZHZyLm5pYy5jegovZG5zLXF1ZXJ5
sdns://AgcAAAAAAAAACzE5My4xNy40Ny4xIJB40hpWwOCJHZBiIbaZIzG90XFy6w8z3aB9XGXG4Uw5C29kdnIubmljLmN6Ci9kbnMtcXVlcnk


## nic.cz-ipv6

Open, DNSSEC, No-log and No-filter DoH over IPv6 operated by https://nic.cz

sdns://AgcAAAAAAAAAE1syMDAxOjE0OGY6ZmZmZTo6MV0gkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkLb2R2ci5uaWMuY3oKL2Rucy1xdWVyeQ
sdns://AgcAAAAAAAAAE1syMDAxOjE0OGY6ZmZmZjo6MV0gkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkLb2R2ci5uaWMuY3oKL2Rucy1xdWVyeQ


## njalla-doh

Non-logging DoH server in Sweden operated by Njalla.

https://dns.njal.la/

sdns://AgcAAAAAAAAADDk1LjIxNS4xOS41MyDWHZbr-z-hkJbiwALjYDv3_arvsicE2oZoBiu-hu1LkwtkbnMubmphbC5sYQovZG5zLXF1ZXJ5


## nwps.fi

Helsinki, Finland. DNSCrypt, no filters, no logs, DNSSEC

sdns://AQcAAAAAAAAAETk1LjIxNy4xMS42Mzo4NDQzILqK827XPyVhFNCgYRi2VrryJyHhnfkeQnBB2EvkiM-3FzIuZG5zY3J5cHQtY2VydC5ud3BzLmZp


## plan9dns-fl

Miami Florida, USA. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAAEzE0OS4yOC4xMDEuMTE5Ojg0NDMgVaFV4a8StIfx8fnCxDxVlxppqm-hJYyCKqtMtQENnCwkMi5kbnNjcnlwdC1jZXJ0LnBsdXRvbi5wbGFuOS1kbnMuY29t


## plan9dns-fl-doh

Miami Florida, USA. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAADjE0OS4yOC4xMDEuMTE5IJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZFHBsdXRvbi5wbGFuOS1kbnMuY29tCi9kbnMtcXVlcnk


## plan9dns-fl-doh-ipv6

Miami Florida, USA. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAAJ1syMDAxOjE5ZjA6OTAwMjpkZTQ6NTQwMDo0ZmY6ZmUwODo3ZGUzXSCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGRRwbHV0b24ucGxhbjktZG5zLmNvbQovZG5zLXF1ZXJ5


## plan9dns-fl-ipv6

Miami Florida, USA. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAALFsyMDAxOjE5ZjA6OTAwMjpkZTQ6NTQwMDo0ZmY6ZmUwODo3ZGUzXTo4NDQzIFWhVeGvErSH8fH5wsQ8VZcaaapvoSWMgiqrTLUBDZwsJDIuZG5zY3J5cHQtY2VydC5wbHV0b24ucGxhbjktZG5zLmNvbQ


## plan9dns-mx

Mexico City, MX. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAAEzIxNi4yMzguODAuMjE5Ojg0NDMgKmPCui35rtOj9yk7c07sEtC_Khyo_9_HcpO23GCroNskMi5kbnNjcnlwdC1jZXJ0LmhlbGlvcy5wbGFuOS1kbnMuY29t


## plan9dns-mx-doh

Mexico City, MX. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAADjIxNi4yMzguODAuMjE5IJo6NPcn3rm8pRAD2c6cOfjyfdnFJCkBwrqxpE5jWgIZFGhlbGlvcy5wbGFuOS1kbnMuY29tCi9kbnMtcXVlcnk


## plan9dns-mx-doh-ipv6

Mexico City, MX. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAAKFsyMDAxOjE5ZjA6YjQwMDoxZDhjOjU0MDA6NGZmOmZlMTE6YjE1YV0gmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkUaGVsaW9zLnBsYW45LWRucy5jb20KL2Rucy1xdWVyeQ


## plan9dns-mx-ipv6

Mexico City, MX. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAALVsyMDAxOjE5ZjA6YjQwMDoxZDhjOjU0MDA6NGZmOmZlMTE6YjE1YV06ODQ0MyAqY8K6Lfmu06P3KTtzTuwS0L8qHKj_38dyk7bcYKug2yQyLmRuc2NyeXB0LWNlcnQuaGVsaW9zLnBsYW45LWRucy5jb20


## plan9dns-nj

Piscataway New Jersey, USA. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAAEjIwNy4yNDYuODcuOTY6ODQ0MyCwmQlIDpKk8SiiyrJbPgKhHxCrBJLb8ZWlu6tvr1KvkyQyLmRuc2NyeXB0LWNlcnQua3Jvbm9zLnBsYW45LWRucy5jb20


## plan9dns-nj-doh

Piscataway New Jersey, USA. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAADTIwNy4yNDYuODcuOTYgmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkUa3Jvbm9zLnBsYW45LWRucy5jb20KL2Rucy1xdWVyeQ


## plan9dns-nj-doh-ipv6

Piscataway New Jersey, USA. DoH, DoH3 via the Alt-Svc header, no-logs, no-filters, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns, DoT & DoQ supported.

sdns://AgcAAAAAAAAAJVsyMDAxOjE5ZjA6NTozYmQ3OjU0MDA6NGZmOmZlMDU6ZGE4M10gmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkUa3Jvbm9zLnBsYW45LWRucy5jb20KL2Rucy1xdWVyeQ


## plan9dns-nj.ipv6

Piscataway New Jersey, USA. DNSCrypt, no filters, no logs, DNSSEC

Hosted on Vultr, jlongua.github.io/plan9-dns

sdns://AQcAAAAAAAAAKlsyMDAxOjE5ZjA6NTozYmQ3OjU0MDA6NGZmOmZlMDU6ZGE4M106ODQ0MyCwmQlIDpKk8SiiyrJbPgKhHxCrBJLb8ZWlu6tvr1KvkyQyLmRuc2NyeXB0LWNlcnQua3Jvbm9zLnBsYW45LWRucy5jb20


## qihoo360-doh

DoH server runned by Qihoo 360, has logs, GFW filtering rules are applied.
Homepage: https://sdns.360.net

sdns://AgAAAAAAAAAAACBGRinMfizEpf6XTTrC4BNXB3syOlkxKYNaWpRbX7u40Qpkb2guMzYwLmNuCi9kbnMtcXVlcnk


## quad9-dnscrypt-ip4-filter-ecs-pri

Quad9 (anycast) dnssec/no-log/filter/ecs 9.9.9.11 - 149.112.112.11

sdns://AQMAAAAAAAAADTkuOS45LjExOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQMAAAAAAAAAEzE0OS4xMTIuMTEyLjExOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip4-filter-pri

Quad9 (anycast) dnssec/no-log/filter 9.9.9.9 - 149.112.112.9 - 149.112.112.112

sdns://AQMAAAAAAAAADDkuOS45Ljk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAEjE0OS4xMTIuMTEyLjk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAFDE0OS4xMTIuMTEyLjExMjo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ


## quad9-dnscrypt-ip4-nofilter-ecs-pri

Quad9 (anycast) no-dnssec/no-log/no-filter/ecs 9.9.9.12 - 149.112.112.12

sdns://AQYAAAAAAAAADTkuOS45LjEyOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQYAAAAAAAAAEzE0OS4xMTIuMTEyLjEyOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip4-nofilter-pri

Quad9 (anycast) no-dnssec/no-log/no-filter 9.9.9.10 - 149.112.112.10

sdns://AQYAAAAAAAAADTkuOS45LjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA
sdns://AQYAAAAAAAAAEzE0OS4xMTIuMTEyLjEwOjg0NDMgZ8hHuMh1jNEgJFVDvnVnRt803x2EwAuMRwNo34Idhj4ZMi5kbnNjcnlwdC1jZXJ0LnF1YWQ5Lm5ldA


## quad9-dnscrypt-ip6-filter-ecs-pri

Quad9 (anycast) dnssec/no-log/filter/ecs 2620:fe::11 - 2620:fe::fe:11

sdns://AQMAAAAAAAAAElsyNjIwOmZlOjoxMV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAFVsyNjIwOmZlOjpmZToxMV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-dnscrypt-ip6-filter-pri

Quad9 (anycast) dnssec/no-log/filter 2620:fe::fe - 2620:fe::9 - 2620:fe::fe:9

sdns://AQMAAAAAAAAAElsyNjIwOmZlOjpmZV06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQMAAAAAAAAAEVsyNjIwOmZlOjo5XTo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ
sdns://AQMAAAAAAAAAFFsyNjIwOmZlOjpmZTo5XTo4NDQzIGfIR7jIdYzRICRVQ751Z0bfNN8dhMALjEcDaN-CHYY-GTIuZG5zY3J5cHQtY2VydC5xdWFkOS5uZXQ


## quad9-dnscrypt-ip6-nofilter-ecs-pri

Quad9 (anycast) no-dnssec/no-log/no-filter/ecs 2620:fe::12 - 2620:fe::fe:12

sdns://AQYAAAAAAAAAElsyNjIwOmZlOjoxMl06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQYAAAAAAAAAFVsyNjIwOmZlOjpmZToxMl06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-dnscrypt-ip6-nofilter-pri

Quad9 (anycast) no-dnssec/no-log/no-filter 2620:fe::10 - 2620:fe::fe:10

sdns://AQYAAAAAAAAAElsyNjIwOmZlOjoxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0
sdns://AQYAAAAAAAAAFVsyNjIwOmZlOjpmZToxMF06ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0


## quad9-doh-ip4-port443-filter-ecs-pri

Quad9 (anycast) dnssec/no-log/filter/ecs 9.9.9.11 - 149.112.112.11

sdns://AgMAAAAAAAAACDkuOS45LjExILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczExLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADjE0OS4xMTIuMTEyLjExILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczExLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip4-port443-filter-pri

Quad9 (anycast) dnssec/no-log/filter 9.9.9.9 - 149.112.112.9 - 149.112.112.112

sdns://AgMAAAAAAAAABzkuOS45LjkgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8SZG5zOS5xdWFkOS5uZXQ6NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAADTE0OS4xMTIuMTEyLjkgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8SZG5zOS5xdWFkOS5uZXQ6NDQzCi9kbnMtcXVlcnk


## quad9-doh-ip4-port443-nofilter-ecs-pri

Quad9 (anycast) no-dnssec/no-log/no-filter/ecs 9.9.9.12 - 149.112.112.12

sdns://AgYAAAAAAAAACDkuOS45LjEyILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEyLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgYAAAAAAAAADjE0OS4xMTIuMTEyLjEyILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEyLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip4-port443-nofilter-pri

Quad9 (anycast) no-dnssec/no-log/no-filter 9.9.9.10 - 149.112.112.10

sdns://AgYAAAAAAAAACDkuOS45LjEwILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEwLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgYAAAAAAAAADjE0OS4xMTIuMTEyLjEwILAZIHRLu3bJqwU-AeB7fgUORz0g95976kNfr-Q8nSQvE2RuczEwLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip6-port443-filter-ecs-pri

Quad9 (anycast) dnssec/no-log/filter/ecs 2620:fe::11 - 2620:fe::fe:11

sdns://AgMAAAAAAAAADVsyNjIwOmZlOjoxMV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTEucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAEFsyNjIwOmZlOjpmZToxMV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTEucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## quad9-doh-ip6-port443-filter-pri

Quad9 (anycast) dnssec/no-log/filter 2620:fe::fe - 2620:fe::9 - 2620:fe::fe:9

sdns://AgMAAAAAAAAADVsyNjIwOmZlOjpmZV0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8RZG5zLnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ
sdns://AgMAAAAAAAAADFsyNjIwOmZlOjo5XSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxFkbnMucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAAD1syNjIwOmZlOjpmZTo5XSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxJkbnM5LnF1YWQ5Lm5ldDo0NDMKL2Rucy1xdWVyeQ


## quad9-doh-ip6-port443-nofilter-ecs-pri

Quad9 (anycast) no-dnssec/no-log/no-filter/ecs 2620:fe::12 - 2620:fe::fe:12

sdns://AgYAAAAAAAAADVsyNjIwOmZlOjoxMl0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTIucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgYAAAAAAAAAEFsyNjIwOmZlOjpmZToxMl0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTIucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## quad9-doh-ip6-port443-nofilter-pri

Quad9 (anycast) no-dnssec/no-log/no-filter 2620:fe::10 - 2620:fe::fe:10

sdns://AgYAAAAAAAAADVsyNjIwOmZlOjoxMF0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTAucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5
sdns://AgYAAAAAAAAAEFsyNjIwOmZlOjpmZToxMF0gsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8TZG5zMTAucXVhZDkubmV0OjQ0MwovZG5zLXF1ZXJ5


## restena-doh-ipv4

DNSSEC, No-log and No-filter DoH operated by RESTENA. Homepage: https://www.restena.lu

sdns://AgcAAAAAAAAACzE1OC42NC4xLjI5IDDf1DoabxEd4ETIZd8xjTi-zEq1FHcQJ7CmCmYcUM5WEWRuc3B1Yi5yZXN0ZW5hLmx1Ci9kbnMtcXVlcnk


## restena-doh-ipv6

DNSSEC, No-log and No-filter DoH (IPv6) operated by RESTENA. Homepage: https://www.restena.lu

sdns://AgcAAAAAAAAAEFsyMDAxOmExODoxOjoyOV0gMN_UOhpvER3gRMhl3zGNOL7MSrUUdxAnsKYKZhxQzlYRZG5zcHViLnJlc3RlbmEubHUKL2Rucy1xdWVyeQ


## rethinkdns-doh

No-log, No-filter
RethinkDNS, a stub (sky.rethinkdns.com hosted on Cloudflare) and recursive (max.rethinkdns.com hosted on fly.io) resolver
The stub server strips identification parameters from the request and acts as a proxy to another recursive resolver.

sdns://AgYAAAAAAAAAACBdzvEcz84tL6QcR78t69kc0nufblyYal5di10An6SyUBJza3kucmV0aGlua2Rucy5jb20KL2Rucy1xdWVyeQ
sdns://AgYAAAAAAAAAACCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGRJtYXgucmV0aGlua2Rucy5jb20KL2Rucy1xdWVyeQ


## safesurfer

Family safety focused blocklist for over 2 million adult sites, as well as phishing and malware and more.
Free to use, paid for customizing blocking for more categories+sites and viewing usage at my.safesurfer.io. Logs taken for viewing
usage, data never sold - https://safesurfer.io

Warning: this server is incompatible with DNS anonymization.

sdns://AQIAAAAAAAAADzEwNC4xNTUuMjM3LjIyNSAnIH_VEgToNntINABd-f_R0wu-KpwzY55u2_iu2R1A2CAyLmRuc2NyeXB0LWNlcnQuc2FmZXN1cmZlci5jby5ueg


## safesurfer-doh

Family safety focused blocklist for over 2 million adult sites, as well as phishing and malware and more.
Free to use, paid for customizing blocking for more categories+sites and viewing usage at my.safesurfer.io. Logs taken for viewing
usage, data never sold - https://safesurfer.io

sdns://AgAAAAAAAAAAACBW1D4A3rPRi8QazGGnZq98S8bEb0ZyDjFdjqVEtSPc3BFkb2guc2FmZXN1cmZlci5pbwovZG5zLXF1ZXJ5


## saldns01-conoha-ipv4

Hosted on ConoHa VPS Tokyo region. No log. No filter. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFDE2My40NC4xMjQuMjA0OjUwNDQzIGvWmxvhx79edG-xPZxrQR1g9jFOofVRDbPFCGWVGV1PIjIuZG5zY3J5cHQtY2VydC5zYWxkbnMwMS50eXBlcS5vcmc


## saldns02-conoha-ipv4

Hosted on ConoHa VPS Tokyo region. No log. No filter. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFTE2MC4yNTEuMjE0LjE3Mjo1MDQ0MyB7SI0q4_Ff8lFRUCbjPtcAQ3HfdWlLxyGDUUNc3NUZdiIyLmRuc2NyeXB0LWNlcnQuc2FsZG5zMDIudHlwZXEub3Jn


## saldns03-conoha-ipv4

Hosted on ConoHa VPS Tokyo region. No log. No filter. From experimental &mu;ODNS project https://junkurihara.github.io/dns/.

sdns://AQcAAAAAAAAAFDE2MC4yNTEuMTY4LjI1OjUwNDQzIFl1NfOwMd24kRlr0mXR4rKo-c_jMV7DBUVooDEY1xFeIjIuZG5zY3J5cHQtY2VydC5zYWxkbnMwMy50eXBlcS5vcmc


## scaleway-ams

DNSSEC/Non-logged/Uncensored in Amsterdam - DEV1-S instance donated by Scaleway.com
Maintained by Frank Denis - https://fr.dnscrypt.info

sdns://AQcAAAAAAAAADTUxLjE1LjEyMi4yNTAg6Q3ZfapcbHgiHKLF7QFoli0Ty1Vsz3RXs1RUbxUrwZAcMi5kbnNjcnlwdC1jZXJ0LnNjYWxld2F5LWFtcw


## scaleway-ams-ipv6

DNSSEC/Non-logged/Uncensored in Amsterdam - IPv6 only - DEV1-S instance donated by Scaleway.com
Maintained by Frank Denis - https://fr.dnscrypt.info

sdns://AQcAAAAAAAAAJlsyMDAxOmJjODoxNjQwOjFjZTI6ZGMwMDpmZjpmZTI4OjViMTddIOkN2X2qXGx4Ihyixe0BaJYtE8tVbM90V7NUVG8VK8GQHDIuZG5zY3J5cHQtY2VydC5zY2FsZXdheS1hbXM


## scaleway-fr

DNSSEC/Non-logged/Uncensored in Paris - DEV1-S instance donated by Scaleway.com
Maintained by Frank Denis - https://fr.dnscrypt.info

sdns://AQcAAAAAAAAADjIxMi40Ny4yMjguMTM2IOgBuE6mBr-wusDOQ0RbsV66ZLAvo8SqMa4QY2oHkDJNHzIuZG5zY3J5cHQtY2VydC5mci5kbnNjcnlwdC5vcmc


## scaleway-fr-ipv6

DNSSEC/Non-logged/Uncensored in Paris - IPv6 only - DEV1-S instance donated by Scaleway.com
Maintained by Frank Denis - https://fr.dnscrypt.info

sdns://AQcAAAAAAAAAJVsyMDAxOmJjODo3MTA6NTgxODpkYzAwOmZmOmZlNWI6M2Y2M10g6AG4TqYGv7C6wM5DRFuxXrpksC-jxKoxrhBjageQMk0fMi5kbnNjcnlwdC1jZXJ0LmZyLmRuc2NyeXB0Lm9yZw


## searx-se-ipv4

No-filtering - No-logging - Sweden - IPv4

sdns://AQcAAAAAAAAAEzE4NS4xOTUuMjM2LjE2OjU0NDMgL5FKFwxJ_35yPTqBA_GxELJMhgzr8RCbThTPXO_0OgEYMi5kbnNjcnlwdC1jZXJ0LnNlYXJ4LWNj


## searx-se-ipv6

No-filtering - No-logging - Sweden - IPv6

sdns://AQcAAAAAAAAAGlsyYTA5OmIyODA6ZmUwMTplOjphXTo1NDQzIC-RShcMSf9-cj06gQPxsRCyTIYM6_EQm04Uz1zv9DoBGDIuZG5zY3J5cHQtY2VydC5zZWFyeC1jYw


## serbica

Public DNSCrypt server in the Netherlands by https://litepay.ch

sdns://AQcAAAAAAAAAEzE4NS42Ni4xNDMuMTc4OjUzNTMg-Y2MQmGOXiggAEKulN-ITGEn_Kj3TIP1UK1X2wh3o7wXMi5kbnNjcnlwdC1jZXJ0LnNlcmJpY2E


## sfw.scaleway-fr

Uses deep learning to block adult websites. Free, DNSSEC, no logs.
Hosted in Paris, running on a 1-XS server donated by Scaleway.com

Maintained by Frank Denis - https://fr.dnscrypt.info/sfw.html

sdns://AQMAAAAAAAAADzE2My4xNzIuMTgwLjEyNSDfYnO_x1IZKotaObwMhaw_-WRF1zZE9mJygl01WPGh_x8yLmRuc2NyeXB0LWNlcnQuc2Z3LnNjYWxld2F5LWZy


## switch

Public DoH service provided by SWITCH in Switzerland. Provides protection against malware, but does not block ads.
Homepage: https://www.switch.ch

sdns://AgMAAAAAAAAADTEzMC41OS4zMS4yNDggsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8NMTMwLjU5LjMxLjI0OAovZG5zLXF1ZXJ5
sdns://AgMAAAAAAAAADTEzMC41OS4zMS4yNTEgsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8NMTMwLjU5LjMxLjI1MQovZG5zLXF1ZXJ5


## switch-ipv6

Public DoH (IPv6) service provided by SWITCH in Switzerland. Provides protection against malware, but does not block ads.
Homepage: https://www.switch.ch

sdns://AgMAAAAAAAAAElsyMDAxOjYyMDowOmZmOjoyXSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxZbMjAwMTo2MjA6MDpmZjo6Ml06NDQzCi9kbnMtcXVlcnk
sdns://AgMAAAAAAAAAElsyMDAxOjYyMDowOmZmOjozXSCwGSB0S7t2yasFPgHge34FDkc9IPefe-pDX6_kPJ0kLxZbMjAwMTo2MjA6MDpmZjo6M106NDQzCi9kbnMtcXVlcnk


## uncensoreddns-dk-ipv4

Also known as censurfridns.
DoH, no logs, no filter, unicast hosted in Denmark - https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAADDg5LjIzMy40My43MSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMORl1bmljYXN0LnVuY2Vuc29yZWRkbnMub3JnCi9kbnMtcXVlcnk


## uncensoreddns-dk-ipv6

Also known as censurfridns.
DoH, no logs, no filter, unicast hosted in Denmark - https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAAElsyYTAxOjNhMDo1Mzo1Mzo6XSCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMORl1bmljYXN0LnVuY2Vuc29yZWRkbnMub3JnCi9kbnMtcXVlcnk


## uncensoreddns-ipv4

Also known as censurfridns.
DoH, no logs, no filter, anycast - https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAADjkxLjIzOS4xMDAuMTAwILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0GWFueWNhc3QudW5jZW5zb3JlZGRucy5vcmcKL2Rucy1xdWVyeQ


## uncensoreddns-ipv6

Also known as censurfridns.
DoH, no logs, no filter, anycast - https://blog.uncensoreddns.org

sdns://AgYAAAAAAAAAEVsyMDAxOjY3YzoyOGE0OjpdILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0GWFueWNhc3QudW5jZW5zb3JlZGRucy5vcmcKL2Rucy1xdWVyeQ


## userspace-australia

DNSCrypt in Australia (Brisbane & Melbourne) by UserSpace.
No logs | IPv4 | Filtered

sdns://AQIAAAAAAAAAEDEwMy4xNi4xMzEuNzc6NTQgnRNtOLv4IzxEfkbLFOaHa-ncLImdQiP-pS1jaFY5jlUdMi5kbnNjcnlwdC1jZXJ0LnVzZXJzcGFjZS1ibmU
sdns://AQIAAAAAAAAAEjEwMy4yMzYuMTYyLjExOTo1NCBPr5jCD_2geOTMmS5LgQg_v79pgppTm3vLZhe_oahbgR0yLmRuc2NyeXB0LWNlcnQudXNlcnNwYWNlLW1lbA


## userspace-australia-ipv6

DNSCrypt in Australia (Brisbane & Melbourne) by UserSpace.
No logs | IPv6 | Filtered

sdns://AQIAAAAAAAAAJVsyNDA0Ojk0MDA6MTowOjIxNjozZWZmOmZlZjA6MTgwYV06NTQgnRNtOLv4IzxEfkbLFOaHa-ncLImdQiP-pS1jaFY5jlUdMi5kbnNjcnlwdC1jZXJ0LnVzZXJzcGFjZS1ibmU
sdns://AQIAAAAAAAAAJVsyNDA0Ojk0MDA6MzowOjIxNjozZWZmOmZlZTA6N2Y2OV06NTQgT6-Ywg_9oHjkzJkuS4EIP7-_aYKaU5t7y2YXv6GoW4EdMi5kbnNjcnlwdC1jZXJ0LnVzZXJzcGFjZS1tZWw


## wikimedia

Wikimedia DNS (formerly called Wikidough), is a caching, recursive,
public resolver service that is run and managed by the Site
Reliability Engineering (Traffic) team at the Foundation.

Wikimedia DNS helps prevent some surveillance and censorship of our
wikis and other websites by securing DNS lookups.

sdns://AgcAAAAAAAAADjE4NS43MS4xMzguMTM4ILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0EXdpa2ltZWRpYS1kbnMub3JnCi9kbnMtcXVlcnk


## yandex

Yandex public DNS server (anycast)

sdns://AgUAAAAAAAAACTc3Ljg4LjguMSCoF6cUD2dwqtorNi96I2e3nkHPSJH1ka3xbdOglmOVkQk3Ny44OC44LjEKL2Rucy1xdWVyeQ
sdns://AgUAAAAAAAAACTc3Ljg4LjguOCCoF6cUD2dwqtorNi96I2e3nkHPSJH1ka3xbdOglmOVkQk3Ny44OC44LjgKL2Rucy1xdWVyeQ


## yandex-ipv6

Yandex public DNS server (anycast IPv6)

sdns://AgUAAAAAAAAAE1syYTAyOjZiODo6ZmVlZDpmZl0gqBenFA9ncKraKzYveiNnt55Bz0iR9ZGt8W3ToJZjlZEJNzcuODguOC4xCi9kbnMtcXVlcnk
sdns://AgUAAAAAAAAAF1syYTAyOjZiODowOjE6OmZlZWQ6ZmZdIKgXpxQPZ3Cq2is2L3ojZ7eeQc9IkfWRrfFt06CWY5WRCTc3Ljg4LjguMQovZG5zLXF1ZXJ5


## yandex-safe

Yandex public DNS server with malware filtering (anycast)

sdns://AgEAAAAAAAAACTc3Ljg4LjguMiCoF6cUD2dwqtorNi96I2e3nkHPSJH1ka3xbdOglmOVkQk3Ny44OC44LjIKL2Rucy1xdWVyeQ
sdns://AgEAAAAAAAAACjc3Ljg4LjguODggqBenFA9ncKraKzYveiNnt55Bz0iR9ZGt8W3ToJZjlZEKNzcuODguOC44OAovZG5zLXF1ZXJ5


## yandex-safe-ipv6

Yandex public DNS server with malware filtering (anycast IPv6)

sdns://AgEAAAAAAAAAFFsyYTAyOjZiODo6ZmVlZDpiYWRdIKgXpxQPZ3Cq2is2L3ojZ7eeQc9IkfWRrfFt06CWY5WRCTc3Ljg4LjguMgovZG5zLXF1ZXJ5
sdns://AgEAAAAAAAAAGFsyYTAyOjZiODowOjE6OmZlZWQ6YmFkXSCoF6cUD2dwqtorNi96I2e3nkHPSJH1ka3xbdOglmOVkQk3Ny44OC44LjIKL2Rucy1xdWVyeQ

