// Namespace
Ext.ns("SYNOCOMMUNITY.DebianChroot");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.DebianChroot.AppInstance", category, element)
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/debian-chroot/debian-chroot.cgi/direct/router",
    "namespace": "SYNOCOMMUNITY.DebianChroot.Remote",
    "type": "remoting",
    "actions": {
        "Overview": [{
            "name": "load",
            "len": 0
        }, {
            "name": "updates_count",
            "len": 0
        }, {
            "name": "do_update",
            "len": 0
        }, {
            "name": "do_upgrade",
            "len": 0
        }],
        "Services": [{
            "name": "save",
            "len": 5
        }, {
            "name": "read",
            "len": 0
        }, {
            "name": "create",
            "len": 1
        }, {
            "name": "update",
            "len": 1
        }, {
            "name": "destroy",
            "len": 1
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
    'url': '3rdparty/debian-chroot/debian-chroot.cgi/direct/poller',
    'interval': 10000
});
Ext.Direct.addProvider(SYNOCOMMUNITY.DebianChroot.Poller);
SYNOCOMMUNITY.DebianChroot.Poller.disconnect();

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
            this.mainPanel.onDeactivate();
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
        this.cardPanel.onActivate(panel);
    },
    onDeactivate: function (panel) {
        if (!this.rendered) {
            return
        }
        this.cardPanel.onDeactivate(panel);
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
    onDeactivate: function (panel) {
        this.PanelOverview.onDeactivate();
    }
});

