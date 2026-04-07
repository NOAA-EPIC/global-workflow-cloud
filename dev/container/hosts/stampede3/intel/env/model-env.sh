#!/bin/bash

source /usr/lmod/lmod/init/bash
#module use "${HOMEglobal}/sorc/ufs_model.fd/modulefiles"
module use "/work2/11244/huangwei/stampede3/src/global-workflow-cloud/sorc/ufs_model.fd/modulefiles"
module load ufs_container.intel

if [[ $# -gt 0 ]]; then
    "$@"
fi

