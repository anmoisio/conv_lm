#!/bin/bash -e
#SBATCH --time=1:00:00
#SBATCH --mem=10G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load GCC
module load openfst

"${UTILS_DIR}/prepare_lang.sh" \
  "${EXPT_WORK_DIR}/dict/baseline" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/nosp.tmp" \
  "${EXPT_WORK_DIR}/lang/nosp"
