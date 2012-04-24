// Namespace
Ext.ns("SYNOCOMMUNITY.DebianChroot");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.DebianChroot.AppInstance", category, element)
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/debian-chroot/debian-chroot.cgi",
    "namespace": "SYNOCOMMUNITY.DebianChroot.Remote",
    "type": "remoting",
    "actions": {
        "Services": [{
            "name": "save",
            "len": 5
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "start",
            "len": 1
        }, {
            "name": "stop",
            "len": 1
        }]
    }
});
SYNOCOMMUNITY.DebianChroot.Poller = new Ext.direct.PollingProvider({
    'type': 'polling',
    'url': '3rdparty/debian-chroot/debian-chroot-poll.cgi',
    'intervall': 6000
});
Ext.Direct.addProvider(SYNOCOMMUNITY.DebianChroot.Poller);
SYNOCOMMUNITY.DebianChroot.Poller.disconnect();

// Fix for RadioGroup reset bug
Ext.form.RadioGroup.override({
    reset: function () {
        if (this.originalValue) {
            this.setValue(this.originalValue.inputValue);
        } else {
            this.eachItem(function (c) {
                if (c.reset) {
                    c.reset();
                }
            });
        }

        (function () {
            this.clearInvalid();
        }).defer(50, this);
    },
    isDirty: function () {
        if (this.disabled || !this.rendered) {
            return false;
        }
        return String(this.getValue().inputValue) !== String(this.originalValue.inputValue);
    }
});

// ActionColumn from ExtJS 3.3
Ext.grid.ActionColumn = Ext.extend(Ext.grid.Column, {
    header: '&#160;',
    actionIdRe: /x-action-col-(\d+)/,
    altText: '',
    constructor: function(cfg) {
        var me = this,
            items = cfg.items || (me.items = [me]),
            l = items.length,
            i,
            item;
        Ext.grid.ActionColumn.superclass.constructor.call(me, cfg);
        me.renderer = function(v, meta) {
            v = Ext.isFunction(cfg.renderer) ? cfg.renderer.apply(this, arguments)||'' : '';

            meta.css += ' x-action-col-cell';
            for (i = 0; i < l; i++) {
                item = items[i];
                v += '<img alt="' + (item.altText || me.altText) + '" src="' + (item.icon || Ext.BLANK_IMAGE_URL) +
                    '" class="x-action-col-icon x-action-col-' + String(i) + ' ' + (item.iconCls || '') +
                    ' ' + (Ext.isFunction(item.getClass) ? item.getClass.apply(item.scope||this.scope||this, arguments) : '') + '"' +
                    ((item.tooltip) ? ' ext:qtip="' + item.tooltip + '"' : '') + ' />';
            }
            return v;
        };
    },
    destroy: function() {
        delete this.items;
        delete this.renderer;
        return Ext.grid.ActionColumn.superclass.destroy.apply(this, arguments);
    },
    processEvent : function(name, e, grid, rowIndex, colIndex){
        var m = e.getTarget().className.match(this.actionIdRe),
            item, fn;
        if (m && (item = this.items[parseInt(m[1], 10)])) {
            if (name == 'click') {
                (fn = item.handler || this.handler) && fn.call(item.scope||this.scope||this, grid, rowIndex, colIndex, item, e);
            } else if ((name == 'mousedown') && (item.stopSelection !== false)) {
                return false;
            }
        }
        return Ext.grid.ActionColumn.superclass.processEvent.apply(this, arguments);
    }
});
Ext.apply(Ext.grid.Column.types, {actioncolumn: Ext.grid.ActionColumn})

// Const
SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT = 300;
SYNOCOMMUNITY.DebianChroot.MAIN_WIDTH = 800;
SYNOCOMMUNITY.DebianChroot.LIST_WIDTH = 210;

