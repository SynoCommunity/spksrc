// Namespace
Ext.ns("SYNOCOMMUNITY.NZBConfig");

// Translator
_V = function (category, element) {
    return _TT("SYNOCOMMUNITY.NZBConfig.AppInstance", category, element)
}

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/nzbconfig/nzbconfig.cgi",
    "namespace": "SYNOCOMMUNITY.NZBConfig.Remote",
    "type": "remoting",
    "actions": {
        "SABnzbd": [{
            "formHandler": true,
            "name": "save",
            "len": 1
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "is_installed",
            "len": 0
        }],
        "NZBGet": [{
            "formHandler": true,
            "name": "save",
            "len": 1
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "is_installed",
            "len": 0
        }],
        "SickBeard": [{
            "formHandler": true,
            "name": "save",
            "len": 1
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "is_installed",
            "len": 0
        }],
        "CouchPotato": [{
            "formHandler": true,
            "name": "save",
            "len": 1
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "is_installed",
            "len": 0
        }],
        "Headphones": [{
            "formHandler": true,
            "name": "save",
            "len": 1
        }, {
            "name": "load",
            "len": 0
        }, {
            "name": "is_installed",
            "len": 0
        }]
    }
});

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

// Const
SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT = 300;
SYNOCOMMUNITY.NZBConfig.MAIN_WIDTH = 800;
SYNOCOMMUNITY.NZBConfig.LIST_WIDTH = 210;

