Ext.namespace("SYNO.SDS.PelicanWings.Utils");

Ext.apply(SYNO.SDS.PelicanWings.Utils, function(){
    return {
        getMainHtml: function(){
            var host = window.location.hostname;
            return '<iframe src="http://' + host + ':8080/wings-config?_ts=' + new Date().getTime() + '" title="Wings Configuration" style="width: 100%; height: 100%; border: none; margin: 0; background: #0a1628;"/>';
        }
    };
}());

Ext.define("SYNO.SDS.PelicanWings.Application", {
    extend: "SYNO.SDS.AppInstance",
    appWindowName: "SYNO.SDS.PelicanWings.MainWindow",
    constructor: function(){
        this.callParent(arguments);
    }
});

Ext.define("SYNO.SDS.PelicanWings.MainWindow", {
    extend: "SYNO.SDS.AppWindow",
    constructor: function(a){
        var MY = SYNO.SDS.PelicanWings;
        this.appInstance = a.appInstance;
        MY.MainWindow.superclass.constructor.call(this, Ext.apply({
            layout: "fit",
            resizable: true,
            cls: "syno-pelican-wings-win",
            maximizable: true,
            minimizable: true,
            width: 900,
            height: 700,
            html: MY.Utils.getMainHtml()
        }, a));
        MY.Utils.ApplicationWindow = this;
    },

    onOpen: function(){
        SYNO.SDS.PelicanWings.MainWindow.superclass.onOpen.apply(this, arguments);
    },

    onRequest: function(a){
        SYNO.SDS.PelicanWings.MainWindow.superclass.onRequest.call(this, a);
    },

    onClose: function(){
        clearTimeout(SYNO.SDS.PelicanWings.TimeOutID);
        SYNO.SDS.PelicanWings.TimeOutID = undefined;
        SYNO.SDS.PelicanWings.MainWindow.superclass.onClose.apply(this, arguments);
        this.doClose();
        return true;
    }
});
