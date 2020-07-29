#!/bin/bash

export LC_ALL=C
set -e

# Begin configuration section.
# End configuration section.

. ./utils/parse_options.sh

if [ $# != 2 ]; then
   echo "Create LM graph"
   echo "Usage: common/process_lm.sh <lm> <outdir>"
   return;
fi

model=$1
outdir=$2

if [ ! -f ${model} ]; then
   echo "arpa is missing at ${model}. Make sure this file exists."
   return;
fi

srcdir=$(dirname ${model})
mname=$(basename ${srcdir})
pdir=$(dirname ${srcdir})
model_type=$(basename ${pdir})

echo srcdir "${srcdir}"
echo mname "${mname}"
echo pdir "${pdir}"
echo model_type "${model_type}"

if [ ! -f ${pdir}/type ]; then
   echo "type file missing is at ${pdir}/type"
   exit 1;
fi

if [ ! -f ${srcdir}/vocab ]; then
  common/extract_vocab_from_arpa.py < ${model} | env LC_ALL=C sort -u > ${srcdir}/vocab1
  cat ${srcdir}/vocab1 | grep -v "<s>" | grep -v "</s>" | LC_ALL=C sort -u > ${srcdir}/vocab
fi

mkdir -p $outdir/langs $outdir/dicts $outdir/recog_langs
mkdir -p $outdir/langs/${model_type}_${mname} $outdir/dicts/${model_type}_${mname} $outdir/recog_langs/${model_type}_${mname}

common/make_recog_dict.sh ${srcdir}/vocab $outdir/dicts/${model_type}_${mname}
t=$(cat ${pdir}/type)

case $t in
word)
  extra=1
  ;;
*)
  extra=3
  ;;
esac

utils/prepare_lang.sh   $outdir/dicts/${model_type}_${mname} "<UNK>" $outdir/langs/${model_type}_${mname}/local $outdir/langs/${model_type}_${mname} # --phone-symbol-table data/lang/phones.txt # --num-extra-phone-disambig-syms $extra


dir=$outdir/langs/${model_type}_${mname}
tmpdir=$outdir/langs/${model_type}_${mname}/local

case $t in
*suf)
  common/make_lfst_suf.py $(tail -n1 $dir/phones/disambig.txt) < $tmpdir/lexiconp_disambig.txt | fstcompile --isymbols=$dir/phones.txt --osymbols=$dir/words.txt --keep_isymbols=false --keep_osymbols=false | fstaddselfloops  $dir/phones/wdisambig_phones.int $dir/phones/wdisambig_words.int | fstarcsort --sort_type=olabel > $dir/L_disambig.fst
  ;;
*pre)
  common/make_lfst_pre.py $(tail -n1 $dir/phones/disambig.txt) < $tmpdir/lexiconp_disambig.txt | fstcompile --isymbols=$dir/phones.txt --osymbols=$dir/words.txt --keep_isymbols=false --keep_osymbols=false | fstaddselfloops  $dir/phones/wdisambig_phones.int $dir/phones/wdisambig_words.int | fstarcsort --sort_type=olabel > $dir/L_disambig.fst
  ;;
*aff)
  common/make_lfst_aff.py $(tail -n1 $dir/phones/disambig.txt) < $tmpdir/lexiconp_disambig.txt | fstcompile --isymbols=$dir/phones.txt --osymbols=$dir/words.txt --keep_isymbols=false --keep_osymbols=false | fstaddselfloops  $dir/phones/wdisambig_phones.int $dir/phones/wdisambig_words.int | fstarcsort --sort_type=olabel > $dir/L_disambig.fst
  ;;
*wma)
  common/make_lfst_wma.py $(tail -n3 $dir/phones/disambig.txt) < $tmpdir/lexiconp_disambig.txt | fstcompile --isymbols=$dir/phones.txt --osymbols=$dir/words.txt --keep_isymbols=false --keep_osymbols=false | fstaddselfloops  $dir/phones/wdisambig_phones.int $dir/phones/wdisambig_words.int | fstarcsort --sort_type=olabel > $dir/L_disambig.fst
  ;;
*)
  echo "word model, L_disambig.fst not edited"
  ;;
esac

if [ ! -f $outdir/recog_langs/${model_type}_${mname}/G.fst ]; then
  common/make_recog_lang.sh --inwordbackoff false ${model} $outdir/langs/${model_type}_${mname} $outdir/recog_langs/${model_type}_${mname}
fi


