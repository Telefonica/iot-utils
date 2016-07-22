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
  echo "Copy a mongo db"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --dbfrom \"dbsource\" --dbto \"dbtarget\"]"
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
    --dbfrom)
      DBFROM="$2"
      [[ -z "${DBFROM}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --dbto)
      DBTO="$2"
      [[ -z "${DBTO}" ]] && help "ERROR: Empty parameter <$1>"
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
[[ -z "${DBFROM+x}" ]] && echo "ERROR: Missing parameter --dbfrom" >&2 && exit 2
[[ -z "${DBTO+x}" ]] && echo "ERROR: Missing parameter --dbto" >&2 && exit 3

[[ "${DBFROM}" == "${DBTO}" ]] && echo "ERROR: Database source and target are same" >&2 && exit 4

LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 5

EXISTDBFROM="$(echo "${LISTDBS}" | grep -- "^${DBFROM}$")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Cannot find source database <${DBFROM}>" >&2 && exit 6

# Inverse grep because grep status code 1 when not finded
EXISTDBTO="$(echo "${LISTDBS}" | (! grep -- "^${DBTO}$"))"
[[ ${RESULT} != 0 ]] && echo "ERROR: Target database already exists <${DBTO}>" >&2 && exit 7

COPYDB="$(mongo admin --host ${MONGODBHOST} --eval "db.copyDatabase('${DBFROM}', '${DBTO}');")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Cannot copy database source <${DBFROM}> to target <${DBTO}> error code <${RESULT}>" >&2 && exit 8
echo "INFO: Database source <${DBFROM}> copied to target <${DBTO}>"

exit ${RESULT}

