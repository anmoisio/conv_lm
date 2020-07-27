#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"
mkdir -p "${PROJECT_DIR}/lattices"

convert () {
	local test_set="${1}"

	local src_dir="${EXPT_WORK_DIR}/models/tdnn/decode-${test_set}"
	local dst_dir="${PROJECT_DIR}/lattices/${test_set}/morph-baseline-elisa"

	../../kaldi-am/tdnn/utils/convert_slf_parallel.sh --cmd "${DECODE_CMD}" \
	  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/${test_set}" \
	  "${EXPT_WORK_DIR}/lang/nosp" \
	  "${src_dir}"

	rm -rf "${dst_dir}"
	mv "${src_dir}/lats-in-htk-slf" "${dst_dir}"
	mv "${dst_dir}/lat_htk.scp" "${dst_dir}/lattice-list"
	sed -i "s:${src_dir}/lats-in-htk-slf:${dst_dir}:" "${dst_dir}/lattice-list"
	echo "Wrote ${dst_dir}/lattice-list."
}

convert devel
# convert eval