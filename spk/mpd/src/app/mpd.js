// Namespace
Ext.ns("MPD");

// Direct API
Ext.Direct.addProvider({
    "url": "3rdparty/mpd/mpd.cgi",
    "namespace": "MPD.Remote",
    "type": "remoting",
    "actions": {
        "MPD": [
            {"formHandler": true, "name": "save", "len": 2},
            {"name": "load", "len": 0}
        ]
    }
});

// Application
MPD.Instance = Ext.extend(SYNO.SDS.AppInstance, {
    appWindowName : "MPD.MainWindow",
    constructor : function() {
        MPD.Instance.superclass.constructor.apply(this, arguments);
    }
});

// Main window
MPD.MainWindow = Ext.extend(SYNO.SDS.AppWindow, {
    appInstance: null,	
    mainPanel: null,
    constructor: function(config) {
        this.appInstance = config.appInstance;
        this.mainPanel = new MPD.MainPanel({owner: this});
        config = Ext.apply({
            resizable: false,
            maximizable: false,
            minimizable: true,
            width: 500,
            layout: 'fit',
            items: [this.mainPanel]
        }, config);
        MPD.MainWindow.superclass.constructor.call(this, config);
    },
    onOpen : function(a) {
        MPD.MainWindow.superclass.onOpen.call(this, a);
        this.mainPanel.load();
    },
    onRequest : function(a) {
        MPD.MainWindow.superclass.onRequest.call(this, a);
    },
    onClose : function() {
        if(MPD.MainWindow.superclass.onClose.apply(this, arguments)) {
            this.doClose();
            return true
        }
        return false;
    }
});

// Main panel
MPD.MainPanel = Ext.extend(Ext.FormPanel, {
    constructor: function(config) {
        this.owner = config.owner;
        config = Ext.apply({
            labelWidth: 125,
            bodyStyle: 'padding: 5px 5px 0',
            monitorValid: true,
            items: [{
                xtype:'fieldset',
                title: _V('config', 'fieldset_files_and_directories'),
                defaultType: 'textfield',
                items :[{
                    fieldLabel: _V('config', 'music_directory'),
                    name: 'music_directory',
                    allowBlank: false,
                    anchor: '100%'
                }, {
                    xtype: 'numberfield',
                    fieldLabel: _V('config', 'port_number'),
                    name: 'port_number',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '100%'
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
                load: MPD.Remote.MPD.load,
                submit: MPD.Remote.MPD.save
            }
        }, config);
        MPD.MainPanel.superclass.constructor.call(this, config);
        this.on('beforeaction', function(form, action) {
            this.owner.setStatusBusy();
        });
        this.on('actioncomplete', function(form, action) {
            this.owner.clearStatusBusy();
            if (action.type == 'directsubmit') {
                this.owner.setStatusOK({text: _V('messages', 'saved')});
            }
        });
        this.on('actionfailed', function(form, action) {
            this.owner.clearStatusBusy();
            if (action.type == 'directsubmit') {
                this.owner.setStatusError({text: _V('errors', 'directsubmit'), clear: true});
                if (action.failureType == Ext.form.Action.SERVER_INVALID) {
                    for (field in action.result.myerrors) {
                        this.getForm().findField(field).markInvalid();
                    }
                }
            } else {
                this.owner.setStatusError();
            }
        });
    }
});

// Translator
_V = function(category, element) {
    return _TT('MPD.Instance', category, element)
}
