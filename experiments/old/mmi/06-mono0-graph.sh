#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=40G

source ../../scripts/run-expt.sh "${0}"

export LC_ALL=C

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" --mono \
  "${EXPT_WORK_DIR}/lang/train-nosp" \
  "${EXPT_WORK_DIR}/models/mono0" \
  "${EXPT_WORK_DIR}/models/mono0/graph-train-nosp"
