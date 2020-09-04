#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir="${KALDI_ROOT}/.git/" log -n 1 --pretty=oneline 
echo

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

# Take a subset of 4000 utterances.
utils/subset_data_dir.sh \
  data/am-train \
  4000 \
  data/am-train-4k

# align speaker-independent model
steps/align_si.sh --nj 10 --cmd "$train_cmd" \
  data/am-train-4k \
  data/lang_nosp \
  exp/mono0a \
  exp/mono0a_ali || exit 1;

# deltas
steps/train_deltas.sh --cmd "$train_cmd" \
  2000 10000 \
  data/am-train-4k \
  data/lang_nosp \
  exp/mono0a_ali \
  exp/tri1 || exit 1;