// Application
SYNOCOMMUNITY.NZBConfig.AppInstance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName: "SYNOCOMMUNITY.NZBConfig.AppWindow",
    constructor: function () {
        SYNOCOMMUNITY.NZBConfig.AppInstance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SYNOCOMMUNITY.NZBConfig.AppWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,
    mainPanel: null,
    constructor: function (config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SYNOCOMMUNITY.NZBConfig.MainPanel({
            owner: this
        });
        config = Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: SYNOCOMMUNITY.NZBConfig.MAIN_WIDTH,
            height: SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT,
            layout: "fit",
            border: false,
            cls: "synocommunity-nzbconfig",
            items: [this.mainPanel]
        }, config);
        SYNOCOMMUNITY.NZBConfig.AppWindow.superclass.constructor.call(this, config);
    },
    onOpen: function (a) {
        SYNOCOMMUNITY.NZBConfig.AppWindow.superclass.onOpen.call(this, a);
        this.mainPanel.onActivate();
    },
    onRequest: function (a) {
        SYNOCOMMUNITY.NZBConfig.AppWindow.superclass.onRequest.call(this, a);
    },
    onClose: function () {
        if (SYNOCOMMUNITY.NZBConfig.AppWindow.superclass.onClose.apply(this, arguments)) {
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
SYNOCOMMUNITY.NZBConfig.MainPanel = Ext.extend(Ext.Panel, {
    listPanel: null,
    cardPanel: null,
    constructor: function (config) {
        this.owner = config.owner;
        var a = new SYNOCOMMUNITY.NZBConfig.ListView({
            module: this
        });
        this.listPanel = new Ext.Panel({
            region: "west",
            width: SYNOCOMMUNITY.NZBConfig.LIST_WIDTH,
            height: SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT,
            cls: "synocommunity-nzbconfig-list",
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
        this.curHeight = SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT;
        this.cardPanel = new SYNOCOMMUNITY.NZBConfig.MainCardPanel({
            module: this,
            owner: config.owner,
            itemId: "grid",
            region: "center"
        });
        this.id_panel = [
            ["sabnzbd", this.cardPanel.PanelSABnzbd],
            ["nzbget", this.cardPanel.PanelNZBGet],
            ["sickbeard", this.cardPanel.PanelSickBeard],
            ["couchpotato", this.cardPanel.PanelCouchPotato],
            ["headphones", this.cardPanel.PanelHeadphones]
        ];
        SYNOCOMMUNITY.NZBConfig.MainPanel.superclass.constructor.call(this, {
            border: false,
            layout: "border",
            height: SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT,
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
        return SYNOCOMMUNITY.NZBConfig.DEFAULT_HEIGHT
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
SYNOCOMMUNITY.NZBConfig.ListView = Ext.extend(Ext.list.ListView, {
    constructor: function (config) {
        var store = new Ext.data.JsonStore({
            data: {
                items: [{
                    title: _V("ui", "newsgrabber"),
                    id: "newsgrabber_title"
                }, {
                    title: "SABnzbd",
                    id: "sabnzbd"
                }, {
                    title: "NZBGet",
                    id: "nzbget"
                }, {
                    title: _V("ui", "applications"),
                    id: "applications_title"
                }, {
                    title: "SickBeard",
                    id: "sickbeard"
                }, {
                    title: "CouchPotato",
                    id: "couchpotato"
                }, {
                    title: "Headphones",
                    id: "headphones"
                }]
            },
            autoLoad: true,
            root: "items",
            fields: ["title", "id"]
        });
        config = Ext.apply({
            cls: "synocommunity-nzbconfig-list",
            padding: 10,
            split: false,
            trackOver: false,
            hideHeaders: true,
            singleSelect: true,
            store: store,
            columns: [{
                dataIndex: "title",
                cls: "synocommunity-nzbconfig-list-column",
                sortable: false,
                tpl: '<div class="synocommunity-nzbconfig-list-{id}">{title}</div>'
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
                        if (h === "newsgrabber_title" || h === "applications_title") {
                            f.removeClass(this.overClass)
                        }
                    }
                }
            }
        }, config);
        this.addEvents("onbeforeclick");
        SYNOCOMMUNITY.NZBConfig.ListView.superclass.constructor.call(this, config)
    },
    onBeforeClick: function (c, d, f, b) {
        var g = c.getRecord(f);
        var h = g.get("id");
        if (h === "newsgrabber_title" || h === "applications_title") {
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
SYNOCOMMUNITY.NZBConfig.MainCardPanel = Ext.extend(Ext.Panel, {
    PanelSABnzbd: null,
    constructor: function (config) {
        this.owner = config.owner;
        this.module = config.module;
        this.PanelSABnzbd = new SYNOCOMMUNITY.NZBConfig.PanelSABnzbd({
            owner: this.owner
        });
        this.PanelNZBGet = new SYNOCOMMUNITY.NZBConfig.PanelNZBGet({
            owner: this.owner
        });
        this.PanelSickBeard = new SYNOCOMMUNITY.NZBConfig.PanelSickBeard({
            owner: this.owner
        });
        this.PanelCouchPotato = new SYNOCOMMUNITY.NZBConfig.PanelCouchPotato({
            owner: this.owner
        });
        this.PanelHeadphones = new SYNOCOMMUNITY.NZBConfig.PanelHeadphones({
            owner: this.owner
        });
        config = Ext.apply({
            activeItem: 0,
            layout: "card",
            items: [this.PanelSABnzbd, this.PanelNZBGet, this.PanelSickBeard, this.PanelCouchPotato, this.PanelHeadphones],
            border: false,
            listeners: {
                scope: this,
                activate: this.onActivate,
                deactivate: this.onDeactivate
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.MainCardPanel.superclass.constructor.call(this, config)
    },
    onActivate: function (panel) {
        if (this.PanelSABnzbd) {
            this.PanelSABnzbd.onActivate();
        }
    },
    onDeactivate: function (panel) {}
});

// FormPanel base
SYNOCOMMUNITY.NZBConfig.FormPanel = Ext.extend(Ext.FormPanel, {
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
        SYNOCOMMUNITY.NZBConfig.FormPanel.superclass.constructor.call(this, a);
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

// SABnzbd panel
SYNOCOMMUNITY.NZBConfig.PanelSABnzbd = Ext.extend(SYNOCOMMUNITY.NZBConfig.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "sabnzbd",
            items: [{
                xtype: "fieldset",
                title: "SickBeard",
                defaultType: "textfield",
                defaults: {
                    anchor: "-20"
                },
                items: [{
                    xtype: "checkbox",
                    fieldLabel: _V("ui", "postprocessing"),
                    name: "sickbeard_postprocessing"
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.load,
                submit: SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.save
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.PanelSABnzbd.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.is_installed(function (provider, response) {
            if (!response.result) {
                this.getEl().mask(_V("errors", "sabnzbd_not_installed"));
                return;
            }
            SYNOCOMMUNITY.NZBConfig.Remote.SickBeard.is_installed(function (provider, response) {
                if (!response.result) {
                    this.getForm().findField("sickbeard_postprocessing").disable();
                }
            }, this);
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }, this);
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.NZBConfig.PanelSABnzbd.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getFieldValues());
            }
        });
    }
});

// NZBGet panel
SYNOCOMMUNITY.NZBConfig.PanelNZBGet = Ext.extend(SYNOCOMMUNITY.NZBConfig.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "nzbget",
            items: [{
                xtype: "fieldset",
                title: "SickBeard",
                defaultType: "textfield",
                defaults: {
                    anchor: "-20"
                },
                items: [{
                    xtype: "checkbox",
                    fieldLabel: _V("ui", "postprocessing"),
                    name: "sickbeard_postprocessing"
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.load,
                submit: SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.save
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.PanelNZBGet.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.is_installed(function (provider, response) {
            if (!response.result) {
                this.getEl().mask(_V("errors", "nzbget_not_installed"));
                return;
            }
            SYNOCOMMUNITY.NZBConfig.Remote.SickBeard.is_installed(function (provider, response) {
                if (!response.result) {
                    this.getForm().findField("sickbeard_postprocessing").disable();
                }
            }, this);
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }, this);
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.NZBConfig.PanelNZBGet.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getFieldValues());
            }
        });
    }
});

// SickBeard panel
SYNOCOMMUNITY.NZBConfig.PanelSickBeard = Ext.extend(SYNOCOMMUNITY.NZBConfig.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "sickbeard",
            items: [{
                xtype: "fieldset",
                title: _V("ui", "newsgrabber"),
                defaultType: "textfield",
                defaults: {
                    anchor: "-20"
                },
                items: [{
                    xtype: "radiogroup",
                    fieldLabel: _V("ui", "configure_for"),
                    name: "configure_for",
                    defaults: {
                        xtype: "radio",
                        name: "configure_for"
                    },
                    items: [{
                        itemId: "sabnzbd",
                        boxLabel: "SABnzbd",
                        inputValue: "sabnzbd"
                    }, {
                        itemId: "nzbget",
                        boxLabel: "NZBGet",
                        inputValue: "nzbget"
                    }, {
                        itemId: "nochange",
                        boxLabel: _V("ui", "no_change"),
                        inputValue: "nochange"
                    }]
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.NZBConfig.Remote.SickBeard.load,
                submit: SYNOCOMMUNITY.NZBConfig.Remote.SickBeard.save
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.PanelSickBeard.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.NZBConfig.Remote.SickBeard.is_installed(function (provider, response) {
            if (!response.result) {
                this.getEl().mask(_V("errors", "sickbeard_not_installed"));
                return;
            }
            SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "sabnzbd") {
                            item.disable();
                        }
                    });
                }
            }, this);
            SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "nzbget") {
                            item.disable();
                        }
                    });
                }
            }, this);
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }, this);
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.NZBConfig.PanelSickBeard.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getValues());
            }
        });
    }
});

