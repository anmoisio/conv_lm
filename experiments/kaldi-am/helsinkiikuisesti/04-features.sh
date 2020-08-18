#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load sox

cd "${EXPT_SCRIPT_DIR}"

data_dir="${EXPT_WORK_DIR}/data"

(set -x; ../mmi/steps/make_mfcc.sh --nj 1 --cmd "${TRAIN_CMD}" \
	"${data_dir}" \
	"${EXPT_WORK_DIR}/log/mfcc" \
	"${EXPT_WORK_DIR}/mfcc")

(set -x; ../mmi/steps/compute_cmvn_stats.sh \
	"${data_dir}" \
	"${EXPT_WORK_DIR}/log/mfcc" \
	"${EXPT_WORK_DIR}/mfcc")

