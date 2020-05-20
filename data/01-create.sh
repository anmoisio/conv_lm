#!/bin/bash -e
#
# selected functions copied from /teamwork/t40511_asr/p/sanasto2016/data/01-create.sh
# fetch data for training the LM and evaluating the ASR system

module purge
module load speech-scripts

script_dir=$(readlink -f "$(dirname $0)")
echo script_dir $script_dir

corpus_dir="${GROUP_DIR}/c"
echo corpus_dir $corpus_dir

# Kaldi is strict about the sort order.
export LC_ALL=C

sort_trn () {
	sed '/^$/d' |
	  awk '{print $NF,$0}' |
	  sort |
	  cut -f2- -d' '
}

filter_trn () {
	perl -C -ple 's/\[[^\]]*\]//g' \
	| sed 's/ *(.*//' \
	| perl -C -ple 's/ *\S+-(?!\pL) */ /g' \
	| perl -C -ple 's/ *(?<!\pL)-\S+ */ /g' \
	| sed 's/ *- */ /g' \
	| awk '{$1 = $1}1' \
	| sed '/^$/d'
}

flist2scp () {
	perl -C -ple 's:^\S+/(\S+)\.(wav|FI0)$:$1 $_: || die "Bad line $_"'
}

# LM train data
dspcon_train_trn () {
	grep -E 'dsp(f003|f005|f006|f008|f009|m002|m008|m012|m016|m020|m027|m029|m035|m037|m044|m046)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/2013/verbatim.trn"
	cat "${corpus_dir}"/aalto-dspcon/201[456]/verbatim.trn
}

lm_train () {
	dspcon_train_trn | filter_trn >"${script_dir}/lm-train/dsp.txt"
	cat "${corpus_dir}"/webcon-fi/filtered/set{1..6}.txt >"${script_dir}/lm-train/web.txt"
}

# ASR devel and evaluation data
# DSPCON
dspcon_devel_trn () {
	grep -E 'dsp(f004|f007|m001|m004|m005|m006|m007|m010|m011|m014|m015|m017|m018|m019|m021|m022|m024|m025|m026|m028|m031|m032|m033|m034|m036|m039|m040|m042|m043|m045|m047|m048|m049|m050|m052|m054|m055|m056|m057|m058)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/2013/verbatim.trn"
}

dspcon_devel_normalized_trn () {
	grep -E 'dsp(f004|f007|m001|m004|m005|m006|m007|m010|m011|m014|m015|m017|m018|m019|m021|m022|m024|m025|m026|m028|m031|m032|m033|m034|m036|m039|m040|m042|m043|m045|m047|m048|m049|m050|m052|m054|m055|m056|m057|m058)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/2013/normalized.trn"
}

dspcon_eval_trn () {
	grep -E 'dsp(f001|f002|m003|m009|m013|m023|m030|m038|m041|m051|m053)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/2013/verbatim.trn"
}

dspcon_eval_normalized_trn () {
	grep -E 'dsp(f001|f002|m003|m009|m013|m023|m030|m038|m041|m051|m053)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/2013/normalized.trn"
}

dspcon_eval_wav_list () {
	grep -E 'dsp(f001|f002|m003|m009|m013|m023|m030|m038|m041|m051|m053)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/wav-list"
}

dspcon_eval_utt2spk () {
	grep -E 'dsp(f001|f002|m003|m009|m013|m023|m030|m038|m041|m051|m053)_dsp2013_' \
	        "${corpus_dir}/aalto-dspcon/utt2spk"
}

# radiocon

radiocon_devel_trn () {
	cat "${corpus_dir}"/radiocon-fi/original/fym20071218/verbatim.trn
	grep '(radio.*_kbk' "${corpus_dir}/radiocon-fi/verbatim.trn"
}

radiocon_devel_normalized_trn () {
	cat "${corpus_dir}"/radiocon-fi/original/fym20071218/normalized.trn
	grep '(radio.*_kbk' "${corpus_dir}/radiocon-fi/normalized.trn"
}

radiocon_devel_wav_list () {
	grep '/radio.*_fym20071218' "${corpus_dir}/radiocon-fi/wav-list"
	grep '/radio.*_kbk' "${corpus_dir}/radiocon-fi/wav-list"
}

radiocon_devel_utt2spk () {
	grep 'radio.*_fym20071218' "${corpus_dir}/radiocon-fi/utt2spk"
	grep 'radio.*_kbk' "${corpus_dir}/radiocon-fi/utt2spk"
}
radiocon_devel_utt2spk () {
	grep 'radio.*_fym20071218' "${corpus_dir}/radiocon-fi/utt2spk"
	grep 'radio.*_kbk' "${corpus_dir}/radiocon-fi/utt2spk"
}

radiocon_eval_trn () {
	grep '(radio.*_aamushow' "${corpus_dir}/radiocon-fi/verbatim.trn"
	grep '(radio.*_puhujainkulma' "${corpus_dir}/radiocon-fi/verbatim.trn"
}

