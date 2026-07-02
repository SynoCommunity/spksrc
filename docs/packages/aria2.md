# Aria2

[Aria2](http://aria2.github.io) is a lightweight multi-protocol and multi-source command-line download utility.

## Package Options

If you need the `aria2c` command line tool only, you can use the [synocli-net](synocli-net.md) package.

To host an aria2 server on DSM, install the [aria2 package](https://synocommunity.com/package/aria2).

## AriaNg Web Frontend

SynoCommunity also provides a package for [AriaNg](https://ariang.mayswind.net/). This is a modern web frontend making aria2 easier to use. It can be used with any aria2 service that is reachable from the DSM system it is installed on.

## Known Issues

With aria2 and ariang installed on DSM, ariang could connect to aria2 only with the `WebSocket` protocol. The connection with `http` protocol was not possible, neither with `GET` nor `POST` Methods.

This can be caused by aria2 configuration or ariang implementation.

Please [create an issue](https://github.com/SynoCommunity/spksrc/issues) if you have further information or a solution regarding the http rpc connection.
