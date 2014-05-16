function estimateHeight() {
    var myWidth = 0, myHeight = 0;
    if( typeof( window.innerWidth ) == 'number' ) {
        //Non-IE
        myHeight = window.innerHeight;
    } else if( document.documentElement && ( document.documentElement.clientWidth || document.documentElement.clientHeight ) ) {
        //IE 6+ in 'standards compliant mode'
        myHeight = document.documentElement.clientHeight;
    } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
        //IE 4 compatible
        myHeight = document.body.clientHeight;
    }
    return myHeight;
}


Ext.onReady(function() {

// CONFIG FILE SECTION AND BUTTONS ACTIONS
    function onSaveBtnClick(item){
        conn.request({
            url: 'scripts/writefile.cgi',
            params: Ext.urlEncode({name: combo.value, action: texta.getValue()}),
            success: function(responseObject) {
                if (responseObject.responseText=="Config Saved\n") {
                    Ext.Msg.alert('Status','Changes&nbsp;saved.');
                } else {
                    Ext.Msg.alert('Status',responseObject.responseText);
                }
                saveBtn.disable();
            }
        });
    }
    
    var conn = new Ext.data.Connection();

    function onComboClick(item){
        conn.request({
            url: 'scripts/getfile.cgi?'+Ext.urlEncode({action: combo.value}),
            success: function(responseObject) {
                texta.setValue(responseObject.responseText);
            }
        });
        saveBtn.disable();
    }
    
// SERVER BUTTONS ACTIONS
    function StartServerBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({startserver: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'server.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('serverlog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/server.enabled',
                    success : function() {
                    //alert('file found');
                    startserver.disable();
                    stopserver.enable();
                    }
                });                
                }});
                saveBtn.disable();
                startproxy.disable();
                restartproxy.disable();
                stopproxy.disable();
                refresh1.disable();
            }
        });
    }
    
    function RestartServerBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({restartserver: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'server.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('serverlog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/server.enabled',
                    success : function() {
                    //alert('file found');
                    startserver.disable();
                    stopserver.enable();
                    }
                });                
                }});
            }
        });
    }
    
    function StopServerBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({stopserver: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'server.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('serverlog');
                    cp1.update(htmlText, true);
                    }
                    });
                }});
                saveBtn.disable();
                startproxy.enable();
                restartproxy.enable();
                stopproxy.enable();
                refresh1.enable();
                stopserver.disable();
                startserver.enable();
            }
        });
    }

// PROXY BUTTONS ACTIONS
    function StartProxyBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({startproxy: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'proxy.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('proxylog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/proxy.enabled',
                    success : function() {
                    //alert('file found');
                    startproxy.disable();
                    stopproxy.enable();
                    }
                });                
                }});
                saveBtn.disable();
                startserver.disable();
                restartserver.disable();
                stopserver.disable();
                refresh0.disable();
            }
        });
    }
    
    function RestartProxyBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({restartproxy: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'proxy.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('proxylog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/proxy.enabled',
                    success : function() {
                    //alert('file found');
                    startproxy.disable();
                    stopproxy.enable();
                    }
                });                
                }});
            }
        });
    }
    
    function StopProxyBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({stopproxy: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'proxy.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('proxylog');
                    cp1.update(htmlText, true);
                    }
                    });
                }});
                saveBtn.disable();
                startserver.enable();
                restartserver.enable();
                stopserver.enable();
                refresh0.enable();
                stopproxy.disable();
                startproxy.enable();
            }
        });
    }
    
