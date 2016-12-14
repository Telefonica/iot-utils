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
  echo "STH restore one database"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --dirbackup \"path_abs_dir_backup\" --dbbackup \"dbbackup\" --dborigin \"dborigin\"]"
  echo "*************************************************"
  echo "WARNING: Restore databases is very dangerous..."
  echo "The original database will be dropped..."
  echo "*************************************************"
  echo "Example:"
  echo "${PROGNAME##*/} --dirbackup /home/ec2-user/managemongodbs/backups/backupsth --dbbackup Bsth_db --dborigin sth_db"
  echo
  echo "With general settings:"
  cat ${CONF_BASEDIR}/settings.conf
  echo
  echo "With specific settings:"
  cat ${CONF_BASEDIR}/STHsettings.conf
  exit 10
}

if [ "$#" == "0" ]; then help; fi

. ${CONF_BASEDIR}/settings.conf
. ${CONF_BASEDIR}/STHsettings.conf

args=()
while [ $# -gt 0 ] ; do
  case "$1" in
    --help)
      help
      ;;
    --dirbackup)
      DIRBACKUP="$2"
      [[ -z "${DIRBACKUP}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --dbbackup)
      DBBACKUP="$2"
      [[ -z "${DBBACKUP}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --dborigin)
      DBORIGIN="$2"
      [[ -z "${DBORIGIN}" ]] && help "ERROR: Empty parameter <$1>"
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
[[ -z "${DIRBACKUP+x}" ]] && echo "ERROR: Missing parameter --dirbackup" >&2 && exit 2
[[ -z "${DBBACKUP+x}" ]] && echo "ERROR: Missing parameter --dbbackup" >&2 && exit 2
[[ -z "${DBORIGIN+x}" ]] && echo "ERROR: Missing parameter --dborigin" >&2 && exit 2

echo "INFO: Restoring backup database <${DBBACKUP}> to origin <${DBORIGIN}> We will drop <${DBORIGIN}>"
echo "INFO: Filtering database STH for security..."
[[ $(echo "${DBBACKUP}" | grep -P -- "${STHFINDBACKUP_DBS}") ]] || (echo "ERROR: database STH backup <${DBBACKUP}> not inside <${STHFINDBACKUP_DBS}>" >&2; exit 3)

[[ $(echo "${DBORIGIN}" | grep -P -- "${STHFIND_DBS}") ]] || (echo "ERROR: database STH origin <${DBORIGIN}> not inside <${STHFIND_DBS}>" >&2; exit 3)

echo "WARN: Have you made a previous backup of <${DBORIGIN}>???"
read -p "Continue (y/n)? " choice
case "$choice" in 
  y|Y) echo "INFO: Go on!!!";;
  *) echo "INFO: Stop!!!" && exit 3;;
esac

echo "INFO: Drop if exist origin STH database <${DBORIGIN}>"
DROPORIGINSTHDB="$(${SCRIPT_BASEDIR}/dropdb.sh --db "${DBORIGIN}" 2>/dev/null || true)"

echo "INFO: Restore backup database <${DBBACKUP}> to origin <${DBORIGIN}>"
RESTOREBACKUPSTHDB="$(${SCRIPT_BASEDIR}/restoreonedb.sh --dirbackup "${DIRBACKUP}" --dbsource ${DBBACKUP} --dbtarget ${DBORIGIN})"
[[ ${RESULT} != 0 ]] && echo "ERROR: FATAL error when restoring backup database <${DBBACKUP}> to origin <${DBORIGIN}>" >&2 && exit 4
echo "INFO: Database restore <${DBBACKUP}> to <${DBORIGIN}> successful"

echo "INFO: Replace adding slash in collections of origin STH database <${DBORIGIN}>"
echo "INFO: Finding <${STHFINDNOSLASH_COLLS}> and replace by <${STHREPLACENOSLASH_COLLS}>"
REPLACEADDSLASHCOLLSDBORIGIN="$(${SCRIPT_BASEDIR}/rencolls.sh --db "${DBORIGIN}" --find "${STHFINDNOSLASH_COLLS}" --replace "${STHREPLACENOSLASH_COLLS}" --dochanges)"
[[ ${RESULT} != 0 ]] && echo "ERROR: FATAL error when replace add slash in collections of origin STH database" >&2 && exit 5
echo "INFO: Replace successfull"

exit ${RESULT}

