#!/bin/bash

# kaldi scripts
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/steps .
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/utils .
ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/local .

# for creating vocab from arpa LM
ln -s /scratch/work/moisioa3/conv_lm/elisa-asr-2019/conv_lm/common .

# link the acoustic model
exp_dir=/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain
model_dir=models/tdnn

mkdir -p ${model_dir}
cd ${model_dir}

ln -s ${exp_dir}/${model_dir}/final.mdl .
cp ${exp_dir}/${model_dir}/final.ie.id .
cp ${exp_dir}/${model_dir}/num_jobs .
cp ${exp_dir}/${model_dir}/frame_subsampling_factor .
cp ${exp_dir}/${model_dir}/tree .
cp ${exp_dir}/${model_dir}/cmvn_opts .
cd ../..

ln -s ${exp_dir}/ivectors .

cp -r ${exp_dir}/conf .
touch path.sh