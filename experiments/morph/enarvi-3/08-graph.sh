#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load openfst

"${UTILS_DIR}/mkgraph.sh" \
  "${EXPT_WORK_DIR}/lang/train-nosp" \
  "/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/tdnn/models/tdnn" \
  "${EXPT_WORK_DIR}/graph"