// Application
SYNOCOMMUNITY.DebianChroot.AppInstance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName: "SYNOCOMMUNITY.DebianChroot.AppWindow",
    constructor: function () {
        SYNOCOMMUNITY.DebianChroot.AppInstance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SYNOCOMMUNITY.DebianChroot.AppWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,
    mainPanel: null,
    constructor: function (config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SYNOCOMMUNITY.DebianChroot.MainPanel({
            owner: this
        });
        config = Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: SYNOCOMMUNITY.DebianChroot.MAIN_WIDTH,
            height: SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT,
            layout: "fit",
            border: false,
            cls: "synocommunity-debianchroot",
            items: [this.mainPanel]
        }, config);
        SYNOCOMMUNITY.DebianChroot.AppWindow.superclass.constructor.call(this, config);
    },
    onOpen: function (a) {
        SYNOCOMMUNITY.DebianChroot.AppWindow.superclass.onOpen.call(this, a);
        this.mainPanel.onActivate();
    },
    onRequest: function (a) {
        SYNOCOMMUNITY.DebianChroot.AppWindow.superclass.onRequest.call(this, a);
    },
    onClose: function () {
        if (SYNOCOMMUNITY.DebianChroot.AppWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            return true;
        }
        return false;
    },
    setStatus: function (status) {
        status = status || {};
        var toolbar = this.mainPanel.cardPanel.layout.activeItem.getFooterToolbar();
        if (toolbar && Ext.isFunction(toolbar.setStatus)) {
            toolbar.setStatus(status)
        } else {
            this.getMsgBox().alert("Message", status.text)
        }
    }
});

// Main panel
SYNOCOMMUNITY.DebianChroot.MainPanel = Ext.extend(Ext.Panel, {
    listPanel: null,
    cardPanel: null,
    constructor: function (config) {
        this.owner = config.owner;
        var a = new SYNOCOMMUNITY.DebianChroot.ListView({
            module: this
        });
        this.listPanel = new Ext.Panel({
            region: "west",
            width: SYNOCOMMUNITY.DebianChroot.LIST_WIDTH,
            height: SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT,
            cls: "synocommunity-debianchroot-list",
            items: [a],
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            },
            onActivate: function (panel) {
                a.onActivate()
            }
        });
        this.listView = a;
        this.curHeight = SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT;
        this.cardPanel = new SYNOCOMMUNITY.DebianChroot.MainCardPanel({
            module: this,
            owner: config.owner,
            itemId: "grid",
            region: "center"
        });
        this.id_panel = [
            ["overview", this.cardPanel.PanelOverview],
            ["services", this.cardPanel.PanelServices]
        ];
        SYNOCOMMUNITY.DebianChroot.MainPanel.superclass.constructor.call(this, {
            border: false,
            layout: "border",
            height: SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT,
            monitorResize: true,
            items: [this.listPanel, this.cardPanel]
        });
    },
    onActivate: function (panel) {
        if (!this.isVisible()) {
            return
        }
        this.listPanel.onActivate(panel);
        this.cardPanel.onActivate(panel)
    },
    onDeactivate: function (panel) {
        if (!this.rendered) {
            return
        }
        this.cardPanel.onDeactivate(panel)
    },
    doSwitchPanel: function (id_panel) {
        var c = this.cardPanel.getLayout();
        c.setActiveItem(id_panel);
        var b;
        for (b = 0; b < this.id_panel.length; b++) {
            var a = this.id_panel[b][1];
            if (id_panel === this.id_panel[b][0]) {
                a.onActivate();
                break
            }
        }
    },
    getPanelHeight: function (id_panel) {
        return SYNOCOMMUNITY.DebianChroot.DEFAULT_HEIGHT
    },
    isPanelDirty: function (c) {
        var b;
        for (b = 0; b < this.id_panel.length; b++) {
            if (c === this.id_panel[b][0]) {
                var a = this.id_panel[b][1];
                if ("undefined" === typeof a.checkDirty) {
                    return false
                }
                if (true == a.checkDirty()) {
                    return true
                }
                break
            }
        }
        return false
    },
    panelDeactivate: function (c) {
        for (var b = 0; b < this.id_panel.length; b++) {
            if (c === this.id_panel[b][0]) {
                var a = this.id_panel[b][1];
                if ("undefined" === typeof a.onDeactivate) {
                    return
                }
                a.onDeactivate();
                return
            }
        }
        return
    },
    switchPanel: function (f) {
        var c = this.cardPanel.getLayout();
        var b = c.activeItem.itemId;
        if (f === b) {
            return
        }
        if (Ext.isIE) {
            this.doSwitchPanel(f);
            return
        }
        var a = this.getPanelHeight(f);
        if (this.curHeight == a) {
            this.doSwitchPanel(f);
            return
        }
        this.owner.el.disableShadow();
        var d = this.owner.body;
        var e = function () {
                d.clearOpacity();
                this.owner.getEl().setHeight("auto");
                d.setHeight("auto");
                this.owner.setHeight(a);
                this.owner.el.enableShadow();
                this.owner.syncShadow();
                this.doSwitchPanel(f)
            };
        d.shift({
            height: a - 54,
            duration: 0.3,
            opacity: 0.1,
            scope: this,
            callback: e
        });
        this.curHeight = a
    }
});

