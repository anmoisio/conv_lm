#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/prepare_lang.sh" \
  "${EXPT_WORK_DIR}/dict/sp" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/sp.tmp" \
  "${EXPT_WORK_DIR}/lang/sp"
