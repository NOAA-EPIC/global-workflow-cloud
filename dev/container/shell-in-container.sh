#!/bin/bash

set -x

gwHomeDir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." > /dev/null 2>&1 && pwd)"
source "${gwHomeDir}/ush/detect_machine.sh"

sed -e "s|GLOBALWORKFLOWHOMEDIR|${gwHomeDir}|g" \
       ${gwHomeDir}/dev/container/hosts/${MACHINE_ID}/intel/env/CONTAINER.env \
       > ${gwHomeDir}/env/CONTAINER.env
source ${gwHomeDir}/env/CONTAINER.env
cp ${gwHomeDir}/env/CONTAINER.env ${gwHomeDir}/dev/container/env/CONTAINER.env

# shellcheck disable=SC2086
singularity shell -e ${CONTAINER_BINDINGS} "${CONTAINER_SIF}"
