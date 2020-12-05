#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
compute-wer-bootci --mode=present ark:decode_nbest/nnlm_weight_0.5/scoring_kaldi/test_filt.txt ark:decode_nbest/nnlm_weight_0.5/scoring_kaldi/penalty_0.0/9.txt > decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/wer_bootci 
EOF
) >decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( compute-wer-bootci --mode=present ark:decode_nbest/nnlm_weight_0.5/scoring_kaldi/test_filt.txt ark:decode_nbest/nnlm_weight_0.5/scoring_kaldi/penalty_0.0/9.txt > decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/wer_bootci  ) &>>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
echo '#' Finished at `date` with status $ret >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/wer_bootci.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/done.63411
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch  --open-mode=append -e decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/wer_bootci.log -o decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/wer_bootci.log  /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/wer_bootci.sh >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/wer_bootci.log 2>&1
