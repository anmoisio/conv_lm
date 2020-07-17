#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
ali-to-phones --write-lengths=true /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/../final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/ali_tmp.${SLURM_ARRAY_TASK_ID}.gz|" ark,t:- | perl -ne 'chomp;s/^\S+\s*//;@a=split /\s;\s/, $_;$count{"begin ".$a[$0]."\n"}++;
  if(@a>1){$count{"end ".$a[-1]."\n"}++;}for($i=0;$i<@a;$i++){$count{"all ".$a[$i]."\n"}++;}
  END{for $k (sort keys %count){print "$count{$k} $k"}}' | gzip -c > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/phone_stats.${SLURM_ARRAY_TASK_ID}.gz 
EOF
) >/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( ali-to-phones --write-lengths=true /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/../final.mdl "ark:gunzip -c /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/ali_tmp.${SLURM_ARRAY_TASK_ID}.gz|" ark,t:- | perl -ne 'chomp;s/^\S+\s*//;@a=split /\s;\s/, $_;$count{"begin ".$a[$0]."\n"}++;
  if(@a>1){$count{"end ".$a[-1]."\n"}++;}for($i=0;$i<@a;$i++){$count{"all ".$a[$i]."\n"}++;}
  END{for $k (sort keys %count){print "$count{$k} $k"}}' | gzip -c > /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/phone_stats.${SLURM_ARRAY_TASK_ID}.gz  ) &>>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/log/get_lattice_stats.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/done.34987.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch --time 1:00:00 --mem-per-cpu 10G  --open-mode=append -e /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/get_lattice_stats.log -o /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/get_lattice_stats.log --array 1-8 /scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/get_lattice_stats.sh >>/scratch/work/moisioa3/conv_lm/experiments/morph/enarvi-4/model/decode-devel/q/get_lattice_stats.log 2>&1
