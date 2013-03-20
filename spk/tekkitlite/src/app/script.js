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
			params: Ext.urlEncode({lineNo: log.lineNumber}),
			success: function(responseObject) {
				console.log(responseObject.responseText);
				var obj = Ext.decode(responseObject.responseText);
				if (obj.ret != 'ok') {
					Ext.Msg.alert('Error','Unable to load Tekkit log... is the server running ?(' + obj.error + ')');
					Ext.TaskMgr.stop(updateLog);
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
				}
			},
			failure: function(rso) {
				Ext.TaskMgr.stop(updateLog);
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
					//Need to delay this get log slightly...
					getLog(); //This usually happens to quick!
					log.el.dom.scrollTop = 99999;
				}
			},
			failure: function(responseObject) {
				Ext.Msg.alert('Error','Server has been stopped.');
				Ext.TaskMgr.stop(updateLog);
			}
		});
	}
	
	var conn = new Ext.data.Connection();
	var updateLog = {
		run: getLog,
		interval: 1000 //1 second
	}
	Ext.TaskMgr.start(updateLog);

	var log = new Ext.form.TextArea ({
		hideLabel: true,
		name: 'log',
		disabled: true,
		autoScroll: true,
		grow: false,
		preventScrollbars: false,
		anchor: '100% -53',
		value: 'Loading...',
		style: {
			color: 'black',
			'font-size': '14px'
		}
	});

	log.lineNumber = 0; //Keep track of how many lines we have read

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


    var form = new Ext.form.FormPanel({
    	renderTo: 'content',
        baseCls: 'x-plain',
        url:'save-form.php',
		height: estimateHeight(),
        items: [
			log,
			new Ext.Toolbar({
				items: [
					msgBox,
					'-',
				]
			})
		]
    });

	Ext.EventManager.onWindowResize(function() {
		form.doLayout();
		form.setHeight(estimateHeight());
		msgBox.setWidth(form.getWidth() - 5);
	});

	//Expand the textbox to use all the space in the toolbar
	msgBox.setWidth(form.getWidth() - 5);
});
