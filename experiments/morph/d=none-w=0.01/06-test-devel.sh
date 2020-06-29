#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load AaltoASR
module load srilm
module load anaconda2

eval_kn devel | tee "${EXPT_SCRIPT_DIR}/test-devel.log"
