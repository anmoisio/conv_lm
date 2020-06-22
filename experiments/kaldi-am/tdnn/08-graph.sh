#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G
#SBATCH --dependency=afterok:53600156

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" \
  "${EXPT_WORK_DIR}/lang/baseline-nosp" \
  "${EXPT_WORK_DIR}/models/tdnn" \
  "${EXPT_WORK_DIR}/models/tdnn/graph-baseline"
