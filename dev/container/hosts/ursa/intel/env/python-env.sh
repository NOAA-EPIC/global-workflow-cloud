#!/bin/bash

source /usr/lmod/lmod/init/bash
module purge
module use /scratch5/purged/Wei.Huang/src/global-workflow-cloud/sorc/gfs_utils.fd/modulefiles
module load gfsutils_container.intel
module load python
module load py-netcdf4
module load py-xarray
module load py-f90nml
module load py-numpy
module load py-jinja2
module load py-pyyaml

# shellcheck disable=SC2034
wxflowPATH="/scratch5/purged/Wei.Huang/src/global-workflow-cloud/ush:/scratch5/purged/Wei.Huang/src/global-workflow-cloud/ush/python:/scratch5/purged/Wei.Huang/src/global-workflow-cloud/sorc/wxflow/src"
export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}${wxflowPATH}"

if [[ $# -gt 0 ]]; then
    python "$@"
fi
