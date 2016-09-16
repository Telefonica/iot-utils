#!/bin/bash

INTEGRATORS=group_vars/external
INTEGRATION=group_vars/integration
PREPRODUCTION=group_vars/preproduction
PRODUCTION=group_vars/production

LISTFILES="${INTEGRATORS}/1credentials.yml ${INTEGRATORS}/2credentials_provision.yml ${INTEGRATORS}/3certificates.yml \
${INTEGRATION}/1credentials.yml ${INTEGRATION}/2credentials_provision.yml ${INTEGRATION}/3certificates.yml \
${PREPRODUCTION}/1credentials.yml ${PREPRODUCTION}/2credentials_provision.yml ${PREPRODUCTION}/3certificates.yml \
${PRODUCTION}/1credentials.yml ${PRODUCTION}/2credentials_provision.yml ${PRODUCTION}/3certificates.yml "

echo "LIST DIFFERENCES FROM branch develop"
echo "You need to launch from home directory of git repo..."
echo "Changes in diffcreds"
rm -rf ./diffcreds
mkdir -p ./diffcreds

cd iot_ansible
git checkout develop
git pull origin develop

for myfile in ${LISTFILES}
do
  echo "*******************************************************************"
  echo "PROCESSING FILE <${myfile}>"
  echo "*******************************************************************"
  mkdir -p ../diffcreds/$(dirname ${myfile})
  listcommits="$(git log --pretty=format:"%H - %ce, %ad : %s" --date=short ${myfile})"
  echo "${listcommits}"

  for commit in $(echo "${listcommits}" | cut -d' ' -f1)
  do
    echo "*** $(echo "${listcommits}" | grep ${commit})" | tee -a ../diffcreds/$(dirname ${myfile})/$(basename ${myfile}).diff
    ../ansible-vault-git-diff.sh ${commit} ${myfile} 2>&1 | tee -a ../diffcreds/$(dirname ${myfile})/$(basename ${myfile}).diff
    echo | tee -a ../diffcreds/$(dirname ${myfile})/$(basename ${myfile}).diff
  done
done

cd - 2>/dev/null

exit

# List changes

echo "*******************************************************************"
echo "PROCESSING FILE <${MYFILE}>"
echo "*******************************************************************"

for commit in $(echo "${LISTCOMMITS}" | cut -d' ' -f2)
do
  echo
  echo "*** ${commit}"
  ../ansible-vault-git-diff.sh ${commit} ${MYFILE} 2>&1
done

