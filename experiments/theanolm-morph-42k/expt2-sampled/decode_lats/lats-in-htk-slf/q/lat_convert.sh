#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
mkdir -p /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/${SLURM_ARRAY_TASK_ID}/ && lattice-align-words-lexicon --output-error-lats=true --output-if-empty=true /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/phones/align_lexicon.int /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lat.${SLURM_ARRAY_TASK_ID}.gz |" ark,t:- | utils/int2sym.pl -f 3 /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/words.txt | utils/convert_slf.pl - /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/${SLURM_ARRAY_TASK_ID}/ 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( mkdir -p /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/${SLURM_ARRAY_TASK_ID}/ && lattice-align-words-lexicon --output-error-lats=true --output-if-empty=true /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/phones/align_lexicon.int /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lat.${SLURM_ARRAY_TASK_ID}.gz |" ark,t:- | utils/int2sym.pl -f 3 /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp/words.txt | utils/convert_slf.pl - /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/${SLURM_ARRAY_TASK_ID}/  ) &>>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/log/lat_convert.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/q/done.56445.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 16G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/q/lat_convert.log -o /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/q/lat_convert.log --array 1-30 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/q/lat_convert.sh >>/scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_lats/lats-in-htk-slf/q/lat_convert.log 2>&1
