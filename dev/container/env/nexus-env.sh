#!/bin/bash

source /usr/lmod/lmod/init/bash
module use "${containerHOMEglobal}/sorc/nexus.fd/modulefiles"
module load nexus_container.intel

if [[ $# -gt 0 ]]; then
    "$@"
fi
