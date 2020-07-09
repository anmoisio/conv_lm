#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=2:00:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"

module purge
module load speech-scripts
module load srilm
module list

for lm_scale in 29 30 31 32
do
	export DECODE_LATTICES_LM1="${EXPT_WORK_DIR}/kn.arpa.gz"
	export DECODE_LATTICES_LM_SCALE="${lm_scale}"
	export DECODE_LATTICES_ORDER="4"
	out_file="${RESULTS_DIR}/lattices-lms=${lm_scale}.trn"
	decode-lattices.sh "${PROJECT_DIR}/lattices/devel/chain-baseline/lattice-list" >"${out_file}"
	echo "Wrote ${out_file}."
done
