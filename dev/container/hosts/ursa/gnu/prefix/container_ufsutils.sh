#!/bin/bash

 LD_LIBRARY_PATH=$(dirname "${CONTAINER_SIF}")
 export LD_LIBRARY_PATH

 module reset

 singularity exec \
        ${CONTAINER_BINDINGS} \
        "${CONTAINER_SIF}" \
        "${HOMEgfs}/dev/container/env/ufsutils-env.sh" \
        "$@"
