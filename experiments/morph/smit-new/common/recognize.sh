#!/bin/bash
export LC_ALL=C

# Begin configuration section.
dataset=dev
skip_scoring=false
beam=18
iter=final
extra_flags=""
extra_name=""
write_to=""
# End configuration options.

echo "$0 $@"  # Print the command line for logging

. utils/parse_options.sh || return;

if [ $# -ne 2 ]; then
   echo "usage: common/recognize.sh model"
   echo "e.g.:  common/recognize.sh gr_tdnn_lstm_a"
   echo "main options (for others, see top of script file)"

   return;
fi

. ./cmd.sh ## You'll want to change cmd.sh to something that will work on your system.
           ## This relates to the queue.

am=$1
rl=$2
graph=$(basename $rl)

decode_flags="--post-decode-acwt 10.0 --acwt 1.0"
if [ -f $am/decode_flags ]; then
decode_flags="${decode_flags} $(cat $am/decode_flags)"
fi

dsname=$(basename $dataset)
extra="${extra_name}"
extra=_${dsname}${extra}
if [ "$iter" != "final" ]; then
extra=${iter}${extra}
fi

nj=50
echo data/$dataset/spk2utt
echo $(wc -l < data/$dataset/spk2utt)

if (( $(wc -l < data/$dataset/spk2utt) < $nj )); then
echo Lower nj
    nj=$(wc -l < data/$dataset/spk2utt)
fi

if [ ! -f ${write_to}decode${extra}_${graph}/wer_15_0.0 ]; then 
 steps/nnet3/decode_wo_ivecs_check.sh $extra_flags --cmd "run.pl --max-jobs-run 8" --iter $iter --beam $beam --lattice-beam 10.0 --skip-scoring $skip_scoring --nj $nj $decode_flags --scoring-opts "--min-lmwt 4 --max-lmwt 19" --online-ivector-dir ${am}/ivecs/ivectors_${dataset} ${am}/graph_${graph} ${am}/feats/${dataset} ${write_to}/decode${extra}_$graph
fi

