// Namespace definition
Ext.ns("SYNOCOMMUNITY.SimpleExtJSApp");

// Application definition
Ext.define("SYNOCOMMUNITY.SimpleExtJSApp.AppInstance", {
    extend: "SYNO.SDS.AppInstance",
    appWindowName: "SYNOCOMMUNITY.SimpleExtJSApp.AppWindow",
    constructor: function() {
        this.callParent(arguments)
    }
});

// Window definition
Ext.define("SYNOCOMMUNITY.SimpleExtJSApp.AppWindow", {
    extend: "SYNO.SDS.AppWindow",
    appInstance: null,
    tabs: null,
    constructor: function(config) {
        this.appInstance = config.appInstance;

        this.tabs = (function() {
            var allTabs = [];

            // Tab for CGI calls
            allTabs.push({
                title: "CGI Call",
                layout: "fit",
                items: [
                    this.createDisplayCall()
                ]
            });

            // Tab for GUI components
            allTabs.push({
                title: "GUI Components",
                layout: "fit",
                items: [
                    this.createDisplayGUI()
                ]
            });

            return allTabs;
        }).call(this);

        config = Ext.apply({
            resizable: true,
            maximizable: true,
            minimizable: true,
            width: 640,
            height: 640,
            items: [{
                    xtype: 'syno_displayfield',
                    value: 'Welcome to the DSM Demo App! Please choose :'
                },
                {
                    xtype: 'syno_tabpanel',
                    activeTab: 0,
                    plain: true,
                    items: this.tabs,
                    deferredRender: true
                }
            ]
        }, config);

        this.callParent([config]);
    },
    createDisplayCall: function() {
        return new SYNO.ux.FieldSet({
            title: "Call to CGI or API",
            collapsible: false,
            items: [{
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CGI in C :',
                        width: 100
                    }, {
                        xtype: "syno_button",
                        btnStyle: "green",
                        text: 'Call C CGI ',
                        handler: this.onCGIClick.bind(this)
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CGI in Perl :',
                        width: 100
                    }, {
                        xtype: "syno_button",
                        btnStyle: "red",
                        text: 'Call Perl CGI ',
                        handler: this.onPerlCGIClick.bind(this)
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CGI in Python :',
                        width: 100
                    }, {
                        xtype: "syno_button",
                        btnStyle: "blue",
                        text: 'Call Python CGI ',
                        handler: this.onPythonCGIClick.bind(this)
                    }]
                }
            ]
        });
    },
    createDisplayGUI: function() {
        return new SYNO.ux.FieldSet({
            title: "GUI components ",
            collapsible: false,
            items: [

                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'Button Field :'
                    }, {
                        xtype: "syno_button",
                        text: "Confirm"
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'Text Field :'
                    }, {
                        xtype: "syno_textfield",
                        fieldLabel: "TextField: ",
                        value: "Text"
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CheckBox :'
                    }, {
                        xtype: "syno_checkbox",
                        boxLabel: "Activate option"
                    }]
                }

            ]
        });
    },
    onCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/test.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // loads results whose Id is 1
            },
            headers: {
                'Content-Type': 'text/html'
            },
            success: function(response) {
                var result = response.responseText;
                window.alert('C CGI called : ' + result);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }

        });

    },
    onPythonCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/python.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // loads results whose Id is 1
            },
            headers: {
                'Content-Type': 'text/html'
            },
            success: function(response) {
                var result = response.responseText;
                window.alert('Python CGI called : ' + result);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }

        });

    },
    onPerlCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/perl.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // loads results whose Id is 1
            },
            headers: {
                'Content-Type': 'text/html'
            },
            success: function(response) {
                var result = response.responseText;
                window.alert('Perl CGI called : ' + result);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }

        });

    },
    onOpen: function(a) {
        SYNOCOMMUNITY.SimpleExtJSApp.AppWindow.superclass.onOpen.call(this, a);

    }
});

