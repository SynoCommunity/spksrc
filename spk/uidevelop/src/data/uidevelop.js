// Namespace
Ext.ns("SYNOCOMMUNITY.UIDevelop");

// Translator
_V = function(category, element) {
    var translation = _TT("SYNOCOMMUNITY.UIDevelop.Instance", category, element);
    console.log(translation);
    return translation
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/uidevelop/uidevelop.cgi",
    "namespace": "SYNOCOMMUNITY.UIDevelop.Remote",
    "type": "remoting",
    "actions": {
        "UID": [
            {"formHandler": true, "name": "save", "len": 2},
            {"name": "load", "len": 0},
            {"name": "get_devices", "len": 0}
        ]
    }
});

// Application
SYNOCOMMUNITY.UIDevelop.Instance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName : "SYNOCOMMUNITY.UIDevelop.MainWindow",
    constructor : function() {
        SYNOCOMMUNITY.UIDevelop.Instance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SYNOCOMMUNITY.UIDevelop.MainWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,	
    mainPanel: null,
    constructor: function(config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SYNOCOMMUNITY.UIDevelop.MainPanel({
            owner: this,
            app: this
        });
        config = Ext.apply({
            resizable: false,
            maximizable: false,
            minimizable: true,
            width: 500,
            layout: 'fit',
            cls: "synocommunity",
            items: [this.mainPanel]
        }, config);
        SYNOCOMMUNITY.UIDevelop.MainWindow.superclass.constructor.call(this, config);
    },
    onOpen : function(a) {
        SYNOCOMMUNITY.UIDevelop.MainWindow.superclass.onOpen.call(this, a);
        this.mainPanel.onActivate();
    },
    onRequest : function(a) {
        SYNOCOMMUNITY.UIDevelop.MainWindow.superclass.onRequest.call(this, a);
    },
    onClose : function() {
        if(SYNOCOMMUNITY.UIDevelop.MainWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            return true
        }
        return false;
    }
});

