#!/bin/bash -e
#SBATCH --time=0:30:00
#SBATCH --mem=100M

# set -x

source ../../../scripts/run-expt.sh "${0}"

module purge
module load srilm

# nosp = no silence & pronunciation probabilities
dir="${EXPT_WORK_DIR}/dict/nosp"
mkdir -p "${dir}"

# generate vocab from the arpa LM
vocab_file="${dir}/vocab.txt"
common/extract_vocab_from_arpa.py < "${LM}" | env LC_ALL=C sort -u > "${dir}/vocab1"
cat "${dir}/vocab1" | grep -v "<s>" | grep -v "</s>" | LC_ALL=C sort -u > "${vocab_file}"

mkdir -p tmp
tmpdir=$(mktemp -d -p tmp/)
echo "Tmpdir: ${tmpdir}"
rvocab=$tmpdir/rvocab
cat ${vocab} | common/make_upp_low_map.py $tmpdir/vocab_map > $rvocab
if [ -f definitions/dict_prep/low_map ]; then
        cat definitions/dict_prep/low_map >> $tmpdir/vocab_map
fi
cat data/lexicon/lexicon.txt data/lexicon/lex| common/filter_lex.py - ${rvocab} ${tmpdir}/found.lex ${tmpdir}/oov

cat ${tmpdir}/oov
touch ${tmpdir}/oov.lex

/scratch/work/moisioa3/conv_lm/scripts/vocab2dict-fi.pl -read=$rvocab >> $tmpdir/oov.lex

echo "hi"
mkdir -p ${dir}
utils/apply_map.pl -f 2 <(cat ${tmpdir}/found.lex ${tmpdir}/oov.lex data/lexicon/lex | sort -u) < $tmpdir/vocab_map | sed "s/ /\t/" > $tmpdir/upp.lex

cat ${tmpdir}/upp.lex ${tmpdir}/found.lex ${tmpdir}/oov.lex data/lexicon/lex | sort -u > ${dir}/lexicon.txt
rm -f ${dir}/lexiconp.txt

cp data/lexicon/silence_phones.txt ${tmpdir}/silence_phones.txt
sort -u < ${tmpdir}/silence_phones.txt > ${dir}/silence_phones.txt

cp data/lexicon/extra_questions.txt ${tmpdir}/extra_questions.txt
sort -u < ${tmpdir}/extra_questions.txt > ${dir}/extra_questions.txt

echo "SIL" > ${dir}/optional_silence.txt
echo "ba"

cut -f2- < ${dir}/lexicon.txt | tr ' ' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sed '/^$/d' | sort -u | grep -v -F -f ${dir}/silence_phones.txt > ${dir}/nonsilence_phones.txt

rm -Rf ${tmpdir}
echo "na"
