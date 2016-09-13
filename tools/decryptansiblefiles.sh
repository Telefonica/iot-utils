#!/bin/bash

cd $HOME/sw
INTEGRATION=group_vars/integration
PREPRODUCTION=group_vars/preproduction
PRODUCTION=group_vars/production
mkdir -p DECRYPT_${INTEGRATION}
mkdir -p DECRYPT_${PREPRODUCTION}
mkdir -p DECRYPT_${PRODUCTION}
echo "*** Decript integration..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/integration/1credentials.yml --output=DECRYPT_${INTEGRATION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/integration/2credentials_provision.yml --output=DECRYPT_${INTEGRATION}/2credentials_provision.yml

echo "*** Decript preproduction..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/preproduction/1credentials.yml --output=DECRYPT_${PREPRODUCTION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/preproduction/2credentials_provision.yml --output=DECRYPT_${PREPRODUCTION}/2credentials_provision.yml

echo "*** Decript production..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/production/1credentials.yml --output=DECRYPT_${PRODUCTION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/group_vars/production/2credentials_provision.yml --output=DECRYPT_${PRODUCTION}/2credentials_provision.yml


