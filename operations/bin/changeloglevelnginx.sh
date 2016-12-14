#!/bin/bash

function help ()
{
  echo "****************************************"
  echo "NGINX CHANGE LOG LEVEL"
  echo "****************************************"
  echo
  echo "Usage: ${0##*/} <loglevel>"
  echo "Where loglevel can be:"
  echo "\
    emerg: Emergency situations where the system is in an unusable state.
    alert: Severe situation where action is needed promptly.
    crit: Important problems that need to be addressed.
    error: An Error has occurred. Something was unsuccessful.
    warn: Something out of the ordinary happened, but not a cause for concern.
    notice: Something normal, but worth noting has happened.
    info: An informational message that might be nice to know.
    debug: Debugging information that can be useful to pinpoint where a problem is occurring.
"
  echo
  echo "For debug level visit http://nginx.org/en/docs/debugging_log.html"
}

if [ "$#" != "1" ]
then
  help
  exit 0
fi

echo "****************************************"
echo "NGINX CHANGE LOG LEVEL"
echo "****************************************"

NGINXBASECONFIGSERVICES="/etc/nginx/conf.d"
LISTLOGLEVELS="emerg alert crit error warn notice info debug"

LOGLEVEL="$1"

match=0
for loglevel in ${LISTLOGLEVELS}
do
  if [[ ${loglevel} == "${LOGLEVEL}" ]]
  then
    match=1
    break
  fi
done

if [[ ${match} == 0 ]]
then
  echo "ERROR: loglevel <${LOGLEVEL}> is not a valid loglevel for nginx..."
  exit 1
fi

for configfile in /etc/nginx/conf.d/*.conf
do
  echo "INFO: Change loglevel to <${LOGLEVEL}> in file <${configfile}>"
  perl -p -i -e 's/(^\s+error_log\s+.*\.log)(\s+.*|);$/\1 '${LOGLEVEL}';/g' ${configfile}
done

nginx -s reload 2>/dev/null

