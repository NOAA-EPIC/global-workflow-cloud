#!/bin/bash

source /opt/ohpc/admin/lmod/lmod/init/bash
module purge
module use "${HOMEgfs}/sorc/ufs_model.fd/modulefiles"
module load ufs_container.gnu

if [[ $# -gt 0 ]]; then
    "$@"
fi

