// Namespace definition
Ext.ns("SYNOCOMMUNITY.SimpleExtJSApp");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.SimpleExtJSApp.WidgetCustom", category, element)
}

Ext.ns("SYNO.SDS.SystemInfoApp");

Ext.define("SYNOCOMMUNITY.SimpleExtJSApp.WidgetCustom", {
    extend: "Ext.Panel",
    minimizable: true,
    taskButton: undefined,
    constructor: function constructor(a) {
        this.initializeSouthTable();
        var b = Ext.apply(this.getConfig(), a);
        SYNOCOMMUNITY.SimpleExtJSApp.WidgetCustom.superclass.constructor.call(this, b);
        this.westIcon = this.getIconComponent();
        this.centerContent = this.getContentComponent();
        this.isActive = false;
        this.timestamp = null;
        this.uptime = null;
        this.appSetting = SYNO.SDS.SystemInfoApp.SystemHealthDefaultApp
    },
    getConfig: function getConfig() {
        return {
            layout: "fit",
            border: false,
            defaults: {
                border: false
            },
            items: [this.getViewConfig()]
        }
    },
    getViewConfig: function getViewConfig() {
        return {
            itemId: "layoutPanel",
            layout: "vbox",
            height: "100%",
            border: false,
            padding: "4px 12px 5px 12px",
            cls: "syno-sysinfo-system-health",
            defaults: {
                border: false
            },
            items: [{
                xtype: "container",
                itemId: "northPanel",
                height: 20,
                width: 296,
                cls: "syno-sysinfo-system-health-status",
                items: [{
                    xtype: "box",
                    itemId: "westIcon"
                }, {
                    xtype: "box",
                    itemId: "centerContent",
                    region: "center"
                }]
            }, {
                region: "south",
                height: 84,
                width: 296,
                items: this.southTable
            }]
        }
    },
    doCollapse: function doCollapse() {
        this.getEl().setHeight(84);
        this.doLayout()
    },
    doExpand: function doExpand() {
        this.getEl().setHeight(172);
        this.doLayout()
    },
    setApp: function setApp(a) {
        this.appSetting = a
    },

    getIconComponent: function getIconComponent() {
        return this.getComponent("layoutPanel").getComponent("northPanel").getComponent("westIcon")
    },
    getContentComponent: function getContentComponent() {
        return this.getComponent("layoutPanel").getComponent("northPanel").getComponent("centerContent")
    },
    onClickTitle: function onClickTitle() {
        SYNO.SDS.AppLaunch(this.appSetting.appInstance, this.appSetting.launchParam)
    },
    onActivate: function onActivate() {
        this.isActive = true;
    },
    onDeactivate: function onDeactivate() {
        this.isActive = false;
        this.unmask()
    },
    mask: Ext.emptyFn,
    unmask: Ext.emptyFn,
    initializeSouthTable: function initializeSouthTable() {
        var b = Ext.util.Format.htmlEncode(_V("app", "message"));
        var c = Ext.util.Format.htmlEncode(_S("hostname"));
        this.southTable = new Ext.Panel({
            layout: "table",
            itemId: "southTable",
            cls: "sys-info-south-table",
            margins: 0,
            height: 84,
            layoutConfig: {
                columns: 2,
                cellCls: "sys-info-row"
            },
            items: [{
                xtype: "box",
                html: String.format('<p ext:qtip="{1}" class="syno-sysinfo-system-health-south-title">{0}</p>', b, Ext.util.Format.htmlEncode(b))
            }, {
                xtype: "box",
                html: String.format('<p ext:qtip="{1}" class="syno-sysinfo-system-health-south-data">{0}</p>', c, Ext.util.Format.htmlEncode(c))
            }]
        })
    },

    destroy: function destroy() {
        var a = this;
        a.onDeactivate();
        if (a.taskButton) {
            Ext.destroy(a.taskButton)
        }
        if (a.southGrid && a.southGrid.getStore()) {
            a.southGrid.getStore().destroy()
        }
        SYNOCOMMUNITY.SimpleExtJSApp.WidgetCustom.superclass.destroy.call(this)
    }
});
