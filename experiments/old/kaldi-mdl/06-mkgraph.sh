#!/bin/bash -e
#SBATCH --time=1:30:00
#SBATCH --mem=44G

export LC_ALL=C

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" \
  "${EXPT_WORK_DIR}/lang/fullvocab-nosp" \
  "${MODEL_DIR}" \
  "${MODEL_DIR}/graph-fullvocab"
