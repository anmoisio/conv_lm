#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load TheanoLM-develop
module load sctk

cd "${EXPT_SCRIPT_DIR}"

echo "=== Development set WER against verbatim transcripts ====================" |
  tee "${EXPT_SCRIPT_DIR}/results.log"
decode_dir="${EXPT_WORK_DIR}/models/tdnn/decode-devel"
grep WER "${decode_dir}/wer_"* |
  utils/best_wer.sh |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"

echo "=== Evaluation set WER against verbatim transcripts =====================" |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"
decode_dir="${EXPT_WORK_DIR}/models/tdnn/decode-eval"
grep WER "${decode_dir}/wer_"* |
  utils/best_wer.sh |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"

decode_dir="${EXPT_WORK_DIR}/models/tdnn/decode-devel"
"${THEANOLM}/kaldi/steps/score_sclite.sh" \
  --cmd "${SCORE_CMD}" \
  --min-lm-scale "11" \
  --max-lm-scale "18" \
  --wi-penalties "0.0" \
  "${EXPT_WORK_DIR}/lang/baseline-nosp" \
  "${decode_dir}" \
  "${PROJECT_DIR}/data/devel/normalized.trn"

echo "=== Development set WER against transcripts with multiple paths =========" |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"
grep 'Sum/Avg' "${decode_dir}/scoring_sclite/penalty_0.0/"*.ref.iso.sys |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"

decode_dir="${EXPT_WORK_DIR}/models/tdnn/decode-eval"
"${THEANOLM}/kaldi/steps/score_sclite.sh" \
  --cmd "${SCORE_CMD}" \
  --min-lm-scale "11" \
  --max-lm-scale "18" \
  --wi-penalties "0.0" \
  "${EXPT_WORK_DIR}/lang/baseline-nosp" \
  "${decode_dir}" \
  "${PROJECT_DIR}/data/eval/normalized.trn"

echo "=== Evaluation set WER against transcripts with multiple paths ==========" |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"
grep 'Sum/Avg' "${decode_dir}/scoring_sclite/penalty_0.0/"*.ref.iso.sys |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"
