#!/bin/bash
cd /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
lattice-scale --inv-acoustic-scale=${SLURM_ARRAY_TASK_ID} "ark:gunzip -c decode_nbest/nnlm_weight_1.0/lat.*.gz|" ark:- | lattice-add-penalty --word-ins-penalty=1.0 ark:- ark:- | lattice-best-path --word-symbol-table=/scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph/words.txt ark:- ark,t:- | utils/int2sym.pl -f 2- /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph/words.txt | utils/clean_wertext.py - | local/wer_hyp_filter > decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/${SLURM_ARRAY_TASK_ID}.txt 
EOF
) >decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( lattice-scale --inv-acoustic-scale=${SLURM_ARRAY_TASK_ID} "ark:gunzip -c decode_nbest/nnlm_weight_1.0/lat.*.gz|" ark:- | lattice-add-penalty --word-ins-penalty=1.0 ark:- ark:- | lattice-best-path --word-symbol-table=/scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph/words.txt ark:- ark,t:- | utils/int2sym.pl -f 2- /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/graph/words.txt | utils/clean_wertext.py - | local/wer_hyp_filter > decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/${SLURM_ARRAY_TASK_ID}.txt  ) &>>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/log/best_path.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/q/done.61420.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --export=PATH,LIBRARY_PATH,LD_LIBRARY_PATH,CUDA_HOME,CUDA_PATH  --partition batch  --open-mode=append -e decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/q/best_path.log -o decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/q/best_path.log --array 7-17 /scratch/work/moisioa3/conv_lm/experiments/theanolm-morph-42k/expt2-sampled/decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/q/best_path.sh >>decode_nbest/nnlm_weight_1.0/scoring_kaldi/penalty_1.0/q/best_path.log 2>&1
