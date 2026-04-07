#!/bin/bash

set -x

HOMEglobal="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." > /dev/null 2>&1 && pwd)"
source "${HOMEglobal}/ush/detect_machine.sh"

ln -sf ${HOMEglobal}/dev/container/hosts/${MACHINE_ID}/intel/env ${HOMEglobal}/dev/container/env
ln -sf ${HOMEglobal}/dev/container/hosts/${MACHINE_ID}/intel/prefix ${HOMEglobal}/dev/container/prefix
cp ${HOMEglobal}/dev/container/hosts/${MACHINE_ID}/intel/env/CONTAINER.env ${HOMEglobal}/env/CONTAINER.env
UMID="${MACHINE_ID^^}"
if [[ -f ${HOMEglobal}/dev/container/hosts/${MACHINE_ID}/intel/env/${UMID}.env ]]; then
    cp ${HOMEglobal}/dev/container/hosts/${MACHINE_ID}/intel/env/${UMID}.env ${HOMEglobal}/env/${UMID}.env
fi
source ${HOMEglobal}/env/CONTAINER.env

# shellcheck disable=SC2086
singularity shell -e ${CONTAINER_BINDINGS} "${CONTAINER_SIF}"