// CouchPotato panel
SYNOCOMMUNITY.NZBConfig.PanelCouchPotato = Ext.extend(SYNOCOMMUNITY.NZBConfig.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "couchpotato",
            items: [{
                xtype: "fieldset",
                title: _V("ui", "newsgrabber"),
                defaultType: "textfield",
                defaults: {
                    anchor: "-20"
                },
                items: [{
                    xtype: "radiogroup",
                    fieldLabel: _V("ui", "configure_for"),
                    name: "configure_for",
                    defaults: {
                        xtype: "radio",
                        name: "configure_for"
                    },
                    items: [{
                        itemId: "sabnzbd",
                        boxLabel: "SABnzbd",
                        inputValue: "sabnzbd"
                    }, {
                        itemId: "nzbget",
                        boxLabel: "NZBGet",
                        inputValue: "nzbget"
                    }, {
                        itemId: "nochange",
                        boxLabel: _V("ui", "no_change"),
                        inputValue: "nochange"
                    }]
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.NZBConfig.Remote.CouchPotato.load,
                submit: SYNOCOMMUNITY.NZBConfig.Remote.CouchPotato.save
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.PanelCouchPotato.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.NZBConfig.Remote.CouchPotato.is_installed(function (provider, response) {
            if (!response.result) {
                this.getEl().mask(_V("errors", "couchpotato_not_installed"));
                return;
            }
            SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "sabnzbd") {
                            item.disable();
                        }
                    });
                }
            }, this);
            SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "nzbget") {
                            item.disable();
                        }
                    });
                }
            }, this);
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }, this);
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.NZBConfig.PanelCouchPotato.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getValues());
            }
        });
    }
});

