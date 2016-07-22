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
  echo "Restore mongo dbs with BSON format"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --dirbackup \"path_abs_dir_backup\" <--dbs \"searchstring\" | --alldbs]>"
  echo
  echo "With general settings:"
  cat ${CONF_BASEDIR}/settings.conf
  exit 10
}

if [ "$#" == "0" ]; then help; fi

. ${CONF_BASEDIR}/settings.conf

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
    --dbs)
      DBSFILTER="$2"
      [[ -z "${DBSFILTER}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --alldbs)
      ISFULLRESTORE="True"
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
[[ -z "${DBSFILTER+x}" && -z "${ISFULLRESTORE+x}" ]] && echo "ERROR: Missing restore type" >&2 && exit 2
# Exclusion parameters
[[ ! -z "${DBSFILTER+x}" && ! -z "${ISFULLRESTORE+x}" ]] && echo "ERROR: Incompatible options" >&2 && exit 2

if [[ -d "${DIRBACKUP}" && "$(find ${DIRBACKUP}/* -type d 2>/dev/null)" ]]
then
  LISTDBSINDIRBACKUP="$(find ${DIRBACKUP}/* -type d -printf '%f\n')"
  echo "INFO: Databases in backup dir <${DIRBACKUP}>"
  echo "${LISTDBSINDIRBACKUP}"
else
  echo "ERROR: Cannot find backup directory or not contains any databases" >&2 && exit 3
fi

if [ "${ISFULLRESTORE}" == "True" ]
then
  echo "INFO: Restoring FULL database"
  [[ ! "$(find ${DIRBACKUP}/oplog.* -type f 2>/dev/null)" ]] && echo "ERROR: Cannot find a FULL backup generated with --oplog inside <${DIRBACKUP}>" >&2 && exit 4
  RESTOREDBFULL="$(mongorestore -v --host=${MONGODBHOST} --oplogReplay ${DIRBACKUP})"
  if [ ${RESULT} != 0 ]
  then
    echo "ERROR: Cannot restore FULL database from <${DIRBACKUP}> error code <${RESULT}>"
  else
    echo "INFO: Database restore FULL from <${DIRBACKUP}> successful"
  fi
else
  LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
  [[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 4

  # Inverse grep because grep status code 1 when not finded
  EXISTDBS="$(echo "${LISTDBS}" | (! grep -- "^${DBSFILTER}$"))"
  [[ ${RESULT} != 0 ]] && echo "ERROR: Target database already exists <${DBTARGET}>" >&2 && exit 6

  FILTERED_LISTDBSINDIRBACKUP="$(echo "${LISTDBSINDIRBACKUP}" | grep -P -- "${DBSFILTER}" || true)"
  [[ "${FILTERED_LISTDBSINDIRBACKUP}" == "" ]] && echo "ERROR: Cannot find any database names inside <${DIRBACKUP}> with searchstring <${DBSFILTER}>..." >&2 && exit 5

  for dbtorestore in ${FILTERED_LISTDBSINDIRBACKUP}
  do
    echo "INFO: Restoring database <${dbtorestore}>"
    # Inverse grep because grep status code 1 when not finded
    EXISTDB="$(echo "${LISTDBS}" | (! grep -- "^${dbtorestore}$"))"
    if [ $? != 0 ]
    then
      echo "ERROR: Database to restore <${dbtorestore}> already exists"
    else
      LOGRESTOREDB="$(mongorestore -v --host=${MONGODBHOST} --db ${dbtorestore} ${DIRBACKUP}/${dbtorestore})"
      if [ $? != 0 ]
      then
        echo "ERROR: Cannot restore database <${dbtorestore}> error code <${RESULT}>"
      else
        echo "INFO: Database restore <${dbtorestore}> successful"
      fi
    fi
  done
fi

exit  ${RESULT}

