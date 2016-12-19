#!/bin/bash

cd $HOME/sw
INTEGRATORS=group_vars/external
INTEGRATION=group_vars/integration
PREPRODUCTION=group_vars/preproduction
PRODUCTION=group_vars/production

mkdir -p ENCRYPT_${INTEGRATORS}
mkdir -p ENCRYPT_${INTEGRATION}
mkdir -p ENCRYPT_${PREPRODUCTION}
mkdir -p ENCRYPT_${PRODUCTION}

echo "*** Encrypt integrators..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATORS}/1credentials.yml --output=ENCRYPT_${INTEGRATORS}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATORS}/2credentials_provision.yml --output=ENCRYPT_${INTEGRATORS}/2credentials_provision.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATORS}/3certificates.yml --output=ENCRYPT_${INTEGRATORS}/3certificates.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATORS}/4syncthing_certificates.yml --output=ENCRYPT_${INTEGRATORS}/4syncthing_certificates.yml

echo "*** Encrypt integration..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/1credentials.yml --output=ENCRYPT_${INTEGRATION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/2credentials_provision.yml --output=ENCRYPT_${INTEGRATION}/2credentials_provision.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/3certificates.yml --output=ENCRYPT_${INTEGRATION}/3certificates.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${INTEGRATION}/4syncthing_certificates.yml --output=ENCRYPT_${INTEGRATION}/4syncthing_certificates.yml

echo "*** Encrypt preproduction..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/1credentials.yml --output=ENCRYPT_${PREPRODUCTION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/2credentials_provision.yml --output=ENCRYPT_${PREPRODUCTION}/2credentials_provision.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/3certificates.yml --output=ENCRYPT_${PREPRODUCTION}/3certificates.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PREPRODUCTION}/4syncthing_certificates.yml --output=ENCRYPT_${PREPRODUCTION}/4syncthing_certificates.yml

echo "*** Encrypt production..."
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/1credentials.yml --output=ENCRYPT_${PRODUCTION}/1credentials.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/2credentials_provision.yml --output=ENCRYPT_${PRODUCTION}/2credentials_provision.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/3certificates.yml --output=ENCRYPT_${PRODUCTION}/3certificates.yml
ansible-vault encrypt --vault-password-file $HOME/sw/thevaultpass.txt DECRYPT_${PRODUCTION}/4syncthing_certificates.yml --output=ENCRYPT_${PRODUCTION}/4syncthing_certificates.yml

