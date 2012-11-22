// Namespace
Ext.ns("SYNOCOMMUNITY.HAProxy");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.HAProxy.AppInstance", category, element)
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/haproxy/haproxy.cgi/direct/router",
    "namespace": "SYNOCOMMUNITY.HAProxy.Remote",
    "type": "remoting",
    "actions": {
        "Frontends": [{
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
        }],
        "Backends": [{
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
        }],
        "Associations": [{
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
        }],
        "Configuration": [{
            "name": "load",
            "len": 0
        }, {
            "name": "write",
            "len": 1
        }, {
            "name": "reload",
            "len": 0
        }, {
            "name": "generate_certificate",
            "len": 0
        }]
    }
});

// Const
SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT = 400;
SYNOCOMMUNITY.HAProxy.MAIN_WIDTH = 750;
SYNOCOMMUNITY.HAProxy.LIST_WIDTH = 210;

// Application
SYNOCOMMUNITY.HAProxy.AppInstance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName: "SYNOCOMMUNITY.HAProxy.AppWindow",
    constructor: function () {
        SYNOCOMMUNITY.HAProxy.AppInstance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SYNOCOMMUNITY.HAProxy.AppWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,
    mainPanel: null,
    constructor: function (config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SYNOCOMMUNITY.HAProxy.MainPanel({
            owner: this
        });
        config = Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: SYNOCOMMUNITY.HAProxy.MAIN_WIDTH,
            height: SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT,
            layout: "fit",
            border: false,
            cls: "synocommunity-haproxy",
            items: [this.mainPanel]
        }, config);
        SYNOCOMMUNITY.HAProxy.AppWindow.superclass.constructor.call(this, config);
    },
    onOpen: function (a) {
        SYNOCOMMUNITY.HAProxy.AppWindow.superclass.onOpen.call(this, a);
        this.mainPanel.onActivate();
    },
    onRequest: function (a) {
        SYNOCOMMUNITY.HAProxy.AppWindow.superclass.onRequest.call(this, a);
    },
    onClose: function () {
        if (SYNOCOMMUNITY.HAProxy.AppWindow.superclass.onClose.apply(this, arguments)) {
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
SYNOCOMMUNITY.HAProxy.MainPanel = Ext.extend(Ext.Panel, {
    listPanel: null,
    cardPanel: null,
    constructor: function (config) {
        this.owner = config.owner;
        var a = new SYNOCOMMUNITY.HAProxy.ListView({
            module: this
        });
        this.listPanel = new Ext.Panel({
            region: "west",
            width: SYNOCOMMUNITY.HAProxy.LIST_WIDTH,
            height: SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT,
            cls: "synocommunity-haproxy-list",
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
        this.curHeight = SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT;
        this.cardPanel = new SYNOCOMMUNITY.HAProxy.MainCardPanel({
            module: this,
            owner: config.owner,
            itemId: "grid",
            region: "center"
        });
        this.id_panel = [
            ["configuration", this.cardPanel.PanelConfiguration],
            ["frontends", this.cardPanel.PanelFrontends],
            ["backends", this.cardPanel.PanelBackends],
            ["associations", this.cardPanel.PanelAssociations]
        ];
        SYNOCOMMUNITY.HAProxy.MainPanel.superclass.constructor.call(this, {
            border: false,
            layout: "border",
            height: SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT,
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
        return SYNOCOMMUNITY.HAProxy.DEFAULT_HEIGHT
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
SYNOCOMMUNITY.HAProxy.ListView = Ext.extend(Ext.list.ListView, {
    constructor: function (config) {
        var store = new Ext.data.JsonStore({
            data: {
                items: [{
                    title: _V("ui", "console"),
                    id: "console_title"
                }, {
                    title: _V("ui", "configuration"),
                    id: "configuration"
                }, {
                    title: _V("ui", "frontends"),
                    id: "frontends"
                }, {
                    title: _V("ui", "backends"),
                    id: "backends"
                }, {
                    title: _V("ui", "associations"),
                    id: "associations"
                }]
            },
            autoLoad: true,
            root: "items",
            fields: ["title", "id"]
        });
        config = Ext.apply({
            cls: "synocommunity-haproxy-list",
            padding: 10,
            split: false,
            trackOver: false,
            hideHeaders: true,
            singleSelect: true,
            store: store,
            columns: [{
                dataIndex: "title",
                cls: "synocommunity-haproxy-list-column",
                sortable: false,
                tpl: '<div class="synocommunity-haproxy-list-{id}">{title}</div>'
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
        SYNOCOMMUNITY.HAProxy.ListView.superclass.constructor.call(this, config)
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
            this.module.cardPanel.owner.getMsgBox().confirm(_T("app", "app_name"), _T("common", "confirm_lostchange"),
            function (i) {
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
SYNOCOMMUNITY.HAProxy.MainCardPanel = Ext.extend(Ext.Panel, {
    PanelConfiguration: null,
    constructor: function (config) {
        this.owner = config.owner;
        this.module = config.module;
        this.PanelConfiguration = new SYNOCOMMUNITY.HAProxy.PanelConfiguration({
            owner: this.owner
        });
        this.PanelFrontends = new SYNOCOMMUNITY.HAProxy.PanelFrontends({
            owner: this.owner
        });
        this.PanelBackends = new SYNOCOMMUNITY.HAProxy.PanelBackends({
            owner: this.owner
        });
        this.PanelAssociations = new SYNOCOMMUNITY.HAProxy.PanelAssociations({
            owner: this.owner
        });
        config = Ext.apply({
            activeItem: 0,
            layout: "card",
            items: [this.PanelConfiguration, this.PanelFrontends, this.PanelBackends, this.PanelAssociations],
            border: false,
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            }
        }, config);
        SYNOCOMMUNITY.HAProxy.MainCardPanel.superclass.constructor.call(this, config)
    },
    onActivate: function (panel) {
        if (this.PanelConfiguration) {
            this.PanelConfiguration.onActivate();
        }
    },
    onDeactivate: function (panel) {
        this.PanelConfiguration.onDeactivate();
    },
    forceRefresh: function () {
        this.items.each(function (item) {
            if (item.loaded !== undefined) {
                item.loaded = false;
            }
        });
    }
});

// FormPanel base
SYNOCOMMUNITY.HAProxy.FormPanel = Ext.extend(Ext.FormPanel, {
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
        SYNOCOMMUNITY.HAProxy.FormPanel.superclass.constructor.call(this, config);
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
        this.owner.getMsgBox().confirm(this.title, _T("common", "confirm_lostchange"),
        function (response) {
            if ("yes" === response) {
                this.getForm().reset();
            }
        }, this);
    }
});

// Configuration panel
SYNOCOMMUNITY.HAProxy.PanelConfiguration = Ext.extend(SYNOCOMMUNITY.HAProxy.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "configuration",
            tbar: {
                items: [{
                    text: _V("ui", "write_configuration"),
                    itemId: "write_configuration",
                    scope: this,
                    handler: this.onClickWriteConfiguration
                }, {
                    text: _V("ui", "default_configuration"),
                    itemId: "default_configuration",
                    scope: this,
                    handler: this.onClickDefaultConfiguration
                }, {
                    text: _V("ui", "generate_certificate"),
                    itemId: "generate_certificate",
                    scope: this,
                    handler: this.onClickGenerateCertificate
                }]
            },
            fbar: null,
            items: [{
                xtype: "fieldset",
                labelWidth: 130,
                title: _V("ui", "status"),
                defaultType: "displayfield",
                items: [{
                    fieldLabel: _V("ui", "status"),
                    name: "status",
                    value: ""
                }, {
                    fieldLabel: _V("ui", "frontends"),
                    name: "frontends",
                    value: ""
                }, {
                    fieldLabel: _V("ui", "backends"),
                    name: "backends",
                    value: ""
                }, {
                    fieldLabel: _V("ui", "associations"),
                    name: "associations",
                    value: ""
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.HAProxy.Remote.Configuration.load
            }
        }, config);
        SYNOCOMMUNITY.HAProxy.PanelConfiguration.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"), "x-mask-loading");
        this.load({
            scope: this,
            success: function (form, action) {
                this.getForm().findField("status").setValue(_V("ui", action.result.data.status));
                this.getEl().unmask();
            }
        });
    },
    disableButtons: function () {
        this.getTopToolbar().items.each(function(item){
            item.disable();
        });  
    },
    enableButtons: function () {
        this.getTopToolbar().items.each(function(item){
            item.enable();
        });  
    },
    onClickWriteConfiguration: function (button, event) {
        this.disableButtons();
        SYNOCOMMUNITY.HAProxy.Remote.Configuration.write(true, function (provider, response) {
            if (response.result.success) {
                this.owner.setStatusOK({
                    text: _V("msg", "write_configuration_successful")
                });
            } else {
                this.owner.setStatusError({
                    text: _V("msg", "configuration_error") + response.result.error,
                    clear: true
                });
                this.onActivate();
            }
            this.enableButtons();
        }, this);
    },
    onClickDefaultConfiguration: function (button, event) {
        this.disableButtons();
        SYNOCOMMUNITY.HAProxy.Remote.Configuration.reload(function (provider, response) {
            if (response.result) {
                this.owner.setStatusOK({
                    text: _V("msg", "default_configuration_successful")
                });
            }
            this.owner.mainPanel.cardPanel.forceRefresh();
            this.enableButtons();
        }, this);
    },
    onClickGenerateCertificate: function (button, event) {
        this.disableButtons();
        SYNOCOMMUNITY.HAProxy.Remote.Configuration.generate_certificate(function (provider, response) {
            if (response.result) {
                this.owner.setStatusOK({
                    text: _V("msg", "generate_certificate_successful")
                });
            }
            this.owner.mainPanel.cardPanel.forceRefresh();
            this.enableButtons();
        }, this);
    }
});


// Frontends panel
SYNOCOMMUNITY.HAProxy.PanelFrontends = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        this.store = new Ext.data.DirectStore({
            autoSave: false,
            fields: ["id", "name", "binds", "default_backend_id", "default_backend_name", "options"],
            api: {
                read: SYNOCOMMUNITY.HAProxy.Remote.Frontends.read,
                create: SYNOCOMMUNITY.HAProxy.Remote.Frontends.create,
                update: SYNOCOMMUNITY.HAProxy.Remote.Frontends.update,
                destroy: SYNOCOMMUNITY.HAProxy.Remote.Frontends.destroy
            },
            idProperty: "id",
            root: "data",
            writer: new Ext.data.JsonWriter({
                encode: false,
                listful: true,
                writeAllFields: true
            })
        }),
        config = Ext.apply({
            itemId: "frontends",
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
                    text: _V("ui", "refresh"),
                    itemId: "refresh",
                    scope: this,
                    handler: this.onClickRefresh
                }]
            },
            columns: [{
                header: _V("ui", "name"),
                sortable: true,
                width: 30,
                dataIndex: "name"
            }, {
                header: _V("ui", "binds"),
                dataIndex: "binds"
            }, {
                header: _V("ui", "default_backend"),
                width: 35,
                dataIndex: "default_backend_name"
            }, {
                header: _V("ui", "options"),
                dataIndex: "options"
            }]
        }, config);
        SYNOCOMMUNITY.HAProxy.PanelFrontends.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.store.load();
            this.loaded = true;
        }
    },
    onClickAdd: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.FrontendEditorWindow({
            store: this.store,
            title: _V("ui", "frontend_add")
        });
        editor.open();
    },
    onClickEdit: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.FrontendEditorWindow({
            store: this.store,
            record: this.getSelectionModel().getSelected(),
            title: _V("ui", "frontend_edit")
        });
        editor.open();
    },
    onClickDelete: function () {
        var records = this.getSelectionModel().getSelections();
        if (records.length != 0) {
            this.store.remove(this.getSelectionModel().getSelections());
            this.store.save();
        }
    },
    onClickRefresh: function () {
        this.store.load();
    }
});

// Frontend window
SYNOCOMMUNITY.HAProxy.FrontendEditorWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    initComponent: function () {
        this.panel = new SYNOCOMMUNITY.HAProxy.PanelFrontendEditor();
        var config = {
            width: 520,
            height: 210,
            resizable: false,
            layout: "fit",
            items: [this.panel],
            listeners: {
                scope: this,
                afterrender: this.onAfterRender
            },
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "close"),
                scope: this,
                handler: this.onClickClose
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.FrontendEditorWindow.superclass.initComponent.apply(this, arguments);
    },
    onAfterRender: function () {
        if (this.record) {
            this.panel.loadRecord(this.record);
        }
    },
    onClickApply: function () {
        if (this.record === undefined) {
            var record = new this.store.recordType({
                name: this.panel.getForm().findField("name").getValue(),
                binds: this.panel.getForm().findField("binds").getValue(),
                default_backend_id: this.panel.getForm().findField("default_backend").getValue(),
                default_backend_name: this.panel.getForm().findField("default_backend").getRawValue(),
                options: this.panel.getForm().findField("options").getValue()
            });
            this.store.add(record);
        } else {
            this.record.beginEdit();
            this.record.set("name", this.panel.getForm().findField("name").getValue());
            this.record.set("binds", this.panel.getForm().findField("binds").getValue());
            this.record.set("default_backend_id", this.panel.getForm().findField("default_backend").getValue());
            this.record.set("default_backend_name", this.panel.getForm().findField("default_backend").getRawValue());
            this.record.set("options", this.panel.getForm().findField("options").getValue());
            this.record.endEdit();
        }
        this.store.save();
        this.close();
    },
    onClickClose: function () {
        this.close();
    }
});

// Frontend form panel
SYNOCOMMUNITY.HAProxy.PanelFrontendEditor = Ext.extend(SYNOCOMMUNITY.HAProxy.FormPanel, {
    initComponent: function () {
        var config = {
            itemId: "frontend",
            padding: "15px 15px 2px 15px",
            defaultType: "textfield",
            labelWidth: 130,
            fbar: null,
            defaults: {
                anchor: "-20"
            },
            items: [{
                allowBlank: false,
                fieldLabel: _V("ui", "name"),
                name: "name"
            }, {
                allowBlank: false,
                fieldLabel: _V("ui", "binds"),
                name: "binds"
            }, {
                xtype: "combo",
                fieldLabel: _V("ui", "default_backend"),
                emptyText: _V("ui", "select_backend"),
                triggerAction: "all",
                store: new Ext.data.DirectStore({
                    autoSave: false,
                    fields: ["id", "name", "servers", "options"],
                    api: {
                        read: SYNOCOMMUNITY.HAProxy.Remote.Backends.read
                    },
                    idProperty: "id",
                    root: "data",
                    writer: new Ext.data.JsonWriter({
                        encode: false,
                        listful: true,
                        writeAllFields: true
                    })
                }),
                displayField: "name",
                valueField: "id",
                name: "default_backend"
            }, {
                fieldLabel: _V("ui", "options"),
                name: "options"
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.PanelFrontendEditor.superclass.initComponent.apply(this, arguments);
    },
    loadRecord: function (record) {
        this.getForm().findField("name").setValue(record.data.name);
        this.getForm().findField("binds").setValue(record.data.binds);
        this.getForm().findField("default_backend").setValue(record.data.default_backend_id);
        this.getForm().findField("default_backend").setRawValue(record.data.default_backend_name);
        this.getForm().findField("options").setValue(record.data.options);
    }
});


// Backends panel
SYNOCOMMUNITY.HAProxy.PanelBackends = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        this.store = new Ext.data.DirectStore({
            autoSave: false,
            fields: ["id", "name", "servers", "options"],
            api: {
                read: SYNOCOMMUNITY.HAProxy.Remote.Backends.read,
                create: SYNOCOMMUNITY.HAProxy.Remote.Backends.create,
                update: SYNOCOMMUNITY.HAProxy.Remote.Backends.update,
                destroy: SYNOCOMMUNITY.HAProxy.Remote.Backends.destroy
            },
            idProperty: "id",
            root: "data",
            writer: new Ext.data.JsonWriter({
                encode: false,
                listful: true,
                writeAllFields: true
            })
        }),
        config = Ext.apply({
            itemId: "backends",
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
                header: _V("ui", "servers"),
                dataIndex: "servers"
            }, {
                header: _V("ui", "options"),
                dataIndex: "options"
            }]
        }, config);
        SYNOCOMMUNITY.HAProxy.PanelBackends.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.store.load();
            this.loaded = true;
        }
    },
    onClickAdd: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.BackendEditorWindow({
            store: this.store,
            title: _V("ui", "backend_add")
        });
        editor.open();
    },
    onClickEdit: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.BackendEditorWindow({
            store: this.store,
            record: this.getSelectionModel().getSelected(),
            title: _V("ui", "backend_edit")
        });
        editor.open();
    },
    onClickDelete: function () {
        var records = this.getSelectionModel().getSelections();
        if (records.length != 0) {
            this.store.remove(this.getSelectionModel().getSelections());
            this.store.save();
        }
    },
    onClickRefresh: function () {
        this.store.load();
    }
});