// Main panel
SYNOCOMMUNITY.UIDevelop.MainPanel = Ext.extend(Ext.Panel, {
    listPanel: null,
    formPanel: null,
    constructor: function(config) {
        this.owner = config.owner;
        this.app = config.app;
        var a = new SYNOCOMMUNITY.UIDevelop.ListView({module: this});
        this.listPanel = new Ext.Panel({
            region: "west",
            width: 210,
            height: 525,
            cls: "synocommunity-uid-list",
            items: [a],
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            },
            onActivate: function() {
                a.onActivate()
            },
            onDeactivate: function() {}
        });
        this.listView = a;
        this.formPanel = new SYNOCOMMUNITY.UIDevelop.MainCardPanel({
            module: this,
            owner: config.owner,
            app: this.app,
            itemId: "grid",
            region: "center"
        });
        this.id_panel = [
            ["test", this.formPanel.PanelTest]
        ];
        SYNOCOMMUNITY.UIDevelop.MainPanel.superclass.constructor.call(this, {
            border: false,
            layout: "border",
            width: 500,
            height: 525,
            monitorResize: true,
            items: [this.listPanel, this.formPanel]
        });
    },
    onActivate: function(a) {
        if (!this.isVisible()) {
            return
        }
        this.listPanel.onActivate(a);
        this.formPanel.onActivate(a)
    },
    onDeactivate: function(a) {
        if (!this.rendered) {
            return
        }
        this.formPanel.onDeactivate(a)
    },
    doSwitchPanel: function(d) {
        var c = this.formPanel.getLayout();
        c.setActiveItem(d);
        var b;
        for (b = 0; b < this.id_panel.length; b++) {
            var a = this.id_panel[b][1];
            if (d === this.id_panel[b][0]) {
                SYNO.Debug("panel " + d + " activated");
                a.onActivate();
                break
            }
        }
    },
    getPanelHeight: function (a) {
        return 525
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
        var c = this.formPanel.getLayout();
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
SYNOCOMMUNITY.UIDevelop.ListView = Ext.extend(Ext.list.ListView, {
    constructor: function (config) {
        var store = new Ext.data.JsonStore({
            data: {
                items: [{
                    title: _V("ui", "configurations"),
                    id: "configurations_title"
                }, {
                    title: _V("ui", "test"),
                    id: "test"
                }]
            },
            autoLoad: true,
            root: "items",
            fields: ["title", "id"]
        });
        config = Ext.apply({
            cls: "synocommunity-uid-list",
            padding: 10,
            split: false,
            trackOver: false,
            hideHeaders: true,
            singleSelect: true,
            store: store,
            columns: [{
                dataIndex: "title",
                cls: "synocommunity-uid-list-column",
                sortable: false,
                tpl: '<div class="synocommunity-uid-list-{id}">{title}</div>'
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
                        if (h === "configurations_title") {
                            f.removeClass(this.overClass)
                        }
                    }
                }
            }
        }, config);
        this.addEvents("onbeforeclick");
        SYNOCOMMUNITY.UIDevelop.ListView.superclass.constructor.call(this, config)
    },
    onBeforeClick: function (c, d, f, b) {
        var g = c.getRecord(f);
        var h = g.get("id");
        if (h === "configurations_title") {
            return false
        }
        if (false == this.fireEvent("onbeforeclick", this, d, f, b)) {
            return false
        }
        var e = this.module.formPanel.getLayout();
        var a = e.activeItem.itemId;
        if (h === a) {
            return false
        }
        if (this.module.isPanelDirty(a)) {
            this.module.formPanel.owner.getMsgBox().confirm(_T("app", "app_name"), _T("common", "confirm_lostchange"), function (i) {
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
    onActivate: function () {
        var a = this.getSelectedRecords()[0];
        if (!a) {
            this.select(1)
        }
    }
});

// Card panel
SYNOCOMMUNITY.UIDevelop.MainCardPanel = Ext.extend(Ext.Panel, {
    PanelTest: null,
    constructor: function (config) {
        this.app = config.app;
        this.PanelTest = new SYNOCOMMUNITY.UIDevelop.PanelTest({app: this.app});
        config = Ext.apply({
            activeItem: 0,
            layout: "card",
            items: [this.PanelTest],
            border: false,
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            }
        }, config);
        SYNOCOMMUNITY.UIDevelop.MainCardPanel.superclass.constructor.call(this, config)
    },
    onActivate: function (a) {
        if (this.PanelTest) {
            this.PanelTest.load()
        }
    },
    onDeactivate: function (a) {}
});


// Test panel
//SYNOCOMMUNITY.UIDevelop.PanelTest = Ext.extend(Ext.Panel, {});

SYNOCOMMUNITY.UIDevelop.PanelTest = Ext.extend(Ext.FormPanel, {
    constructor: function(config) {
        this.app = config.app;
        config = Ext.apply({
            border: false,
            labelWidth: 125,
            bodyStyle: 'padding: 5px 5px 0',
            monitorValid: true,
            items: [{
                xtype:'fieldset',
                title: _V('config', 'fieldset_test'),
                defaultType: 'textfield',
                defaults: {
                    anchor: '-20'
                },
                items :[{
                    fieldLabel: _V('config', 'test_directory'),
                    name: 'test_directory',
                    allowBlank: false,
                }]
            }],
            buttons: [{
                text: _T('common', 'apply'),
                handler: function() {
                    this.getForm().submit();
                },
                scope: this
            }],
            api: {
                load: SYNOCOMMUNITY.UIDevelop.Remote.UID.load,
                submit: SYNOCOMMUNITY.UIDevelop.Remote.UID.save
            }
        }, config);
        SYNOCOMMUNITY.UIDevelop.PanelTest.superclass.constructor.call(this, config);
        this.on('beforeaction', function(form, action) {
            this.app.setStatusBusy();
        });
        this.on('actioncomplete', function(form, action) {
            this.app.clearStatusBusy();
            if (action.type == 'directsubmit') {
                this.app.setStatusOK({text: _V('messages', 'saved')});
            }
        });
        this.on('actionfailed', function(form, action) {
            this.app.clearStatusBusy();
            if (action.type == 'directsubmit') {
                this.app.setStatusError({clear: true});
                if (action.failureType == Ext.form.Action.SERVER_INVALID) {
                    for (field in action.result.myerrors) {
                        this.getForm().findField(field).markInvalid();
                    }
                }
            } else {
                this.app.setStatusError();
            }
        });
    }
});

