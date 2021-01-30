#!/usr/bin/python3

# Create the file to define usr-local-linker and data-share resources
# for spk installer

# usage:
# call this script with SPK_COMMANDS and/or SERVICE_WIZARD_SHARE parameters.
#
# examples:
# get_resources.py SPK_COMMANDS "bin/less sbin/mount.davfs" SERVICE_WIZARD_SHARE "wizard_download_folder"
# get_resources.py SPK_COMMANDS "bin/tree"


import json
import sys

# create linker resources from SPK_COMMAND 
def create_commands(input):
    linkers = {}
    if (input != ""):
        links = input.split(" ")
        for link in links:
            # take the top folder as key
            key = link.split("/", 1)[0]
            if key in linkers:
                (linkers [ key ]).append(link)
            else:
                linkers [ key ] = [ link ]
    return linkers


# create the wizard data resource for data-shares defined in wizard
def create_shares(input):
    if (input != ""):
        return { "name": "{{" + input + "}}", "permission" : { "ro": ["admin"] } }
    else:
        return {}


if __name__ == "__main__":
    for i, arg in enumerate(sys.argv):
        if arg == "SPK_COMMANDS":
            SPK_COMMANDS = sys.argv[i+1]
        if arg == "SERVICE_WIZARD_SHARE":
            SERVICE_WIZARD_SHARE = sys.argv[i+1]

    linkers = create_commands( SPK_COMMANDS )
    shares = create_shares( SERVICE_WIZARD_SHARE )
    
    resources = {}
    if ( linkers != {} ):
        resources ["usr-local-linker"] = linkers
    if ( shares != {} ):
        resources ["data-share"] = { "shares": [ shares ] }

    print ( json.dumps( resources, indent=2) )
