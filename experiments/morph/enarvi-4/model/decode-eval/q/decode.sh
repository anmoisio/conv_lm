#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
nnet3-latgen-faster --online-ivectors=scp:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/ivectors/eval/ivector_online.scp --online-ivector-period=10 --frames-per-chunk=50 --extra-left-context=0 --extra-right-context=0 --extra-left-context-initial=-1 --extra-right-context-final=-1 --minimize=false --max-active=7000 --min-active=200 --beam=15.0 --lattice-beam=8.0 --acoustic-scale=1.0 --allow-partial=true --word-symbol-table=/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph/words.txt /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/final.mdl /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph/HCLG.fst "ark,s,cs:apply-cmvn --norm-means=false --norm-vars=false --utt2spk=ark:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/utt2spk scp:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/cmvn.scp scp:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/feats.scp ark:- |" "ark:|lattice-scale --acoustic-scale=10.0 ark:- ark:- | gzip -c >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/lat.${SLURM_ARRAY_TASK_ID}.gz" 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( nnet3-latgen-faster --online-ivectors=scp:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/ivectors/eval/ivector_online.scp --online-ivector-period=10 --frames-per-chunk=50 --extra-left-context=0 --extra-right-context=0 --extra-left-context-initial=-1 --extra-right-context-final=-1 --minimize=false --max-active=7000 --min-active=200 --beam=15.0 --lattice-beam=8.0 --acoustic-scale=1.0 --allow-partial=true --word-symbol-table=/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph/words.txt /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/final.mdl /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph/HCLG.fst "ark,s,cs:apply-cmvn --norm-means=false --norm-vars=false --utt2spk=ark:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/utt2spk scp:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/cmvn.scp scp:/scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/split8/${SLURM_ARRAY_TASK_ID}/feats.scp ark:- |" "ark:|lattice-scale --acoustic-scale=10.0 ark:- ark:- | gzip -c >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/lat.${SLURM_ARRAY_TASK_ID}.gz"  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/decode.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/done.36159.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/decode.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/decode.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/decode.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/decode.log 2>&1