// FormPanel base
SYNOCOMMUNITY.DebianChroot.FormPanel = Ext.extend(Ext.FormPanel, {
    constructor: function (config) {
        config = Ext.apply({
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
        SYNO.LayoutConfig.fill(config);
        SYNOCOMMUNITY.DebianChroot.FormPanel.superclass.constructor.call(this, config);
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
SYNOCOMMUNITY.DebianChroot.PanelOverview = Ext.extend(SYNOCOMMUNITY.DebianChroot.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        config = Ext.apply({
            itemId: "overview",
            fbar: {
                xtype: "statusbar",
                defaultText: "&nbsp;",
                statusAlign: "left",
                buttonAlign: "left",
                hideMode: "visibility",
                items: []
            },
            items: [{
                xtype: "fieldset",
                labelWidth: 130,
                title: _V("ui", "package_informations"),
                defaultType: "displayfield",
                items: [{
                    fieldLabel: _V("ui", "status"),
                    name: "install_status",
                    value: ""
                }, {
                    fieldLabel: _V("ui", "running_services"),
                    name: "running_services",
                    value: ""
                }]
            }, {
                xtype: "fieldset",
                labelWidth: 130,
                title: "Debian",
                items: [{
                    xtype: "compositefield",
                    fieldLabel: _V("ui", "updates"),
                    items: [{
                        xtype: "displayfield",
                        name: "updates",
                        width: 60,
                        value: ""
                    }, {
                        xtype: "button",
                        id: "synocommunity-debianchroot-do_update",
                        text: _V("ui", "do_update"),
                        handler: this.onClickUpdate,
                        scope: this
                    }, {
                        xtype: "button",
                        id: "synocommunity-debianchroot-do_upgrade",
                        text: _V("ui", "do_upgrade"),
                        handler: this.onClickUpgrade,
                        scope: this
                    }]
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.DebianChroot.Remote.Overview.load
            }
        }, config);
        SYNO.LayoutConfig.fill(config);
        SYNOCOMMUNITY.DebianChroot.PanelOverview.superclass.constructor.call(this, config);
    },
    onClickUpdate: function (button, event) {
        button.disable();
        Ext.getCmp("synocommunity-debianchroot-do_upgrade").disable();
        SYNOCOMMUNITY.DebianChroot.Remote.Overview.do_update(function (provider, response) {
            if (response.result !== false) {
                this.getForm().findField("updates").setValue(response.result);
                this.owner.setStatusOK({
                    text: response.result + " " + _V("ui", "updates_available")
                });
            } else {
                this.owner.setStatusError({
                    text: _V("ui", "cannot_update"),
                    clear: true
                });
            }
            button.enable();
            Ext.getCmp("synocommunity-debianchroot-do_upgrade").enable();
        }, this);
    },
    onClickUpgrade: function (button, event) {
        button.disable();
        Ext.getCmp("synocommunity-debianchroot-do_update").disable();
        SYNOCOMMUNITY.DebianChroot.Remote.Overview.do_upgrade(function (provider, response) {
            if (response.result) {
                this.getForm().findField("updates").setValue(0);
                this.owner.setStatusOK({
                    text: _V("ui", "upgrade_successful")
                });
            } else {
                this.owner.setStatusError({
                    text: _V("ui", "cannot_upgrade"),
                    clear: true
                });
            }
            button.enable();
            Ext.getCmp("synocommunity-debianchroot-do_update").enable();
        }, this);
    },
    onStatus: function (response) {
        this.getForm().findField("install_status").setValue(_V("ui", response.data.installed));
        this.getForm().findField("running_services").setValue(response.data.running_services);
        if (response.data.installed == "installing") {
            Ext.getCmp("synocommunity-debianchroot-do_update").disable();
            Ext.getCmp("synocommunity-debianchroot-do_upgrade").disable();
        } else {
            Ext.getCmp("synocommunity-debianchroot-do_update").enable();
            Ext.getCmp("synocommunity-debianchroot-do_upgrade").enable();
        }
    },
    onActivate: function () {
        Ext.Direct.on("status", this.onStatus, this);
        if (!this.loaded) {
            this.loaded = true;
            this.getEl().mask(_T("common", "loading"), "x-mask-loading");
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getForm().findField("install_status").setValue(_V("ui", action.result.data.installed));
                    if (action.result.data.updates > 0) {
                        this.owner.setStatusOK({
                            text: action.result.data.updates + " " + _V("ui", "updates_available")
                        });
                    }
                    if (action.result.data.installed == "installing") {
                        Ext.getCmp("synocommunity-debianchroot-do_update").disable();
                        Ext.getCmp("synocommunity-debianchroot-do_upgrade").disable();
                    }
                    this.getEl().unmask();
                    SYNOCOMMUNITY.DebianChroot.Poller.connect();
                }
            });
        } else {
            SYNOCOMMUNITY.DebianChroot.Poller.connect();
        }
    },
    onDeactivate: function () {
        Ext.Direct.un("status", this.onStatus, this);
        SYNOCOMMUNITY.DebianChroot.Poller.disconnect();
    }
});

// Services panel
SYNOCOMMUNITY.DebianChroot.PanelServices = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        this.store = new Ext.data.DirectStore({
            autoSave: false,
            fields: ["id", "name", "launch_script", "status_command", "status"],
            api: {
                read: SYNOCOMMUNITY.DebianChroot.Remote.Services.read,
                create: SYNOCOMMUNITY.DebianChroot.Remote.Services.create,
                update: SYNOCOMMUNITY.DebianChroot.Remote.Services.update,
                destroy: SYNOCOMMUNITY.DebianChroot.Remote.Services.destroy
            },
            idProperty: "id",
            root: "data",
            writer: new Ext.data.JsonWriter({
                encode: false,
                listful: true,
                writeAllFields: true
            })
        });
        config = Ext.apply({
            itemId: "services",
            border: false,
            store: this.store,
            loadMask: true,
            tbar: {
                items: [{
                    text: _V("ui", "add"),
                    itemId: "add",
                    scope: this,
                    handler: this.onClickAdd
                }, {
                    text: _V("ui", "edit"),
                    itemId: "edit",
                    scope: this,
                    handler: this.onClickEdit
                }, {
                    text: _V("ui", "delete"),
                    itemId: "delete",
                    scope: this,
                    handler: this.onClickDelete
                }, {
                    text: _V("ui", "start"),
                    itemId: "start",
                    scope: this,
                    handler: this.onClickStart
                }, {
                    text: _V("ui", "stop"),
                    itemId: "stop",
                    scope: this,
                    handler: this.onClickStop
                }, {
                    text: _V("ui", "refresh"),
                    itemId: "refresh",
                    scope: this,
                    handler: this.onClickRefresh
                }]
            },
            columns: [{
                header: _V("ui", "name"),
                sortable: true,
                width: 35,
                dataIndex: "name"
            }, {
                header: _V("ui", "launch_script"),
                width: 45,
                dataIndex: "launch_script"
            }, {
                header: _V("ui", "status_command"),
                dataIndex: "status_command"
            }, {
                header: _V("ui", "status"),
                width: 25,
                dataIndex: "status",
                renderer: function (value, metaData, record, rowIndex, colIndex, store) {
                    if (value) {
                        return _V("ui", "running");
                    }
                    return _V("ui", "not_running");
                }
            }]
        }, config);
        SYNOCOMMUNITY.DebianChroot.PanelServices.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.store.load();
            this.loaded = true;
        }
    },
    onClickAdd: function () {
        var editor = new SYNOCOMMUNITY.DebianChroot.ServiceEditorWindow({}, this.store);
        editor.open()
    },
    onClickEdit: function () {
        var editor = new SYNOCOMMUNITY.DebianChroot.ServiceEditorWindow({}, this.store, this.getSelectionModel().getSelected());
        editor.open()
    },
    onClickDelete: function () {
        var records = this.getSelectionModel().getSelections();
        if (records.length != 0) {
            this.store.remove(this.getSelectionModel().getSelections());
            this.store.save();
        }
    },
    onClickStart: function () {
        this.getSelectionModel().each(function (record) {
            SYNOCOMMUNITY.DebianChroot.Remote.Services.start(record.id, function (provider, response) {
                if (response.result) {
                    record.set("status", true);
                    record.commit();
                }
            });
        }, this);
    },
    onClickStop: function () {
        this.getSelectionModel().each(function (record) {
            SYNOCOMMUNITY.DebianChroot.Remote.Services.stop(record.id, function (provider, response) {
                if (response.result) {
                    record.set("status", false);
                    record.commit();
                }
            });
        }, this);
    },
    onClickRefresh: function () {
        this.store.load();
    }
});