// AGENT BUTTONS ACTIONS
    function StartAgentBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({startagent: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'agentd.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('agentlog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/agent.enabled',
                    success : function() {
                    //alert('file found');
                    startagent.disable();
                    stopagent.enable();
                    }
                });                
                }});
                saveBtn.disable();
            }
        });
    }
    
    function RestartAgentBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({restartagent: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'agentd.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('agentlog');
                    cp1.update(htmlText, true);
                    }
                    }),
                    Ext.Ajax.request({
                    url: 'enable/agent.enabled',
                    success : function() {
                    //alert('file found');
                    startagent.disable();
                    stopagent.enable();
                    }
                });                
                }});
            }
        });
    }
    
    function StopAgentBtnClick(item){
        conn.request({
            url: 'scripts/services.cgi?'+Ext.urlEncode({stopagent: '*'}),
            success: function(responseObject) {
                Ext.Msg.alert('Status',responseObject.responseText, function(btn){if (btn == 'ok'){
                    Ext.Ajax.request ({
                    url: 'scripts/logfiles.cgi',
                    params: {
                    action: 'agentd.log'
                    },
                    success: function(response) {
                    var htmlText= response.responseText;
                    var cp1 = Ext.getCmp('agentlog');
                    cp1.update(htmlText, true);
                    }
                    });
                }});
                saveBtn.disable();
                stopagent.disable();
                startagent.enable();
            }
        });
    }
    
// CONFIG FILE SECTION AND BUTTON  */    
    var texta = new Ext.form.TextArea ({
        hideLabel: true,
        name: 'msg',
        style: 'font-family:monospace',
        grow: false,
        preventScrollbars: false,
        height: 400,
        width: '100%',
        enableKeyEvents:true,
        listeners: {
            keypress: function(f, e) {
                if (saveBtn.disabled) {
                    saveBtn.enable();
                    restartserver.enable();
                    restartproxy.enable();
                    restartagent.enable();
                }
            }
        }

    });

    var combo = new Ext.form.ComboBox ({
        store: [==:names:==],
        name: 'file',
        shadow: true,
        editable: false,
        mode: 'local',
        triggerAction: 'all',
        emptyText: 'Choose Config File',
        selectOnFocus: true
    });

    var saveBtn = new Ext.Toolbar.Button({
        handler: onSaveBtnClick,
        name: 'save',
        text: 'Save',
        icon: 'gui_images/save.png',
        cls: 'x-btn-text-icon',
        disabled: true
    });