// Headphones panel
SYNOCOMMUNITY.NZBConfig.PanelHeadphones = Ext.extend(SYNOCOMMUNITY.NZBConfig.FormPanel, {
    constructor: function (config) {
        this.owner = config.owner;
        config = Ext.apply({
            itemId: "headphones",
            items: [{
                xtype: "fieldset",
                title: _V("ui", "newsgrabber"),
                defaultType: "textfield",
                defaults: {
                    anchor: "-20"
                },
                items: [{
                    xtype: "radiogroup",
                    fieldLabel: _V("ui", "configure_for"),
                    name: "configure_for",
                    defaults: {
                        xtype: "radio",
                        name: "configure_for"
                    },
                    items: [{
                        itemId: "sabnzbd",
                        boxLabel: "SABnzbd",
                        inputValue: "sabnzbd"
                    }, {
                        itemId: "nzbget",
                        boxLabel: "NZBGet",
                        inputValue: "nzbget"
                    }, {
                        itemId: "nochange",
                        boxLabel: _V("ui", "no_change"),
                        inputValue: "nochange"
                    }]
                }]
            }],
            api: {
                load: SYNOCOMMUNITY.NZBConfig.Remote.Headphones.load,
                submit: SYNOCOMMUNITY.NZBConfig.Remote.Headphones.save
            }
        }, config);
        SYNOCOMMUNITY.NZBConfig.PanelHeadphones.superclass.constructor.call(this, config);
    },
    onActivate: function () {
        this.getEl().mask(_T("common", "loading"));
        SYNOCOMMUNITY.NZBConfig.Remote.Headphones.is_installed(function (provider, response) {
            if (!response.result) {
                this.getEl().mask(_V("errors", "headphones_not_installed"));
                return;
            }
            SYNOCOMMUNITY.NZBConfig.Remote.SABnzbd.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "sabnzbd") {
                            item.disable();
                        }
                    });
                }
            }, this);
            SYNOCOMMUNITY.NZBConfig.Remote.NZBGet.is_installed(function (provider, response) {
                if (!response.result) {
                    Ext.each(this.getForm().findField("configure_for").items.items, function (item, index) {
                        if (item.itemId == "nzbget") {
                            item.disable();
                        }
                    });
                }
            }, this);
            this.load({
                scope: this,
                success: function (form, action) {
                    this.getEl().unmask();
                }
            });
        }, this);
    },
    onApply: function () {
        if (!SYNOCOMMUNITY.NZBConfig.PanelHeadphones.superclass.onApply.apply(this, arguments)) {
            return false;
        }
        this.owner.setStatusBusy({
            text: _T("common", "saving")
        });
        this.getForm().submit({
            scope: this,
            success: function (form, action) {
                this.owner.clearStatusBusy();
                this.owner.setStatusOK();
                this.getForm().setValues(this.getForm().getValues());
            }
        });
    }
});

