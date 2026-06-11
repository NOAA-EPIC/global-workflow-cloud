#!/bin/bash

set -x

GWHOMEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." > /dev/null 2>&1 && pwd)"
source "${GWHOMEDIR}/ush/detect_machine.sh"

run_with_container="YES"
#run_with_container="NO"

casetype="pr"
#yamllist="C48_ATM"
yamllist="C48_S2SW"
#yamllist="C48_S2SWA_gefs"
#yamllist="C96mx100_S2S"

#casetype=hires
#yamllist="C768_S2SW"

img=ubuntu22.04-intel-ufs-env-v1.9.2.img
if [[ ${MACHINE_ID} = ursa* ]]; then
    rundir="/scratch3/NAGAPE/epic/${USER}/run/prefix"
    HPC_ACCOUNT=epic

    module load rocoto/1.3.7
    rocotocmd=$(command -v rocotorun)
elif [[ ${MACHINE_ID} = gaea* ]]; then
    rundir="/gpfs/f6/scratch/${USER}/run/prefix"
    HPC_ACCOUNT=bil-fire8

    rocotocmd=/autofs/ncrc-svm1_home2/Christopher.W.Harrop/rocoto-1.3.7/bin/rocotorun
elif [[ ${MACHINE_ID} = hercules* ]]; then
    module load singularity
    CONTAINER_SIF="/work2/noaa/epic/weihuang/containers/${sif}"
    CONTAINER_BINDINGS="-B /work -B /work2"
    rundir="/work2/noaa/epic/weihuang/run/prefix"
    HPC_ACCOUNT=epic

    module load contrib/0.1
    module load rocoto/1.3.7
    rocotocmd=$(command -v rocotorun)
elif [[ ${MACHINE_ID} = noaacloud* ]]; then
    rundir="/lustre/${USER}/run"
    HPC_ACCOUNT="${USER}"

    module load rocoto/1.3.7
    rocotocmd=$(command -v rocotorun)
elif [[ ${MACHINE_ID} = stampede3* ]]; then
   #rundir=${WORK}/run
    rundir=/work2/11244/huangwei/stampede3/run
    HPC_ACCOUNT="TG-EES250186"

    rocotocmd=$(command -v rocotorun)
elif [[ ${MACHINE_ID} = container* ]]; then
   #rundir=${WORK}/run
    rundir=/work2/11244/huangwei/stampede3/run
    HPC_ACCOUNT="TG-EES250186"

    rocotocmd=$(command -v rocotorun)
fi

set -x

mkdir -p "${rundir}"

cd "${GWHOMEDIR}/dev/workflow" || exit 1

if [[ "${run_with_container}" == "YES" ]]; then
    CONTAINER_OPTIONS="-R -r \"${rocotocmd}\""

    ln -sf ${GWHOMEDIR}/dev/container/hosts/${MACHINE_ID}/intel/env ${GWHOMEDIR}/dev/container/env
    ln -sf ${GWHOMEDIR}/dev/container/hosts/${MACHINE_ID}/intel/prefix ${GWHOMEDIR}/dev/container/prefix
    cp ${GWHOMEDIR}/dev/container/hosts/${MACHINE_ID}/intel/env/CONTAINER.env ${GWHOMEDIR}/env/CONTAINER.env
    UMID="${MACHINE_ID^^}"
    if [[ -f ${GWHOMEDIR}/dev/container/hosts/${MACHINE_ID}/intel/env/${UMID}.env ]]; then
        cp ${GWHOMEDIR}/dev/container/hosts/${MACHINE_ID}/intel/env/${UMID}.env ${GWHOMEDIR}/env/${UMID}.env
    fi
    source ${GWHOMEDIR}/env/CONTAINER.env
else
    CONTAINER_OPTIONS=" "
fi

RUNTESTS="${rundir}" \
./generate_workflows.sh \
        -H "${GWHOMEDIR}" \
        -y "${yamllist}" \
        -Y "${GWHOMEDIR}/dev/ci/cases/${casetype}" \
        -A "${HPC_ACCOUNT}" \
        -e "${USER}@noaa.gov" \
        ${CONTAINER_OPTIONS} \
        -v

unset GWHOMEDIR
