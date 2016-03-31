#!/bin/bash

shopt -s extglob

SCRIPT_BASEDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))
HOME_BASEDIR=$(dirname $(realpath "${SCRIPT_BASEDIR}"))

cd ${HOME_BASEDIR}

declare -a LISTHOSTENV
declare -a FORMATTEDLISTHOSTENV

ENVFILES="$(find ${HOME_BASEDIR}/envs/iotenv*.hosts -printf %f\\n | sort)"
ENVS="$(echo "${ENVFILES}" | sed -e 's/^iotenv//' -e 's/\.hosts$//')"

SELECTEDENV="$(dialog --stdout --no-mouse --title "IOT ENVIRONMENTS" --menu "IOT ENVIRONMENT LIST" \
  0 0 0 $(paste --delimiters ' ' <(echo "${ENVFILES}") <(echo "${ENVS}")))"

SELECTEDSHORTENV="$(echo "${SELECTEDENV}" | sed -e 's/^iotenv//' -e 's/\.hosts$//')"

# Obtain all hosts of selected environment in two lists, one exact list and one formatted list for use with dynamic dialog
while read -r myhost
do
  LISTHOSTENV+=("${myhost}")
  FORMATTEDLISTHOSTENV+=(${#LISTHOSTENV[@]} "${myhost}")
done <<< "$(cat ${HOME_BASEDIR}/envs/${SELECTEDENV} | sort)"

# print arrays (debug only)
# echo "*****"
# echo "Length ${#LISTHOSTENV[@]}"
# for ((indexarr=0; indexarr<${#LISTHOSTENV[@]}; indexarr++));
# do
#   echo "${indexarr} - ${LISTHOSTENV[${indexarr}]}"
# done
# echo "*****"
# echo "*****"
# echo "Length ${#FORMATTEDLISTHOSTENV[@]}"
# for ((indexarr=0; indexarr<${#FORMATTEDLISTHOSTENV[@]}; indexarr++));
# do
#   echo "${indexarr} - ${FORMATTEDLISTHOSTENV[${indexarr}]}"
# done
# echo "*****"

# For debug we can add the flag --args
INDEXSELECTEDHOST="$(dialog --stdout --no-mouse --title "IOT ENVIRONMENTS" --menu "IOT ${SELECTEDSHORTENV} ENVIRONMENT" 0 0 0 \
"${FORMATTEDLISTHOSTENV[@]}")"

INFOSELECTEDHOST="$(echo "${FORMATTEDLISTHOSTENV[((${INDEXSELECTEDHOST}*2-1))]}")"
NUMBERSELECTEDHOST="$(echo "${FORMATTEDLISTHOSTENV[((${INDEXSELECTEDHOST}*2-2))]}")"

echo
echo
echo "**********************************************"
echo "Using host SSH <${NUMBERSELECTEDHOST} ${INFOSELECTEDHOST}>"
echo "**********************************************"
echo

SSHSELECTEDHOST="$(echo "${INFOSELECTEDHOST}" | awk -F '=>' '{print $2}')"
eval exec ${SSHSELECTEDHOST}


