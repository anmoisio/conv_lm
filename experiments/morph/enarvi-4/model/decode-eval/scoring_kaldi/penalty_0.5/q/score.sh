#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
cat /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/${SLURM_ARRAY_TASK_ID}.txt | compute-wer --text --mode=present ark:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/test_filt.txt ark,p:- >& /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/wer_${SLURM_ARRAY_TASK_ID}_0.5 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( cat /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/${SLURM_ARRAY_TASK_ID}.txt | compute-wer --text --mode=present ark:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/test_filt.txt ark,p:- >& /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/wer_${SLURM_ARRAY_TASK_ID}_0.5  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/log/score.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/q/done.38233.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/q/score.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/q/score.log --array 9-20 /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/q/score.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_0.5/q/score.log 2>&1
