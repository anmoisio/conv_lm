#!/bin/bash -e

module purge
module load srilm
module load AaltoASR
module load speech-scripts

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/prune-functions.sh"

convert_kn "kn-ip"