// SERVER BUTTONS  */
    var startserver = new Ext.Toolbar.Button({
        handler: StartServerBtnClick,
        name: 'startserver',
        text: 'Start Server',
        icon: 'gui_images/run.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });

    var restartserver = new Ext.Toolbar.Button({
        handler: RestartServerBtnClick,
        name: 'restartserver',
        text: 'Restart Server',
        icon: 'gui_images/restart.png',
        cls: 'x-btn-text-icon',
        disabled: false
        
    });

    
    var stopserver = new Ext.Toolbar.Button({
        handler: StopServerBtnClick,
        name: 'stopserver',
        text: 'Stop Server',
        icon: 'gui_images/stop.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });

// PROXY BUTTONS  */
    var startproxy = new Ext.Toolbar.Button({
        handler: StartProxyBtnClick,
        name: 'startproxy',
        text: 'Start Proxy',
        icon: 'gui_images/run.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });
    
    var restartproxy = new Ext.Toolbar.Button({
        handler: RestartProxyBtnClick,
        name: 'restartproxy',
        text: 'Restart Proxy',
        icon: 'gui_images/restart.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });
    
    var stopproxy = new Ext.Toolbar.Button({
        handler: StopProxyBtnClick,
        name: 'stopproxy',
        text: 'Stop Proxy',
        icon: 'gui_images/stop.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });
    
// AGENT BUTTONS  */
    var startagent = new Ext.Toolbar.Button({
        handler: StartAgentBtnClick,
        name: 'startagent',
        text: 'Start Agent',
        icon: 'gui_images/run.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });

    var restartagent = new Ext.Toolbar.Button({
        handler: RestartAgentBtnClick,
        name: 'restartagent',
        text: 'Restart Agent',
        icon: 'gui_images/restart.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });
    
    var stopagent = new Ext.Toolbar.Button({
        handler: StopAgentBtnClick,
        name: 'stopagent',
        text: 'Stop Agent',
        icon: 'gui_images/stop.png',
        cls: 'x-btn-text-icon',
        disabled: false
    });

// FRESH BUTTONS
    var refresh0 = new Ext.Toolbar.Button({
        name: 'refresh0',
        text: 'Refresh Logfile',
        icon: 'gui_images/refresh.gif',
        cls: 'x-btn-text-icon',
        disabled: false,
        
        handler: function() {
            Ext.Ajax.request ({
                url: 'scripts/logfiles.cgi',
                params: {
                action: 'server.log'
                },
                success: function(response) {
                var htmlText= response.responseText;
                var cp1 = Ext.getCmp('serverlog');
                cp1.update(htmlText, true);
                }
            });
        }
    });
    var refresh1 = new Ext.Toolbar.Button({
        name: 'refresh1',
        text: 'Refresh Logfile',
        icon: 'gui_images/refresh.gif',
        cls: 'x-btn-text-icon',
        disabled: false,
        handler: function() {
            Ext.Ajax.request ({
                url: 'scripts/logfiles.cgi',
                params: {
                action: 'proxy.log'
                },
                success: function(response) {
                var htmlText= response.responseText;
                var cp1 = Ext.getCmp('proxylog');
                cp1.update(htmlText, true);
                }
            });
        }
    });
    var refresh2 = new Ext.Toolbar.Button({
        name: 'refresh2',
        text: 'Refresh Logfile',
        icon: 'gui_images/refresh.gif',
        cls: 'x-btn-text-icon',
        disabled: false,
        handler: function() {
            Ext.Ajax.request ({
                url: 'scripts/logfiles.cgi',
                params: {
                action: 'agentd.log'
                },
                success: function(response) {
                var htmlText= response.responseText;
                var cp1 = Ext.getCmp('agentlog');
                cp1.update(htmlText, true);
                }
            });
        }
    });

// THE FORM    
    var form = new Ext.form.FormPanel({
        renderTo: 'content',
        baseCls: 'x-plain',
        url:'save-form.php',
        bodyStyle: 'padding: 10px 20px 0px 20px',
        height: estimateHeight(),
        width: 1024,
        items: [{
        xtype: 'label',
        html: '<br>',
        },
        {
        xtype: 'label',
        html: '<img src="gui_images/zabbix_logo.png" alt="zabbix" align="left">',
        },
        {
        xtype: 'label',
        html: '<br>',
        },
        {xtype: 'hidden',
        listeners: {
        'render': function()
            {
            Ext.Ajax.request({
                    url: 'enable/agent.enabled',
                        success : function() {
                        //alert('file found');
                        startagent.disable();
                    },
                        failure : function() {  
                        //alert('file not found');
                        stopagent.disable();
                    }
                });                
            }
        }
        },
        {xtype: 'hidden',
        listeners: {
        'render': function()
            {
            Ext.Ajax.request({
                    url: 'enable/proxy.enabled',
                        success : function() {
                        //alert('file found');
                        startserver.disable();
                        restartserver.disable();
                        stopserver.disable();
                        refresh0.disable();
                        startproxy.disable();
                    },
                        failure : function() {  
                        //alert('file not found');
                        stopproxy.disable();
                    }
                });                
            }
        }
        },
        {xtype: 'hidden',
        listeners: {
        'render': function()
            {
            Ext.Ajax.request({
                    url: 'enable/server.enabled',
                        success : function() {
                        //alert('file found');
                        startproxy.disable();
                        restartproxy.disable();
                        stopproxy.disable();
                        refresh1.disable();
                        startserver.disable();
                    },
                        failure : function() {  
                        //alert('file not found');
                        stopserver.disable();
                    }
                });               
            }
        }
        },
        {
        xtype: 'label',
        html: '<br><br>',
        },
        new Ext.TabPanel({
        plain: true,
        activeTab: 0,
                items: [{
                title: 'Information',
                html: '<div class="article"><div class="section_header_support">Zabbix SIA</div><br>Thinking what to write here!!!!',
                },{
                title:'Zabbix Server',
                    items: [
                        new Ext.Toolbar({
                            items: [
                            {xtype: 'tbspacer', width: 20},
                            {xtype: 'tbseparator'},
                            startserver,
                            {xtype: 'tbseparator'},
                            stopserver,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbfill'},
                            {xtype: 'tbseparator'},
                            refresh0,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbspacer', width: 20},
                            ]
                        }),
                        new Ext.Panel({
                        id:     'serverlog',
                        height: 400,
                        width: '100%',
                        autoScroll: true,
                        frame: false,
                        header: false,
                        bodyCfg : { style: { 'text-align':'left', 'font':'12px tahoma,arial,helvetica,sans-serif','padding':'10px 10px 10px 10px' } },
                        autoLoad:{
                            url: 'scripts/logfiles.cgi',
                            contentType: 'html',
                            loadMask: true,
                            params: {
                            action: 'server.log'
                            }
                            }
                        }),
                    ]
                },{
                title:'Zabbix Proxy',
                    items: [
                        new Ext.Toolbar({
                            items: [
                            {xtype: 'tbspacer', width: 20},
                            {xtype: 'tbseparator'},
                            startproxy,
                            {xtype: 'tbseparator'},
                            stopproxy,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbfill'},
                            {xtype: 'tbseparator'},
                            refresh1,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbspacer', width: 20},
                            ]
                        }),
                        new Ext.Panel({
                        id:     'proxylog',
                        height: 400,
                        width: '100%',
                        autoScroll: true,
                        frame: false,
                        header: false,
                        bodyCfg : { style: { 'text-align':'left', 'font':'12px tahoma,arial,helvetica,sans-serif','padding':'10px 10px 10px 10px' } },
                        autoLoad:{
                            url: 'scripts/logfiles.cgi',
                            contentType: 'html',
                            loadMask: true,
                            params: {
                            action: 'proxy.log'
                            }
                            }
                        }),
                    ]
                },{
                title:'Zabbix Agent',
                    items: [
                        new Ext.Toolbar({
                            items: [
                            {xtype: 'tbspacer', width: 20},
                            {xtype: 'tbseparator'},
                            startagent,
                            {xtype: 'tbseparator'},
                            stopagent,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbfill'},
                            {xtype: 'tbseparator'},
                            refresh2,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbspacer', width: 20},
                            ]
                        }),
                        new Ext.Panel({
                        id:     'agentlog',
                        height: 400,
                        width: '100%',
                        autoScroll: true,
                        frame: false,
                        header: false,
                        bodyCfg : { style: { 'text-align':'left', 'font':'12px tahoma,arial,helvetica,sans-serif','padding':'10px 10px 10px 10px' } },
                        autoLoad:{
                            url: 'scripts/logfiles.cgi',
                            contentType: 'html',
                            loadMask: true,
                            params: {
                            action: 'agentd.log'
                            }
                            }
                        }),
                    ]
                },
                {
                title:'Configuration',
                    items: [
                        new Ext.Toolbar({
                        anchor:'100%',
                            items: [
                            {xtype: 'tbspacer', width: 20},
                            {xtype: 'tbseparator'},
                            combo,
                            {xtype: 'tbseparator'},
                            saveBtn,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbfill'},
                            {xtype: 'tbseparator'},
                            restartserver,
                            {xtype: 'tbseparator'},
                            restartproxy,
                            {xtype: 'tbseparator'},
                            restartagent,
                            {xtype: 'tbseparator'},
                            {xtype: 'tbspacer', width: 20},
                            ]
                        }),
                        texta
                    ]
                },{
                title:'Online Manual',
                height: 500,
                    items: [{
                        xtype: 'box',
                        autoEl: {
                        tag: 'iframe',
                        style: 'height: 100%; width: 100%; border: none',
                        src: 'https://www.zabbix.com/documentation/2.2/manual',
                        }
                    }]
                }]
            }),
        ]
    });

    Ext.EventManager.onWindowResize(function() {
        form.doLayout();
        form.setHeight(estimateHeight());
    });

    combo.addListener('select',onComboClick);

});
