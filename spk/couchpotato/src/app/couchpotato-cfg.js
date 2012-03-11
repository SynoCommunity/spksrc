// Namespace
Ext.ns("CouchPotatoCfg");

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/couchpotato/couchpotato-cfg.cgi",
    "namespace": "CouchPotatoCfg.Remote",
    "type": "remoting",
    "actions": {
        "CouchPotatoCfg": [
            {"formHandler": true, "name": "save", "len": 1},
            {"name": "load", "len": 0},
            {"name": "available_configs", "len": 0}
        ]
    }
});

// Application
CouchPotatoCfg.Instance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName : "CouchPotatoCfg.MainWindow",
    constructor : function() {
        CouchPotatoCfg.Instance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
CouchPotatoCfg.MainWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,	
    mainPanel: null,
    constructor: function(config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new CouchPotatoCfg.MainPanel({owner: this});
        config = Ext.apply({
            resizable: false,
            maximizable: false,
            minimizable: true,
            width: 500,
            layout: 'fit',
            items: [this.mainPanel]
        }, config);
        CouchPotatoCfg.MainWindow.superclass.constructor.call(this, config);
    },
    onOpen : function(a) {
        CouchPotatoCfg.MainWindow.superclass.onOpen.call(this, a);
        this.mainPanel.load();
    },
    onRequest : function(a) {
        CouchPotatoCfg.MainWindow.superclass.onRequest.call(this, a);
    },
    onClose : function() {
        if(CouchPotatoCfg.MainWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            return true
        }
        return false;
    }
});

// Main panel
CouchPotatoCfg.MainPanel = Ext.extend(Ext.FormPanel, {
    constructor: function(config) {
        this.owner = config.owner;
        config = Ext.apply({
            labelWidth: 125,
            bodyStyle: 'padding: 5px 5px',
            monitorValid: true,
            items: [{
                xtype: 'fieldset',
                title: _V('config', 'binary_newsgrabber'),
                items:[{
                    xtype: 'radiogroup',
                    fieldLabel: _V('config', 'binary_newsgrabber'),
                    name: 'configure_for',
                    defaults: {xtype: 'radio',
                        name: 'configure_for'
                    },
                    items: [{
                        boxLabel: 'SABnzbd',
                        inputValue: 'Sabnzbd'
                    }, {
                        boxLabel: 'NZBGet',
                        inputValue: 'Nzbget'
                    }, {
                        boxLabel: _V('config', 'nothing'),
                        inputValue: 'nothing'
                    }]
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
                load: CouchPotatoCfg.Remote.CouchPotatoCfg.load,
                submit: CouchPotatoCfg.Remote.CouchPotatoCfg.save
            }
        }, config);
        CouchPotatoCfg.MainPanel.superclass.constructor.call(this, config);
        this.on('beforeaction', function(form, action) {
            this.owner.setStatusBusy();
        });
        this.on('actioncomplete', function(form, action) {
            this.owner.clearStatusBusy();
            if (action.type == 'directsubmit') {
                this.owner.setStatusOK();
            }
        });
        this.on('actionfailed', function(form, action) {
            this.owner.setStatusError();
        });
    }
});

// Translator
_V = function(category, element) {
    return _TT('CouchPotatoCfg.Instance', category, element)
}

