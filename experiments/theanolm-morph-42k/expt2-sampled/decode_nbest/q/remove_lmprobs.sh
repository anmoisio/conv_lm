#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
lattice-scale --acoustic-scale=-1 --lm-scale=-1 "ark:gunzip -c decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz |" ark:- | lattice-compose ark:- "fstproject --project_output=true /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/G.fst |" ark:- | lattice-1best ark:- ark:- | lattice-scale --acoustic-scale=-1 --lm-scale=-1 ark:- "ark:| gzip -c >decode_nbest/nbest_without_lmprobs.${SLURM_ARRAY_TASK_ID}.gz" 
EOF
) >decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( lattice-scale --acoustic-scale=-1 --lm-scale=-1 "ark:gunzip -c decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz |" ark:- | lattice-compose ark:- "fstproject --project_output=true /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/G.fst |" ark:- | lattice-1best ark:- ark:- | lattice-scale --acoustic-scale=-1 --lm-scale=-1 ark:- "ark:| gzip -c >decode_nbest/nbest_without_lmprobs.${SLURM_ARRAY_TASK_ID}.gz"  ) &>>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_nbest/log/remove_lmprobs.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/q/done.57544.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 16G  --open-mode=append -e decode_nbest/q/remove_lmprobs.log -o decode_nbest/q/remove_lmprobs.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/q/remove_lmprobs.sh >>decode_nbest/q/remove_lmprobs.log 2>&1
