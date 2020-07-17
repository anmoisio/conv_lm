#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
ali-to-phones --per-frame=true /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/../final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/ali_tmp.${SLURM_ARRAY_TASK_ID}.gz|" ark,t:- | paste /dev/stdin <( gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/depth_tmp.${SLURM_ARRAY_TASK_ID}.gz ) | perl -ane '$half=@F/2;for($i=1;$i<$half;$i++){$j=$i+$half;$count{$F[$i]." ".$F[$j]}++;}
  END{for $k (sort keys %count){print "$k $count{$k}\n"}}' | gzip -c > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/depth_stats_tmp.${SLURM_ARRAY_TASK_ID}.gz 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( ali-to-phones --per-frame=true /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/../final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/ali_tmp.${SLURM_ARRAY_TASK_ID}.gz|" ark,t:- | paste /dev/stdin <( gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/depth_tmp.${SLURM_ARRAY_TASK_ID}.gz ) | perl -ane '$half=@F/2;for($i=1;$i<$half;$i++){$j=$i+$half;$count{$F[$i]." ".$F[$j]}++;}
  END{for $k (sort keys %count){print "$k $count{$k}\n"}}' | gzip -c > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/depth_stats_tmp.${SLURM_ARRAY_TASK_ID}.gz  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/log/lattice_best_path.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/done.37749.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/lattice_best_path.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/lattice_best_path.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/lattice_best_path.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-eval/q/lattice_best_path.log 2>&1
