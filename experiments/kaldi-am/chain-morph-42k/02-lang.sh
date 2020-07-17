#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load GCC
module load openfst

"${UTILS_DIR}/prepare_lang.sh" \
  "${EXPT_WORK_DIR}/dict/nosp" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/nosp.tmp" \
  "${EXPT_WORK_DIR}/lang/nosp"