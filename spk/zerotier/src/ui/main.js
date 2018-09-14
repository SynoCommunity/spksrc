/*
 * ZeroTier One - Network Virtualization Everywhere
 * Copyright (C) 2011-2015  ZeroTier, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * --
 *
 * ZeroTier may be used and distributed under the terms of the GPLv3, which
 * are available at: http://www.gnu.org/licenses/gpl-3.0.html
 *
 * If you would like to embed ZeroTier into a commercial application or
 * redistribute it in a modified binary form, please contact ZeroTier Networks
 * LLC. Start here: http://www.zerotier.com/
 */

function getUrlParameter(parameter)
{
	var currLocation = window.location.search;
	if (currLocation.indexOf('?') < 0)
		return '';
	var parArr = currLocation.split("?")[1].split("&");
	for(var i = 0; i < parArr.length; i++){
		parr = parArr[i].split("=");
		if (parr[0] == parameter) {
			return decodeURIComponent(parr[1]);
		}
	}
	return '';
}

React.render(
	React.createElement(ZeroTierNode, {}),
	document.getElementById('main')
);
