#!/bin/bash

LISTFILES="group_vars/integration/1credentials.yml group_vars/integration/2credentials_provision.yml \
group_vars/preproduction/1credentials.yml group_vars/preproduction/2credentials_provision.yml \
group_vars/production/1credentials.yml group_vars/production/2credentials_provision.yml"

echo "LIST DIFFERENCES FROM branch develop"
echo "You need to launch from home directory of git repo..."
echo "Changes in ../diffcreds"
rm -rf ../diffcreds
mkdir -p ../diffcreds

git checkout develop
git pull origin

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

