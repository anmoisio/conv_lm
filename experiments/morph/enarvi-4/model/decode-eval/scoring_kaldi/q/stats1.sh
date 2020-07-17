#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
cat /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_1.0/20.txt | align-text --special-symbol='***' ark:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/test_filt.txt ark:- ark,t:- | utils/scoring/wer_per_utt_details.pl --special-symbol '***' | tee /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/wer_details/per_utt | utils/scoring/wer_per_spk_details.pl /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/utt2spk > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/wer_details/per_spk 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( cat /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/penalty_1.0/20.txt | align-text --special-symbol='***' ark:/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/test_filt.txt ark:- ark,t:- | utils/scoring/wer_per_utt_details.pl --special-symbol '***' | tee /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/wer_details/per_utt | utils/scoring/wer_per_spk_details.pl /scratch/work/moisioa3/conv_lm/experiments/kaldi-am/mmi/data/eval/utt2spk > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/wer_details/per_spk  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/log/stats1.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/q/done.38665
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/q/stats1.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/q/stats1.log  /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/q/stats1.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/scoring_kaldi/q/stats1.log 2>&1
