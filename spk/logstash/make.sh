# Notes
# http://forum.synology.com/wiki/index.php/Synology_package_files
# Usage:
# cd ".../SynoCommunity-spksrc/spk/logstash"
# ./make.sh


# [ Build Package ]
PACKAGE_NAME="logstash-1.3.3-noarch-0011"
WORKSPACE_DIRECTORY="$(pwd)"  # set to same directory that "make.sh" is located in.
PACKAGE_PATH="$WORKSPACE_DIRECTORY/src"

# Package Payload
cd "$PACKAGE_PATH/package"
tar -cvzf "$PACKAGE_PATH/package.tgz" *

# Move Package Directory our for compile
mv "$PACKAGE_PATH/package" "$WORKSPACE_DIRECTORY/package-TEMP"

# Create Application Package
cd "$PACKAGE_PATH"
tar -cvf "$WORKSPACE_DIRECTORY/$PACKAGE_NAME.spk" *

# Move Package Directory back to its orignail location
mv "$WORKSPACE_DIRECTORY/package-TEMP" "$PACKAGE_PATH/package"
