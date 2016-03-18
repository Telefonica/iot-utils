#!/bin/bash

shopt -s extglob

SCRIPT_BASEDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))
HOME_BASEDIR=$(dirname $(realpath "${SCRIPT_BASEDIR}"))

echo "********"
echo "* CJMM *"
echo "********"
echo
echo "******************************************************"
echo "PROCESS TO DISCOVER OPENSTACK HOSTS"
echo "******************************************************"

cd ${HOME_BASEDIR}
mkdir -p ${HOME_BASEDIR}/envs
rm -f ${HOME_BASEDIR}/envs/iotenvOST_*.hosts

echo
echo "Inventory parsing..."
echo

export PYTHONWARNINGS="ignore:Unverified HTTPS request"

# PEM files
if [ "${PEMEPG}" == "" ]
then
  PEMEPG="error_configure_correctly_bashrcconfignoroot.cnf.template_task"
  echo "ERROR: configure correctly bashrcconfignoroot.cnf.template task"
  exit 2
fi
if [ "${PEMPREDSN}" == "" ]
then
  PEMPREDSN="error_configure_correctly_bashrcconfignoroot.cnf.template_task"
  echo "ERROR: configure correctly bashrcconfignoroot.cnf.template task"
  exit 3
fi
if [ "${PEMPRODSN}" == "" ]
then
  PEMPRODSN="error_configure_correctly_bashrcconfignoroot.cnf.template_task"
  echo "ERROR: configure correctly bashrcconfignoroot.cnf.template task"
  exit 4
fi

# SSH
DEFAULTSSHUSER="ec2-user"
SPECIFICSSHUSER="cloud-user"

# OST environments file
OSTENVFILE="${HOME}/listostenvs.cnf"
LISTOSTENVS="$(cat ${OSTENVFILE} | grep ^OSTENV)"

while read -r myostenv
do
   echo "***"
   echo "*** PROCESSING ${myostenv}"
   echo "***"
   export ${myostenv}
   LISTALLDATASRV="$(openstack --insecure server list -f value -c Name -c Networks)"
   LISTSRVNAMES="$(echo "${LISTALLDATASRV}" | grep -Po "^[^ ]*")"
   # Using non-greedy patterns
   LISTACCESS="$(echo "${LISTALLDATASRV}" | grep -Po "IoT-Management=.*?\;" | grep -Po "([0-9]+\.)+[0-9]+\;" | tr -d ';')"
   LISTSRVNAMEACCESS=$(paste --delimiters ' ' <(echo "${LISTSRVNAMES}") <(echo "${LISTACCESS}"))
   # Uncomment for debug
   # echo "***********************************************"
   # echo "${LISTSRVNAMEACCESS}"
   # echo "***********************************************"

   LISTSRVFINAL=""
   while read -r mysrv
   do
     echo "****** PROCESSING ${mysrv}"
     myname="$(echo ${mysrv} | cut -d ' ' -f1)"
     myaccess="$(echo ${mysrv} | cut -d ' ' -f2)"
     # If we are inside EPG environments, we try to determine the ssh user
     # The default is DEFAULTSSHUSER
     if [ "${OSTENV}" == "EPG" ]
     then
       myuser="$(nova --insecure console-log ${myname} | grep -Po "Authorized keys from .* for user [^\+]*")"
       myuser="$(echo ${myuser##* })"
       if [ "${myuser}" != "" ]
       then
         sshuser="${myuser}"
       else
         # Final check login user
         # INFO: We use -n option to prevent ssh read input used by while loop to process environments
         SSHTESTRESULT=""
         ssh -q -n -o ConnectTimeout=5 ${DEFAULTSSHUSER}@${myaccess} exit
         SSHTESTRESULT="$?"
         if [ "${SSHTESTRESULT}" == "0" ]
         then
           sshuser="${DEFAULTSSHUSER}"
         else
           # INFO: We use -n option to prevent ssh read input used by while loop to process environments
           ssh -q -n -o ConnectTimeout=5 ${SPECIFICSSHUSER}@${myaccess} exit
           SSHTESTRESULT="$?"
           if [ "${SSHTESTRESULT}" == "0" ]
           then
             sshuser="${SPECIFICSSHUSER}"
           else
             sshuser="cannotdeterminelogin"
           fi
         fi
       fi
     else
       sshuser="${DEFAULTSSHUSER}"
     fi
     if [ "${OSTENV}" == "EPG" ]
     then
       # Unificate operations
       # sshcommand="ssh -i ${PEMEPG} ${sshuser}@${myaccess}"
       sshcommand="ssh ${sshuser}@${myaccess}"
     elif [ "${OSTENV}" == "PREDSN" ]
     then
       # Unificate operations
       # sshcommand="ssh -i ${PEMPREDSN} ${sshuser}@${myaccess}"
       sshcommand="ssh ${sshuser}@${myaccess}"
     elif [ "${OSTENV}" == "PRODSN" ]
     then
       # Unificate operations
       # sshcommand="ssh -i ${PEMPRODSN} ${sshuser}@${myaccess}"
       sshcommand="ssh ${sshuser}@${myaccess}"
     else
       sshcommand="CANNOT DETERMINE..."
     fi
     echo "****** ${sshcommand}"
     if [ "${LISTSRVFINAL}" == "" ]
     then
       LISTSRVFINAL+="${myname} ${myaccess}=>${sshcommand}"
     else
       LISTSRVFINAL+=$'\n'"${myname} ${myaccess}=>${sshcommand}"
     fi
   done <<< "${LISTSRVNAMEACCESS}"
   echo "****** FINAL list:"
   echo "${LISTSRVFINAL}" | sort | tee ${HOME_BASEDIR}/envs/iotenvOST_${OSTENV}_${OS_TENANT_NAME}.hosts
done <<< "${LISTOSTENVS}"