// Backend window
SYNOCOMMUNITY.HAProxy.BackendEditorWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    initComponent: function () {
        this.panel = new SYNOCOMMUNITY.HAProxy.PanelBackendEditor();
        var config = {
            width: 520,
            height: 180,
            resizable: false,
            layout: "fit",
            items: [this.panel],
            listeners: {
                scope: this,
                afterrender: this.onAfterRender
            },
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "close"),
                scope: this,
                handler: this.onClickClose
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.BackendEditorWindow.superclass.initComponent.apply(this, arguments);
    },
    onAfterRender: function () {
        if (this.record) {
            this.panel.loadRecord(this.record);
        }
    },
    onClickApply: function () {
        if (this.record === undefined) {
            var record = new this.store.recordType({
                name: this.panel.getForm().findField("name").getValue(),
                servers: this.panel.getForm().findField("servers").getValue(),
                options: this.panel.getForm().findField("options").getValue()
            });
            this.store.add(record);
        } else {
            this.record.beginEdit();
            this.record.set("name", this.panel.getForm().findField("name").getValue());
            this.record.set("servers", this.panel.getForm().findField("servers").getValue());
            this.record.set("options", this.panel.getForm().findField("options").getValue());
            this.record.endEdit();
        }
        this.store.save();
        this.close();
    },
    onClickClose: function () {
        this.close();
    }
});

