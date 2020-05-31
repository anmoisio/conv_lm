#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=0:30:00
#SBATCH --mem=12G

source ../../scripts/run-expt.sh "${0}"

module purge
module load speech-scripts
module load srilm

lm_scale=30
lattices_file="${PROJECT_DIR}/lattices/eval/aalto-baseline/lattice-list"
out_dir="${EXPT_WORK_DIR}/nbest/lms=${lm_scale}"

mkdir -p "${out_dir}"
lattice-tool \
  -order 4 \
  -in-lattice-list "${lattices_file}" \
  -read-htk \
  -htk-lmscale "${lm_scale}" \
  -nbest-decode 100000 \
  -out-nbest-dir "${out_dir}" \
  -debug 1
echo "Wrote ${out_dir}."
