#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

steps/get_prons.sh --cmd "${TRAIN_CMD}" \
  "${EXPT_WORK_DIR}/data/am-train" \
  "${EXPT_WORK_DIR}/lang/nosp" \
  "${EXPT_WORK_DIR}/models/tri3"

"${UTILS_DIR}/dict_dir_add_pronprobs.sh" \
  --max-normalize true \
  "${EXPT_WORK_DIR}/dict/nosp" \
  "${EXPT_WORK_DIR}/models/tri3/pron_counts_nowb.txt" \
  "${EXPT_WORK_DIR}/models/tri3/sil_counts_nowb.txt" \
  "${EXPT_WORK_DIR}/models/tri3/pron_bigram_counts_nowb.txt" \
  "${EXPT_WORK_DIR}/dict/sp-test"
