#!/bin/bash

source /opt/ohpc/admin/lmod/lmod/init/bash
module purge
module use "${HOMEgfs}/sorc/ufs_model.fd/modulefiles"
module load ufs_container.gnu

HDF5_PLUGIN_PATH=/opt/spack-stack/spack-stack-1.9.2/envs/ufs-wm-env/install/gcc/13.3.1/netcdf-c-4.9.2-xmkcipz/plugins
HDF5_USE_FILE_LOCKING=FALSE
ESMFMKFILE=/opt/spack-stack/spack-stack-1.9.2/envs/ufs-wm-env/install/gcc/13.3.1/esmf-8.8.0-xzh352w/lib/esmf.mk
CRTM_FIX=/opt/spack-stack/spack-stack-1.9.2/envs/ufs-wm-env/install/gcc/13.3.1/crtm-fix-2.4.0.1_emc-55e5oqz/fix

if [[ $# -gt 0 ]]; then
    "$@"
fi

