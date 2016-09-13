#!/bin/bash

shopt -s extglob

SCRIPT_BASEDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))
HOME_BASEDIR=$(dirname $(realpath "${SCRIPT_BASEDIR}"))

echo "********"
echo "* CJMM *"
echo "********"
echo
echo "******************************************************"
echo "PROCESS TO DISCOVER VMWARE HOSTS"
echo "******************************************************"


cd ${HOME_BASEDIR}
mkdir -p ${HOME_BASEDIR}/envs
# Before to remove old hosts, we try to remove existing entries inside $HOME/.ssh/known_hosts file
for oldhost in $(cat ${HOME_BASEDIR}/envs/iotenvNOOST_*.hosts | cut -d'@' -f2)
do
  ssh-keygen -R ${oldhost} -f $HOME/.ssh/known_hosts >/dev/null 2>&1
done
rm -f ${HOME_BASEDIR}/envs/iotenvNOOST_*.hosts

echo
echo "Inventory parsing..."
echo

# We ask to Ansible inventories repo...
git clone git@pdihub.hi.inet:ep/iot_ansible.git 2>/dev/null
if [ "$(find -mindepth 1 -maxdepth 1 -name "iot_ansible" -type d)" != "" ]
then
  cd ./iot_ansible
  git checkout develop
  git pull origin
  cd ..
else
  echo "ERROR: Git Ansible repo not found..."
  exit 1
fi

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
if [ "${DSN_USER}" == "" ]
then
  DSN_USER="error_configure_correctly_bashrcconfignoroot.cnf.template_task"
  echo "ERROR: configure correctly bashrcconfignoroot.cnf.template task"
  exit 5
fi

LISTPLATFORMS="hadoop vmware"

for platform in ${LISTPLATFORMS}
do
  echo
  echo "PROCESSING PLATFORM <${platform}>"
  echo
  for iotenv in $(ls -d1 ${HOME_BASEDIR}/iot_ansible/inventory_${platform}/**)
  do
    echo "PROCESSING ENVIRONMENT <$(basename ${iotenv})> OF PLATFORM <${platform}>"
    GROUPHOST=""
    INVFILE="${iotenv}/*"
    linesinvfile="$(cat ${INVFILE})"
    oldifs="${IFS}"
    IFS=$'\n'

    MYIOTENV=""
    if [ "$(basename ${iotenv})" == "integration" ]
    then
      MYIOTENV="EPG"
    elif [ "$(basename ${iotenv})" == "preproduction" ]
    then
      MYIOTENV="PREDSN"
    elif [ "$(basename ${iotenv})" == "production" ]
    then
      MYIOTENV="PRODSN"
    else
      echo "ERROR: environment not defined... Skipping"
      continue
    fi

    LISTSRVFINAL=""

    for fileline in ${linesinvfile}
    do
      if [[ "${fileline}" =~ ^[[:space:]]*\[.+\] ]]
      then
        echo "- Bash exact rematch <${BASH_REMATCH}>"
        GROUPHOST="${BASH_REMATCH##*( )}"
        GROUPHOST="${GROUPHOST%%*( )}"
        GROUPHOST="$(echo ${GROUPHOST} | tr -d '[' | tr -d ']')"
        # echo "GROUPHOST <${fileline}>"
      else
        if [ "${GROUPHOST}" != "" ]
        then
          MYHOST="${fileline##*( )}"
          MYHOST="${MYHOST%%*( )}"
          if [[ "${MYHOST}" =~ [[:space:]]+ansible\_ssh\_host\=([0-9]+\.)+[0-9]+( +|$) ]]
          then
            NAMEMYHOST="$(echo "${MYHOST}" | cut -d' ' -f1)"
            IPMYHOST="$(echo "${MYHOST}" | grep -Po "ansible_ssh_host=([0-9]+\.)+[0-9]+( +|$)" | cut -d'=' -f2 | tr -d ' ')"
            # In PRE and PRO DSN the sshuser is the personal VPN user
            # In EPG the sshuser is the ansible_ssh_user variable inside inventory
            SSHCOMMAND=""
            SSHUSER=""
            if [ "${MYIOTENV}" == "EPG" ]
            then
              SSHUSER="$(echo "${MYHOST}" | grep -Po "ansible_ssh_user=.*( +|$)" | cut -d'=' -f2 | tr -d ' ')"
              # Unificate operations
              # SSHCOMMAND="ssh -i ${PEMEPG} ${SSHUSER}@${IPMYHOST}"
              SSHCOMMAND="ssh ${SSHUSER}@${IPMYHOST}"
            elif [ "${MYIOTENV}" == "PREDSN" ]
            then
              SSHUSER="\${DSN_USER}"
              # Unificate operations
              # SSHCOMMAND="ssh -i ${PEMPREDSN} ${SSHUSER}@${IPMYHOST}"
              SSHCOMMAND="ssh ${SSHUSER}@${IPMYHOST}"
            elif [ "${MYIOTENV}" == "PRODSN" ]
            then
              SSHUSER="\${DSN_USER}"
              # Unificate operations
              # SSHCOMMAND="ssh -i ${PEMPRODSN} ${SSHUSER}@${IPMYHOST}"
              SSHCOMMAND="ssh ${SSHUSER}@${IPMYHOST}"
            else
              echo "ERROR: environment not defined"
              continue
            fi
            if [ "${MYIOTENV}" != "" ]
            then
              if [ "${LISTSRVFINAL}" == "" ]
              then
                LISTSRVFINAL+="${GROUPHOST} ${NAMEMYHOST} ${IPMYHOST}=>${SSHCOMMAND}"
              else
                LISTSRVFINAL+=$'\n'"${GROUPHOST} ${NAMEMYHOST} ${IPMYHOST}=>${SSHCOMMAND}"
              fi
            fi
          fi
        fi
      fi
      # For debug only
      # echo "<${fileline}>"
    done
    IFS="${oldifs}"
    echo "****** FINAL list of PLATFORM <${platform}> and ENVIRONMENT <${MYIOTENV}>"
    echo "${LISTSRVFINAL}" | sort | tee ${HOME_BASEDIR}/envs/iotenvNOOST_${platform}_${MYIOTENV}.hosts
  done
done

# After calculate new hosts we remove this hosts, we try to remove existing entries inside $HOME/.ssh/known_hosts file
for oldhost in $(cat ${HOME_BASEDIR}/envs/iotenvNOOST_*.hosts | cut -d'@' -f2)
do
  ssh-keygen -R ${oldhost} -f $HOME/.ssh/known_hosts >/dev/null 2>&1
done


