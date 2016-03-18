#!/bin/bash

cd $HOME/sw
INTEGRATION=group_vars/integration
PREPRODUCTION=group_vars/preproduction
PRODUCTION=group_vars/production
mkdir -p ENCRYPT_${INTEGRATION}
mkdir -p ENCRYPT_${PREPRODUCTION}
mkdir -p ENCRYPT_${PRODUCTION}
echo "*** Encrypt integration..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/1credentials.yml --output=ENCRYPT_${INTEGRATION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/2credentials_provision.yml --output=ENCRYPT_${INTEGRATION}/2credentials_provision.yml

echo "*** Encrypt preproduction..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/1credentials.yml --output=ENCRYPT_${PREPRODUCTION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/2credentials_provision.yml --output=ENCRYPT_${PREPRODUCTION}/2credentials_provision.yml

echo "*** Encrypt production..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/1credentials.yml --output=ENCRYPT_${PRODUCTION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/2credentials_provision.yml --output=ENCRYPT_${PRODUCTION}/2credentials_provision.yml


