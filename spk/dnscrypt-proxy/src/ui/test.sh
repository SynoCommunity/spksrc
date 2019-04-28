#!/bin/sh

set -u

urlencode() {
    # https://stackoverflow.com/questions/296536/how-to-urlencode-data-for-curl-command/10797966#10797966
    echo "$1" | curl -Gso /dev/null -w %{url_effective} --data-urlencode @- "" | cut -c 3-
}

countBytes() {
    echo "$1" | wc -c | xargs
}

# ---------------------------------------------------------------------------

setup() {
    mkdir -p test/bin test/var
    #ln -sf $(pwd)/../../work-*/install/var/packages/dnscrypt-proxy/target/bin/dnscrypt-proxy test/bin/dnscrypt-proxy
    ln -sf $(which dnscrypt-proxy) test/bin/dnscrypt-proxy
    cp ../../work-*/install/var/packages/dnscrypt-proxy/target/example-* test/var/
    for file in test/var/example-*; do
        mv "${file}" "${file//example-/}"
    done

    wget -t 3 -O test/var/generate-domains-blacklist.py \
        --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/generate-domains-blacklist.py
    echo "file:domains-blacklist-local-additions.txt" > test/var/domains-blacklist.conf
    # wget -t 3 -O test/var/domains-blacklist.conf \
    #     --https-only https://raw.githubusercontent.com/jedisct1/dnscrypt-proxy/master/utils/generate-domains-blacklists/domains-blacklist.conf
    touch test/var/domains-whitelist.txt
    touch test/var/domains-time-restricted.txt
    touch test/var/domains-blacklist-local-additions.txt
}

fixLinks() {
    sed -i '' -e "s@/webman/3rdparty/dnscrypt-proxy/style\\.css@../style\\.css@" $1
    sed -i '' -e "s@codemirror/@../codemirror/@" $1
}

if [ ! -d test ]; then
    echo "Preparing test folder.."
    setup
fi

## lint
# gofmt -s -w cgi.go

## build
# go get github.com/BurntSushi/toml
go build -ldflags "-s -w" -o index.cgi

# compress
# upx --brute index.cgi

## test
export REQUEST_METHOD=GET
export SERVER_PROTOCOL=HTTP/1.1
./index.cgi --dev | tail -n +4 > test/index.html
fixLinks test/index.html

export REQUEST_METHOD=POST
export CONTENT_TYPE="application/x-www-form-urlencoded"
data="file=config&fileContent=$(urlencode "$(cat test/var/dnscrypt-proxy.toml)")"
numOfBytes=$(countBytes "$data")
export CONTENT_LENGTH=$numOfBytes
echo "$data" | ./index.cgi --dev | tail -n +4 > test/post.html
fixLinks test/post.html

export REQUEST_METHOD=GET
export QUERY_STRING=file=blocklist
./index.cgi --dev | tail -n +4 > test/get.html
fixLinks test/get.html

export REQUEST_METHOD=POST
export CONTENT_TYPE="application/x-www-form-urlencoded"
data="generateBlocklist=true"
numOfBytes=$(countBytes "$data")
export CONTENT_LENGTH=$numOfBytes
echo "$data" | ./index.cgi --dev > test/generateBlocklist.html
fixLinks test/generateBlocklist.html
