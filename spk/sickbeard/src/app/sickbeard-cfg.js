// Namespace
Ext.ns("SickBeardCfg");

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/sickbeard/sickbeard-cfg.cgi",
    "namespace": "SickBeardCfg.Remote",
    "type": "remoting",
    "actions": {
        "SickBeardCfg": [
            {"formHandler": true, "name": "save", "len": 2},
            {"name": "load", "len": 0},
            {"name": "available_configs", "len": 0}
        ]
    }
});

// Application
SickBeardCfg.Instance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName : "SickBeardCfg.MainWindow",
    constructor : function() {
        SickBeardCfg.Instance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
SickBeardCfg.MainWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,	
    mainPanel: null,
    constructor: function(config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new SickBeardCfg.MainPanel({owner: this});
        config = Ext.apply({
            resizable: false,
            maximizable: false,
            minimizable: true,
            width: 500,
            layout: 'fit',
            items: [this.mainPanel]
        }, config);
        SickBeardCfg.MainWindow.superclass.constructor.call(this, config);
    },
    onOpen : function(a) {
        SickBeardCfg.MainWindow.superclass.onOpen.call(this, a);
        this.mainPanel.load();
    },
    onRequest : function(a) {
        SickBeardCfg.MainWindow.superclass.onRequest.call(this, a);
    },
    onClose : function() {
        if(SickBeardCfg.MainWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            return true
        }
        return false;
    }
});

// Main panel
SickBeardCfg.MainPanel = Ext.extend(Ext.FormPanel, {
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
                        inputValue: 'sabnzbd'
                    }, {
                        boxLabel: 'NZBGet',
                        inputValue: 'nzbget'
                    }, {
                        boxLabel: _V('config', 'nothing'),
                        inputValue: 'nothing'
                    }]
                }]
            }, {
                xtype: 'fieldset',
                title: _V('config', 'autoprocesstv'),
                items:[{
                    xtype: 'checkbox',
                    fieldLabel: _V('config', 'autoprocesstv'),
                    boxLabel: _V('config', 'enable'),
                    name: 'autoprocesstv'
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
                load: SickBeardCfg.Remote.SickBeardCfg.load,
                submit: SickBeardCfg.Remote.SickBeardCfg.save
            }
        }, config);
        SickBeardCfg.MainPanel.superclass.constructor.call(this, config);
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
    return _TT('SickBeardCfg.Instance', category, element)
}

