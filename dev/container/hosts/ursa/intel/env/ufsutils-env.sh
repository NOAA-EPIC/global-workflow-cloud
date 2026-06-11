#!/bin/bash

source /usr/lmod/lmod/init/bash
module use "/scratch5/purged/Wei.Huang/src/global-workflow-cloud/sorc/ufs_utils.fd/modulefiles"
module load build.container.intel

if [[ $# -gt 0 ]]; then
    "$@"
fi
