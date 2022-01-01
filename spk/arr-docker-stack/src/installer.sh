#!/bin/sh

preinst ()
{
    echo "[preinst] Installing..." 1>&2
    echo "Please open docker to see logs." 1>&2
    exit 0
}

postinst ()
{
    echo "[postinst] Installing..." 1>&2
    echo "Please open docker to see logs." 1>&2
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
    echo "[preupgrade] Upgrading..." 1>&2
    echo "Please open docker to see logs." 1>&2
    exit 0
}

postupgrade ()
{
    echo "[postupgrade] Upgrading..." 1>&2
    echo "Please open docker to see logs." 1>&2
    exit 0
}
