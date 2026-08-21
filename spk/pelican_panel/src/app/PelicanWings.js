// Namespace definition
Ext.ns("PelicanWings");

// Application definition
Ext.define("PelicanWings.AppInstance", {
	extend: "SYNO.SDS.AppInstance",
	appWindowName: "PelicanWings.AppWindow"
});

// Window definition
Ext.define("PelicanWings.AppWindow", {
	extend: "SYNO.SDS.AppWindow",

	constructor: function(config) {
		this.appInstance = config.appInstance;

		// Use the 3rdparty path which is allowed by DSM's Content Security Policy
		var iframeSrc = '/webman/3rdparty/pelican_panel/wings-config.html';

		config = Ext.apply({
			resizable: true,
			maximizable: true,
			minimizable: true,
			width: 900,
			height: 700,
			minWidth: 600,
			minHeight: 400,
			items: [{
				xtype: 'box',
				autoEl: {
					tag: 'iframe',
					src: iframeSrc,
					width: '100%',
					height: '100%',
					frameborder: '0',
					style: 'border: none; background: #0a1628;'
				}
			}],
			tools: [{
				id: 'help',
				qtip: 'Ouvrir dans un nouvel onglet',
				handler: function(event, element, panel) {
					window.open(iframeSrc, '_blank');
				}
			}]
		}, config);

		this.callParent([config]);
	}
});
