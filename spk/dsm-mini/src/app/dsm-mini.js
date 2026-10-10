// The window DSM opens from its main menu.
//
// It is deliberately thin: a DSM app is written in Ext JS against an internal
// framework that is neither documented nor stable between releases, so the
// only thing written against it here is a frame. Everything a person sees is
// an ordinary page in index.html, which is also what makes it testable in a
// normal browser.
//
// "allUsers": false in config keeps the icon out of a non-administrator's
// menu, but that is a courtesy, not a guard: DSM serves /webman/3rdparty/ to
// anyone, so the service checks the session on every request of its own.
Ext.ns("SYNOCOMMUNITY.DsmMini");

Ext.define("SYNOCOMMUNITY.DsmMini.AppInstance", {
    extend: "SYNO.SDS.AppInstance",
    appWindowName: "SYNOCOMMUNITY.DsmMini.AppWindow",
    constructor: function () {
        this.callParent(arguments);
    }
});

Ext.define("SYNOCOMMUNITY.DsmMini.AppWindow", {
    extend: "SYNO.SDS.AppWindow",
    constructor: function (config) {
        this.callParent([Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: 760,
            height: 720,
            minWidth: 420,
            minHeight: 480,
            layout: "fit",
            border: false,
            items: [{
                xtype: "box",
                itemId: "appframe",
                autoEl: {
                    tag: "iframe",
                    // A new address on every open. DSM's web server sends these
                    // files with no Cache-Control, so a browser may go on
                    // showing the page of the previous version for hours after
                    // an upgrade; the page passes the same value on to its
                    // scripts.
                    src: "/webman/3rdparty/dsm-mini/index.html?v=" + Date.now(),
                    frameborder: "0",
                    style: "width:100%; height:100%; border:none;"
                }
            }]
        }, config)]);
    }
});