// List view
SYNOCOMMUNITY.DebianChroot.ListView = Ext.extend(Ext.list.ListView, {
    constructor: function (config) {
        var store = new Ext.data.JsonStore({
            data: {
                items: [{
                    title: _V("ui", "console"),
                    id: "console_title"
                }, {
                    title: _V("ui", "overview"),
                    id: "overview"
                }, {
                    title: _V("ui", "services"),
                    id: "services"
                }]
            },
            autoLoad: true,
            root: "items",
            fields: ["title", "id"]
        });
        config = Ext.apply({
            cls: "synocommunity-debianchroot-list",
            padding: 10,
            split: false,
            trackOver: false,
            hideHeaders: true,
            singleSelect: true,
            store: store,
            columns: [{
                dataIndex: "title",
                cls: "synocommunity-debianchroot-list-column",
                sortable: false,
                tpl: '<div class="synocommunity-debianchroot-list-{id}">{title}</div>'
            }],
            listeners: {
                scope: this,
                beforeclick: this.onBeforeClick,
                selectionchange: this.onListSelect,
                activate: this.onActivate,
                mouseenter: {
                    fn: function (d, e, g) {
                        var f = Ext.get(g);
                        if (f.hasClass(this.selectedClass)) {
                            f.removeClass(this.overClass)
                        }
                        var h = d.getRecord(g).get("id");
                        if (h === "console_title") {
                            f.removeClass(this.overClass)
                        }
                    }
                }
            }
        }, config);
        this.addEvents("onbeforeclick");
        SYNOCOMMUNITY.DebianChroot.ListView.superclass.constructor.call(this, config)
    },
    onBeforeClick: function (c, d, f, b) {
        var g = c.getRecord(f);
        var h = g.get("id");
        if (h === "console_title") {
            return false
        }
        if (false == this.fireEvent("onbeforeclick", this, d, f, b)) {
            return false
        }
        var e = this.module.cardPanel.getLayout();
        var a = e.activeItem.itemId;
        if (h === a) {
            return false
        }
        if (this.module.isPanelDirty(a)) {
            this.module.cardPanel.owner.getMsgBox().confirm(_T("app", "app_name"), _T("common", "confirm_lostchange"), function (i) {
                if ("yes" === i) {
                    this.module.panelDeactivate(a);
                    this.select(d)
                }
            }, this);
            return false
        }
        this.module.panelDeactivate(a);
        return true
    },
    onListSelect: function (b, a) {
        var c = this.getRecord(a[0]);
        this.module.switchPanel(c.get("id"))
    },
    onActivate: function (panel) {
        var a = this.getSelectedRecords()[0];
        if (!a) {
            this.select(1)
        }
    }
});

// Card panel
SYNOCOMMUNITY.DebianChroot.MainCardPanel = Ext.extend(Ext.Panel, {
    PanelOverview: null,
    constructor: function (config) {
        this.owner = config.owner;
        this.module = config.module;
        this.PanelOverview = new SYNOCOMMUNITY.DebianChroot.PanelOverview({
            owner: this.owner
        });
        this.PanelServices = new SYNOCOMMUNITY.DebianChroot.PanelServices({
            owner: this.owner
        });
        config = Ext.apply({
            activeItem: 0,
            layout: "card",
            items: [this.PanelOverview, this.PanelServices],
            border: false,
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            }
        }, config);
        SYNOCOMMUNITY.DebianChroot.MainCardPanel.superclass.constructor.call(this, config)
    },
    onActivate: function (panel) {
        if (this.PanelOverview) {
            this.PanelOverview.onActivate();
        }
    },
    onDeactivate: Ext.emptyFn
});

