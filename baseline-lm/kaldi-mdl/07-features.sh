#!/bin/bash -e

# This script extracts high-resolution MFCC features.

export LC_ALL=C

source ../../scripts/run-expt.sh "${0}"

module purge
module load kaldi

cd "${EXPT_SCRIPT_DIR}"

for set_name in devel eval
do
	data_dir="${EXPT_WORK_DIR}/data/${set_name}"
	echo "${data_dir}"
	mkdir -p "${data_dir}"

	cp "${PROJECT_DIR}/data/${set_name}/wav.scp" "${data_dir}/"
	cp "${PROJECT_DIR}/data/${set_name}/verbatim.ref" "${data_dir}/text"
	cp "${PROJECT_DIR}/data/${set_name}/spk2utt" "${data_dir}/"
	cp "${PROJECT_DIR}/data/${set_name}/utt2spk" "${data_dir}/"

	steps/make_mfcc.sh --nj 40 --cmd "${TRAIN_CMD}" \
	  --mfcc-config conf/mfcc_hires.conf \
	  "${data_dir}" \
	  "${EXPT_WORK_DIR}/log/mfcc-${set_name}" \
	  "${EXPT_WORK_DIR}/mfcc"

	steps/compute_cmvn_stats.sh \
	  "${data_dir}" \
	  "${EXPT_WORK_DIR}/log/mfcc-${set_name}" \
	  "${EXPT_WORK_DIR}/mfcc"
done