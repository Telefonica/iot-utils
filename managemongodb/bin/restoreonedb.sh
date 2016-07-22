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
  echo "Restore a mongo db with BSON format"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --dirbackup \"path_abs_dir_backup\" --dbsource \"dbsource\" [--dbtarget \"dbtarget\"]]"
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
    --dbsource)
      DBSOURCE="$2"
      [[ -z "${DBSOURCE}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --dbtarget)
      DBTARGET="$2"
      [[ -z "${DBTARGET}" ]] && help "ERROR: Empty parameter <$1>"
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
[[ -z "${DBSOURCE+x}" ]] && echo "ERROR: Missing parameter --dbsource" >&2 && exit 2

[[ ! -z "${DBTARGET+x}" ]] && echo "INFO: Restoring database <${DBSOURCE}> to <${DBTARGET}>"
[[ -z "${DBTARGET+x}" ]] && echo "INFO: Restoring database <${DBSOURCE}> to <${DBSOURCE}>" && DBTARGET="${DBSOURCE}"

if [[ -d "${DIRBACKUP}" && "$(find ${DIRBACKUP}/* -type d 2>/dev/null)" ]]
then
  LISTDBSINDIRBACKUP="$(find ${DIRBACKUP}/* -type d -printf '%f\n')"
  echo "INFO: Databases in backup dir <${DIRBACKUP}>"
  echo "${LISTDBSINDIRBACKUP}"
  FINDDBSOURCEDIRBACKUP="$(echo "${LISTDBSINDIRBACKUP}" | grep -- "^${DBSOURCE}$")"
  [[ ${RESULT} != 0 ]] && echo "ERROR: Database source <${DBSOURCE}> not exists in backup dir <${DIRBACKUP}>" >&2 && exit 3
else
  echo "ERROR: Cannot find backup directory" >&2 && exit 4
fi

LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 5

# Inverse grep because grep status code 1 when not finded
EXISTDBTARGET="$(echo "${LISTDBS}" | (! grep -- "^${DBTARGET}$"))"
[[ ${RESULT} != 0 ]] && echo "ERROR: Target database already exists <${DBTARGET}>" >&2 && exit 6

echo "INFO: Restoring database <${DBSOURCE}> to <${DBTARGET}> from <${DIRBACKUP}>"
RESTOREDB="$(mongorestore -v --host=${MONGODBHOST} --db ${DBTARGET} ${DIRBACKUP}/${DBSOURCE})"
if [ ${RESULT} != 0 ]
then
  echo "ERROR: Cannot restore database <${DBSOURCE}> to <${DBTARGET}> from <${DIRBACKUP}> error code <${RESULT}>"
else
  echo "INFO: Database restore <${DBSOURCE}> to <${DBTARGET}> successful"
fi

exit ${RESULT}

