#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi
module load sox

cd "${EXPT_SCRIPT_DIR}"

for set_name in am-train devel eval
do
	data_dir="${EXPT_WORK_DIR}/data/${set_name}"
	echo "${data_dir}"
	mkdir -p "${data_dir}"

	cp "${PROJECT_DIR}/data/${set_name}/wav.scp" "${data_dir}/"
	cp "${PROJECT_DIR}/data/${set_name}/verbatim.ref" "${data_dir}/text"
	cp "${PROJECT_DIR}/data/${set_name}/spk2utt" "${data_dir}/"
	cp "${PROJECT_DIR}/data/${set_name}/utt2spk" "${data_dir}/"

	(set -x; steps/make_mfcc.sh --nj 20 --cmd "${TRAIN_CMD}" \
	  "${data_dir}" \
	  "${EXPT_WORK_DIR}/log/mfcc-${set_name}" \
	  "${EXPT_WORK_DIR}/mfcc")

	(set -x; steps/compute_cmvn_stats.sh \
	  "${data_dir}" \
	  "${EXPT_WORK_DIR}/log/mfcc-${set_name}" \
	  "${EXPT_WORK_DIR}/mfcc")
done