#!/bin/bash

# cd pwd

# copy Kaldi AM to another experiment directory

# kaldi scripts
# ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/steps .
# ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/utils .
# ln -s /scratch/work/moisioa3/conv_lm/kaldi/egs/wsj/s5/local .

# for creating vocab from arpa LM
# ln -s /scratch/work/moisioa3/conv_lm/elisa-asr-2019/conv_lm/common .

# link the acoustic model
# exp_dir=/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/chain
# model_dir=models/tdnn

# mkdir -p ${model_dir}
# cd ${model_dir}

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

ln -s ${am_dir}/${am}/final.mdl .
# cp ${am_dir}/${am}/final.ie.id .
cp ${am_dir}/${am}/num_jobs .
cp ${am_dir}/${am}/frame_subsampling_factor .
cp ${am_dir}/${am}/tree .
cp ${am_dir}/${am}/cmvn_opts .
# cd ../..

# ln -s ${exp_dir}/ivectors .

# cp -r ${exp_dir}/conf .
# touch path.sh