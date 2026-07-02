#!/bin/bash

# install and activate nushell plugins for the current user

SOURCE=/var/packages/nushell/target/bin
if [ ! -d "${SOURCE}" ]; then
  "ERROR: ${SOURCE}"
  exit 1
fi

# ensure config folder exists
CFG=~/.config/nushell
if [ ! -d ${CFG} ]; then
    echo ""
    echo "create nushell config folder ${CFG}"
    mkdir -p ${CFG}
    echo ""
fi

NU=${SOURCE}/nu
PLUGINS="$(ls ${SOURCE}/nu_plugin_*)"

for plugin in ${PLUGINS}; do
    name="${plugin##*_}"
    echo "install nushell plugin ${name}"
    ${NU} -c "plugin add ${plugin}"
    ${NU} -c "plugin use ${name}"
done

echo ""
echo "Installed plugins:"
${NU} -c "plugin list | select  name version status filename"
