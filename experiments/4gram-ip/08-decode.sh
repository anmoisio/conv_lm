#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=0:15:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

source ../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

decode () {
	local test_set="${1}"

	for lm_scale in 29 30 31 32
	do
		export DECODE_LATTICES_LM1="${PROJECT_DIR}/models/fullvocab-ip2.arpa.gz"
		export DECODE_LATTICES_LM_SCALE="${lm_scale}"
		export DECODE_LATTICES_ORDER="4"
		local lattices_file="${PROJECT_DIR}/lattices/${test_set}/aalto-baseline/lattice-list"
		local out_file="${RESULTS_DIR}/${test_set}/lats-lms=${lm_scale}.trn"
		decode-lattices.sh "${lattices_file}" >"${out_file}"
		echo "Wrote ${out_file}."
	done
}

decode devel
decode eval
