#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=4:00:00
#SBATCH --mem=10G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

UTILS_DIR=utils
lm=/scratch/work/moisioa3/conv_lm/experiments/4gram/ip/kn-ip-dsp-web.arpa.gz
dir=data/lang_train_nosp

echo "${dir}"
mkdir -p "${dir}"
cp -r "${EXPT_WORK_DIR}/data/lang_nosp/"* "${dir}/"

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
