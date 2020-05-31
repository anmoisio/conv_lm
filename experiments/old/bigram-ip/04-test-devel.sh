#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load AaltoASR
module load srilm

export GENERATE_LATTICES="1"
export RECTOOL_OUTPUT_DIR="${EXPT_WORK_DIR}/lattices/devel"
eval_kn devel kn-ip | tee "${EXPT_SCRIPT_DIR}/test-devel.log"

find "${RECTOOL_OUTPUT_DIR}" -name '*-rescored.slf' |
  sort \
  >"${RECTOOL_OUTPUT_DIR}/lattice-list"