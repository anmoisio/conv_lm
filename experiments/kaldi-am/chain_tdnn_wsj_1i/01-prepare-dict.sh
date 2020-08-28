#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load speech-scripts
module load srilm
module list

echo "$0 $@"  # Print the command line for logging
. utils/parse_options.sh || exit 1;

# nosp = no silence & pronunciation probabilities
dir=data/local/dict${dict_suffix}
mkdir -p "${dir}"

TRAIN_TRN="${PROJECT_DIR}/data/am-train/verbatim.trn"
vocab_file="${dir}/vocab.txt"
echo "${vocab_file} :: ${TRAIN_TRN}"
sed 's/(.*$//' "${TRAIN_TRN}" |
  ngram-count -order 1 -no-sos -no-eos -text - -write-vocab - |
  egrep -v '^(-pau-|<s>|</s>|<unk>)$' \
  >"${vocab_file}"

# lexicon.txt is without the _B, _E, _S, _I markers for beginning, ending, and singleton phones.
dict_file="${dir}/lexicon.txt"
echo "${dict_file} :: ${vocab_file}"
echo "[oov] SPN" >"${dict_file}"
vocab2dict-fi.pl -read="${vocab_file}" >>"${dict_file}"
rm -f "${dir}/lexiconp.txt"

# silence phones, one per line.
(echo SIL; echo SPN; echo NSN) > $dir/silence_phones.txt
echo SIL > $dir/optional_silence.txt

# nonsilence phones; on each line is a list of phones that correspond
# really to the same base phone.
# Create a list of normal (non-silence) phones. We have only one stress.
symbols_file="${dir}/nonsilence_phones.txt"
echo "${symbols_file} :: ${dict_file}"
cut -d' ' -f2- "${dict_file}" |
  tr ' ' '\n' |
  sort -u |
  egrep -v '^(SIL|SPN|NSN)$' \
  >"${symbols_file}"

# A few extra questions that will be added to those obtained by automatically clustering
# the "real" phones.  These ask about stress; there's also one for silence.
cat $dir/silence_phones.txt| awk '{printf("%s ", $1);} END{printf "\n";}' > $dir/extra_questions.txt || exit 1;
cat $dir/nonsilence_phones.txt | perl -e 'while(<>){ foreach $p (split(" ", $_)) {
  $p =~ m:^([^\d]+)(\d*)$: || die "Bad phone $_"; $q{$2} .= "$p "; } } foreach $l (values %q) {print "$l\n";}' \
 >> $dir/extra_questions.txt || exit 1;
