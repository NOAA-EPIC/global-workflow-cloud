#!/bin/bash

source /usr/lmod/lmod/init/bash
module use "/scratch5/purged/Wei.Huang/src/global-workflow-cloud/sorc/ufs_model.fd/modulefiles"
module load ufs_container.intel

if [[ $# -gt 0 ]]; then
    "$@"
fi