// Service window
SYNOCOMMUNITY.DebianChroot.ServiceEditorWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    title: _V("ui", "service"),
    constructor: function (config, store, record) {
        this.store = store;
        this.record = record;
        this.panel = new SYNOCOMMUNITY.DebianChroot.PanelServiceEditor({}, record);
        config = Ext.apply(config, {
            width: 550,
            height: 210,
            resizable: false,
            layout: "fit",
            items: [this.panel],
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "close"),
                scope: this,
                handler: this.onClickClose
            }]
        })
        SYNOCOMMUNITY.DebianChroot.ServiceEditorWindow.superclass.constructor.call(this, config);
    },
    onClickApply: function () {
        if (this.record === undefined) {
            var record = new this.store.recordType({
                name: this.panel.getForm().findField("name").getValue(),
                launch_script: this.panel.getForm().findField("launch_script").getValue(),
                status_command: this.panel.getForm().findField("status_command").getValue()
            });
            this.store.add(record);
        } else {
            this.record.beginEdit();
            this.record.set("name", this.panel.getForm().findField("name").getValue());
            this.record.set("launch_script", this.panel.getForm().findField("launch_script").getValue());
            this.record.set("status_command", this.panel.getForm().findField("status_command").getValue());
            this.record.endEdit();
        }
        this.store.save();
        this.close();
    },
    onClickClose: function () {
        this.close();
    }
});

// Service panel
SYNOCOMMUNITY.DebianChroot.PanelServiceEditor = Ext.extend(SYNOCOMMUNITY.DebianChroot.FormPanel, {
    constructor: function (config, record) {
        this.record = record;
        config = Ext.apply({
            itemId: "service",
            padding: "15px 15px 2px 15px",
            defaultType: "textfield",
            labelWidth: 130,
            fbar: null,
            defaults: {
                anchor: "-20"
            },
            items: [{
                fieldLabel: _V("ui", "name"),
                name: "name"
            }, {
                fieldLabel: _V("ui", "launch_script"),
                name: "launch_script"
            }, {
                fieldLabel: _V("ui", "status_command"),
                name: "status_command"
            }]
        }, config);
        SYNOCOMMUNITY.DebianChroot.PanelServiceEditor.superclass.constructor.call(this, config);
        if (this.record !== undefined) {
            this.loadRecord();
        }
    },
    loadRecord: function () {
        this.getForm().findField("name").setValue(this.record.data.name);
        this.getForm().findField("launch_script").setValue(this.record.data.launch_script);
        this.getForm().findField("status_command").setValue(this.record.data.status_command);
    }
});
