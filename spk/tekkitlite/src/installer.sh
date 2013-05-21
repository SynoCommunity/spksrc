#!/bin/sh

#Original script:
#--------MINECRAFT/CRAFTBUKKIT installer script
#--------package maintained at pcloadletter.co.uk
#Modified by Meeces2911 for TekkitLite

#
#Shout Out: This package was made based on Patters scripts over at PCLoadLetter, without that #this would not have been possible. MANY THANKS! Also to Merty for his CFE package which inspired #the console UI.
#


#Modify these
DOWNLOAD_PATH="http://mirror.technicpack.net/Technic/servers/tekkitlite"
DOWNLOAD_FILE="Tekkit_Lite_Server_0.6.1.zip"
UPGRADE_FILES="server.properties *.txt world"

DOWNLOAD_URL="${DOWNLOAD_PATH}/${DOWNLOAD_FILE}"
DAEMON_USER="`echo ${SYNOPKG_PKGNAME} | awk {'print tolower($_)'}`"
DAEMON_ID="${SYNOPKG_PKGNAME} daemon user"
DAEMON_PASS="`openssl rand 12 -base64 2>nul`"
MIGRATION_FOLDER="${DAEMON_USER}_data_mig"
ENGINE_SCRIPT="/var/packages/${SYNOPKG_PKGNAME}/scripts/launcher.sh"
INSTALL_FILES="${DOWNLOAD_URL}"
source /etc/profile
TEMP_FOLDER="`find / -maxdepth 2 -name '@tmp' | head -n 1`"
PRIMARY_VOLUME="/`echo $TEMP_FOLDER | cut -f2 -d'/'`"
WORLD_BACKUP="${PRIMARY_VOLUME}/public/${DAEMON_USER}world.`date +\"%d-%b\"`.bak"
PUBLIC_FOLDER="/volume1/public"

preinst ()
{
  if [ -z ${JAVA_HOME} ]; then
    echo "Java is not installed or not properly configured. JAVA_HOME is not defined. "
    echo "Download and install the Java Synology package from http://wp.me/pVshC-z5"
    exit 1
  fi
  
  if [ ! -f ${JAVA_HOME}/bin/java ]; then
    echo "Java is not installed or not properly configured. The Java binary could not be located. "
    echo "Download and install the Java Synology package from http://wp.me/pVshC-z5"
    exit 1
  fi
  
  #is the User Home service enabled?
  UH_SERVICE=maybe
  synouser --add userhometest Testing123 "User Home test user" 0 "" ""
  UHT_HOMEDIR=`cat /etc/passwd | sed -r '/User Home test user/!d;s/^.*:User Home test user:(.*):.*$/\1/'`
  if echo $UHT_HOMEDIR | grep '/var/services/homes/' > /dev/null; then
    if [ ! -d $UHT_HOMEDIR ]; then
      UH_SERVICE=false
    fi
  fi
  synouser --del userhometest
  #remove home directory (needed since DSM 4.1)
  [ -e /var/services/homes/userhometest ] && rm -r /var/services/homes/userhometest
  if [ ${UH_SERVICE} == "false" ]; then
    echo "The User Home service is not enabled. Please enable this feature in the User control panel in DSM."
    exit 1
  fi
  
  cd ${TEMP_FOLDER}
  for WGET_URL in ${INSTALL_FILES}
  do    
    if [ -d ${PUBLIC_FOLDER} ] && [ -f ${PUBLIC_FOLDER}/${DOWNLOAD_FILE} ]; then
	  cp ${PUBLIC_FOLDER}/${DOWNLOAD_FILE} ${TEMP_FOLDER}
    else
	  WGET_FILENAME="`echo ${WGET_URL} | sed -r "s%^.*/(.*)%\1%"`"
	  [ -f ${TEMP_FOLDER}/${WGET_FILENAME} ] && rm ${TEMP_FOLDER}/${WGET_FILENAME}
	  wget ${WGET_URL}
	  if [[ $? != 0 ]]; then
	    echo "There was a problem downloading ${WGET_FILENAME} from the official download link, "
	    echo "which was \"${WGET_URL}\" "
	    echo "Alternatively, you may download this file manually and place it in the 'public' shared folder. "
		echo "Public folder = ${PUBLIC_FOLDER}"
	    exit 1
	  fi
    fi
  done
  
  exit 0
}


