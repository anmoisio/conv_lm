#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/mmi
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
compute-mfcc-feats --verbose=2 --config=conf/mfcc.conf scp,p:/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/wav_devel.${SLURM_ARRAY_TASK_ID}.scp ark:- | copy-feats --compress=true ark:- ark,scp:/scratch/work/moisioa3/conv_lm/experiments/mmi/mfcc/raw_mfcc_devel.${SLURM_ARRAY_TASK_ID}.ark,/scratch/work/moisioa3/conv_lm/experiments/mmi/mfcc/raw_mfcc_devel.${SLURM_ARRAY_TASK_ID}.scp 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( compute-mfcc-feats --verbose=2 --config=conf/mfcc.conf scp,p:/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/wav_devel.${SLURM_ARRAY_TASK_ID}.scp ark:- | copy-feats --compress=true ark:- ark,scp:/scratch/work/moisioa3/conv_lm/experiments/mmi/mfcc/raw_mfcc_devel.${SLURM_ARRAY_TASK_ID}.ark,/scratch/work/moisioa3/conv_lm/experiments/mmi/mfcc/raw_mfcc_devel.${SLURM_ARRAY_TASK_ID}.scp  ) 2>>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log >>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log
ret=$?
time2=`date +"%s"`
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/make_mfcc_devel.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/q/done.30705.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH,PYTHONPATH  --partition coin,batch --time 1:00:00 --mem-per-cpu 3G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/q/make_mfcc_devel.log -o /scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/q/make_mfcc_devel.log --array 1-10 /scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/q/make_mfcc_devel.sh >>/scratch/work/moisioa3/conv_lm/experiments/mmi/log/mfcc-devel/q/make_mfcc_devel.log 2>&1
