#!/bin/bash

echo "********"
echo "* CJMM *"
echo "********"
echo
echo "******************************************************"
echo "SELECT OST TENANT FOR DSNAH ENVIRONMENTS"
echo "******************************************************"

OSTENVFILE="${HOME}/listostenvs.cnf"
LISTOSTENVS="$(cat ${OSTENVFILE} | egrep '^OSTENV=.*DSNAH.*')"

unset options i
while read -r myostenv
do
  myostenv="$(echo "${myostenv}" | cut -d' ' -f1-2)"
  options[i++]="${myostenv}"
done <<< "${LISTOSTENVS}"

echo

PS3='Please enter your choice: '
select opt in "${options[@]}"
do
  echo "You chose choice <${opt}>"
  break;
done

export PYTHONWARNINGS="ignore:Unverified HTTPS request"
alias nova="nova --insecure"
alias openstack="openstack --insecure"
alias cinder="cinder --insecure"
alias keystone="keystone --insecure"
alias neutron="neutron --insecure"
alias glance="glance --insecure"

for myostenv in $(echo "${LISTOSTENVS}" | grep "${opt} ")
do
 export "${myostenv}"
done
export PS1="[\u@\h \W]\[\e[7;32m\][\${OSTENV}]-[\${OS_TENANT_NAME}]\[\e[m\]\$ "

env | grep ^OS
env | grep ^PS1

