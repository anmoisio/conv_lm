#!/bin/bash -e
#SBATCH --time=1:00:00
#SBATCH --mem=8G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load GCC
module load openfst

utils-old/prepare_lang.sh \
  "${EXPT_WORK_DIR}/dict/nosp" \
  '[oov]' \
  "${EXPT_WORK_DIR}/lang/nosp-old.tmp" \
  "${EXPT_WORK_DIR}/lang/nosp-old"
