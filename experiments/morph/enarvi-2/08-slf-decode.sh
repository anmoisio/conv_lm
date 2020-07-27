#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=2:00:00
#SBATCH --mem=7G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

decode () {
	local test_set="${1}"

	local lattices_file="${PROJECT_DIR}/lattices/${test_set}/morph-baseline/lattice-list"

	local trn_dir="${RESULTS_DIR}/${test_set}"
	mkdir -p "${trn_dir}"

	for lm_scale in 66
	do
		export DECODE_LATTICES_LM1="${BASELINE_LM}"
		export DECODE_LATTICES_LM_SCALE="${lm_scale}"
		export DECODE_LATTICES_ORDER="1"

		trn_file="${trn_dir}/lats-lms=${lm_scale}-order=${DECODE_LATTICES_ORDER}.trn"
		decode-lattices.sh "${lattices_file}" >"${trn_file}"
		echo "Wrote ${trn_file}."
	done
}

decode devel
# decode eval