// FormPanel base
SYNOCOMMUNITY.DebianChroot.FormPanel = Ext.extend(Ext.FormPanel, {
    constructor: function (config) {
        var a = Ext.apply({
            owner: null,
            items: [],
            padding: "20px 30px 2px 30px",
            border: false,
            header: false,
            trackResetOnLoad: true,
            monitorValid: true,
            fbar: {
                xtype: "statusbar",
                defaultText: "&nbsp;",
                statusAlign: "left",
                buttonAlign: "left",
                hideMode: "visibility",
                items: [{
                    text: _T("common", "commit"),
                    ctCls: "syno-sds-cp-btn",
                    scope: this,
                    handler: this.onApply
                }, {
                    text: _T("common", "reset"),
                    ctCls: "syno-sds-cp-btn",
                    scope: this,
                    handler: this.onReset
                }]
            }
        }, config);
        SYNO.LayoutConfig.fill(a);
        SYNOCOMMUNITY.DebianChroot.FormPanel.superclass.constructor.call(this, a);
        if (!this.owner instanceof SYNO.SDS.BaseWindow) {
            throw Error("please set the owner window of form");
        }
    },
    onActivate: Ext.emptyFn,
    onDeactivate: Ext.emptyFn,
    onApply: function () {
        if (!this.getForm().isDirty()) {
            this.owner.setStatusError({
                text: _T("error", "nochange_subject"),
                clear: true
            });
            return;
        }
        if (!this.getForm().isValid()) {
            this.owner.setStatusError({
                text: _T("common", "forminvalid"),
                clear: true
            });
            return;
        }
        return true;
    },
    onReset: function () {
        if (!this.getForm().isDirty()) {
            this.getForm().reset();
            return;
        }
        this.owner.getMsgBox().confirm(this.title, _T("common", "confirm_lostchange"), function (response) {
            if ("yes" === response) {
                this.getForm().reset();
            }
        }, this);
    }
});

// Overview panel
SYNOCOMMUNITY.DebianChroot.PanelOverview = Ext.extend(Ext.Panel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            xtype: "panel",
            itemId: "overview",
            hideLabel: true,
            layout: "form",
            labelWidth: 250,
            padding: "20px 40px 20px 40px",
            border: false,
            flex: 1,
            items: [{
                fieldLabel: _T("ui", "status"),
                id: this.statusTextID = Ext.id(),
                hideLabel: false
            }, {
                fieldLabel: _T("ui", "running_services"),
                id: this.runningServicesTextID = Ext.id(),
                hideLabel: false
            }]
        }, config);
        SYNOCOMMUNITY.DebianChroot.PanelOverview.superclass.constructor.call(this, config);
        Ext.Direct.on("status", function (data) {
            Ext.getCmp(this.statusTextID).setValue(_T("ui", data.installed));
            Ext.getCmp(this.statusTextID).setValue(data.running_services);
            this.getEl().unmask();
        }, this);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.DebianChroot.Poller.connect();
    },
    onDeactivate: function () {
        SYNOCOMMUNITY.DebianChroot.Poller.disconnect();
    }
});

// Services panel
SYNOCOMMUNITY.DebianChroot.PanelServices = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        var store = new Ext.data.DirectStore({
            autoLoad: true,
            fields: ["id", "name", "launch_script", "status_command", "status"],
            api: {
                load: SYNOCOMMUNITY.DebianChroot.Remote.Services.load,
                save: SYNOCOMMUNITY.DebianChroot.Remote.Services.save
            },
            root: "records"
        });
        config = Ext.apply({
            itemId: "services",
            store: store,
            columns: [
            {
                header: _V("ui", "name"),
                width: 80,
                sortable: true,
                dataIndex: "name"
            },
            {
                header: _V("ui", "launch_script"),
                width: 200,
                dataIndex: "launch_script"
            },
            {
                header:  _V("ui", "status_command"),
                width: 200,
                dataIndex: 'status_command'
            }, {
                xtype: "actioncolumn",
                width: 50,
                items: [{
                    icon: "3rdparty/debian-chroot/images/accept.png",
                    tooltip: _V("ui", "start"),
                    handler: function(grid, rowIndex, colIndex, item, e) {
                        var service = store.getAt(rowIndex);
                        SYNOCOMMUNITY.DebianChroot.Remote.Services.start(service.id);
                    },
                    scope: this
                }, {
                    icon: "3rdparty/debian-chroot/images/delete.png",
                    tooltip: _V("ui", "stop"),
                    handler: function(grid, rowIndex, colIndex, item, e) {
                        var service = store.getAt(rowIndex);
                        SYNOCOMMUNITY.DebianChroot.Remote.Services.stop(service.id);
                    },
                    scope: this
                }, {
                    icon: "3rdparty/debian-chroot/images/pencil.png",
                    tooltip: _V("ui", "edit"),
                    handler: function(grid, rowIndex, colIndex, item, e) {
                        var service = store.getAt(rowIndex);
                        //TODO: Edit form
                    },
                    scope: this
                }]
            }]
        }, config);
        SYNOCOMMUNITY.DebianChroot.PanelServices.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        //TODO: Mask on store loading
        //this.getEl().mask(_T("common", "loading"));
    }
});

