#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

# print Kaldi repo version for logging
echo 'Kaldi version:'
git --no-pager --git-dir=/scratch/work/moisioa3/conv_lm/kaldi/.git/ log -n 1
echo

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

nj=30
train_set="am-train" # you might set this to e.g. train.
test_sets="devel eval"
gmm=tri3b_mmi_b0.1 # This specifies a GMM-dir from the features of the type you're training the system on;
          # it should contain alignments for 'train_set'.

nj_extractor=10
# It runs a JOB with '-pe smp N', where N=$[threads*processes]
num_processes_extractor=1
num_threads_extractor=1

online_cmvn_iextractor=false

nnet3_affix=    # affix for exp/nnet3 directory to put iVector stuff in (e.g.
                # in the tedlium recip it's _cleaned).

gmm_dir=exp/${gmm}
ali_dir=exp/${gmm}_ali_${train_set}_sp


# Train the iVector extractor.  Use all of the speed-perturbed data since iVector extractors
# can be sensitive to the amount of data.  The script defaults to an iVector dimension of
# 100.
echo "$0: training the iVector extractor"
steps/online/nnet2/train_ivector_extractor.sh --cmd "$train_cmd" \
  --online-cmvn-iextractor $online_cmvn_iextractor \
  --nj $nj_extractor --num-threads $num_threads_extractor --num-processes $num_processes_extractor \
  data/${train_set}_sp_hires exp/nnet3${nnet3_affix}/diag_ubm_700k exp/nnet3${nnet3_affix}/extractor_new || exit 1;


# note, we don't encode the 'max2' in the name of the ivectordir even though
# that's the data we extract the ivectors from, as it's still going to be
# valid for the non-'max2' data; the utterance list is the same.
ivectordir=exp/nnet3${nnet3_affix}/ivectors_${train_set}_sp_hires_new
# if [[ $(hostname -f) == *.clsp.jhu.edu ]] && [ ! -d $ivectordir/storage ]; then
#   utils/create_split_dir.pl /export/b0{5,6,7,8}/$USER/kaldi-data/ivectors/wsj-$(date +'%m_%d_%H_%M')/s5/$ivectordir/storage $ivectordir/storage
# fi

# We now extract iVectors on the speed-perturbed training data .  With
# --utts-per-spk-max 2, the script pairs the utterances into twos, and treats
# each of these pairs as one speaker; this gives more diversity in iVectors..
# Note that these are extracted 'online' (they vary within the utterance).

# Having a larger number of speakers is helpful for generalization, and to
# handle per-utterance decoding well (the iVector starts at zero at the beginning
# of each pseudo-speaker).
temp_data_root=${ivectordir}
utils/data/modify_speaker_info.sh \
  --utts-per-spk-max 2 \
  data/${train_set}_sp_hires \
  ${temp_data_root}/${train_set}_sp_hires_max2_new

steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj $nj \
  ${temp_data_root}/${train_set}_sp_hires_max2_new \
  exp/nnet3${nnet3_affix}/extractor_new $ivectordir

# Also extract iVectors for the test data, but in this case we don't need the speed
# perturbation (sp).
for data in ${test_sets}; do
  nspk=$(wc -l <data/${data}_hires/spk2utt)
  steps/online/nnet2/extract_ivectors_online.sh --cmd "$train_cmd" --nj 1 \
      data/${data}_hires \
      exp/nnet3${nnet3_affix}/extractor_new \
      exp/nnet3${nnet3_affix}/ivectors_${data}_hires_new
done
