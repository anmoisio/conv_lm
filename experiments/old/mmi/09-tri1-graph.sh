#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=21G

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" \
  "${EXPT_WORK_DIR}/lang/train-nosp" \
  "${EXPT_WORK_DIR}/models/tri1" \
  "${EXPT_WORK_DIR}/models/tri1/graph-train-nosp"