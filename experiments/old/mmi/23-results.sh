#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load TheanoLM-develop
module load sctk

cd "${EXPT_SCRIPT_DIR}"

echo "=== Development set WER against verbatim transcripts ====================" |
  tee "${EXPT_SCRIPT_DIR}/results.log"
for decode_dir in "${EXPT_WORK_DIR}/models/"*/decode-devel-nosp2
do
	if [ -d "${decode_dir}" ]
	then
		grep WER "${decode_dir}/wer_"* |
		  utils/best_wer.sh |
		  tee --append "${EXPT_SCRIPT_DIR}/results.log"
	fi
done

echo "=== Evaluation set WER against verbatim transcripts =====================" |
  tee --append "${EXPT_SCRIPT_DIR}/results.log"
for decode_dir in "${EXPT_WORK_DIR}/models/"*/decode-eval-nosp2
do
	if [ -d "${decode_dir}" ]
	then
		grep WER "${decode_dir}/wer_"* |
		  utils/best_wer.sh |
		  tee --append "${EXPT_SCRIPT_DIR}/results.log"
	fi
done

# decode_dir="${EXPT_WORK_DIR}/models/mmi/decode-devel"
# "${THEANOLM}/kaldi/steps/score_sclite.sh" \
#   --cmd "${DECODE_CMD}" \
#   --min-lm-scale "13" \
#   --max-lm-scale "18" \
#   --wi-penalties "0.0" \
#   "${EXPT_WORK_DIR}/lang/train" \
#   "${decode_dir}" \
#   "${PROJECT_DIR}/data/devel/normalized.trn"

# echo "=== Development set WER against transcripts with multiple paths =========" |
#   tee --append "${EXPT_SCRIPT_DIR}/results.log"
# grep 'Sum/Avg' "${decode_dir}/scoring_sclite/penalty_0.0/"*.ref.iso.sys |
#   tee --append "${EXPT_SCRIPT_DIR}/results.log"

# decode_dir="${EXPT_WORK_DIR}/models/mmi/decode-eval"
# "${THEANOLM}/kaldi/steps/score_sclite.sh" \
#   --cmd "${DECODE_CMD}" \
#   --min-lm-scale "13" \
#   --max-lm-scale "18" \
#   --wi-penalties "0.0" \
#   "${EXPT_WORK_DIR}/lang/train" \
#   "${decode_dir}" \
#   "${PROJECT_DIR}/data/eval/normalized.trn"

# echo "=== Evaluation set WER against transcripts with multiple paths ==========" |
#   tee --append "${EXPT_SCRIPT_DIR}/results.log"
# grep 'Sum/Avg' "${decode_dir}/scoring_sclite/penalty_0.0/"*.ref.iso.sys |
#   tee --append "${EXPT_SCRIPT_DIR}/results.log"
