#!/bin/bash

source /opt/ohpc/admin/lmod/lmod/init/bash
module purge
module use "${HOMEgfs}/sorc/gfs_utils.fd/modulefiles"
module load gfsutils_container.gnu
module load wgrib2
module load gettext
#module load prod_util
#export UTILROOT=${prod_util_ROOT}

if [[ $# -gt 0 ]]; then
    "$@"
fi
