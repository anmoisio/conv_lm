#!/bin/bash -e
#SBATCH --time=0:20:00
#SBATCH --mem=100M

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

"${UTILS_DIR}/prepare_lang.sh" \
  "${EXPT_WORK_DIR}/dict/nosp" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/nosp.tmp" \
  "${EXPT_WORK_DIR}/lang/nosp"
