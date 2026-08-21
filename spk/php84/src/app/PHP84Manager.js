/**
 * PHP 8.4 Extension Manager for Synology DSM 7
 */

Ext.ns('SYNO.SDS.PHP84Manager');

// Utils (dependency)
SYNO.SDS.PHP84Manager.Utils = {};

// Main Window
SYNO.SDS.PHP84Manager.MainWindow = Ext.extend(SYNO.SDS.AppWindow, {
    constructor: function(config) {
        var self = this;
        self.appInstance = config.appInstance;

        SYNO.SDS.PHP84Manager.MainWindow.superclass.constructor.call(self, Ext.apply({
            title: 'PHP 8.4 Extension Manager',
            width: 950,
            height: 650,
            minWidth: 800,
            minHeight: 500,
            resizable: true,
            maximizable: true,
            minimizable: true,
            layout: 'fit',
            items: [{
                xtype: 'box',
                autoEl: {
                    tag: 'iframe',
                    src: 'webman/3rdparty/php84/index.cgi?t=' + new Date().getTime(),
                    style: 'width:100%;height:100%;border:none;'
                }
            }]
        }, config));
    }
});

// Application
SYNO.SDS.PHP84Manager.Application = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName: 'SYNO.SDS.PHP84Manager.MainWindow',

    constructor: function(config) {
        SYNO.SDS.PHP84Manager.Application.superclass.constructor.call(this, config);
    }
});
