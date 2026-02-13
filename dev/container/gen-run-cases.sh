#!/bin/bash

set -x

HOMEgfs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." > /dev/null 2>&1 && pwd)"
source "${HOMEgfs}/ush/detect_machine.sh"

run_with_container="YES"
#run_with_container="NO"

casetype="pr"
#yamllist="C48_ATM"
yamllist="C48_S2SW"
#yamllist="C48_S2SWA_gefs"
#yamllist="C96mx100_S2S"

#casetype=hires
#yamllist="C768_S2SW"

function _usage() {
    cat << EOF
   This script automates the experiment setup process for the global workflow.
   Options are also available to update submodules, build the workflow (with
   specific build flags), specify which YAMLs and YAML directory to run, and
   whether to automatically update your crontab.

   Usage: gen-run-cases.sh [OPTIONS]
       NOTES on -C -c:
           - Both the way to select compiler: Intel, or GNU

       -C Select a COMPILER: Available compilers are: Intel, GNU
       -c Select a compiler: Available compilers are: Intel, GNU
       -v Verbose mode.  Prints output of all commands to stdout.
       -h Display this message.
EOF
}

_verbose=false
_compiler="Intel"

while [[ $# -gt 0 && "$1" != "--" ]]; do
    while getopts ":Cc:vh" option; do
        case "${option}" in
            C) _compiler="${OPTARG}" ;;
            c) _compiler="${OPTARG}" ;;
            v) _verbose=true ;;
            h) _usage && exit 0 ;;
            :)
                echo "[${BASH_SOURCE[0]}]: ${option} requires an argument"
                _usage
                exit 1
                ;;
            *)
                echo "[${BASH_SOURCE[0]}]: Unrecognized option: ${option}"
                _usage
                exit 1
                ;;
        esac
    done

    if [[ ${OPTIND:-0} -gt 0 ]]; then
        shift $((OPTIND - 1))
    fi
done

compiler="${_compiler,,}"

HOMEDIR=${HOMEgfs}
if [[ ${MACHINE_ID} = ursa* ]]; then
    rundir="/scratch3/NAGAPE/epic/${USER}/run/gnu"
    HPC_ACCOUNT=epic

    module load rocoto/1.3.7
    rocotocmd=$(command -v rocotorun)
elif [[ ${MACHINE_ID} = gaea* ]]; then
    rundir="/gpfs/f6/scratch/${USER}/run/prefix"
    HPC_ACCOUNT=bil-fire8

    rocotocmd=/autofs/ncrc-svm1_home2/Christopher.W.Harrop/rocoto-1.3.7/bin/rocotorun
elif [[ ${MACHINE_ID} = hercules* ]]; then
    module load singularity
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
fi

set -x

mkdir -p "${rundir}"

cd "${HOMEDIR}/dev/workflow" || exit 1

if [[ "${run_with_container}" == "YES" ]]; then
    CONTAINER_OPTIONS="-R -r \"${rocotocmd}\" -c ${compiler}"

    ln -sf ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env ${HOMEgfs}/dev/container/env
    ln -sf ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/prefix ${HOMEgfs}/dev/container/prefix
    cp ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/CONTAINER.env ${HOMEgfs}/env/CONTAINER.env
    UMID="${MACHINE_ID^^}"
    if [[ -f ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/${UMID}.env ]]; then
        cp ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/${UMID}.env ${HOMEgfs}/env/${UMID}.env
    fi
    source ${HOMEgfs}/env/CONTAINER.env
else
    CONTAINER_OPTIONS=" "
fi

RUNTESTS="${rundir}" \
./generate_workflows.sh \
        -H "${HOMEDIR}" \
        -y "${yamllist}" \
        -Y "${HOMEDIR}/dev/ci/cases/${casetype}" \
        -A "${HPC_ACCOUNT}" \
        -e "${USER}@noaa.gov" \
        ${CONTAINER_OPTIONS} \
        -v
