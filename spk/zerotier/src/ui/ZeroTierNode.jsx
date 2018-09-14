var ZeroTierNode = React.createClass({
	getInitialState: function() {
		
		// get local address (of NAS) for ZT UI server and auth functions
		if(location.protocol == 'https:') {
			window.ui_port = 5001
		}
		else {
			window.ui_port = 5000
		}
		window.auth_addr = location.protocol + "//" + document.location.host + "/"
		window.ui_addr = location.protocol + "//" + document.location.hostname + ":" + ui_port + "/"

		this.syno_init()
		return {
			address: '----------',
			online: false,
			version: '_._._',
			_networks: [],
			_peers: []
		};
	},
	ago: function(ms) {
		if (ms > 0) {
			var tmp = Math.round((Date.now() - ms) / 1000);
			return ((tmp > 0) ? tmp : 0);
		} else return 0;
	},
	updatePeers: function() {
		Ajax.call({
			url: window.ui_addr+'peer' 
				+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
			type: 'GET',
			success: function(data) {
				if (data) {
					var pl = JSON.parse(data);
					if (Array.isArray(pl)) {
						this.setState({_peers: pl});
					}
				}
			}.bind(this),
			error: function() {
			}.bind(this)
		});
	},
	updateNetworks: function() {
		Ajax.call({
			url: window.ui_addr+'network' 
				+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
			type: 'GET',
			success: function(data) {
				if (data) {
					var nwl = JSON.parse(data);
					if (Array.isArray(nwl)) {
						this.setState({_networks: nwl});
					}
				}
			}.bind(this),
			error: function() {
			}.bind(this)
		});
	},
    requestAuth: function() {
        this.dispatchRequest('auth', {})
    },
    requestVersion: function () {
        this.dispatchRequest('version', {})
    },
    dispatchRequest: function(path, parameters) {
        Ajax.call({
        	url: window.ui_addr + path 
        		+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
            type: 'GET',
            success: function (response) {
                var data = JSON.parse(response.responseText)
            	alert('data=' + data)
            }.bind(this),
            error: function (response) {
                //alert('request error')
                //this.setState('UNAUTH');
            }.bind(this),
        })
    },
    getCookieVal : function(offset){
        var endstr = document.cookie.indexOf(";", offset);
        if(endstr == -1){
            endstr = document.cookie.length;
        }
        return unescape(document.cookie.substring(offset, endstr));
    },
    getCookie : function(name){
        var arg = name + "=",
            alen = arg.length,
            clen = document.cookie.length,
            i = 0,
            j = 0;
            
        while(i < clen){
            j = i + alen;
            if(document.cookie.substring(i, j) == arg){
                return this.getCookieVal(j);
            }
            i = document.cookie.indexOf(" ", i) + 1;
            if(i === 0){
                break;
            }
        }
        return null;
    },
	syno_init: function()
	{
		if (this.CSRF_TOKEN_KEY == 'SynoToken') {
            return
        }
        // Synology DSM require SynoToken (CSRF) and Cookie (USER) to authenticate a user request
        window.CSRF_TOKEN_KEY ='SynoToken'
        window.CSRF_TOKEN_VAL = null
        window.COOKIE_KEY = 'Cookie'
        window.COOKIE_VAL ='id='+this.getCookie('id')

		Ajax.call({
			url: window.auth_addr+'webman/login.cgi',
			type: 'GET',
			success: function(data) {
				this.alertedToFailure = false;
				if (data) {
					var parsed_data = JSON.parse(data)
					window.CSRF_TOKEN_VAL = parsed_data[window.CSRF_TOKEN_KEY]
					this.authenticated = true
				}
                this.requestAuth()

			}.bind(this),
			error: function(xhr){
        		//this.setState('UNAUTH');
    		}.bind(this)
		});
	},
	updateAll: function() {
		if(this.authenticated) {
			Ajax.call({
				url: window.ui_addr+'status' + '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
				type: 'GET',
				success: function(data) {
					this.alertedToFailure = false;
					if (data) {
						var status = JSON.parse(data);
						this.setState(status);
						document.title = 'ZeroTier One [' + status.address + ']';
					}
					this.updateNetworks();
					this.updatePeers();
				}.bind(this),
				error: function(xhr){
	        		//this.setState('UNAUTH');
	    		}.bind(this)
			});
		}
	},
	joinNetwork: function(event) {
		event.preventDefault();
		if ((this.networkToJoin)&&(this.networkToJoin.length === 16)) {
			Ajax.call({
				url: window.ui_addr+'network/'+this.networkToJoin 
					+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
				type: 'POST',
				success: function(data) {
					this.networkToJoin = '';
					if (this.networkInputElement)
						this.networkInputElement.value = '';
					this.updateNetworks();
				}.bind(this),
				error: function() {
				}.bind(this)
			});
		} else {
			alert('To join a network, create a network at https://my.zerotier.com and enter its 16-digit network ID here.');
		}
	},
	resetService: function(event) {
		event.preventDefault();
		Ajax.call({
			url: window.ui_addr+'reset' 
				+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
			type: 'POST',
			success: function(data) {
				// ...
			}.bind(this),
			error: function() {
			}.bind(this)
		});
	},
	handleNetworkIdEntry: function(event) {
		this.networkInputElement = event.target;
		var nid = this.networkInputElement.value;
		if (nid) {
			nid = nid.toLowerCase();
			var nnid = '';
			for(var i=0;((i<nid.length)&&(i<16));++i) {
				if ("0123456789abcdef".indexOf(nid.charAt(i)) >= 0)
					nnid += nid.charAt(i);
			}
			this.networkToJoin = nnid;
			this.networkInputElement.value = nnid;
		} else {
			this.networkToJoin = '';
			this.networkInputElement.value = '';
		}
	},
	handleNetworkDelete: function(nwid) {
		var networks = [];
		for(var i=0;i<this.state._networks.length;++i) {
			if (this.state._networks[i].nwid !== nwid)
				networks.push(this.state._networks[i]);
		}
		this.setState({_networks: networks});
	},
	componentDidMount: function() {
		this.updateAll();
		this.updateIntervalId = setInterval(this.updateAll,1000);
	},
	componentWillUnmount: function() {
		clearInterval(this.updateIntervalId);
	},
	render: function() {
		return (
			<div className="zeroTierNode">
				<div className="middle"><div className="middleCell">
					<div className="middleScroll">
						<div className="networks" key="_networks">
							{
								this.state._networks.map(function(network) {
									network['onNetworkDeleted'] = this.handleNetworkDelete;
									return React.createElement('div',{className: 'network',key: network.nwid},React.createElement(ZeroTierNetwork,network));
								}.bind(this))
							}
						</div>
					</div>
				</div></div>
				<div className="bottom">
					<div className="left">
						<span className="statusLine"><span className="zeroTierAddress">{this.state.address}</span>&nbsp;&nbsp;{this.state.online ? (this.state.tcpFallbackActive ? 'TUNNELED' : 'ONLINE') : 'OFFLINE'}&nbsp;&nbsp;{this.state.version}</span>
					</div>
					<div className="right">
						<form onSubmit={this.joinNetwork}><input type="text" maxlength="16" placeholder="[ Network ID ]" onChange={this.handleNetworkIdEntry} size="16"/>
							<button type="button" onClick={this.joinNetwork}>Join</button></form>
					</div>
				</div>
			</div>
		);
	}
});
