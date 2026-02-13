#!/bin/bash

 LD_LIBRARY_PATH=$(dirname "${CONTAINER_SIF}")
 export LD_LIBRARY_PATH

 module reset

 LD_LIBRARY_PATH=$(dirname "${CONTAINER_SIF}")
 export LD_LIBRARY_PATH

# GNU singularity settings
export APPTAINERENV_FI_PROVIDER=tcp
export APPTAINER_SHELL=/bin/bash

export APPTAINERENV_PMIX_MCA_gds=hash
export APPTAINERENV_OMPI_MCA_btl="^openib"

if ip link show eth0 &>/dev/null; then
    export APPTAINERENV_OMPI_MCA_btl_tcp_if_include=eth0
    export APPTAINERENV_OMPI_MCA_oob_tcp_if_include=eth0
fi

export APPTAINERENV_OMPI_MCA_pml=ob1
export APPTAINERENV_OMPI_MCA_btl_vader_single_copy_mechanism=none
export APPTAINERENV_OMPI_MCA_mca_base_component_show_load_errors=0

#       -B ${I_MPI_PMI_LIBRARY} \
 singularity exec \
        ${CONTAINER_BINDINGS} \
        "${CONTAINER_SIF}" \
        "${HOMEgfs}/dev/container/env/model-env.sh" \
        "$@"
