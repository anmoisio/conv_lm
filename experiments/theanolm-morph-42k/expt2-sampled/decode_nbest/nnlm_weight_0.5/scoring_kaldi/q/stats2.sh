#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
cat decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/per_utt | utils/scoring/wer_ops_details.pl --special-symbol '***' | sort -b -i -k 1,1 -k 4,4rn -k 2,2 -k 3,3 > decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/ops 
EOF
) >decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( cat decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/per_utt | utils/scoring/wer_ops_details.pl --special-symbol '***' | sort -b -i -k 1,1 -k 4,4rn -k 2,2 -k 3,3 > decode_nbest/nnlm_weight_0.5/scoring_kaldi/wer_details/ops  ) &>>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
echo '#' Finished at `date` with status $ret >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/log/stats2.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/done.63360
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch  --open-mode=append -e decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/stats2.log -o decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/stats2.log  /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/stats2.sh >>decode_nbest/nnlm_weight_0.5/scoring_kaldi/q/stats2.log 2>&1
