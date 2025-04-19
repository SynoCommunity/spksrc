# -*- coding: utf-8 -*-
import grp
import os
import pwd
import subprocess

from salt.utils import get_group_list


def auth(username, password):
    with open(os.devnull, 'w') as devnull:
        return subprocess.call(['synoauth', username, password], stdout=devnull, stderr=devnull) == 0


def groups(username, *args, **kwargs):
    return get_group_list(username)

