# -*- coding: utf8 -*-
# ***** BEGIN LICENSE BLOCK *****
# Version: MPL 1.1/GPL 2.0/LGPL 2.1
#
# The contents of this file are subject to the Mozilla Public License Version
# 1.1 (the "License"); you may not use this file except in compliance with
# the License. You may obtain a copy of the License at
# http://www.mozilla.org/MPL/
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
# for the specific language governing rights and limitations under the
# License.
#
# The Original Code is Sync Server
#
# The Initial Developer of the Original Code is the Mozilla Foundation.
# Portions created by the Initial Developer are Copyright (C) 2010
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Tarek Ziade (tarek@mozilla.com)
#
# Alternatively, the contents of this file may be used under the terms of
# either the GNU General Public License Version 2 or later (the "GPL"), or
# the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
# in which case the provisions of the GPL or the LGPL are applicable instead
# of those above. If you wish to allow use of your version of this file only
# under the terms of either the GPL or the LGPL, and not to allow others to
# use your version of this file under the terms of the MPL, indicate your
# decision by deleting the provisions above and replace them with the notice
# and other provisions required by the GPL or the LGPL. If you do not delete
# the provisions above, a recipient may use your version of this file under
# the terms of any one of the MPL, the GPL or the LGPL.
#
# ***** END LICENSE BLOCK *****
import os
import sys
import site
from logging.config import fileConfig
from ConfigParser import NoSectionError

# detecting if virtualenv was used in this dir
_CURDIR = os.path.dirname(os.path.abspath(__file__))
_PY_VER = sys.version.split()[0][:3]

# XXX Posix scheme
_SITE_PKG = os.path.join(_CURDIR, 'lib', 'python' + _PY_VER, 'site-packages')

# adding virtualenv's site-package and ordering paths
saved = sys.path[:]

if os.path.exists(_SITE_PKG):
    site.addsitedir(_SITE_PKG)

for path in sys.path:
    if path not in saved:
        saved.insert(0, path)

sys.path[:] = saved

# setting up the egg cache to a place where apache can write
os.environ['PYTHON_EGG_CACHE'] = '/var/services/web/syncserver/tmp'

# setting up logging
ini_file = os.path.join(_CURDIR, 'production.ini')
try:
    fileConfig(ini_file)
except NoSectionError:
    pass

# running the app using Paste
from paste.deploy import loadapp
application = loadapp('config:%s'% ini_file)
