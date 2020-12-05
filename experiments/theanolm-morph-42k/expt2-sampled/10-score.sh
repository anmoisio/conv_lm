#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"

local/score.sh \
  --cmd utils/slurm.pl \
  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/devel" \
  /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph \
  decode_lats_interpolated_new3