#!/bin/bash

source /opt/ohpc/admin/lmod/lmod/init/bash
module purge
module use "${HOMEgfs}/sorc/ufs_utils.fd/modulefiles"
module load build.container.gnu

if [[ $# -gt 0 ]]; then
    "$@"
fi
