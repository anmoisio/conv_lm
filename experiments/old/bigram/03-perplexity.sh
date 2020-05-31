#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

perplexity_kn
