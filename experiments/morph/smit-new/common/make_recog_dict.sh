#!/bin/bash

set -eux

export LC_ALL=C

# Begin configuration section.
# End configuration options.

echo "$0 $@"  # Print the command line for logging

[ -f path.sh ] && . ./path.sh # source the path.
. utils/parse_options.sh || return;

if [ $# != 2 ]; then
   echo "usage: common/make_dict.sh vocab dir_out"
   echo "e.g.:  common/make_dict.sh data/train/vocab data/dict"
   echo "main options (for others, see top of script file)"
   return;
fi

vocab=$1
outdir=$2

mkdir -p tmp
tmpdir=$(mktemp -d -p tmp/)
echo "Tmpdir: ${tmpdir}"
rvocab=$tmpdir/rvocab
cat ${vocab} | common/make_upp_low_map.py $tmpdir/vocab_map > $rvocab
if [ -f definitions/dict_prep/low_map ]; then
        cat definitions/dict_prep/low_map >> $tmpdir/vocab_map
fi
cat data/lexicon/lexicon.txt data/lexicon/lex| common/filter_lex.py - ${rvocab} ${tmpdir}/found.lex ${tmpdir}/oov

# echo "$(wc -l ${tmpdir}/oov) pronunciations are missing, estimating them with phonetisaurus"
# cat ${tmpdir}/oov
# touch ${tmpdir}/oov.lex

# if [[ $(wc -l < $tmpdir/oov) > 0 ]]; then
#   if [ -f data/lexicon/g2p_wfsa ]; then
#     phonetisaurus-g2pfst --print_scores=false --model=data/lexicon/g2p_wfsa --wordlist=${tmpdir}/oov | sed "s/\t$/\tSPN/" > ${tmpdir}/oov.lex
#   else
#     echo "*Training a G2P and generating missing pronunciations"
#     mkdir -p $tmpdir/g2p/
#     phonetisaurus-align --input=${tmpdir}/found.lex --ofile=$tmpdir/g2p/aligned_lexicon.corpus
#     ngram-count -order 4 -kn-modify-counts-at-end -ukndiscount\
#        -gt1min 0 -gt2min 0 -gt3min 0 -gt4min 0 \
#        -text $tmpdir/g2p/aligned_lexicon.corpus -lm $tmpdir/g2p/aligned_lexicon.arpa
#     phonetisaurus-arpa2wfst --lm=$tmpdir/g2p/aligned_lexicon.arpa --ofile=$tmpdir/g2p/g2p.fst
#     phonetisaurus-apply --nbest 2 --model $tmpdir/g2p/g2p.fst --thresh 1 --accumulate \
#        --word_list $tmpdir/oov > $tmpdir/oov.lex
#   fi
# fi

# lexicon.txt is without the _B, _E, _S, _I markers for beginning, ending, and singleton phones.
# dict_file="${dir}/lexicon.txt"
# echo "${dict_file} :: ${vocab_file}"
echo "[oov] SPN" >${outdir}/lexicon.txt
/scratch/work/moisioa3/conv_lm/scripts/vocab2dict-fi.pl -read=$rvocab >> ${outdir}/lexicon.txt

# echo "hi"
# mkdir -p ${outdir}
# utils/apply_map.pl -f 2 <(cat ${tmpdir}/found.lex ${tmpdir}/oov.lex data/lexicon/lex | sort -u) < $tmpdir/vocab_map | sed "s/ /\t/" > $tmpdir/upp.lex

# cat ${tmpdir}/upp.lex ${tmpdir}/found.lex ${tmpdir}/oov.lex data/lexicon/lex | sort -u > ${outdir}/lexicon.txt
# rm -f ${outdir}/lexiconp.txt

cp data/lexicon/silence_phones.txt ${tmpdir}/silence_phones.txt
sort -u < ${tmpdir}/silence_phones.txt > ${outdir}/silence_phones.txt

cp data/lexicon/extra_questions.txt ${tmpdir}/extra_questions.txt
sort -u < ${tmpdir}/extra_questions.txt > ${outdir}/extra_questions.txt

echo "SIL" > ${outdir}/optional_silence.txt
echo "ba"

# cut -f2- < ${outdir}/lexicon.txt | 
#         tr ' ' '\n' |
#         sed 's/^[ \t]*//;s/[ \t]*$//' |
#         sed '/^$/d' |
#         sort -u |
#         grep -v -F -f ${outdir}/silence_phones.txt
#         > ${outdir}/nonsilence_phones.txt

cut -d' ' -f2- "${outdir}/lexicon.txt" |
        tr ' ' '\n' |
        sort -u |
        egrep -v '^(SIL|SPN|NSN)$' \
        >"${outdir}/nonsilence_phones.txt"

# cp data/lexicon/nonsilence_phones.txt ${tmpdir}/nonsilence_phones.txt
# sort -u < ${tmpdir}/nonsilence_phones.txt > ${outdir}/nonsilence_phones.txt

rm -Rf ${tmpdir}
echo "na"
