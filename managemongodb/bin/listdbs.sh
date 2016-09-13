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
  echo "List mongo db names"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --alldbs | --db \"searchstring\"]"
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
    --alldbs)
      FILTER=""
      ;;
    --db)
      [[ -z "${2+x}" ]] && help "ERROR: Empty parameter <$1>"
      FILTER="$2"
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

LISTDBS="$(mongo --host ${MONGODBHOST} < ${SCRIPT_BASEDIR}/extractdbnames.js)"
LISTDBS="$(echo "${LISTDBS}" | grep -Pzo -- ${EXTRACTJSON} | egrep -v -- ${REMOVEKEYS} || true)"
LISTDBS="$(echo "${LISTDBS}" | grep -P -- "${FILTER}" || true)"

# Bash bug in variable assign length 0
if [ ${RESULT} == 0 ]
then
  [[ "${LISTDBS}" != "" ]] && echo "${LISTDBS}"
else
  echo "${LISTDBS}" >&2
fi

exit ${RESULT}

