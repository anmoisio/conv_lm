#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"
set -e -o pipefail

# 7q is as 7p but a modified topology with resnet-style skip connections, more layers,
#  skinnier bottlenecks, removing the 3-way splicing and skip-layer splicing,
#  and re-tuning the learning rate and l2 regularize.  The configs are
#  standardized and substantially simplified.  There isn't any advantage in WER
#  on this setup; the advantage of this style of config is that it also works
#  well on smaller datasets, and we adopt this style here also for consistency.

# local/chain/compare_wer_general.sh --rt03 tdnn7p_sp tdnn7q_sp
# System                tdnn7p_sp tdnn7q_sp
# WER on train_dev(tg)      11.80     11.79
# WER on train_dev(fg)      10.77     10.84
# WER on eval2000(tg)        14.4      14.3
# WER on eval2000(fg)        13.0      12.9
# WER on rt03(tg)            17.5      17.6
# WER on rt03(fg)            15.3      15.2
# Final train prob         -0.057    -0.058
# Final valid prob         -0.069    -0.073
# Final train prob (xent)        -0.886    -0.894
# Final valid prob (xent)       -0.9005   -0.9106
# Num-parameters               22865188  18702628


# steps/info/chain_dir_info.pl exp/chain/tdnn7q_sp
# exp/chain/tdnn7q_sp: num-iters=394 nj=3..16 num-params=18.7M dim=40+100->6034 combine=-0.058->-0.057 (over 8) xent:train/valid[261,393,final]=(-1.20,-0.897,-0.894/-1.20,-0.919,-0.911) logprob:train/valid[261,393,final]=(-0.090,-0.059,-0.058/-0.098,-0.073,-0.073)

set -e

# configs for 'chain'
train_stage=-10
get_egs_stage=-10
speed_perturb=true
affix=7q
if [ -e data/rt03 ]; then maybe_rt03=rt03; else maybe_rt03= ; fi

decode_iter=
decode_nj=50

# training options
frames_per_eg=150,110,100
remove_egs=false
common_egs_dir=
xent_regularize=0.1
dropout_schedule='0,0@0.20,0.5@0.50,0'

test_online_decoding=false  # if true, it will run the last decoding stage.

# End configuration section.
echo "$0 $@"  # Print the command line for logging

. ./path.sh
. ./utils/parse_options.sh

suffix=
$speed_perturb && suffix=_sp
dir=exp/chain/tdnn${affix}${suffix}


# The iVector-extraction and feature-dumping parts are the same as the standard
# nnet3 setup, and you can skip them by setting "--stage 8" if you have already
# run those things.

train_set=am-train
ali_dir=../chain_tdnn_enarvi_swbd7q/exp/tri3b_mmi_b0.1_ali
treedir=exp/chain/tree
lang=../chain_tdnn_enarvi_swbd7q/data/lang_chain_nospeed

# Create a version of the lang/ directory that has one state per phone in the
# topo file. [note, it really has two states.. the first one is only repeated
# once, the second one has zero or more repeats.]
# rm -rf $lang
# cp -r data/lang $lang
# silphonelist=$(cat $lang/phones/silence.csl) || exit 1;
# nonsilphonelist=$(cat $lang/phones/nonsilence.csl) || exit 1;
# Use our special topology... note that later on may have to tune this
# topology.
# steps/nnet3/chain/gen_topo.py \
#   $nonsilphonelist \
#   $silphonelist \
#   >$lang/topo

# Build a tree using our new topology. This is the critically different
# step compared with other recipes.
steps/nnet3/chain/build_tree.sh --frame-subsampling-factor 3 \
    --context-opts "--context-width=2 --central-position=1" \
    --cmd "$train_cmd" \
    7000 \
    ../chain_tdnn_enarvi_swbd7q/data/$train_set \
    $lang \
    $ali_dir \
    $treedir
