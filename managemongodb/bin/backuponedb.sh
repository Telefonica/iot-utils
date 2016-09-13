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
  echo "Backup a mongo db with BSON format"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --db \"dbtobackup\" [--backupprefix \"prefix\" default: default] [--rotate <True|othervalue> default: True]]"
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
    --db)
      DBBACKUP="$2"
      [[ -z "${DBBACKUP}" ]] && help "ERROR: Empty parameter <$1>"
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

# Required parameters
[[ -z "${DBBACKUP+x}" ]] && echo "ERROR: Missing parameter --db" >&2 && exit 2

echo "INFO: Backup database <${DBBACKUP}>"
echo "INFO: Backup base directory <${BACKUP_BASEDIR}>"
echo "INFO: Backup prefix <${BACKUP_PREFIX}>"

if [ "${ROTATE}" == "True" ]
then
  if [[ -d "${BACKUP_BASEDIR}/${BACKUP_PREFIX}/${DBBACKUP}" && "$(find ${BACKUP_BASEDIR}/${BACKUP_PREFIX}/${DBBACKUP}/* -type f 2>/dev/null)" ]]
  then
    RENOLDBACKUPDIR="${BACKUP_BASEDIR}/${BACKUP_PREFIX}_$(date -r ${BACKUP_BASEDIR} '+%Y%m%d_%H%M%S')"
    echo "INFO: Exists a backup in <${BACKUP_BASEDIR}/${BACKUP_PREFIX}> with same database <${DBBACKUP}>... Moving old backup to <${RENOLDBACKUPDIR}>"
    mv ${BACKUP_BASEDIR}/${BACKUP_PREFIX} ${RENOLDBACKUPDIR}
    mkdir -p ${BACKUP_BASEDIR}/${BACKUP_PREFIX}
  fi
  [[ ${RESULT} != 0 ]] && echo "ERROR: Fail managing backup files..." >&2 && exit 3
fi

LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 4

EXISTDBBACKUP="$(echo "${LISTDBS}" | grep -- "^${DBBACKUP}$")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Cannot find database <${DBBACKUP}>" >&2 && exit 5

BACKUPDB="$(mongodump -v --host=${MONGODBHOST} --db ${DBBACKUP} --out=${BACKUP_BASEDIR}/${BACKUP_PREFIX})"
if [ ${RESULT} != 0 ]
then
  echo "ERROR: Cannot backup database <${DBBACKUP}> error code <${RESULT}>"
else
  echo "INFO: Database backup <${DBBACKUP}> successful"
fi

exit ${RESULT}