radiocon_eval_normalized_trn () {
	grep '(radio.*_aamushow' "${corpus_dir}/radiocon-fi/normalized.trn"
	grep '(radio.*_puhujainkulma' "${corpus_dir}/radiocon-fi/normalized.trn"
}

radiocon_eval_wav_list () {
	grep '/radio.*_aamushow' "${corpus_dir}/radiocon-fi/wav-list"
	grep '/radio.*_puhujainkulma' "${corpus_dir}/radiocon-fi/wav-list"
}

radiocon_eval_utt2spk () {
	grep 'radio.*_aamushow' "${corpus_dir}/radiocon-fi/utt2spk"
	grep 'radio.*_puhujainkulma' "${corpus_dir}/radiocon-fi/utt2spk"
}


# gather the data

devel () {
	dspcon_devel_trn | trn2ref.pl >"${script_dir}/devel/verbatim.ref"
	radiocon_devel_trn | trn2ref.pl >>"${script_dir}/devel/verbatim.ref"
	sort -o "${script_dir}/devel/verbatim.ref" "${script_dir}/devel/verbatim.ref"

	cut -d' ' -f2- "${script_dir}/devel/verbatim.ref" |
	  filter_trn \
	  >"${script_dir}/devel/plain.txt"

	# dspcon_devel_normalized_trn >"${script_dir}/devel/normalized.trn.tmp"
	# radiocon_devel_normalized_trn >>"${script_dir}/devel/normalized.trn.tmp"
	# sort_trn <"${script_dir}/devel/normalized.trn.tmp" >"${script_dir}/devel/normalized.trn"
	# rm -f "${script_dir}/devel/normalized.trn.tmp"

	# dspcon_devel_wav_list >"${script_dir}/devel/wav-list"
	# radiocon_devel_wav_list >>"${script_dir}/devel/wav-list"
	# sort -o "${script_dir}/devel/wav-list" "${script_dir}/devel/wav-list"

	# flist2scp <"${script_dir}/devel/wav-list" >"${script_dir}/devel/wav.scp"
	# sort -o "${script_dir}/devel/wav.scp" "${script_dir}/devel/wav.scp"

	# dspcon_devel_utt2spk >"${script_dir}/devel/utt2spk"
	# radiocon_devel_utt2spk >>"${script_dir}/devel/utt2spk"
	# sort -o "${script_dir}/devel/utt2spk" "${script_dir}/devel/utt2spk"

	# "${script_dir}/../scripts/utt2spk_to_spk2utt.pl" \
	#   <"${script_dir}/devel/utt2spk" \
	#   >"${script_dir}/devel/spk2utt"
	# sort -o "${script_dir}/devel/spk2utt" "${script_dir}/devel/spk2utt"
}

eval () {
	dspcon_eval_trn | trn2ref.pl >"${script_dir}/eval/verbatim.ref"
	radiocon_eval_trn | trn2ref.pl >>"${script_dir}/eval/verbatim.ref"
	sort -o "${script_dir}/eval/verbatim.ref" "${script_dir}/eval/verbatim.ref"

	cut -d' ' -f2- "${script_dir}/eval/verbatim.ref" |
	  filter_trn \
	  >"${script_dir}/eval/plain.txt"

	# dspcon_eval_normalized_trn >"${script_dir}/eval/normalized.trn.tmp"
	# radiocon_eval_normalized_trn >>"${script_dir}/eval/normalized.trn.tmp"
	# sort_trn <"${script_dir}/eval/normalized.trn.tmp" >"${script_dir}/eval/normalized.trn"
	# rm -f "${script_dir}/eval/normalized.trn.tmp"

	# dspcon_eval_wav_list >"${script_dir}/eval/wav-list"
	# radiocon_eval_wav_list >>"${script_dir}/eval/wav-list"
	# sort -o "${script_dir}/eval/wav-list" "${script_dir}/eval/wav-list"

	# flist2scp <"${script_dir}/eval/wav-list" >"${script_dir}/eval/wav.scp"
	# sort -o "${script_dir}/eval/wav.scp" "${script_dir}/eval/wav.scp"

	# dspcon_eval_utt2spk >"${script_dir}/eval/utt2spk"
	# radiocon_eval_utt2spk >>"${script_dir}/eval/utt2spk"
	# sort -o "${script_dir}/eval/utt2spk" "${script_dir}/eval/utt2spk"

	# "${script_dir}/../scripts/utt2spk_to_spk2utt.pl" \
	#   <"${script_dir}/eval/utt2spk" \
	#   >"${script_dir}/eval/spk2utt"
	# sort -o "${script_dir}/eval/spk2utt" "${script_dir}/eval/spk2utt"
}

# mkdir -p "${script_dir}/lm-train" 
# lm_train

mkdir -p "${script_dir}/devel"
devel

mkdir -p "${script_dir}/eval"
eval
