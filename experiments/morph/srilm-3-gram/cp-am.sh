#!/bin/bash

# kaldi scripts
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/steps .
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/utils .
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/local .

# for creating vocab from arpa LM
ln -s /scratch/work/moisioa3/conv_lm/elisa-asr-2019/conv_lm/common .

# link the acoustic model
mkdir -p models/tdnn
cd models/tdnn
ln -s /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/final.mdl .
cp /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/final.ie.id .
cp /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/num_jobs .
cp /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/frame_subsampling_factor .
cp /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/tree .
cp /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/models/tdnn/cmvn_opts .
cd ../..

ln -s /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/ivectors .

cp -r /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain/conf .
touch path.sh