// Backend form panel
SYNOCOMMUNITY.HAProxy.PanelBackendEditor = Ext.extend(SYNOCOMMUNITY.HAProxy.FormPanel, {
    initComponent: function () {
        var config = {
            itemId: "backend",
            padding: "15px 15px 2px 15px",
            defaultType: "textfield",
            labelWidth: 130,
            fbar: null,
            defaults: {
                anchor: "-20"
            },
            items: [{
                allowBlank: false,
                fieldLabel: _V("ui", "name"),
                name: "name"
            }, {
                allowBlank: false,
                fieldLabel: _V("ui", "servers"),
                name: "servers"
            }, {
                fieldLabel: _V("ui", "options"),
                name: "options"
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.PanelBackendEditor.superclass.initComponent.apply(this, arguments);
    },
    loadRecord: function (record) {
        this.getForm().findField("name").setValue(record.data.name);
        this.getForm().findField("servers").setValue(record.data.servers);
        this.getForm().findField("options").setValue(record.data.options);
    }
});

// Associations panel
SYNOCOMMUNITY.HAProxy.PanelAssociations = Ext.extend(Ext.grid.GridPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        this.loaded = false;
        this.store = new Ext.data.DirectStore({
            autoSave: false,
            fields: ["id", "frontend_id", "backend_id", "frontend_name", "backend_name", "condition"],
            api: {
                read: SYNOCOMMUNITY.HAProxy.Remote.Associations.read,
                create: SYNOCOMMUNITY.HAProxy.Remote.Associations.create,
                update: SYNOCOMMUNITY.HAProxy.Remote.Associations.update,
                destroy: SYNOCOMMUNITY.HAProxy.Remote.Associations.destroy
            },
            idProperty: "id",
            root: "data",
            writer: new Ext.data.JsonWriter({
                encode: false,
                listful: true,
                writeAllFields: true
            })
        }),
        config = Ext.apply({
            itemId: "associations",
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
                    text: _V("ui", "refresh"),
                    itemId: "refresh",
                    scope: this,
                    handler: this.onClickRefresh
                }]
            },
            columns: [{
                header: _V("ui", "frontend"),
                sortable: true,
                width: 25,
                dataIndex: "frontend_name"
            }, {
                header: _V("ui", "backend"),
                sortable: true,
                width: 25,
                dataIndex: "backend_name"
            }, {
                header: _V("ui", "condition"),
                dataIndex: "condition"
            }]
        }, config);
        SYNOCOMMUNITY.HAProxy.PanelAssociations.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        if (!this.loaded) {
            this.store.load();
            this.loaded = true;
        }
    },
    onClickAdd: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.AssociationEditorWindow({
            store: this.store,
            title: _V("ui", "association_add")
        });
        editor.open();
    },
    onClickEdit: function () {
        var editor = new SYNOCOMMUNITY.HAProxy.AssociationEditorWindow({
            store: this.store,
            record: this.getSelectionModel().getSelected(),
            title: _V("ui", "association_edit")
        });
        editor.open();
    },
    onClickDelete: function () {
        var records = this.getSelectionModel().getSelections();
        if (records.length != 0) {
            this.store.remove(this.getSelectionModel().getSelections());
            this.store.save();
        }
    },
    onClickRefresh: function () {
        this.store.load();
    }
});

