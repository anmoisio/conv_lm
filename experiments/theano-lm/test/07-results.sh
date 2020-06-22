#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

for test_set in devel eval
do
	for in_dir in "${EXPT_WORK_DIR}/decode/${test_set}/"*
	do
		params=$(basename "${in_dir}")
		out_dir="${RESULTS_DIR}-lats-tpn=${MAX_TOKENS_PER_NODE}-beam=${BEAM}-order=${RECOMBINATION_ORDER}/${test_set}"
		mkdir -p "${out_dir}"
		out_file="${out_dir}/${params}.trn"
		echo "${out_file}"
		cat "${in_dir}/"*.trn |
		  sed 's:<s> ::g' |
		  sed 's: </s>::g' \
		  >"${out_file}"
	done
done
