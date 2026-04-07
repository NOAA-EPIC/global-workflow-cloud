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
    "/work2/11244/huangwei/stampede3/src/global-workflow-cloud/dev/container/env/python-env.sh" "$@"
#   "${HOMEglobal}/dev/container/env/python-env.sh" "$@"
