#!/bin/bash -e
#SBATCH --time=0:30:00
#SBATCH --mem=8G

# set -x

source ../../../scripts/run-expt.sh "${0}"

module purge
# module load speech-scripts
module load srilm

# nosp = no silence & pronunciation probabilities
dir="${EXPT_WORK_DIR}/dict/nosp"
mkdir -p "${dir}"

# generate vocab from the arpa LM
vocab_file="${dir}/vocab.txt"
common/extract_vocab_from_arpa.py < "${LM}" | env LC_ALL=C sort -u > vocab1
cat vocab1 | egrep -v '^(-pau-|<s>|</s>|<unk>|<UNK>)$' | LC_ALL=C sort -u > "${vocab_file}"

## the way vocab was generated without a pretrained LM:
# echo "${vocab_file} :: ${TRAIN_TRN}"
# sed 's/(.*$//' "${TRAIN_TRN}" |
#   ngram-count -order 1 -no-sos -no-eos -text - -write-vocab - |
#   egrep -v '^(-pau-|<s>|</s>|<unk>)$' \
#   >"${vocab_file}"

# lexicon.txt is without the _B, _E, _S, _I markers for beginning, ending, and singleton phones.
dict_file="${dir}/lexicon.txt"
echo "${dict_file} :: ${vocab_file}"
echo "[oov] SPN" >"${dict_file}"
# vocab2dict-fi.pl -read="${vocab_file}" >>"${dict_file}"
/scratch/work/moisioa3/conv_lm/scripts/vocab2dict-fi.pl -read="${vocab_file}" >>"${dict_file}"

rm -f "${dir}/lexiconp.txt"

# Create a list of normal (non-silence) phones. We have only one stress.
symbols_file="${dir}/nonsilence_phones.txt"
echo "${symbols_file} :: ${dict_file}"
cut -d' ' -f2- "${dict_file}" |
  tr ' ' '\n' |
  sort -u |
  egrep -v '^(SIL|SPN|NSN)$' \
  >"${symbols_file}"

# Create a list of silence phones.
echo "${dir}/silence_phones.txt"
echo 'SIL' >"${dir}/silence_phones.txt"
echo 'SPN' >>"${dir}/silence_phones.txt"
echo 'NSN' >>"${dir}/silence_phones.txt"

echo "${dir}/optional_silence.txt"
echo 'SIL' >"${dir}/optional_silence.txt"

# Here we would have extra questions about stress if we would use it; there's
# also one for silence.
echo "${dir}/extra_questions.txt :: ${dir}/<non>silence_phones.txt"
awk '{
    printf("%s ", $1);
  }
  END {
    printf "\n";
  }' "${dir}/silence_phones.txt" \
  >"${dir}/extra_questions.txt"
perl -e '
  while(<>) {
    foreach $phone (split(" ", $_)) {
      $phone =~ m/^([^\d]+)(\d*)$/ || die "Invalid phone in nonsilence_phones.txt: $_";
      $phones{$2} .= "$phone ";
    }
  }
  foreach $phone (values %phones) {
    print "$phone\n";
  }' "${dir}/nonsilence_phones.txt" \
  >>"${dir}/extra_questions.txt"
