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

    function getLog(){
		conn.request({
			url: 'logFunctions.cgi',
			timeout: 60000,
			params: Ext.urlEncode({lineNo: log.lineNumber, lastLogTime: log.lastLogTime }),
			success: function(responseObject) {
				
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret != 'ok') {
					Ext.Msg.confirm('Unable to load the Tekkit log', obj.error + ' Try again ?', 
					function(button) { 
						if (button == 'yes') {
							updateLog.delay(500);
						}
					});
				} else {
					var pos = log.el.dom.scrollTop;
					var max = log.el.dom.scrollTopMax;
					
					if (pos == max) pos = 99999;					

					if (log.lineNumber > 0) {
						log.setRawValue(log.getValue() + unescape(obj.log));
						log.el.dom.scrollTop = pos;
					} else {
						log.setRawValue(unescape(obj.log));
						//Scroll to the bottom of the log
					        log.el.dom.scrollTop = 99999;
					}
					log.lineNumber = obj.lineNo;
					log.lastLogTime = obj.lastLogTime;
					updateLog.delay(500);
				}
			},
			failure: function(rso) {
				Ext.Msg.alert('Error', 'Error reading log');
			}
		});
	}
	
	function sendText(){
		conn.request({
			url: 'logFunctions.cgi',
			params: Ext.urlEncode({ text: msgBox.getValue() }),
			success: function(responseObject) {
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret != 'ok') {
					Ext.Msg.alert('Error','Unable to send text (' + obj.error + ')');
				} else {
					msgBox.setValue('');
					log.el.dom.scrollTop = 99999;
				}
			},
			failure: function(responseObject) {
				Ext.Msg.alert('Error','Server has been stopped.');
				//Ext.TaskMgr.stop(updateLog);
			}
		});
	}
	
	function downloadLog(){
		conn.abort(currentReq); //Abort the current request
		conn.request({
			url: 'logFunctions.cgi',
			params: Ext.urlEncode({ download: true }), //download last 1000 lines ?
			success: function(responseObject) {
				//Is this worth it ? or should i just save log.value to a file... (what about specifing blob data with a name ?)
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret == 'ok') {
					//A bit hacky... but it works
					var tf = new Ext.form.FormPanel({
						renderTo: 'hidden',
						standardSubmit: true,
						url: '/webman/3rdparty/tekkitlite/server.log.tar.gz'
					});
					tf.getForm().submit();
					tf.destroy();
					updateLog.delay(500); //Jobs done, go back to waiting for more log data
				}
			},
			failure: function(responseObject) {
				Ext.Msg.alert('Error', 'Unable to download log file');
			}
		});
		menuOpened = false;
	}

	function clearLog(){
		conn.request({
			url: 'logFunctions.cgi',
			params: Ext.urlEncode({ clearlog: true }),
			success: function(responseObject) {
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret == 'ok') {
					Ext.Msg.alert('', obj.text);
				}
			},
			failure: function(responseObject) {
				Ext.Msg.alert('Error', 'Unable to clear the log file');
			}
		});
		menuOpened = false;
	}

	function mountFolder(){
		conn.request({
			url: 'logFunctions.cgi',
			params: Ext.urlEncode({ mountfolder: true }), //var folderName
			success: function(responseObject) {
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret == 'ok') {
					Ext.Msg.alert('', obj.text);
				}				
			},
			failure: function(responseObject) {
				Ext.Msg.alert('Error', 'Unable to mount Tekkit folder.');
			}
		});
		menuOpened = false;
	}

	var conn = new Ext.data.Connection();
	var currentReq = 0; //Keep track of the active request
	var updateLog = new Ext.util.DelayedTask(function() {
		conn.abort(currentReq);
		currentReq = getLog();
	});
	updateLog.delay(500);

	var log = new Ext.form.TextArea ({
		hideLabel: true,
		name: 'log',
		disabled: true,
		autoScroll: true,
		grow: false,
		preventScrollbars: false,
		anchor: '100% -50',
		value: 'Loading...',
		style: {
			color: 'black',
			'font-size': '14px'
		}
	});

	log.lineNumber = 0; //Keep track of how many lines we have read
	log.lastLogTime = 0; //Has the log been updated since last we read it ?

	var msgBox = new Ext.form.TextField({
		hideLabel: true,
		name: 'msg',
		emptyText: 'Enter Message',
		enableKeyEvents:true,
		listeners: {
			keypress: function(f, e) {
				if(e.getCharCode() == 13) {
					sendText();
				}
			}
		},
	});
	
	
	var menuOpened = false;  //Clunky, but it works
	var options = new Ext.SplitButton({
		text: 'Options',
		handler: function() {
			if (!menuOpened) {
				this.showMenu();
				menuOpened = true;
			} else {
				this.hideMenu();
				menuOpened = false;
			}
		},
		menu: new Ext.menu.Menu({
			items: [
				{text: 'Clear Log', handler: clearLog },
				{id: 'download', text: 'Download Log', handler: downloadLog },
				{text: 'Un/Mount Tekkit Folder', handler: mountFolder }
			]
		})	
	});


    var form = new Ext.form.FormPanel({
	renderTo: 'content',
	baseCls: 'x-plain',
	height: estimateHeight(),
        items: [
		log,
		new Ext.Toolbar({
			items: [
				msgBox,
				'-',
				options
			]
		}),
		]
	
	});
	

	Ext.EventManager.onWindowResize(function() {
		form.doLayout();
		form.setHeight(estimateHeight());
		msgBox.setWidth(form.getWidth() - options.getWidth() - 15);
	});

	//Expand the textbox to use all the space in the toolbar
	msgBox.setWidth(form.getWidth() - options.getWidth() - 15);
});
