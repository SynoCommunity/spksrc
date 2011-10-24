Ext.onReady(function(){
	var tinyProxyStore = new Ext.data.SimpleStore({
		id:1,
		fields: ['key','value'],
		data: ==:tinyproxy:==
	});

	function testPort (field,value) {
		if (value != parseInt(value))
		{
			field.markInvalid('Numéro de port invalide')
		} else {
			if (value < 0 || value > 65535)
			{
				field.markInvalid('Numéro de port invalide')
			} else {
				field.clearInvalid()
			}
		}
	}
	
	function toutvalide() {
		return  Ext.getCmp('proxyaddress').isValid(false) && Ext.getCmp('proxyport').isValid(false);
	}

    var services_form = new Ext.FormPanel({
        url:'services.cgi',
		method: 'POST',
		timeout: 15000,
        frame:true,
		header:false,
		buttonAlign: 'left',
        bodyStyle:'padding:5px 5px 0',
        width: '420',
        items: [
            {
                xtype: 'fieldset',
				id: 'fsproxy',
                autoHeight: true,
                autoWidth: true,
                layout: {
                    columns: 4,
                    type: 'table'
                },
                items: [
                    {
                        xtype: 'label',
                        text: 'Adresse et port d\'écoute :'
                    },
                    {
                        xtype: 'textfield',
						width: 110,
                        name: 'proxyaddress',
						id: 'proxyaddress',
						value: tinyProxyStore.query('key','Listen',false).first().get('value').toString(),
						maskRe: /[0-9.]/,
						regex: /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/,
						regexText: 'Adresse IP invalide',
						msgTarget: 'side',
                        allowBlank: false
                    },
                    {
                        xtype: 'label',
                        html: '&nbsp;:&nbsp;',
                        text: ''
                    },
                    {
                        xtype: 'textfield',
                        width: 50,
						value: tinyProxyStore.query('key','Port',false).first().get('value').toString(),
                        name: 'proxyport',
						id: 'proxyport',
						msgTarget: 'side',
						regex: /^(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3})$/,
						regexText: 'Numéro de port invalide',
                        allowBlank: false
                    }
                ]
            },
            {
                xtype: 'container',
                autoHeight: true,
                autoWidth: true,
                layout: {
                    type: 'fit'
                },
                items: [
                    {
                        xtype: 'button',
                        id: 'sslh-submit',
                        scale: 'medium',
                        text: 'Valider',
                        type: 'submit',
						listeners: {
							'click': function() {
								if (toutvalide()) {
									services_form.getForm().submit({
										waitMsg: 'Mise à jour en cours ...',
										success: function(f,a) {
											Ext.MessageBox.alert('Info','Mise à jour terminée avec succès.<br>Relancer le package pour activer les modifications.');
										}, 
										failure: function(f,a) {
											if (a.result) {
												Ext.MessageBox.alert('Alerte','La mise à jour a échoué : '+a.result.msg);
											} else {
												Ext.MessageBox.alert('Erreur','Echec en raison d\'un problème avec le serveur');
											}
										}
									})
								} else {
									Ext.Msg.alert('Erreur', 'Merci de corriger les erreurs')
								}
							}
						}
                    }
                ]
            }
        ],
		renderTo: 'form1'
	});
});
