#!/bin/sh

preinst ()
{
    # mkdir -p /volume1/docker/arr-stack/storage/torrents/movies /volume1/docker/arr-stack/storage/torrents/music /volume1/docker/arr-stack/storage/torrents/tv
    # mkdir -p /volume1/docker/arr-stack/storage/usenet/movies /volume1/docker/arr-stack/storage/usenet/music /volume1/docker/arr-stack/storage/usenet/tv
    # mkdir -p /volume1/docker/arr-stack/storage/media/movies /volume1/docker/arr-stack/storage/media/music /volume1/docker/arr-stack/storage/media/tv
    # RES=$(cat /var/packages/arr-stack/conf/resource)
    # NEW_UID=$(id -u sc-arr-stack)
    # NEW_GID=$(id -g sc-arr-stack)
    # # source /etc/synoinfo.conf
    # # echo $timezone
    # TZ=$(ls -l /etc/localtime | sed -e 's#.*zoneinfo\/##g')
    # # TZ="UTC" # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    # RES=$(echo "$RES" | jq --arg uid=$NEW_UID --arg gid=$NEW_GID --arg tz=$TZ ' .docker.services[].environment[0]={env_var:"PUID",env_value:$uid} | .docker.services[].environment[1]={env_var:"GUID",env_value:$gid} | .docker.services[].environment[2]={env_var:"TZ",env_value:$tz}')
    # # .docker.services[].environment[0].env_var=100 | .docker.services[].environment[1].env_var=100
    # #  .docker.services[].environment[0]={env_var:"PUID",env_value:10} | .docker.services[].environment[1]={env_var:"GUID",env_value:10} | .docker.services[].environment[2]={env_var:"TZ",env_value:"UTC"}
    # echo "$RES" > /var/packages/arr-stack/conf/resource
    exit 0
}

postinst ()
{
    # RES=$(cat /var/packages/arr-stack/conf/resource)
    # NEW_UID=$(id -u sc-arr-stack)
    # NEW_GID=$(id -g sc-arr-stack)
    # # source /etc/synoinfo.conf
    # # echo $timezone
    # TZ=$(ls -l /etc/localtime | sed -e 's#.*zoneinfo\/##g')
    # # TZ="UTC" # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    # RES=$(echo "$RES" | jq --arg uid=$NEW_UID --arg gid=$NEW_GID --arg tz=$TZ ' .docker.services[].environment[0]={env_var:"PUID",env_value:$uid} | .docker.services[].environment[1]={env_var:"GUID",env_value:$gid} | .docker.services[].environment[2]={env_var:"TZ",env_value:$tz}')
    # # .docker.services[].environment[0].env_var=100 | .docker.services[].environment[1].env_var=100
    # #  .docker.services[].environment[0]={env_var:"PUID",env_value:10} | .docker.services[].environment[1]={env_var:"GUID",env_value:10} | .docker.services[].environment[2]={env_var:"TZ",env_value:"UTC"}
    # echo "$RES" > /var/packages/arr-stack/conf/resource
    exit 0
}

preuninst ()
{
    exit 0
}

postuninst ()
{
    exit 0
}

preupgrade ()
{
    exit 0
}

postupgrade ()
{
    exit 0
}
