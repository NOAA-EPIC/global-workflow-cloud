#!/bin/bash

LD_LIBRARY_PATH=$(dirname "CONTAINER_SIF}")
 export LD_LIBRARY_PATH

 singularity exec \
        ${CONTAINER_BINDINGS} \
        "${CONTAINER_SIF}" \
        "/scratch5/purged/Wei.Huang/src/global-workflow-cloud/dev/container/env/gfsutils-env.sh" \
        "$@"
