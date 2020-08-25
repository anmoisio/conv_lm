#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

cd "${EXPT_SCRIPT_DIR}"

set -e -o pipefail

# LSTM/chain options
train_stage=-10
xent_regularize=0.1
dropout_schedule='0,0@0.20,0.5@0.50,0'

# training chunk-options
chunk_width=140,100,160
# we don't need extra left/right context for TDNN systems.
chunk_left_context=0
chunk_right_context=0

# training options
srand=0
remove_egs=false

#decode options
test_online_decoding=false  # if true, it will run the last decoding stage.


mkdir -p $dir
echo "$0: creating neural net configs using the xconfig parser";

num_targets=$(tree-info $tree_dir/tree |grep num-pdfs|awk '{print $2}')
learning_rate_factor=$(echo "print(0.5/$xent_regularize)" | python)
tdnn_opts="l2-regularize=0.01 dropout-proportion=0.0 dropout-per-dim-continuous=true"
tdnnf_opts="l2-regularize=0.01 dropout-proportion=0.0 bypass-scale=0.66"
linear_opts="l2-regularize=0.01 orthonormal-constraint=-1.0"
prefinal_opts="l2-regularize=0.01"
output_opts="l2-regularize=0.005"

mkdir -p $dir/configs
cat <<EOF > $dir/configs/network.xconfig
input dim=100 name=ivector
input dim=40 name=input

idct-layer name=idct input=input dim=40 cepstral-lifter=22 affine-transform-file=$dir/configs/idct.mat
delta-layer name=delta input=idct
no-op-component name=input2 input=Append(delta, Scale(1.0, ReplaceIndex(ivector, t, 0)))

# the first splicing is moved before the lda layer, so no splicing here
relu-batchnorm-layer name=tdnn1 $tdnn_opts dim=1024 input=input2
tdnnf-layer name=tdnnf2 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=1
tdnnf-layer name=tdnnf3 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=1
tdnnf-layer name=tdnnf4 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=1
tdnnf-layer name=tdnnf5 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=0
tdnnf-layer name=tdnnf6 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf7 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf8 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf9 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf10 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf11 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf12 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
tdnnf-layer name=tdnnf13 $tdnnf_opts dim=1024 bottleneck-dim=128 time-stride=3
linear-component name=prefinal-l dim=192 $linear_opts


prefinal-layer name=prefinal-chain input=prefinal-l $prefinal_opts big-dim=1024 small-dim=192
output-layer name=output include-log-softmax=false dim=$num_targets $output_opts

prefinal-layer name=prefinal-xent input=prefinal-l $prefinal_opts big-dim=1024 small-dim=192
output-layer name=output-xent dim=$num_targets learning-rate-factor=$learning_rate_factor $output_opts
EOF
steps/nnet3/xconfig_to_configs.py \
    --xconfig-file $dir/configs/network.xconfig \
    --config-dir $dir/configs/



steps/nnet3/chain/train.py --stage=$train_stage \
    --cmd="$decode_cmd" \
    --feat.online-ivector-dir=$train_ivector_dir \
    --feat.cmvn-opts="--norm-means=false --norm-vars=false" \
    --chain.xent-regularize $xent_regularize \
    --chain.leaky-hmm-coefficient=0.1 \
    --chain.l2-regularize=0.0 \
    --chain.apply-deriv-weights=false \
    --chain.lm-opts="--num-extra-lm-states=2000" \
    --trainer.dropout-schedule $dropout_schedule \
    --trainer.add-option="--optimization.memory-compression-level=2" \
    --trainer.srand=$srand \
    --trainer.max-param-change=2.0 \
    --trainer.num-epochs=10 \
    --trainer.frames-per-iter=5000000 \
    --trainer.optimization.num-jobs-initial=2 \
    --trainer.optimization.num-jobs-final=8 \
    --trainer.optimization.initial-effective-lrate=0.0005 \
    --trainer.optimization.final-effective-lrate=0.00005 \
    --trainer.num-chunk-per-minibatch=128,64 \
    --trainer.optimization.momentum=0.0 \
    --egs.chunk-width=$chunk_width \
    --egs.chunk-left-context=0 \
    --egs.chunk-right-context=0 \
    --egs.dir="$common_egs_dir" \
    --egs.opts="--frames-overlap-per-eg 0" \
    --cleanup.remove-egs=$remove_egs \
    --use-gpu=true \
    --reporting.email="$reporting_email" \
    --feat-dir=$train_data_dir \
    --tree-dir=$tree_dir \
    --lat-dir=$lat_dir \
    --dir=$dir  || exit 1;


