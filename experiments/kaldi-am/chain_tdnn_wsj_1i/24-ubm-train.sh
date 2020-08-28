#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

nj=30
train_set="am-train" # you might set this to e.g. train.
test_sets="devel eval"

num_threads_ubm=32
nnet3_affix=    # affix for exp/nnet3 directory to put iVector stuff in (e.g.
                # in the tedlium recip it's _cleaned).


echo "$0: computing a subset of data to train the diagonal UBM."
mkdir -p exp/nnet3${nnet3_affix}/diag_ubm
temp_data_root=exp/nnet3${nnet3_affix}/diag_ubm

# train a diagonal UBM using a subset of about a quarter of the data
num_utts_total=$(wc -l <data/${train_set}_sp_hires/utt2spk)
num_utts=$[$num_utts_total/4]
utils/data/subset_data_dir.sh \
    data/${train_set}_sp_hires \
    $num_utts \
    ${temp_data_root}/${train_set}_sp_hires_subset

echo "$0: computing a PCA transform from the hires data."
steps/online/nnet2/get_pca_transform.sh --cmd "$train_cmd" \
    --splice-opts "--left-context=3 --right-context=3" \
    --max-utts 10000 --subsample 2 \
    ${temp_data_root}/${train_set}_sp_hires_subset \
    exp/nnet3${nnet3_affix}/pca_transform

echo "$0: training the diagonal UBM."
# Use 512 Gaussians in the UBM.
steps/online/nnet2/train_diag_ubm.sh --cmd "$train_cmd" --nj 1 \
    --num-frames 700000 \
    --num-threads 1 \
    ${temp_data_root}/${train_set}_sp_hires_subset 512 \
    exp/nnet3${nnet3_affix}/pca_transform \
    exp/nnet3${nnet3_affix}/diag_ubm

