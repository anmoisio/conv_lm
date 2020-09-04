#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1-00
#SBATCH --mem=53G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

# Note: it might appear that this $lang directory is mismatched, and it is as
# far as the 'topo' is concerned, but this script doesn't read the 'topo' from
# the lang directory.
utils/mkgraph.sh --self-loop-scale 1.0 \
    "${EXPT_WORK_DIR}/../tdnn/lang/baseline-nosp" \
    "${EXPT_WORK_DIR}/models/tdnn_no_ivecs" \
    "${EXPT_WORK_DIR}/models/tdnn_no_ivecs/graph"
