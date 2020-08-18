#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=1:00:00
#SBATCH --mem=7G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

lattices_file="${PROJECT_DIR}/lattices/movies-short/lattice-list"

trn_dir="${RESULTS_DIR}"
mkdir -p "${trn_dir}"

for lm_scale in 5
do
	export DECODE_LATTICES_LM1="${BASELINE_LM}"
	export DECODE_LATTICES_LM_SCALE="${lm_scale}"
	export DECODE_LATTICES_ORDER="4"

	trn_file="${trn_dir}/lats-lms=${lm_scale}.trn"
	decode-lattices.sh "${lattices_file}" >"${trn_file}"
	echo "Wrote ${trn_file}."
done

