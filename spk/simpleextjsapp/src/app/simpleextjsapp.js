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

            // Tab for CGI or API calls
            allTabs.push({
                title: "Server Calls",
                items: [
                    this.createDisplayCGI(),
                    this.createDisplayAPI(),
                    this.createDisplayExternalAPI()
                ]
            });

            // Tab for Form components
            allTabs.push({
                title: "Form Components",
                layout: "fit",
                items: [
                    this.createStandardGUI(),
                    this.createAdvancedGUI()
                ]
            });

            // Tab for Menu & Toolbar components
            allTabs.push({
                title: "Menu & Toolbar Components",
                layout: "fit",
                items: [
                    this.createMenuGUI()
                ]
            });

            // Tab for User interaction
            allTabs.push({
                title: "User interaction",
                layout: "fit",
                items: [
                    this.createInteraction()
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
    // Create the display of CGI calls
    createDisplayCGI: function() {
        return new SYNO.ux.FieldSet({
            title: "Call to CGI",
            collapsible: true,
            items: [{
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CGI in C :',
                        width: 140
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
                        width: 140
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
                        width: 140
                    }, {
                        xtype: "syno_button",
                        btnStyle: "blue",
                        text: 'Call Python CGI ',
                        handler: this.onPythonCGIClick.bind(this)
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'CGI in bash :',
                        width: 140
                    }, {
                        xtype: "syno_button",
                        text: 'Call bash CGI ',
                        handler: this.onBashCGIClick.bind(this)
                    }]
                }
            ]
        });
    },
    // Create the display of API calls
    createDisplayAPI: function() {
        return new SYNO.ux.FieldSet({
            title: "Call to Syno API",
            collapsible: true,
            items: [{
                xtype: "syno_compositefield",
                hideLabel: true,
                items: [{
                    xtype: 'syno_displayfield',
                    value: 'SYNO.Core.System :',
                    width: 140
                }, {
                    xtype: "syno_button",
                    btnStyle: "green",
                    text: 'Call API ',
                    handler: this.onAPIClick.bind(this)
                }]
            }]
        });
    },
    // Create the display of external API calls
    createDisplayExternalAPI: function() {
        return new SYNO.ux.FieldSet({
            title: "Call to external API",
            collapsible: true,
            items: [{
                xtype: "syno_compositefield",
                hideLabel: true,
                items: [{
                    xtype: 'syno_displayfield',
                    value: 'www.boredapi.com :',
                    width: 140
                }, {
                    xtype: "syno_button",
                    btnStyle: "green",
                    text: 'Words of Day',
                    handler: this.onExternalAPIClick.bind(this)
                }]
            }]
        });
    },
    // Create the display of Form Components / Standard
    createStandardGUI: function() {
        return new SYNO.ux.FieldSet({
            title: "Standard",
            collapsible: true,
            autoHeight: true,
            items: [

                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'Button :',
                        width: 100
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
                        value: 'TextField :',
                        width: 100
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
                        value: 'Checkbox :',
                        width: 100
                    }, {
                        xtype: "syno_checkbox",
                        boxLabel: "Activate option"
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'ComboBox :',
                        width: 100
                    }, {
                        xtype: "syno_combobox",
                        store: this.createTimeItemStore("min"),
                        displayField: "display",
                        itemId: "minute",
                        valueField: "value",
                        value: 0,
                        triggerAction: "all",
                        width: 145,
                        mode: "local",
                        editable: false
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'TextArea :',
                        width: 100
                    }, {
                        xtype: "syno_textarea",
                        margins: "0 0 0 0",
                        name: "url",
                        width: 476,
                        height: 68,
                        autoFlexcroll: !0,
                        selectOnFocus: !0
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: 'Radio :',
                        width: 100
                    }, {
                        xtype: "syno_radio",
                        name: "policy",
                        checked: true,
                        boxLabel: "Option 1",
                        inputValue: 1
                    }]
                },
                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                        xtype: 'syno_displayfield',
                        value: '',
                        width: 100
                    }, {
                        xtype: "syno_radio",
                        name: "policy",
                        boxLabel: "Option 2",
                        inputValue: 2
                    }]
                }
            ]
        });
    },
    // Create the display of Form Components / Advanced
    createAdvancedGUI: function() {
        return new SYNO.ux.FieldSet({
            title: "Advanced",
            collapsible: true,
            autoHeight: true,
            items: [

                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                            xtype: 'syno_displayfield',
                            value: 'ColorField',
                            width: 100
                        },

                        {
                            xtype: "syno_colorfield",
                            value: "#993300"
                        }
                    ]
                },


                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                            xtype: 'syno_displayfield',
                            value: 'Switch',
                            width: 100
                        },

                        {
                            xtype: "syno_switch"
                        }
                    ]
                },

                {
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                            xtype: 'syno_displayfield',
                            value: 'TimeField',
                            width: 100
                        },

                        {
                            xtype: "syno_timefield",
                            value: "test",
                        }
                    ]
                }


            ]
        });
    },
    // Create the display of Menu & Toolbar Components / Standard
    createMenuGUI: function() {
        return new SYNO.ux.FieldSet({
            title: "Standard",
            collapsible: true,
            autoHeight: true,
            items: [{
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                            xtype: 'syno_displayfield',
                            value: 'Menu :',
                            width: 100
                        },
                        {
                            xtype: "syno_button",
                            text: "Menu button",
                            menu: {
                                items: [{
                                    text: "Undo",
                                    disabled: true
                                }, {
                                    text: "Redo",
                                    disabled: true
                                }, {
                                    xtype: "menuseparator"
                                }, {
                                    text: "Select All",
                                    disabled: false
                                }, {
                                    xtype: "menuseparator"
                                }, {
                                    text: "Lang",
                                    hideOnClick: false,
                                    disabled: false,
                                    menu: {
                                        xtype: "syno_menu",
                                        items: [{
                                            text: "FR"
                                        }, {
                                            text: "US"
                                        }]
                                    }
                                }]
                            }
                        }


                    ]
                }



            ]
        });
    },

    // Create the display of User Interaction
    createInteraction: function() {
        return new SYNO.ux.FieldSet({
            title: "Standard",
            collapsible: true,
            autoHeight: true,
            items: [{
                    xtype: "syno_compositefield",
                    hideLabel: true,
                    items: [{
                            xtype: 'syno_displayfield',
                            value: 'ModalWindow :',
                            width: 100
                        },
                        {
                            xtype: "syno_button",
                            text: 'Open window',
                            handler: this.onModalButtonClick.bind(this)
                        }


                    ]
                }



            ]
        });
    },

    // Handle display for ModalWindow
    onModalButtonClick: function() {

        var window = new SYNO.SDS.ModalWindow({
            closeAction: "hide",
            layout: "fit",
            width: 400,
            height: 200,
            resizable: !1,
            title: "Modal Window",
            buttons: [{
                text: "Close",
                handler: function() {
                    window.close();
                }
            }, {
                text: "Confirm",
                itemId: "confirm",
                btnStyle: "blue",
                handler: function() {
                    window.close();
                }
            }],
            items: [
                {

                    xtype: 'syno_displayfield',
                    value: 'Message for the user',

                }

            ],

        });
        window.open();


    },

    // Create the content for the ComboBox
    createTimeItemStore: function(e) {
        var a = [];
        var c = {
            hour: 24,
            min: 60
        };
        if (e in c) {
            for (var d = 0; d < c[e]; d++) {
                a.push([d, String.leftPad(String(d), 2, "0")])
            }
            var b = new Ext.data.SimpleStore({
                id: 0,
                fields: ["value", "display"],
                data: a
            });
            return b
        }
        return null
    },
    // Call Syno API on click
    onAPIClick: function() {
        var t = this.getBaseURL({
            api: "SYNO.Core.System",
            method: "info",
            version: 3
        });
        Ext.Ajax.request({
            url: t,
            method: 'GET',
            timeout: 60000,
            headers: {
                'Content-Type': 'application/json'
            },
            success: function(response) {
                var data = Ext.decode(response.responseText).data;
                var cpu_clock = data.cpu_clock_speed;
                var temp = data.sys_temp;
                window.alert('API called : cpu clock speed = ' + cpu_clock + ' and temperature = ' + temp);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }
        });

    },
    // Call external API on click
    onExternalAPIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/externalapi.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // add params if needed
            },
            headers: {
                'Content-Type': 'text/html'
            },
            success: function(response) {
                var result = response.responseText;
                window.alert('External API called : ' + result);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }

        });
    },
    // Call bash CGI on click
    onBashCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/bash.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // add params if needed
            },
            headers: {
                'Content-Type': 'text/html'
            },
            success: function(response) {
                var result = response.responseText;
                window.alert('Bash CGI called : ' + result);
            },
            failure: function(response) {
                window.alert('Request Failed.');

            }

        });
    },
    // Call C CGI on click
    onCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/test.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // add params if needed
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
    // Call Python CGI on click
    onPythonCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/python.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // add params if needed
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
    // Call Perl CGI on click
    onPerlCGIClick: function() {
        Ext.Ajax.request({
            url: '/webman/3rdparty/simpleextjsapp/perl.cgi',
            method: 'GET',
            timeout: 60000,
            params: {
                id: 1 // add params if needed
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
