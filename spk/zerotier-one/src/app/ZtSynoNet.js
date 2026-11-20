// zerotier-one — DSM 7 app: a DSM window that hosts index.html in an iframe.
// DSM 7 opens "legacy" and "url" apps in a separate browser tab, where the page
// cannot reach the DSM session (SynoToken); inside this window it can.
Ext.ns('SynoCommunity.ZeroTierOne');

Ext.define('SynoCommunity.ZeroTierOne.Instance', {
    extend: 'SYNO.SDS.AppInstance',
    appWindowName: 'SynoCommunity.ZeroTierOne.MainWindow',
    constructor: function () {
        this.callParent(arguments);
    }
});

Ext.define('SynoCommunity.ZeroTierOne.MainWindow', {
    extend: 'SYNO.SDS.AppWindow',
    constructor: function (config) {
        this.callParent([Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: 900,
            height: 640,
            minWidth: 560,
            minHeight: 420,
            layout: 'fit',
            items: [{
                xtype: 'box',
                autoEl: {
                    tag: 'iframe',
                    src: '/webman/3rdparty/zerotier-one/index.html?v=1.16.2-1',
                    title: 'ZeroTier',
                    frameborder: 0,
                    style: 'border:0;width:100%;height:100%;display:block;background:#fff'
                }
            }]
        }, config)]);
    }
});
