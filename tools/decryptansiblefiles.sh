#!/bin/bash

cd $HOME/sw
INTEGRATORS=group_vars/external
INTEGRATION=group_vars/integration
PREPRODUCTION=group_vars/preproduction
PRODUCTION=group_vars/production

mkdir -p DECRYPT_${INTEGRATORS}
mkdir -p DECRYPT_${INTEGRATION}
mkdir -p DECRYPT_${PREPRODUCTION}
mkdir -p DECRYPT_${PRODUCTION}

echo "*** Decript integrators..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATORS}/1credentials.yml --output=DECRYPT_${INTEGRATORS}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATORS}/2credentials_provision.yml --output=DECRYPT_${INTEGRATORS}/2credentials_provision.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATORS}/3certificates.yml --output=DECRYPT_${INTEGRATORS}/3certificates.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATORS}/4syncthing_certificates.yml --output=DECRYPT_${INTEGRATORS}/4syncthing_certificates.yml

echo "*** Decript integration..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATION}/1credentials.yml --output=DECRYPT_${INTEGRATION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATION}/2credentials_provision.yml --output=DECRYPT_${INTEGRATION}/2credentials_provision.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATION}/3certificates.yml --output=DECRYPT_${INTEGRATION}/3certificates.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${INTEGRATION}/4syncthing_certificates.yml --output=DECRYPT_${INTEGRATION}/4syncthing_certificates.yml

echo "*** Decript preproduction..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PREPRODUCTION}/1credentials.yml --output=DECRYPT_${PREPRODUCTION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PREPRODUCTION}/2credentials_provision.yml --output=DECRYPT_${PREPRODUCTION}/2credentials_provision.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PREPRODUCTION}/3certificates.yml --output=DECRYPT_${PREPRODUCTION}/3certificates.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PREPRODUCTION}/4syncthing_certificates.yml --output=DECRYPT_${PREPRODUCTION}/4syncthing_certificates.yml

echo "*** Decript production..."
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PRODUCTION}/1credentials.yml --output=DECRYPT_${PRODUCTION}/1credentials.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PRODUCTION}/2credentials_provision.yml --output=DECRYPT_${PRODUCTION}/2credentials_provision.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PRODUCTION}/3certificates.yml --output=DECRYPT_${PRODUCTION}/3certificates.yml
ansible-vault decrypt --vault-password-file $HOME/sw/thevaultpass.txt iot_ansible/${PRODUCTION}/4syncthing_certificates.yml --output=DECRYPT_${PRODUCTION}/4syncthing_certificates.yml

