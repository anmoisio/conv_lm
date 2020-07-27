#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=10G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

create_fst () {
	local lm="${1}"
	local dir="${2}"

	echo "${dir}"
	mkdir -p "${dir}"
	cp -r "${EXPT_WORK_DIR}/lang/nosp/"* "${dir}/"

	local tmpdir="${EXPT_WORK_DIR}/lm_tmp"
	mkdir -p "${tmpdir}"
	echo "${tmpdir}/oovs.txt :: ${lm} ${dir}/words.txt"
	# find_arpa_oovs.pl will close the input early and cause a SIGPIPE.
	zcat "${lm}" |
	  "${UTILS_DIR}/find_arpa_oovs.pl" "${dir}/words.txt" \
	  >"${tmpdir}/oovs.txt" || true

	echo "${dir}/G.fst :: ${lm}"
	zcat "${lm}" |
	  arpa2fst - |
	  fstprint |
	  "${UTILS_DIR}/remove_oovs.pl" "${tmpdir}/oovs.txt" |
	  "${UTILS_DIR}/eps2disambig.pl" |
	  "${UTILS_DIR}/s2eps.pl" |
	  fstcompile --isymbols="${dir}/words.txt" \
	             --osymbols="${dir}/words.txt" --keep_isymbols=false --keep_osymbols=false |
	  fstrmepsilon |
	  fstarcsort --sort_type=ilabel \
	  >"${dir}/G.fst"

	"${UTILS_DIR}/validate_lang.pl" --skip-determinization-check "${dir}"

	rm -rf "${tmpdir}"
}
# create_fst "${LM}".gz "${EXPT_WORK_DIR}/lang/train-nosp"

dir="${EXPT_WORK_DIR}/lang/nosp"
tmpdir="${EXPT_WORK_DIR}/lang/nosp.tmp"

common/make_lfst_aff.py $(tail -n1 $dir/phones/disambig.txt) \
	< $tmpdir/lexiconp_disambig.txt | \
	fstcompile 	--isymbols=$dir/phones.txt \
				--osymbols=$dir/words.txt \
				--keep_isymbols=false --keep_osymbols=false | \
	fstaddselfloops  $dir/phones/wdisambig_phones.int $dir/phones/wdisambig_words.int | \
	fstarcsort --sort_type=olabel \
	> $dir/L_disambig.fst

cat "${LM}" | arpa2fst --disambig-symbol="#0" --read-symbol-table="${EXPT_WORK_DIR}/lang/nosp"/words.txt - "${EXPT_WORK_DIR}/lang/nosp"/G.fst

"${UTILS_DIR}/validate_lang.pl" --skip-determinization-check "${EXPT_WORK_DIR}/lang/nosp"


