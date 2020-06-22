#!/bin/bash -e
#SBATCH --time=1:30:00
#SBATCH --mem=8G

source ../../../scripts/run-expt.sh "${0}"

module purge
module load srilm
module load speech-scripts

declare -a TRAIN_FILES=(
	"${PROJECT_DIR}/data/lm-train/dsp.txt"
	"${PROJECT_DIR}/data/lm-train/web.txt")

concatenate_corpora () {
	if [ -n "${1}" ]
	then
        train_files=("${1}")
	else
		declare -a train_files=("${TRAIN_FILES[@]}")
	fi

	[ -n "${SENTENCE_LIMIT}" ] || SENTENCE_LIMIT="-0"

	if [ -n "${CLASSES}" ]
	then
		# head will make gzip return a non-zero exit code.
		gzip --stdout --decompress --force "${train_files[@]}" |
		  grep -v '######' |
		  head --lines="${SENTENCE_LIMIT}" |
		  replace-words-with-classes classes="$CLASSES" || true
	else
		# head will make gzip return a non-zero exit code.
		gzip --stdout --decompress --force "${train_files[@]}" |
		  grep -v '######' |
		  head --lines="${SENTENCE_LIMIT}" || true
	fi

	return 0
}

estimate_srilm () {
	# Output language model file.
	local model_file="${1}"
	shift

	# Vocabulary file contains one word per line. Any text following the word
	# such as counts will be ignored.
	local vocab_file="${1}"
	shift

	local ngram_order="${NGRAM_ORDER:-4}"
	declare -a args=(-order "${ngram_order}")
	if [ "${OPEN_VOCABULARY_NGRAM}" ]
	then
		args+=(-unk)
	else
		args+=(-limit-vocab)
	fi
    # interpolate all n-gram orders
	args+=(-interpolate1 -interpolate2 -interpolate3 -interpolate4 -interpolate5 -interpolate6)
    # minimum count of n-grams that are included in the LM
	args+=(-gt4min 2 -gt5min 2 -gt6min 2)
    # N-gram counts from text file
	args+=(-text -)
	args+=(-lm "${model_file}")
	args+=("${@}")

	echo ngram-count "${args[@]}" -vocab "<(cut -f1 ${vocab_file})"
	ngram-count "${args[@]}" -vocab <(cut -f1 "${vocab_file}")
}

# create vocab
vocab_file="${EXPT_WORK_DIR}/word.vocab"
concatenate_corpora |
    ngram-count -order 1 -text - -no-sos -no-eos -write-vocab - |
    egrep -v '(-pau-|<s>|</s>|<unk>)' \
    >"${vocab_file}"

# dspcon LM
train_file="${PROJECT_DIR}/data/lm-train/dsp.txt"
model_file="${EXPT_WORK_DIR}/dsp.arpa.gz"
echo "${model_file} :: ${train_file}"
declare -a discounting=(-kndiscount1 -kndiscount2 -kndiscount3 -kndiscount4 -kndiscount5 -kndiscount6)
concatenate_corpora "${train_file}" |
    estimate_srilm "${model_file}" "${vocab_file}" "${discounting[@]}"

# web text LM
train_file="${PROJECT_DIR}/data/lm-train/web.txt"
model_file="${EXPT_WORK_DIR}/web.arpa.gz"
echo "${model_file} :: ${train_file}"
declare -a discounting=(-kndiscount1 -kndiscount2 -kndiscount3 -kndiscount4 -kndiscount5 -kndiscount6)
concatenate_corpora "${train_file}" |
    estimate_srilm "${model_file}" "${vocab_file}" "${discounting[@]}"


# ngram-count -order 4 -limit-vocab -interpolate1 -interpolate2 -interpolate3 -interpolate4 -interpolate5 -interpolate6 -gt4min 2 -gt5min 2 -gt6min 2 -text "${PROJECT_DIR}/data/lm-train/dsp.txt" -lm "${EXPT_WORK_DIR}/dsp.arpa.gz" -kndiscount1 -kndiscount2 -kndiscount3 -kndiscount4 -kndiscount5 -kndiscount6 -vocab <(cut -f1 "${EXPT_WORK_DIR}/word.vocab")

# # # web text
# ngram-count -order 4 -limit-vocab -interpolate1 -interpolate2 -interpolate3 -interpolate4 -interpolate5 -interpolate6 -gt4min 2 -gt5min 2 -gt6min 2 -text "${PROJECT_DIR}/data/lm-train/web.txt" -lm "${EXPT_WORK_DIR}/web.arpa.gz" -kndiscount1 -kndiscount2 -kndiscount3 -kndiscount4 -kndiscount5 -kndiscount6 -vocab <(cut -f1 "${EXPT_WORK_DIR}/word.vocab")