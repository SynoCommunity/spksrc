from collections import namedtuple
from flask import abort, request
from functools import wraps, partial
from subprocess import check_output
import grp
import os
import pwd


__all__ = ['authenticate', 'requires_auth']


def authenticate():
    """Authenticate a user using Synology's authenticate.cgi

    If the user is authenticated, returns a nametuple with the
    username and its groups, if not returns None. For example::

        >>> authenticate()
        User(name='admin', groups=['administrators'])

    :rtype: namedtuple or None

    """
    User = namedtuple('User', ['name', 'groups'])
    with open(os.devnull, 'w') as devnull:
        user = check_output(['/usr/syno/synoman/webman/modules/authenticate.cgi'], stderr=devnull).strip()
    if not user:
        return None
    groups = [g.gr_name for g in grp.getgrall() if user in g.gr_mem]
    groups.append(grp.getgrgid(pwd.getpwnam(user).pw_gid).gr_name)
    return User(user, set(groups))


def requires_auth(f=None, groups=None, users=None):
    """Require a user to be authenticated. If he is not, this aborts
    on 403.

    The condition to be authorized is for the user to be authenticated
    and in one of the listed groups (if any) or one of the listed users
    (if any)

    :param function f: the decorated function
    :param list groups: groups whitelist
    :param list users: users whitelist

    """
    if f is None:
        return partial(requires_auth, groups=groups, users=users)

    @wraps(f)
    def decorated(*args, **kwargs):
        user = authenticate()
        if user is None:  # Not authenticated
            abort(403)
        # A user is authorized if he is in the groups whitelist or the users whitelist
        authorized = False
        if groups is not None and len(set(groups) & user.groups) > 0:  # Authorized group
            authorized = True
        if users is not None and user.name in users:  # Authorized user
            authorized = True
        if not authorized:
            abort(403)
        return f(*args, **kwargs)
    return decorated
