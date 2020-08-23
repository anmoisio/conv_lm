#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

stage=0
nj=30
train_set=am-train # you might set this to e.g. train.
test_sets="devel eval"
gmm=tri4b # This specifies a GMM-dir from the features of the type you're training the system on;
                         # it should contain alignments for 'train_set'.

num_threads_ubm=32
nj_extractor=10
# It runs a JOB with '-pe smp N', where N=$[threads*processes]
num_processes_extractor=4
num_threads_extractor=4

nnet3_affix=             # affix for exp/nnet3 directory to put iVector stuff in (e.g.
                         # in the tedlium recip it's _cleaned).

# local/nnet3/run_ivector_common.sh \
#   --stage $stage --nj $nj \
#   --train-set $train_set --gmm $gmm \
#   --num-threads-ubm $num_threads_ubm \
#   --nj-extractor $nj_extractor \
#   --num-processes-extractor $num_processes_extractor \
#   --num-threads-extractor $num_threads_extractor \
#   --nnet3-affix "$nnet3_affix"

for f in data/${train_set}/feats.scp ${gmm_dir}/final.mdl; do
  if [ ! -f $f ]; then
    echo "$0: expected file $f to exist"
    exit 1
  fi
done

if [ $stage -le 2 ] && [ -f data/${train_set}_sp_hires/feats.scp ]; then
  echo "$0: data/${train_set}_sp_hires/feats.scp already exists."
  echo " ... Please either remove it, or rerun this script with stage > 2."
  exit 1
fi

if [ $stage -le 1 ]; then
  echo "$0: preparing directory for speed-perturbed data"
  utils/data/perturb_data_dir_speed_3way.sh \
    data/${train_set} \
    data/${train_set}_sp
fi