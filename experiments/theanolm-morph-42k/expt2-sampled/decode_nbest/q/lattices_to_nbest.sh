#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
lattice-to-nbest --acoustic-scale=0.1 --n=50 "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel/lat.${SLURM_ARRAY_TASK_ID}.gz |" ark:- | lattice-rmali ark:- "ark:|gzip -c >decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz" 
EOF
) >decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( lattice-to-nbest --acoustic-scale=0.1 --n=50 "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel/lat.${SLURM_ARRAY_TASK_ID}.gz |" ark:- | lattice-rmali ark:- "ark:|gzip -c >decode_nbest/nbest_with_lmprobs.${SLURM_ARRAY_TASK_ID}.gz"  ) &>>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_nbest/log/lattices_to_nbest.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/q/done.71374.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH  --ntasks-per-node=1  -p shared --time 1:00:00 --mem-per-cpu 16G  --open-mode=append -e decode_nbest/q/lattices_to_nbest.log -o decode_nbest/q/lattices_to_nbest.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/q/lattices_to_nbest.sh >>decode_nbest/q/lattices_to_nbest.log 2>&1
