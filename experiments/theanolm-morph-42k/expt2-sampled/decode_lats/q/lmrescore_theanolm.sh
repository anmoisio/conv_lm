#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel-nj30/lat.${SLURM_ARRAY_TASK_ID}.gz | lattice-prune --inv-acoustic-scale=10 --beam=8 ark:- ark:- | lattice-lmrescore-const-arpa --lm-scale=-1.0 ark:- lang_new/G.carpa ark,t:- | theanolm decode nnlm.h5 --lattice-format kaldi --kaldi-vocabulary lang_new/words.txt --output kaldi --nnlm-weight 0.5 --lm-scale 20 --max-tokens-per-node 62 --beam 650 --recombination-order 22 --shortlist --log-file decode_lats/log/theanolm_decode.${SLURM_ARRAY_TASK_ID}.log --log-level debug | lattice-minimize ark:- ark:- | gzip -c >decode_lats/lat.${SLURM_ARRAY_TASK_ID}.gz 
EOF
) >decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/models/tdnn/decode-devel-nj30/lat.${SLURM_ARRAY_TASK_ID}.gz | lattice-prune --inv-acoustic-scale=10 --beam=8 ark:- ark:- | lattice-lmrescore-const-arpa --lm-scale=-1.0 ark:- lang_new/G.carpa ark,t:- | theanolm decode nnlm.h5 --lattice-format kaldi --kaldi-vocabulary lang_new/words.txt --output kaldi --nnlm-weight 0.5 --lm-scale 20 --max-tokens-per-node 62 --beam 650 --recombination-order 22 --shortlist --log-file decode_lats/log/theanolm_decode.${SLURM_ARRAY_TASK_ID}.log --log-level debug | lattice-minimize ark:- ark:- | gzip -c >decode_lats/lat.${SLURM_ARRAY_TASK_ID}.gz  ) &>>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_lats/log/lmrescore_theanolm.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_lats/q/done.1408.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 3-00 --mem-per-cpu 16G  --open-mode=append -e decode_lats/q/lmrescore_theanolm.log -o decode_lats/q/lmrescore_theanolm.log --array 1-30 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/q/lmrescore_theanolm.sh >>decode_lats/q/lmrescore_theanolm.log 2>&1
