Ext.onReady(function(){
	var sslhStore = new Ext.data.SimpleStore({
		id:2,
		fields: ['key','address', 'port'],
		data: ==:sslh:==
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
		return Ext.getCmp('sslhaddress').isValid(false) && Ext.getCmp('sslhport').isValid(false) 
			&& Ext.getCmp('sshaddress').isValid(false) && Ext.getCmp('sshport').isValid(false)
			&& Ext.getCmp('ssladdress').isValid(false) && Ext.getCmp('sslport').isValid(false)
			&& Ext.getCmp('vpnaddress').isValid(false) && Ext.getCmp('vpnport').isValid(false);
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
				id: 'fssslh',
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
                        id: 'sslhaddress',
						name: 'sslhaddress',
						value: sslhStore.query('key','listen',false).first().get('address').toString(),
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
                        xtype: 'numberfield',
                        width: 50,
                        id: 'sslhport',
						name: 'sslhport',
						value: sslhStore.query('key','listen',false).first().get('port').toString(),
						regex: /^(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3})$/,
						regexText: 'Numéro de port invalide',
                        allowBlank: false,
						msgTarget: 'side'
                    },
                    {
                        xtype: 'label',
                        text: 'Adresse et port SSH :'
                    },
                    {
                        xtype: 'textfield',
						width: 110,
                        id: 'sshaddress',
						name: 'sshaddress',
						value: sslhStore.query('key','ssh',false).first().get('address').toString(),
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
                        id: 'sshport',
						name: 'sshport',
                        width: 50,
						value: sslhStore.query('key','ssh',false).first().get('port').toString(),
						msgTarget: 'side',
						regex: /^(6553[0-5]|655[0-2][0-9]\d|65[0-4](\d){2}|6[0-4](\d){3}|[1-5](\d){4}|[1-9](\d){0,3})$/,
						regexText: 'Numéro de port invalide',
                        allowBlank: false
                    },
                    {
                        xtype: 'label',
                        text: 'Adresse et port SSL :'
                    },
                    {
                        xtype: 'textfield',
						width: 110,
                        name: 'ssladdress',
						id: 'ssladdress',
						value: sslhStore.query('key','ssl',false).first().get('address').toString(),
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
                        name: 'sslport',
						id: 'sslport',
						value: sslhStore.query('key','ssl',false).first().get('port').toString(),
						msgTarget: 'side',
						listeners: {'change': function(field,newvalue,oldvalue) {
							testPort(field,newvalue)
						}},
						allowBlank: false
                    },
                    {
                        xtype: 'label',
                        text: 'Adresse et port OpenVPN :'
                    },
                    {
                        xtype: 'textfield',
						width: 110,
                        name: 'vpnaddress',
						id: 'vpnaddress',
						value: sslhStore.query('key','openvpn',false).first().get('address').toString(),
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
						value: sslhStore.query('key','openvpn',false).first().get('port').toString(),
                        name: 'vpnport',
						id: 'vpnport',
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
