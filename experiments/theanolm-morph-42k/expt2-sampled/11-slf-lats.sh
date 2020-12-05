#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"
mkdir -p "${PROJECT_DIR}/lattices"
DECODE_CMD="utils/slurm.pl --mem 16G --time 1:00:00"

convert () {
	local test_set="${1}"

	local src_dir="${EXPT_WORK_DIR}/decode_lats"
	local dst_dir="${PROJECT_DIR}/lattices/${test_set}/morph-lstm-lats-rescored${EXPT_PARAMS}"

	../../kaldi-am/tdnn/utils/convert_slf_parallel.sh --cmd "${DECODE_CMD}" \
	  "${PROJECT_DIR}/experiments/kaldi-am/mmi/data/${test_set}" \
	  /scratch/work/moisioa3/conv_lm/experiments/morph/srilm-5-gram/lang/train-nosp \
	  "${src_dir}"

	rm -rf "${dst_dir}"
	mv "${src_dir}/lats-in-htk-slf" "${dst_dir}"
	mv "${dst_dir}/lat_htk.scp" "${dst_dir}/lattice-list"
	sed -i "s:${src_dir}/lats-in-htk-slf:${dst_dir}:" "${dst_dir}/lattice-list"
	echo "Wrote ${dst_dir}/lattice-list."
}

convert devel
# convert eval
