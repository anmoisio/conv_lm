#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module load sox
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

nj=30
train_set="am-train" # you might set this to e.g. train.
test_sets="devel eval"

# check whether high-res MFCC features exist
if [ -f data/${train_set}_sp_hires/feats.scp ]; then
  echo "$0: data/${train_set}_sp_hires/feats.scp already exists."
  echo " ... Please either remove it, or rerun this script with stage > 2."
  exit 1
fi

echo "$0: preparing directory for speed-perturbed data"
utils/data/perturb_data_dir_speed_3way.sh \
  data/${train_set} \
  data/${train_set}_sp


echo "$0: creating high-resolution MFCC features"
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
  steps/make_mfcc.sh --nj $nj \
    --mfcc-config conf/mfcc_hires.conf \
    --cmd "$train_cmd" \
    data/${datadir}_hires

  steps/compute_cmvn_stats.sh \
    data/${datadir}_hires

  utils/fix_data_dir.sh \
    data/${datadir}_hires
done