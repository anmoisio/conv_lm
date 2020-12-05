#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
cat decode_lats/scoring_kaldi/penalty_0.0/${SLURM_ARRAY_TASK_ID}.txt | compute-wer --text --mode=present ark:decode_lats/scoring_kaldi/test_filt.txt ark,p:- >& decode_lats/wer_${SLURM_ARRAY_TASK_ID}_0.0 
EOF
) >decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( cat decode_lats/scoring_kaldi/penalty_0.0/${SLURM_ARRAY_TASK_ID}.txt | compute-wer --text --mode=present ark:decode_lats/scoring_kaldi/test_filt.txt ark,p:- >& decode_lats/wer_${SLURM_ARRAY_TASK_ID}_0.0  ) &>>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_lats/scoring_kaldi/penalty_0.0/log/score.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_lats/scoring_kaldi/penalty_0.0/q/done.41110.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch  --open-mode=append -e decode_lats/scoring_kaldi/penalty_0.0/q/score.log -o decode_lats/scoring_kaldi/penalty_0.0/q/score.log --array 7-17 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/scoring_kaldi/penalty_0.0/q/score.sh >>decode_lats/scoring_kaldi/penalty_0.0/q/score.log 2>&1
