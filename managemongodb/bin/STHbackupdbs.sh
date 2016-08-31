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
  echo "STH backup databases"
  echo "*************************************************"
  echo
  if [ "$*" != "" ]; then echo "$*"; echo; fi
  echo "Usage: ${PROGNAME##*/} [--help | --done]"
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
    --done)
      DONE="True"
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
[[ -z "${DONE+x}" ]] && echo "ERROR: Missing parameter --done" >&2 && exit 2

echo "INFO: Backup of STH databases"

LISTALLDBS="$(${SCRIPT_BASEDIR}/listdbs.sh --alldbs)"
[[ ${RESULT} != 0 ]] && echo "ERROR: Database error when obtain databases" >&2 && exit 3

LISTSTHDBS="$(echo "${LISTALLDBS}" | grep -P -- "${STHFIND_DBS}")"
[[ ${RESULT} != 0 ]] && echo "ERROR: Cannot find any STH databases searching by <${STHFIND_DBS}>" >&2 && exit 4

# Only rotate when first item backup correctly
ROTATE="True"

LISTSTHDBS=sth_sc_vlci

for sthdb in ${LISTSTHDBS}
do
  echo "INFO: Backup of STH database <${sthdb}>"
  baksthdb="$(echo "${sthdb}" | sed -r 's/'${STHFIND_DBS}'/'${STHREPLACEBACKUP_DBS}'/g')"

  echo "INFO: Drop if exist backup STH database <${baksthdb}>"
  dropbackupsthdbpre="$(${SCRIPT_BASEDIR}/dropdb.sh --db "${baksthdb}" 2>/dev/null || true)"
  [[ $? != 0 ]] && echo "ERROR: Drop of backup STH database failed. Cannot backup <${sthdb}>" >&2 && RESULT=0 && continue

  echo "INFO: Copy from <${sthdb}> to <${baksthdb}>"
  copysthdbtobackup="$(${SCRIPT_BASEDIR}/copydb.sh --dbfrom "${sthdb}" --dbto "${baksthdb}")"
  [[ $? != 0 ]] && echo "ERROR: Copy of STH database to backup failed. Cannot backup <${sthdb}>" >&2 && RESULT=0 && continue

  echo "INFO: Replace slash in collections of backup STH database <${baksthdb}>"
  echo "INFO: Finding <${STHFINDSLASH_COLLS}> and replace by <${STHREPLACESLASH_COLLS}>"
  replaceslashcollsdbbackup="$(${SCRIPT_BASEDIR}/rencolls.sh --db "${baksthdb}" --find "${STHFINDSLASH_COLLS}" --replace "${STHREPLACESLASH_COLLS}" --dochanges)"
echo "${replaceslashcollsdbbackup}"
  [[ $? != 0 ]] && echo "ERROR: Replace slash in collections of backup STH database failed. Cannot backup <${sthdb}>" >&2 && RESULT=0 && continue

exit

  echo "INFO: Backup of backup STH database <${baksthdb}>"
  backupsthdb="$(${SCRIPT_BASEDIR}/backuponedb.sh --db ${baksthdb} --backupprefix ${STHBACKUPPREFIX} --rotate False)"
  [[ $? != 0 ]] && echo "ERROR: Cannot backup of backup STH database <${baksthdb}>" >&2 && RESULT=0 && continue

  echo "INFO: Drop backup STH database <${baksthdb}>"
  dropbackupsthdbpost="$(${SCRIPT_BASEDIR}/dropdb.sh --db "${baksthdb}")"
  [[ $? != 0 ]] && echo "ERROR: Drop of backup STH database failed <${sthdb}>" >&2 && RESULT=0 && continue
  [[ "${ROTATE}" == "True" ]] && ROTATE="False"
done

echo "List STH dbs"
${SCRIPT_BASEDIR}/listdbs.sh --db "${STHFIND_DBS}"
echo "List backup STH dbs"
${SCRIPT_BASEDIR}/listdbs.sh --db "${STHFINDBACKUP_DBS}"

exit ${RESULT}

