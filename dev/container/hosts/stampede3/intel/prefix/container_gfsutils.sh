#!/bin/bash

 LD_LIBRARY_PATH=$(dirname "CONTAINER_SIF}")
 export LD_LIBRARY_PATH

 singularity exec \
        ${CONTAINER_BINDINGS} \
        "${CONTAINER_SIF}" \
        "/work2/11244/huangwei/stampede3/src/global-workflow-cloud/dev/container/env/gfsutils-env.sh" \
        "$@"

#       "${HOMEglobal}/dev/container/env/gfsutils-env.sh" \
