#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
nbest-to-linear "ark:gunzip -c decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz |" ark:/dev/null ark:/dev/null ark,t:decode_nbest/text_archives/${SLURM_ARRAY_TASK_ID}/scores.graph ark:/dev/null 
EOF
) >decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( nbest-to-linear "ark:gunzip -c decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz |" ark:/dev/null ark:/dev/null ark,t:decode_nbest/text_archives/${SLURM_ARRAY_TASK_ID}/scores.graph ark:/dev/null  ) &>>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_nbest/log/text_with_lmprobs.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/q/done.59319.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 16G  --open-mode=append -e decode_nbest/q/text_with_lmprobs.log -o decode_nbest/q/text_with_lmprobs.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/q/text_with_lmprobs.sh >>decode_nbest/q/text_with_lmprobs.log 2>&1
