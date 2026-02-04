#!/bin/bash

set -x

HOMEgfs="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." > /dev/null 2>&1 && pwd)"
source "${HOMEgfs}/ush/detect_machine.sh"

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
       -V Very verbose mode.  Passes -v to all commands and prints to stdout.
       -d Debug mode.  Same as -V but also enables logging (set -x).
       -h Display this message.
EOF
}

_very_verbose=false
_verbose=false
_debug="false"
_compiler="Intel"

while [[ $# -gt 0 && "$1" != "--" ]]; do
    while getopts ":Cc:vVdh" option; do
        case "${option}" in
            C) _compiler="${OPTARG}" ;;
            c) _compiler="${OPTARG}" ;;
            v) _verbose=true ;;
            V) _very_verbose=true && _verbose=true && _verbose_flag="-v" ;;
            d) _debug=true && _very_verbose=true && _verbose=true && PS4='${LINENO}: ' ;;
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

ln -sf ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env ${HOMEgfs}/dev/container/env
ln -sf ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/prefix ${HOMEgfs}/dev/container/prefix
cp ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/CONTAINER.env ${HOMEgfs}/env/CONTAINER.env
UMID="${MACHINE_ID^^}"
if [[ -f ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/${UMID}.env ]]; then
    cp ${HOMEgfs}/dev/container/hosts/${MACHINE_ID}/${compiler}/env/${UMID}.env ${HOMEgfs}/env/${UMID}.env
fi
source ${HOMEgfs}/env/CONTAINER.env

# shellcheck disable=SC2086
singularity shell -e ${CONTAINER_BINDINGS} "${CONTAINER_SIF}"
