#!/bin/bash

RESULT=0
trap catch_errors ERR
function catch_errors() {
  RESULT=$?
}

# We have a home directory, bin and conf subdirs
SCRIPT_BASEDIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
HOME_BASEDIR=$(dirname $(readlink -f "${SCRIPT_BASEDIR}"))
CONF_BASEDIR="${HOME_BASEDIR}/conf"
PROGNAME=$(basename $0)
cd ${HOME_BASEDIR}

function help ()
{
  echo "*************************************************"
  echo "Backup mongo dbs with BSON format"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --alldbs | --dbs \"searchstring\" [--backupprefix \"prefix\" default: default] [--rotate <True|othervalue> default: True]]"
  echo
  echo "With general settings:"
  cat ${CONF_BASEDIR}/settings.conf
  exit 10
}

if [ "$#" == "0" ]; then help; fi

. ${CONF_BASEDIR}/settings.conf
# If we need to use other backup dira and prefix, define here to overwrite
# BACKUP_BASEDIR...
# BACKUP_PREFIX=...

mkdir -p ${BACKUP_BASEDIR}/${BACKUP_PREFIX}

ROTATE="True"

args=()
while [ $# -gt 0 ] ; do
  case "$1" in
    --help)
      help
      ;;
    --alldbs)
      ISFULLBACKUP="True"
      ;;
    --dbs)
      DBSFILTER="$2"
      [[ -z "${DBSFILTER}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --backupprefix)
      BACKUP_PREFIX="$2"
      [[ -z "${BACKUP_PREFIX}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --rotate)
      ROTATE="$2"
      [[ -z "${ROTATE}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    -*)
      help "ERROR: Unknown option <$1>"
      ;;
    *)
      args=("${args[@]}" "$1")
      ;;
  esac
  shift
done

if [ ${#args[@]} -ne 0 ]; then echo "ERROR: Many arguments <${args[@]}>"; help; fi

# Exclusion parameters
[[ ! -z "${ISFULLBACKUP+x}" && ! -z "${DBSFILTER+x}" ]] && echo "ERROR: Incompatible options..." >&2 && exit 2

[ ! -z "${ISFULLBACKUP+x}" ] && echo "INFO: Database FULL backup"
[ ! -z "${DBSFILTER+x}" ] && echo "INFO: Database backup of dbs <${DBSFILTER}>"

echo "INFO: Backup base directory <${BACKUP_BASEDIR}>"
echo "INFO: Backup prefix <${BACKUP_PREFIX}>"

if [ "${ROTATE}" == "True" ]
then
  if [[ -d "${BACKUP_BASEDIR}/${BACKUP_PREFIX}" && "$(find ${BACKUP_BASEDIR}/${BACKUP_PREFIX}/* -type d 2>/dev/null)" ]]
  then
    RENOLDBACKUPDIR="${BACKUP_BASEDIR}/${BACKUP_PREFIX}_$(date -r ${BACKUP_BASEDIR}/${BACKUP_PREFIX} '+%Y%m%d_%H%M%S')"
    echo "INFO: Exists a backup in <${BACKUP_BASEDIR}/${BACKUP_PREFIX}>... Moving old backup to <${RENOLDBACKUPDIR}>"
    mv ${BACKUP_BASEDIR}/${BACKUP_PREFIX} ${RENOLDBACKUPDIR}
    mkdir -p ${BACKUP_BASEDIR}/${BACKUP_PREFIX}
  fi
  [[ ${RESULT} != 0 ]] && echo "ERROR: Fail managing backup files..." >&2 && exit 3
fi

if [ "${ISFULLBACKUP}" == "True" ]
then
  echo "INFO: Backup FULL"
  BACKUPDBFULL="$(mongodump -v --host=${MONGODBHOST} --oplog --out=${BACKUP_BASEDIR}/${BACKUP_PREFIX})"
  if [ ${RESULT} != 0 ]
  then
    echo "ERROR: Cannot database FULL backup error code <${RESULT}>"
  else
    echo "INFO: Database FULL backup successful"
  fi
else
  LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
  [[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 4

  LISTDBS="$(echo "${LISTDBS}" | grep -P -- "${DBSFILTER}" || true)"
  [[ "${LISTDBS}" == "" ]] && echo "ERROR: Cannot find any database names with searchstring <${DBSFILTER}>..." >&2 && exit 5

  for dbtobackup in ${LISTDBS}
  do
    echo "INFO: Backup database <${dbtobackup}>"
    LOGBACKUPDB="$(mongodump -v --host=${MONGODBHOST} --db ${dbtobackup} --out=${BACKUP_BASEDIR}/${BACKUP_PREFIX})"
    if [ $? != 0 ]
    then
      echo "ERROR: Cannot backup database <${dbtobackup}> error code <${RESULT}>"
    else
      echo "INFO: Database backup <${dbtobackup}> successful"
    fi
  done
fi

exit ${RESULT}

