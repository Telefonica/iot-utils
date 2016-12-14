#!/bin/bash

cd $HOME/sw/iot_ansible
git checkout develop
# git checkout release/4.0
# git checkout release/4.1

git status
git pull origin
git fetch
cd - > /dev/null
cd $HOME/sw
./decryptansiblefiles.sh
cd - > /dev/null

