#!/bin/bash

echo "******************************************************"
echo "OST TENANT FOR PRODSN ENVIRONMENTS"
echo "We assume we have only one tenant..."
echo "******************************************************"

OSTENVFILE="${HOME}/listostenvs.cnf"
LISTOSTENVS="$(cat ${OSTENVFILE} | grep ^OSTENV=PRODSN)"

if [ "$(echo "${LISTOSTENVS}" | wc -l)" != "1" ]
then
  echo "ERROR: We need only one tenant in ${HOME}/listostenvs.cnf"
  exit 1
fi

export PYTHONWARNINGS="ignore:Unverified HTTPS request"
alias nova="nova --insecure"
alias openstack="openstack --insecure"
alias cinder="cinder --insecure"
alias keystone="keystone --insecure"
alias neutron="neutron --insecure"
alias glance="glance --insecure"

for myostenv in ${LISTOSTENVS}
do
 export "${myostenv}"
done
export PS1="[\u@\h \W]\[\e[7;31m\][\${OSTENV}]-[\${OS_TENANT_NAME}]\[\e[m\]\$ "

env | grep ^OS
env | grep ^PS1

