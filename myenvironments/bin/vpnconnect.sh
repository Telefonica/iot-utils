#!/bin/bash

# VPN access to environments

function openconnecthelp ()
{
  echo "******************************************************"
  echo "VPN access to environments"
  echo "******************************************************"
  echo
  echo "Usage: ${0##*/} <pre|pro> <start|stop>"
}

if [ "$#" != "2" ]
then
  openconnecthelp
  exit 0
fi

VPNENV="${1,,}"
COMMAND="${2,,}"

RESULT="0"
ENDPOINTVPN="notdefined"

# Parse VPN environment
case "${VPNENV}" in
  pre)
    ENDPOINTVPN="${ENDPOINTVPNPRE}"
  ;;
  pro)
    ENDPOINTVPN="${ENDPOINTVPNPRO}"
  ;;
  *)
    echo "ERROR: Invalid environment <${VPNENV}>"
    RESULT=1
  ;;
esac

# Parse command
case "${COMMAND}" in
  start) 
  ;;
  stop) 
  ;;
  *) 
    echo "ERROR: Invalid command <${COMMAND}>"
    RESULT=2
  ;;
esac

if [ "${RESULT}" != "0" ]
then
  openconnecthelp
  exit 1
fi

VPNPIDFILE="/var/run/vpnconnect_${VPNENV}.pid"

echo
echo "*** We <${COMMAND}> VPN with environment <${VPNENV}> endpoint <${ENDPOINTVPN}>"
echo

# Parse command
case "${COMMAND}" in
  start) 
    echo "${DSN_PASS}" | sudo openconnect -b --pid-file=${VPNPIDFILE} -c ${CERTFILE} --no-cert-check -u ${DSN_USER} -p ${CERTPASS} --passwd-on-stdin ${ENDPOINTVPN}
    RESULT="$?"
    if [ "${RESULT}" != "0" ]
    then
      echo "ERROR: Cannot start VPN connection. Error code <${RESULT}>"
    else
      sleep 1
      cat $HOME/vpnalldnsservers.conf | sudo tee /etc/resolv.conf
      echo "VPN PID file in <${VPNPIDFILE}>"
      echo "My DNSs are:"
      cat /etc/resolv.conf | egrep -v "^ *;"
      figlet ${VPNENV^^}
      echo "Enjoy VPN. Be careful..."
      echo
    fi
  ;;
  stop) 
    if [ -f ${VPNPIDFILE} ]
    then
      MYPID="$(cat ${VPNPIDFILE})"
      sudo kill "${MYPID}"
      sleep 1
    fi
    sudo pkill -f "openconnect.*${ENDPOINTVPN}"
    sleep 1
    sudo rm -f ${VPNPIDFILE}
  ;;
esac


