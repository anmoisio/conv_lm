#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load srilm

lm_scale=30
nbest_dir="${EXPT_WORK_DIR}/nbest/lms=${lm_scale}"
ref_file="${GROUP_DIR}/p/sanasto2016/data/eval/verbatim.ref"
nbest-error "${nbest_dir}" "${ref_file}"
