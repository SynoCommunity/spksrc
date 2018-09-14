var ZeroTierNetwork = React.createClass({displayName: "ZeroTierNetwork",
	getInitialState: function() {
		return {};
	},

	leaveNetwork: function(event) {
		Ajax.call({
			url: window.ui_addr+'network/'+this.props.nwid+ '?' + window.COOKIE_KEY + '=' + window.COOKIE_VAL + window.CSRF_TOKEN_KEY + '=' + window.CSRF_TOKEN_VAL,
			type: 'DELETE',
			success: function(data) {
				if (this.props.onNetworkDeleted)
					this.props.onNetworkDeleted(this.props.nwid);
			}.bind(this),
			error: function(error) {
			}.bind(this)
		});
		event.preventDefault();
	},

	render: function() {
		return (
			React.createElement("div", {className: "zeroTierNetwork"}, 
				React.createElement("div", {className: "networkInfo"}, 
					React.createElement("span", {className: "networkId"}, this.props.nwid), " ", 
					React.createElement("span", {className: "networkName"}, this.props.name)
				), 
				React.createElement("div", {className: "networkProps"}, 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Status"), 
						React.createElement("div", {className: "value"}, this.props['status'])
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Type"), 
						React.createElement("div", {className: "value"}, this.props['type'])
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "MAC"), 
						React.createElement("div", {className: "value zeroTierAddress"}, this.props['mac'])
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "MTU"), 
						React.createElement("div", {className: "value"}, this.props['mtu'])
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Broadcast"), 
						React.createElement("div", {className: "value"}, (this.props['broadcastEnabled']) ? 'ENABLED' : 'DISABLED')
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Bridging"), 
						React.createElement("div", {className: "value"}, (this.props['bridge']) ? 'ACTIVE' : 'DISABLED')
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Device"), 
						React.createElement("div", {className: "value"}, (this.props['portDeviceName']) ? this.props['portDeviceName'] : '(none)')
					), 
					React.createElement("div", {className: "row"}, 
						React.createElement("div", {className: "name"}, "Managed IPs"), 
						React.createElement("div", {className: "value ipList"}, 
							
								this.props['assignedAddresses'].map(function(ipAssignment) {
									return (
										React.createElement("div", {key: ipAssignment, className: "ipAddress"}, ipAssignment)
									);
								})
							
						)
					)
				), 
				React.createElement("button", {type: "button", className: "leaveNetworkButton", onClick: this.leaveNetwork}, "Leave Network")
			)
		);
	}
});
