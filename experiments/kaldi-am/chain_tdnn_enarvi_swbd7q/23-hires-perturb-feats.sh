#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module load sox
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir="${KALDI_ROOT}/.git/" log -n 1
echo

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

nj=30
train_set="am-train" # you might set this to e.g. train.
test_sets="devel eval"

gmm=tri3b # this is the source gmm-dir that we'll use for alignments; it
                    # should have alignments for the specified training data.

nnet3_affix=       # affix for exp dirs, e.g. it was _cleaned in tedlium.

gmm_dir=exp/${gmm}
ali_dir=exp/${gmm}_ali_${train_set}_sp

# low-resolution features and alignments,
if [ -f data/${train_set}_sp/feats.scp ] ; then
  echo "$0: data/${train_set}_sp/feats.scp already exists.  Refusing to overwrite the features "
  echo " to avoid wasting time.  Please remove the file and continue if you really mean this."
  exit 1;
fi

echo "$0: preparing directory for low-resolution speed-perturbed data (for alignment)"
utils/data/perturb_data_dir_speed_3way.sh \
  data/${train_set} \
  data/${train_set}_sp

echo "$0: making MFCC features for low-resolution speed-perturbed data (needed for alignments)"
steps/make_mfcc.sh --nj $nj --cmd "$train_cmd" \
  data/${train_set}_sp

steps/compute_cmvn_stats.sh \
  data/${train_set}_sp

echo "$0: fixing input data-dir to remove nonexistent features, in case some "
echo ".. speed-perturbed segments were too short."
utils/fix_data_dir.sh \
  data/${train_set}_sp


if [ -f $ali_dir/ali.1.gz ]; then
  echo "$0: alignments in $ali_dir appear to already exist.  Please either remove them "
  echo " ... or use a later --stage option."
  exit 1
fi
echo "$0: aligning with the perturbed low-resolution data"
steps/align_fmllr.sh --nj $nj --cmd "$train_cmd" \
  data/${train_set}_sp \
  data/lang \
  $gmm_dir \
  $ali_dir


# high-resolution features and i-vector extractor,
if [ -f data/${train_set}_sp_hires/feats.scp ]; then
  echo "$0: data/${train_set}_sp_hires/feats.scp already exists."
  echo " ... Please either remove it, or rerun this script with stage > 2."
  exit 1
fi

echo "$0: creating high-resolution MFCC features"

# this shows how you can split across multiple file-systems.  we'll split the
# MFCC dir across multiple locations.  You might want to be careful here, if you
# have multiple copies of Kaldi checked out and run the same recipe, not to let
# them overwrite each other.
# mfccdir=data/${train_set}_sp_hires/data
# if [[ $(hostname -f) == *.clsp.jhu.edu ]] && [ ! -d $mfccdir/storage ]; then
#   utils/create_split_dir.pl /export/b0{5,6,7,8}/$USER/kaldi-data/mfcc/wsj-$(date +'%m_%d_%H_%M')/s5/$mfccdir/storage $mfccdir/storage
# fi

for datadir in ${train_set}_sp ${test_sets}; do
  utils/copy_data_dir.sh \
    data/$datadir \
    data/${datadir}_hires
done

# do volume-perturbation on the training data prior to extracting hires
# features; this helps make trained nnets more invariant to test data volume.
utils/data/perturb_data_dir_volume.sh \
  data/${train_set}_sp_hires

for datadir in ${train_set}_sp ${test_sets}; do
  steps/make_mfcc.sh --nj $nj --mfcc-config conf/mfcc_hires.conf \
    --cmd "$train_cmd" \
    data/${datadir}_hires

  steps/compute_cmvn_stats.sh \
    data/${datadir}_hires
    
  utils/fix_data_dir.sh \
    data/${datadir}_hires
done