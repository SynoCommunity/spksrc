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
	mainPanel: null,
	constructor: function(config) {
		this.appInstance = config.appInstance;
		config = Ext.apply({
			resizable: true,
			maximizable: true,
			minimizable: true,
			width: 600,
			height: 400,
			items: [{
				xtype: 'label',
				text: 'Welcome: '
			}, {
				xtype: "syno_button",
				btnStyle: "blue",
				text: 'Call CGI',
				handler: this.onSureBtnClick.bind(this)
			}]
		}, config);

		this.callParent([config]);
	},
	onSureBtnClick: function() {
		//window.alert('Button click');
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
				window.alert('CGI called : ' + result);
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

