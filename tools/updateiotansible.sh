#!/bin/bash

cd $HOME/sw/iot_ansible
git checkout develop
git status
git pull origin
cd - > /dev/null
cd $HOME/sw
./decryptansiblefiles.sh
cd - > /dev/null

