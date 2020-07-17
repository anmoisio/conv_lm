#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/phone_stats.*.gz | steps/diagnostic/analyze_phone_length_stats.py /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/phone_stats.*.gz | steps/diagnostic/analyze_phone_length_stats.py /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/graph  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/analyze_alignments.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/done.35013
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/analyze_alignments.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/analyze_alignments.log  /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/analyze_alignments.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/analyze_alignments.log 2>&1
