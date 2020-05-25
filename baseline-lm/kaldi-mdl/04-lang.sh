#!/bin/bash -e
#SBATCH -t 00:15:00
#SBATCH --mem-per-cpu=6G

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load GCC
module load openfst

"${UTILS_DIR}/prepare_lang.sh" \
  "${EXPT_WORK_DIR}/dict" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/nosp.tmp" \
  "${EXPT_WORK_DIR}/lang/nosp"
