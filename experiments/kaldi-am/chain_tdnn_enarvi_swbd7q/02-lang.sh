#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list 

# print Kaldi repo version for logging
echo 'Kaldi scripts version:'
git --no-pager --git-dir=/scratch/work/moisioa3/conv_lm/kaldi/.git/ log -n 1 --pretty=oneline 
echo

utils/prepare_lang.sh data/local/dict \
  "[oov]" \
  data/local/lang_tmp_nosp \
  data/lang_nosp