# if [ $stage -le 17 ]; then
#   # The reason we are using data/lang here, instead of $lang, is just to
#   # emphasize that it's not actually important to give mkgraph.sh the
#   # lang directory with the matched topology (since it gets the
#   # topology file from the model).  So you could give it a different
#   # lang directory, one that contained a wordlist and LM of your choice,
#   # as long as phones.txt was compatible.

#   utils/lang/check_phones_compatible.sh \
#     data/lang_test_tgpr/phones.txt $lang/phones.txt
#   utils/mkgraph.sh \
#     --self-loop-scale 1.0 data/lang_test_tgpr \
#     $tree_dir $tree_dir/graph_tgpr || exit 1;

#   utils/lang/check_phones_compatible.sh \
#     data/lang_test_bd_tgpr/phones.txt $lang/phones.txt
#   utils/mkgraph.sh \
#     --self-loop-scale 1.0 data/lang_test_bd_tgpr \
#     $tree_dir $tree_dir/graph_bd_tgpr || exit 1;
# fi

# if [ $stage -le 18 ]; then
#   frames_per_chunk=$(echo $chunk_width | cut -d, -f1)
#   rm $dir/.error 2>/dev/null || true

#   for data in $test_sets; do
#     (
#       data_affix=$(echo $data | sed s/test_//)
#       nspk=$(wc -l <data/${data}_hires/spk2utt)
#       for lmtype in tgpr bd_tgpr; do
#         steps/nnet3/decode.sh \
#           --acwt 1.0 --post-decode-acwt 10.0 \
#           --extra-left-context 0 --extra-right-context 0 \
#           --extra-left-context-initial 0 \
#           --extra-right-context-final 0 \
#           --frames-per-chunk $frames_per_chunk \
#           --nj $nspk --cmd "$decode_cmd"  --num-threads 4 \
#           --online-ivector-dir exp/nnet3${nnet3_affix}/ivectors_${data}_hires \
#           $tree_dir/graph_${lmtype} data/${data}_hires ${dir}/decode_${lmtype}_${data_affix} || exit 1
#       done
#       steps/lmrescore.sh \
#         --self-loop-scale 1.0 \
#         --cmd "$decode_cmd" data/lang_test_{tgpr,tg} \
#         data/${data}_hires ${dir}/decode_{tgpr,tg}_${data_affix} || exit 1
#       steps/lmrescore_const_arpa.sh --cmd "$decode_cmd" \
#         data/lang_test_bd_{tgpr,fgconst} \
#        data/${data}_hires ${dir}/decode_${lmtype}_${data_affix}{,_fg} || exit 1
#     ) || touch $dir/.error &
#   done
#   wait
#   [ -f $dir/.error ] && echo "$0: there was a problem while decoding" && exit 1
# fi

# # Not testing the 'looped' decoding separately, because for
# # TDNN systems it would give exactly the same results as the
# # normal decoding.

# if $test_online_decoding && [ $stage -le 19 ]; then
#   # note: if the features change (e.g. you add pitch features), you will have to
#   # change the options of the following command line.
#   steps/online/nnet3/prepare_online_decoding.sh \
#     --mfcc-config conf/mfcc_hires.conf \
#     $lang exp/nnet3${nnet3_affix}/extractor ${dir} ${dir}_online

#   rm $dir/.error 2>/dev/null || true

#   for data in $test_sets; do
#     (
#       data_affix=$(echo $data | sed s/test_//)
#       nspk=$(wc -l <data/${data}_hires/spk2utt)
#       # note: we just give it "data/${data}" as it only uses the wav.scp, the
#       # feature type does not matter.
#       for lmtype in tgpr bd_tgpr; do
#         steps/online/nnet3/decode.sh \
#           --acwt 1.0 --post-decode-acwt 10.0 \
#           --nj $nspk --cmd "$decode_cmd" \
#           $tree_dir/graph_${lmtype} data/${data} ${dir}_online/decode_${lmtype}_${data_affix} || exit 1
#       done
#       steps/lmrescore.sh \
#         --self-loop-scale 1.0 \
#         --cmd "$decode_cmd" data/lang_test_{tgpr,tg} \
#         data/${data}_hires ${dir}_online/decode_{tgpr,tg}_${data_affix} || exit 1
#       steps/lmrescore_const_arpa.sh --cmd "$decode_cmd" \
#         data/lang_test_bd_{tgpr,fgconst} \
#        data/${data}_hires ${dir}_online/decode_${lmtype}_${data_affix}{,_fg} || exit 1
#     ) || touch $dir/.error &
#   done
#   wait
#   [ -f $dir/.error ] && echo "$0: there was a problem while decoding" && exit 1
# fi


# exit 0;