// Association window
SYNOCOMMUNITY.HAProxy.AssociationEditorWindow = Ext.extend(SYNO.SDS.ModalWindow, {
    initComponent: function () {
        this.panel = new SYNOCOMMUNITY.HAProxy.PanelAssociationEditor();
        var config = {
            width: 450,
            height: 180,
            resizable: false,
            layout: "fit",
            items: [this.panel],
            listeners: {
                scope: this,
                afterrender: this.onAfterRender
            },
            buttons: [{
                text: _T("common", "apply"),
                scope: this,
                handler: this.onClickApply
            }, {
                text: _T("common", "close"),
                scope: this,
                handler: this.onClickClose
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.AssociationEditorWindow.superclass.initComponent.apply(this, arguments);
    },
    onAfterRender: function () {
        if (this.record) {
            this.panel.loadRecord(this.record);
            this.panel.getForm().findField("frontend").disable();
            this.panel.getForm().findField("backend").disable();
        }
    },
    onClickApply: function () {
        if (this.record === undefined) {
            var record = new this.store.recordType({
                frontend_id: this.panel.getForm().findField("frontend").getValue(),
                backend_id: this.panel.getForm().findField("backend").getValue(),
                frontend_name: this.panel.getForm().findField("frontend").getRawValue(),
                backend_name: this.panel.getForm().findField("backend").getRawValue(),
                condition: this.panel.getForm().findField("condition").getValue()
            });
            if (this.store.getById(record.data.frontend_id + "-" + record.data.backend_id) !== undefined) {
                this.getMsgBox().alert(_V("ui", "error"), _V("msg", "association_duplicate"));
                return
            }
            this.store.add(record);
        } else {
            this.record.beginEdit();
            this.record.set("condition", this.panel.getForm().findField("condition").getValue());
            this.record.endEdit();
        }
        this.store.save();
        this.close();
    },
    onClickClose: function () {
        this.close();
    }
});

// Association form panel
SYNOCOMMUNITY.HAProxy.PanelAssociationEditor = Ext.extend(SYNOCOMMUNITY.HAProxy.FormPanel, {
    initComponent: function () {
        var config = {
            itemId: "association",
            padding: "15px 15px 2px 15px",
            defaultType: "textfield",
            labelWidth: 130,
            fbar: null,
            defaults: {
                anchor: "-20"
            },
            items: [{
                xtype: "combo",
                allowBlank: false,
                fieldLabel: _V("ui", "frontend"),
                emptyText: _V("ui", "select_frontend"),
                triggerAction: "all",
                editable: false,
                store: new Ext.data.DirectStore({
                    autoSave: false,
                    fields: ["id", "name", "binds", "default_backend_id", "default_backend_name", "options"],
                    api: {
                        read: SYNOCOMMUNITY.HAProxy.Remote.Frontends.read
                    },
                    idProperty: "id",
                    root: "data",
                    writer: new Ext.data.JsonWriter({
                        encode: false,
                        listful: true,
                        writeAllFields: true
                    })
                }),
                displayField: "name",
                valueField: "id",
                name: "frontend"
            }, {
                xtype: "combo",
                allowBlank: false,
                fieldLabel: _V("ui", "backend"),
                emptyText: _V("ui", "select_backend"),
                triggerAction: "all",
                editable: false,
                store: new Ext.data.DirectStore({
                    autoSave: false,
                    fields: ["id", "name", "servers", "options"],
                    api: {
                        read: SYNOCOMMUNITY.HAProxy.Remote.Backends.read
                    },
                    idProperty: "id",
                    root: "data",
                    writer: new Ext.data.JsonWriter({
                        encode: false,
                        listful: true,
                        writeAllFields: true
                    })
                }),
                displayField: "name",
                valueField: "id",
                name: "backend"
            }, {
                allowBlank: false,
                fieldLabel: _V("ui", "condition"),
                name: "condition"
            }]
        };
        Ext.apply(this, Ext.apply(this.initialConfig, config));
        SYNOCOMMUNITY.HAProxy.PanelAssociationEditor.superclass.initComponent.apply(this, arguments);
    },
    loadRecord: function (record) {
        this.getForm().findField("frontend").setValue(record.data.frontend_id);
        this.getForm().findField("backend").setValue(record.data.backend_id);
        this.getForm().findField("frontend").setRawValue(record.data.frontend_name);
        this.getForm().findField("backend").setRawValue(record.data.backend_name);
        this.getForm().findField("condition").setValue(record.data.condition);
    }
});

