#!/bin/bash
# Estimate pronunciation and silence probabilities.

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

cd "${EXPT_SCRIPT_DIR}"

# Silprob for normal lexicon.
steps/get_prons.sh --cmd "$train_cmd" \
    data/am-train \
    data/lang_nosp \
    exp/tri3b || exit 1;

utils/dict_dir_add_pronprobs.sh \
    --max-normalize true \
    data/local/dict_nosp \
    exp/tri3b/pron_counts_nowb.txt \
    exp/tri3b/sil_counts_nowb.txt \
    exp/tri3b/pron_bigram_counts_nowb.txt \
    data/local/dict || exit 1
