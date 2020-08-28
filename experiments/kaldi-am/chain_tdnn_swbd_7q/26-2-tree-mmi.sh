#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir="${KALDI_ROOT}/.git/" log -n 1 --pretty=oneline 
echo

cd "${EXPT_SCRIPT_DIR}"

set -e -o pipefail

# First the options that are passed through to run_ivector_common.sh
# (some of which are also used in this script directly).
nj=30
train_set=am-train
test_sets="devel eval"


# End configuration section.
echo "$0 $@"  # Print the command line for logging

. ./path.sh
. ./utils/parse_options.sh


if ! cuda-compiled; then
  cat <<EOF && exit 1
This script is intended to be used with GPUs but you have not compiled Kaldi with CUDA
If you want to use GPUs (and have them), go to src/, and configure and make on a machine
where "nvcc" is installed.
EOF
fi

gmm=tri4b_mmi_b0.1 # this is the source gmm-dir that we'll use for alignments; it
                 # should have alignments for the specified training data.

nnet3_affix=       # affix for exp dirs, e.g. it was _cleaned in tedlium.
gmm_dir=exp/${gmm}
ali_dir=exp/${gmm}_ali_${train_set}_sp
lat_dir=exp/chain${nnet3_affix}/${gmm}_${train_set}_sp_lats
dir=exp/chain${nnet3_affix}/tdnn${affix}_sp
train_data_dir=data/${train_set}_sp_hires
train_ivector_dir=exp/nnet3${nnet3_affix}/ivectors_${train_set}_sp_hires
lores_train_data_dir=data/${train_set}_sp

# note: you don't necessarily have to change the treedir name
# each time you do a new experiment-- only if you change the
# configuration in a way that affects the tree.
tree_dir=exp/chain${nnet3_affix}/tree_mmi_sp
# the 'lang' directory is created by this script.
# If you create such a directory with a non-standard topology
# you should probably name it differently.
lang=data/lang_chain_mmi

# alignments for the MMI model
steps/align_fmllr.sh --nj 10 --cmd "$train_cmd" \
  data/am-train \
  data/lang \
  exp/tri4b_mmi_b0.1 \
  exp/tri4b_mmi_b0.1_ali_${train_set}_sp

for f in $train_data_dir/feats.scp $train_ivector_dir/ivector_online.scp \
    $lores_train_data_dir/feats.scp $gmm_dir/final.mdl \
    $ali_dir/ali.1.gz $gmm_dir/final.mdl; do
  [ ! -f $f ] && echo "$0: expected file $f to exist" && exit 1
done

echo "$0: creating lang directory $lang with chain-type topology"
# Create a version of the lang/ directory that has one state per phone in the
# topo file. [note, it really has two states.. the first one is only repeated
# once, the second one has zero or more repeats.]
if [ -d $lang ]; then
  if [ $lang/L.fst -nt data/lang/L.fst ]; then
    echo "$0: $lang already exists, not overwriting it; continuing"
  else
    echo "$0: $lang already exists and seems to be older than data/lang..."
    echo " ... not sure what to do.  Exiting."
    exit 1;
  fi
else
  cp -r data/lang $lang
  silphonelist=$(cat $lang/phones/silence.csl) || exit 1;
  nonsilphonelist=$(cat $lang/phones/nonsilence.csl) || exit 1;
  # Use our special topology... note that later on may have to tune this
  # topology.
  steps/nnet3/chain/gen_topo.py \
    $nonsilphonelist \
    $silphonelist \
    >$lang/topo
fi

# Get the alignments as lattices (gives the chain training more freedom).
# use the same num-jobs as the alignments
steps/align_fmllr_lats.sh --nj $nj --cmd "$train_cmd" \
  ${lores_train_data_dir} \
  data/lang \
  $gmm_dir \
  $lat_dir

rm $lat_dir/fsts.*.gz # save space

# Build a tree using our new topology.  We know we have alignments for the
# speed-perturbed data (local/nnet3/run_ivector_common.sh made them), so use
# those.  The num-leaves is always somewhat less than the num-leaves from
# the GMM baseline.
  if [ -f $tree_dir/final.mdl ]; then
    echo "$0: $tree_dir/final.mdl already exists, refusing to overwrite it."
    exit 1;
fi
steps/nnet3/chain/build_tree.sh \
  --frame-subsampling-factor 3 \
  --context-opts "--context-width=2 --central-position=1" \
  --cmd "$train_cmd" \
  3500 \
  ${lores_train_data_dir} \
  $lang \
  $ali_dir \
  $tree_dir

