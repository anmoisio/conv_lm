#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=29G

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" \
  "${EXPT_WORK_DIR}/lang/train-nosp" \
  "${EXPT_WORK_DIR}/models/mmi-nosp" \
  "${EXPT_WORK_DIR}/models/mmi-nosp/graph-train-nosp2"
