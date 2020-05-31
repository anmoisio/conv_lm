#!/bin/bash -e

source ../../scripts/run-expt.sh "${0}"

module purge
module load speech-scripts
module load srilm

lattice_error () {
	local test_set="${1}"

	mkdir -p "${PROJECT_DIR}/lattices/${test_set}"

	local in_dir="${EXPT_WORK_DIR}/lattices/${test_set}-pruned"
	local out_dir="${PROJECT_DIR}/lattices/${test_set}/aalto-baseline"
	local lattices_file="${out_dir}/lattice-list"
	local ref_file="${PROJECT_DIR}/data/${test_set}/verbatim.ref"

	if [ ! -d "${out_dir}" ]
	then
		echo "${out_dir}"
		mv "${in_dir}" "${out_dir}"

		echo "${lattices_file}"
		find "${out_dir}" -name '*.slf' | sort >"${lattices_file}"
	fi

	lattice-tool \
	  -in-lattice-list "${lattices_file}" -read-htk \
	  -ref-list "${ref_file}" |
	  awk '{ subs += $2; ins += $4; del += $6; err += $8; words += $10 }
	       END { print "sub", subs, "ins", ins, "del", del, "err", err, "words", words, "wer", err/words }'
}

lattice_error devel
lattice_error eval
