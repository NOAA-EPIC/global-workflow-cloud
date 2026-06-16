#!/bin/bash
LD_LIBRARY_PATH=$(dirname "CONTAINER_SIF}")
export LD_LIBRARY_PATH

module load apptainer

apptainer exec \
    ${CONTAINER_BINDINGS} \
    "${CONTAINER_SIF}" \
    "${containerHOMEglobal}/dev/container/env/python-env.sh" "$@"
