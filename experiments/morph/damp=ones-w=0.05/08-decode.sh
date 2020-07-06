#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=0:15:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --dependency=afterok:54547740

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm

for lm_scale in 29 30 31 32
do
	export DECODE_LATTICES_LM1="${EXPT_WORK_DIR}/kn.4bo.gz"
	export DECODE_LATTICES_LM_SCALE="${lm_scale}"
	export DECODE_LATTICES_ORDER="4"
	out_file="${RESULTS_DIR}/pruned-lattices-lms=${lm_scale}.trn"
	decode-lattices.sh "${EXPT_WORK_DIR}/pruned-lattices/lattice-list" >"${out_file}"
	echo "Wrote ${out_file}."
done
