#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

set -e

# configs for 'chain'
stage=0
train_stage=-10
get_egs_stage=-10

frames_per_eg=150,110,100
remove_egs=false
common_egs_dir=
xent_regularize=0.1
dropout_schedule='0,0@0.20,0.5@0.50,0'

echo "$0: creating neural net configs using the xconfig parser";

num_targets=$(tree-info "${EXPT_WORK_DIR}/data/tree/tree" |grep num-pdfs|awk '{print $2}')
learning_rate_factor=$(echo "print (0.5/$xent_regularize)" | python)
affine_opts="l2-regularize=0.01 dropout-proportion=0.0 dropout-per-dim=true dropout-per-dim-continuous=true"
tdnnf_opts="l2-regularize=0.01 dropout-proportion=0.0 bypass-scale=0.66"
linear_opts="l2-regularize=0.01 orthonormal-constraint=-1.0"
prefinal_opts="l2-regularize=0.01"
output_opts="l2-regularize=0.002"

mkdir -p "${EXPT_WORK_DIR}/configs"

cat <<EOF > ${EXPT_WORK_DIR}/configs/network.xconfig
input dim=100 name=ivector
input dim=40 name=input

# please note that it is important to have input layer with the name=input
# as the layer immediately preceding the fixed-affine-layer to enable
# the use of short notation for the descriptor
fixed-affine-layer name=lda input=Append(-1,0,1,ReplaceIndex(ivector, t, 0)) affine-transform-file=${EXPT_WORK_DIR}/configs/lda.mat

# the first splicing is moved before the lda layer, so no splicing here
relu-batchnorm-dropout-layer name=tdnn1 $affine_opts dim=1536
tdnnf-layer name=tdnnf2 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=1
tdnnf-layer name=tdnnf3 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=1
tdnnf-layer name=tdnnf4 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=1
tdnnf-layer name=tdnnf5 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=0
tdnnf-layer name=tdnnf6 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf7 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf8 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf9 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf10 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf11 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf12 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf13 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf14 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
tdnnf-layer name=tdnnf15 $tdnnf_opts dim=1536 bottleneck-dim=160 time-stride=3
linear-component name=prefinal-l dim=256 $linear_opts

prefinal-layer name=prefinal-chain input=prefinal-l $prefinal_opts big-dim=1536 small-dim=256
output-layer name=output include-log-softmax=false dim=$num_targets $output_opts

prefinal-layer name=prefinal-xent input=prefinal-l $prefinal_opts big-dim=1536 small-dim=256
output-layer name=output-xent dim=$num_targets learning-rate-factor=$learning_rate_factor $output_opts
EOF
steps/nnet3/xconfig_to_configs.py --xconfig-file "${EXPT_WORK_DIR}/configs/network.xconfig" --config-dir "${EXPT_WORK_DIR}/configs/"


steps/nnet3/chain/train.py --stage $train_stage \
  --cmd "${TRAIN_CMD}" \
  --feat.online-ivector-dir "${EXPT_WORK_DIR}/ivectors/am-train" \
  --feat.cmvn-opts "--norm-means=false --norm-vars=false" \
  --chain.xent-regularize $xent_regularize \
  --chain.leaky-hmm-coefficient 0.1 \
  --chain.l2-regularize 0.0 \
  --chain.apply-deriv-weights false \
  --chain.lm-opts="--num-extra-lm-states=2000" \
  --trainer.dropout-schedule $dropout_schedule \
  --trainer.add-option="--optimization.memory-compression-level=2" \
  --egs.dir "$common_egs_dir" \
  --egs.stage $get_egs_stage \
  --egs.opts "--frames-overlap-per-eg 0 --constrained false" \
  --egs.chunk-width $frames_per_eg \
  --trainer.num-chunk-per-minibatch 64 \
  --trainer.frames-per-iter 1500000 \
  --trainer.num-epochs 6 \
  --trainer.optimization.num-jobs-initial 3 \
  --trainer.optimization.num-jobs-final 16 \
  --trainer.optimization.initial-effective-lrate 0.00025 \
  --trainer.optimization.final-effective-lrate 0.000025 \
  --trainer.max-param-change 2.0 \
  --cleanup.remove-egs $remove_egs \
  --feat-dir "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
  --tree-dir "${EXPT_WORK_DIR}/data/tree" \
  --lat-dir "${EXPT_WORK_DIR}/mmi_lats_nodup" \
  --dir "${EXPT_WORK_DIR}"  || exit 1;
