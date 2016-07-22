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
  echo "Rename collection names of a mongo db"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --db \"dbname\" --find \"searchstring\" --replace \"replacestring\" [ --dochanges ] ]"

  echo "Where searchstring can be a regexp, and replacepattern is a string to replace the pattern"
  echo "Examples:"
  echo
  echo "- Find collections that start with sth_ and next char not /, and replace by sth_/"
  echo "  ${PROGNAME##*/} --db mydbname --find '^sth_(([^/])|$)' --replace 'sth_\/\1' --dochanges"
  echo "- Find collections that start with sth_/ and next any char and replace by sth_"
  echo "  ${PROGNAME##*/} --db mydbname --find '^sth_\/' --replace 'sth_' --dochanges"
  echo
  echo "- Find collections that start with sth_ and next char not /, and TRY replace by sth_/ (don't apply any changes)"
  echo "  ${PROGNAME##*/} --db mydbname --find '^sth_(([^/])|$)' --replace 'sth_\/\1'"
  echo "- Find collections that start with sth_/ and next any char and TRY replace by sth_ (don't apply any changes)"
  echo "  ${PROGNAME##*/} --db mydbname --find '^sth_\/' --replace 'sth_'"
  echo
  echo "With general settings:"
  cat ${CONF_BASEDIR}/settings.conf
  exit 10
}

if [ "$#" == "0" ]; then help; fi

. ${CONF_BASEDIR}/settings.conf

DOCHANGES="False"
args=()
while [ $# -gt 0 ] ; do
  case "$1" in
    --help)
      help
      ;;
    --db)
      DBNAME="$2"
      [[ -z "${DBNAME}" ]] && help "ERROR: Empty parameter <$1>"
      shift
      ;;
    --find)
      [[ -z "${2+x}" ]] && help "ERROR: Empty parameter <$1>"
      FIND="$2"
      shift
      ;;
    --replace)
      [[ -z "${2+x}" ]] && help "ERROR: Empty parameter <$1>"
      REPLACE="$2"
      shift
      ;;
    --dochanges)
      DOCHANGES="True"
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

# Required parameters
[[ -z "${FIND+x}" ]] && echo "ERROR: Missing parameter --find" >&2 && exit 2
[[ -z "${REPLACE+x}" ]] && echo "ERROR: Missing parameter --replace" >&2 && exit 3

if [ ${#args[@]} -ne 0 ]; then echo "ERROR: Many arguments <${args[@]}>"; help; fi

LISTDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 4

EXISTDB="$(echo "${LISTDBS}" | grep -- "^${DBNAME}$")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Cannot find database <${DBNAME}>" >&2 && exit 5

LISTCOLLSFIND="$(${SCRIPT_BASEDIR}/listcolls.sh --db ${DBNAME} --col "${FIND}")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain collections of <${DBNAME}>" >&2 && exit 6

echo "INFO: Rename collections of db <${DBNAME}>"
echo "INFO: Find by <${FIND}>"
echo "INFO: Replace by <${REPLACE}>"
[[ "${DOCHANGES}" != "True" ]] && echo "INFO: Only test find and renaming..."
[[ "${DOCHANGES}" == "True" ]] && echo "WARN: Renaming in database..."
echo "INFO: Find and replacing..."

declare -a arrcollsfind
declare -a arrcollsreplace
for collfind in ${LISTCOLLSFIND}
do
  collreplace="$(echo "${collfind}" | sed -r 's/'${FIND}'/'${REPLACE}'/g')"
  arrcollsfind+=("${collfind}")
  arrcollsreplace+=("${collreplace}")
  echo "\"${arrcollsfind[@]: -1}\" => \"${arrcollsreplace[@]: -1}\""
done
echo "INFO: Total number of collections to rename <${#arrcollsfind[@]}>"

if [ ${#arrcollsfind[@]} == 0 ]
then
  echo "INFO: Not found any collections. Don't nothing..."
  exit
fi

if [ "${DOCHANGES}" == "True" ]
then
  echo "WARN: Apply changes in database..."
  mkdir -p ${HOME_BASEDIR}/tmp
  rm -f ${HOME_BASEDIR}/tmp/colls*.js
  FILECOLLSFIND=$(mktemp ${HOME_BASEDIR}/tmp/collsfindXXXXXX.js)
  FILECOLLSREPLACE=$(mktemp ${HOME_BASEDIR}/tmp/collsreplaceXXXXXX.js)
  echo -n "var dbname = \"${DBNAME}\";"$'\n'"var collsfind = \"${arrcollsfind[@]}\";"$'\n' > ${FILECOLLSFIND}
  echo -n "var collsreplace = \"${arrcollsreplace[@]}\";"$'\n' > ${FILECOLLSREPLACE}
  [[ ${RESULT} != 0 ]] && echo "ERROR: Cannot manage temp files" >&2 && exit 7

  DOCHANGES="$(mongo --host ${MONGODBHOST} ${FILECOLLSFIND} ${FILECOLLSREPLACE} ${SCRIPT_BASEDIR}/replacecolls.js)"
  echo "${DOCHANGES}"
else
  echo "INFO: It has not done anything in the database"
fi

exit ${RESULT}

