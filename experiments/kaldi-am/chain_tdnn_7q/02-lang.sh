#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list 

utils/prepare_lang.sh data/local/dict \
  "[oov]" \
  data/local/lang_tmp_nosp \
  data/lang_nosp
