#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir=/scratch/work/moisioa3/conv_lm/kaldi/.git/ log -n 1
echo

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"
  
steps/align_fmllr.sh --nj 30 --cmd "${train_cmd}" \
  data/am-train_sp \
  data/lang \
  exp/tri3b_mmi_b0.1 \
  exp/tri3b_mmi_b0.1_ali_sp