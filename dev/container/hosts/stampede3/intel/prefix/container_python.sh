#!/bin/bash
set -x
LD_LIBRARY_PATH=$(dirname "${CONTAINER_SIF}")
export LD_LIBRARY_PATH

module load TACC
module load tacc-apptainer

#singularity exec \
apptainer exec \
    ${CONTAINER_BINDINGS} \
    "${CONTAINER_SIF}" \
    "${HOMEgfs}/dev/container/env/python-env.sh" "$@"
