#!/bin/bash

source /usr/lmod/lmod/init/bash
module purge
module use ${containerHOMEglobal}/sorc/gfs_utils.fd/modulefiles
module load gfsutils_container.intel
module load python
module load py-netcdf4
module load py-xarray
module load py-f90nml
module load py-numpy
module load py-jinja2
module load py-pyyaml

# shellcheck disable=SC2034
wxflowPATH="${containerHOMEglobal}/ush:${containerHOMEglobal}/ush/python:${containerHOMEglobal}/sorc/wxflow/src"
export PYTHONPATH="${PYTHONPATH:+${PYTHONPATH}:}${wxflowPATH}"
export RUNNING_IN_CONTAINER=true
# export APPTAINER_CONTAINER=true
# export SINGULARITY_CONTAINER=true
export GLOBALWORKFLOWHOMEDIR="${containerHOMEglobal}"

if [[ $# -gt 0 ]]; then
    python "$@"
fi
