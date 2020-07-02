#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/prune-functions.sh"

module purge
module load srilm
module load AaltoASR
module load speech-scripts

convert_kn