postinst ()
{
  #create daemon user
  synouser --add ${DAEMON_USER} ${DAEMON_PASS} "${DAEMON_ID}" 0 "" ""
  
  #Move the downloaded file to the correct directory
  mv ${TEMP_FOLDER}/${DOWNLOAD_FILE} ${SYNOPKG_PKGDEST}/${DOWNLOAD_FILE}
  
  #unzip the files
  unzip -o -qq ${SYNOPKG_PKGDEST}/${DOWNLOAD_FILE} -d ${SYNOPKG_PKGDEST}
  
  #Remove our temp files
  rm ${SYNOPKG_PKGDEST}/${DOWNLOAD_FILE}
  
  #determine the daemon user homedir and save that variable in the user's profile
  #this is needed because new users seem to inherit a HOME value of /root which they have no permissions for
  DAEMON_HOME="`cat /etc/passwd | grep "${DAEMON_ID}" | cut -f6 -d':'`"
  su - ${DAEMON_USER} -s /bin/sh -c "echo export HOME=\'${DAEMON_HOME}\' >> .profile"
  
  #change owner of folder tree
  chown -R ${DAEMON_USER} ${SYNOPKG_PKGDEST}
  
  exit 0
}


preuninst ()
{
  #make sure server is stopped
  su - ${DAEMON_USER} -s /bin/sh -c "${ENGINE_SCRIPT} stop ${SYNOPKG_PKGNAME} ${SYNOPKG_PKGDEST}"
  sleep 10
  
  #if a world exists, back it up to the public folder, just in case...
  if [ -d ${SYNOPKG_PKGDEST}/world ]; then
    if [ ! -d ${WORLD_BACKUP} ]; then
      mkdir -p ${WORLD_BACKUP}
    fi
    for ITEM in ${UPGRADE_FILES}; do
      mv ${SYNOPKG_PKGDEST}/${ITEM} ${WORLD_BACKUP}
    done
  fi
  
  exit 0
}


postuninst ()
{
  #remove daemon user
  synouser --del ${DAEMON_USER}
  
  #remove daemon user's home directory (needed since DSM 4.1)
  [ -e /var/services/homes/${DAEMON_USER} ] && rm -r /var/services/homes/${DAEMON_USER}
  
  exit 0
}


preupgrade ()
{
  #make sure the server is stopped
  su - ${DAEMON_USER} -s /bin/sh -c "${ENGINE_SCRIPT} stop ${SYNOPKG_PKGNAME} ${SYNOPKG_PKGDEST}"
  sleep 10
  
  #if a world exists, back it up
  if [ -d ${SYNOPKG_PKGDEST}/world ]; then
    mkdir ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}
    for ITEM in ${UPGRADE_FILES}; do
      if [ -e ${SYNOPKG_PKGDEST}/${ITEM} ]; then
        mv ${SYNOPKG_PKGDEST}/${ITEM} ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}
      fi
    done
  fi
  
  exit 0
}


postupgrade ()
{
  #use the migrated data files from the previous version
  if [ -d ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}/world ]; then
    for ITEM in ${UPGRADE_FILES}; do
      if [ -e ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}/${ITEM} ]; then
        mv ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}/${ITEM} ${SYNOPKG_PKGDEST}
      fi
    done
    rmdir ${SYNOPKG_PKGDEST}/../${MIGRATION_FOLDER}
    
    #daemon user has been deleted and recreated so we need to reset ownership (new UID)
    chown -R ${DAEMON_USER} ${SYNOPKG_PKGDEST}
  fi
  	
  exit 0
}
