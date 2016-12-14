#!/bin/bash

RPMNAME="iot-agent-base"
HOSTDESTINATION="$(grep iotagent $HOME/myenvironments/envs/*)"
BRANCH="release/1.3.1"
VERSION="${BRANCH#release/}"
GITURLREPO="git@github.com:telefonicaid/fiware-IoTAgent-Cplusplus.git"
GITNAMEREPO="$(basename ${GITURLREPO%.git})"
rm -rf "./${GITNAMEREPO}"
git clone -q ${GITURLREPO}
cd ./${GITNAMEREPO}
git checkout ${BRANCH}

SHORTSHA1="$(git rev-parse --short HEAD)"
NUMCOMMITS="$(git rev-list --all --left-right --pretty=oneline --count HEAD...${VERSION}/KO | cut -f1)"
cd - 2>/dev/null

echo "*********************************************************"
echo "VERIFYING RPM..."
echo "*********************************************************"
echo "RPMNAME <${RPMNAME}>"
echo "BRANCH <${BRANCH}>"
echo "VERSION <${VERSION}>"
echo "GITURLREPO <${GITURLREPO}>"
echo "SHORTSHA1 <${SHORTSHA1}>"
echo "NUMCOMMITS <${NUMCOMMITS}>"

while read -r myhost
do
  # For debug uncomment
  # echo "*** PROCESSING <$(echo "$(basename "${myhost}")")"
  myssh="$(echo "${myhost}" | awk -F '=>' '{print $2}') -qTn -o ConnectTimeout=3"
  askmyrpm="$(${myssh} rpm -q --queryformat \'VERSION %{VERSION}\\nRELEASE %{RELEASE}\' ${RPMNAME})"
  resultaskmyrpm="${PIPESTATUS[0]}"

  if [ "${resultaskmyrpm}" != "0" ]
  then
    echo "UNKNOWN: ENV <$(basename $(echo "${myhost}" | cut -d':' -f1)) PKG <${RPMNAME}> CANNOT ACCESS"
  else
    if [ "$(echo "${askmyrpm}" | fgrep 'not installed')" != "" ]
    then
      echo "NOTINSTALLED: ENV <$(basename $(echo "${myhost}" | cut -d':' -f1)) PKG <${RPMNAME}> NOT INSTALLED"
    else
      myrpmversion="$(echo "${askmyrpm}" | grep "^VERSION " | cut -d' ' -f2)"
      myrpmrelease="$(echo "${askmyrpm}" | grep "^RELEASE " | cut -d' ' -f2 | cut -d'.' -f1)"
      if [[ "${VERSION}" != "${myrpmversion}" || "${NUMCOMMITS}" != "${myrpmrelease}" ]]
      then
        echo "ERROR: ENV <$(basename $(echo "${myhost}" | cut -d':' -f1))> PKG <${RPMNAME}> DIFFER: GITREPO ${VERSION}.${NUMCOMMITS} VS INSTALLED RPM ${myrpmversion}.${myrpmrelease}"
      else
        echo "OK: ENV <$(basename $(echo "${myhost}" | cut -d':' -f1)) PKG <${RPMNAME}> EQUAL GITREPO VS INSTALLED RPM"
      fi
    fi
  fi
done <<< "${HOSTDESTINATION}"

