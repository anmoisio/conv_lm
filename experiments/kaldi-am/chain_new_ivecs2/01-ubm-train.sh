#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

nj=30
train_set="am-train"
test_sets="devel eval"

num_threads_ubm=32
nnet3_affix=    # affix for exp/nnet3 directory to put iVector stuff in (e.g.
                # in the tedlium recip it's _cleaned).


# echo "$0: computing a subset of data to train the diagonal UBM."
mkdir -p exp/nnet3${nnet3_affix}/diag_ubm_700k
temp_data_root=exp/nnet3${nnet3_affix}/diag_ubm_700k

# train a diagonal UBM using a subset of about a quarter of the data
# num_utts_total=$(wc -l <../mmi/data/am-train/utt2spk)
# num_utts=$[$num_utts_total/4]
# utils/data/subset_data_dir.sh \
#     ../mmi/data/am-train \
#     $num_utts \
#     ${temp_data_root}/${train_set}_subset

# echo "$0: computing a PCA transform from the hires data."
# steps/online/nnet2/get_pca_transform.sh --cmd "$train_cmd" \
#     --splice-opts "--left-context=3 --right-context=3" \
#     --max-utts 10000 --subsample 2 \
#     ${temp_data_root}/${train_set}_subset \
#     exp/nnet3${nnet3_affix}/pca_transform

steps/train_lda_mllt.sh --cmd "$train_cmd" \
  --num-iters 13 \
  --realign-iters "" \
  --splice-opts "--left-context=3 --right-context=3" \
  5000 10000 \
  ../mmi/data/am-train \
  ../chain_tdnn_enarvi_swbd7q/data/lang_train \
  ../chain_tdnn_enarvi_swbd7q/exp/tri3b_mmi_b0.1_ali \
  exp/small

echo "$0: training the diagonal UBM."
# Use 512 Gaussians in the UBM.
steps/online/nnet2/train_diag_ubm.sh --cmd "$train_cmd" --nj 30 \
    --num-frames 400000 \
    --num-threads 16 \
    ../mmi/data/am-train 256 \
    exp/small \
    exp/nnet3${nnet3_affix}/diag_ubm_700k

