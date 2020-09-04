#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"
cd "${EXPT_SCRIPT_DIR}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir="${KALDI_ROOT}/.git/" log -n 1 --pretty=oneline 
echo

decode=false

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

# Make a subset with the shortest 2000 utterances.
utils/subset_data_dir.sh --shortest \
    data/am-train \
    2000 \
    data/am-train-2kshort

# Note: the --boost-silence option should probably be omitted by default
# for normal setups.  It doesn't always help. [it's to discourage non-silence
# models from modeling silence.]
steps/train_mono.sh --nj 10 --cmd "$train_cmd" \
    data/am-train-2kshort \
    data/lang_nosp \
    exp/mono0a
