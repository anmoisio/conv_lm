#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"

# Get the alignments as lattices (gives the LF-MMI training more freedom).
# use the same num-jobs as the alignments
nj=$(cat ../mmi/models/mmi/num_jobs) || exit 1;

steps/align_fmllr_lats.sh --nj $nj --cmd "${TRAIN_CMD}" \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
    "${TRAIN_LANG}" \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/models/mmi" \
    "${EXPT_WORK_DIR}/mmi_lats_nodup"

rm "${EXPT_WORK_DIR}"/mmi_lats_nodup/fsts.*.gz # save space

# Create a version of the lang/ directory that has one state per phone in the
# topo file. [note, it really has two states.. the first one is only repeated
# once, the second one has zero or more repeats.]
# rm -rf $lang
# cp -r data/lang $lang

lang="${EXPT_WORK_DIR}/data/lang"
cp -a "${TRAIN_LANG}/." "${lang}/"
silphonelist=$(cat ${lang}/phones/silence.csl) || exit 1;
nonsilphonelist=$(cat ${lang}/phones/nonsilence.csl) || exit 1;

# Use our special topology... note that later on may have to tune this
# topology.
steps/nnet3/chain/gen_topo.py \
    $nonsilphonelist \
    $silphonelist \
    >${lang}/topo


# Build a tree using our new topology. This is the critically different
# step compared with other recipes.
steps/nnet3/chain/build_tree.sh --frame-subsampling-factor 3 \
    --context-opts "--context-width=2 --central-position=1" \
    --cmd "${TRAIN_CMD}" \
    7000 \
    "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/am-train" \
    "${lang}" \
    "${ALIGNMENTS}" \
    "${EXPT_WORK_DIR}/tree"
