#!/bin/bash

# A script to produce the demo graphs

if [ -z "$KALDI_ROOT" ]; then
 echo "Error: \"KALDI_ROOT\" is not defined"
 exit 1
fi

#!!! Define $KALDI_ROOT to match your config !!!
# path to Kaldi's root directory
root=${KALDI_ROOT}
recipe=${root}/egs/wsj/s3

export PATH=${recipe}/scripts:${root}/src/bin:${root}/tools/openfst/bin:${root}/src/fstbin/:${root}/src/gmmbin/:${root}/src/featbin/:${root}/src/fgmmbin:${root}/src/sgmmbin:${root}/src/lm:${root}/src/latbin:${root}/src/tiedbin/:${root}/tools/sctk-2.4.0/bin:$PATH  

# Symbol table for all monophones in the acoustic model
phones_raw=phones_raw.txt

unigram=lm1.arpa
bigram=lm2.arpa
# Symbol table just for the phones in the lexicon 
phones=lexgraphs/phones.txt
tree=tree
model=tri2a.mdl

# G(LM) graphs
echo === Making the G graphs for bi- and tri-gram models ...
mkdir -p lmgraphs 2>/dev/null

echo "- Extracting the lexicon from the unigram LM ..."
cat $unigram |\
 awk '/\\1-grams.*/,/\\(2|e).*/ {if (NF >=2) {n+=1; print $2 "\t" n}} BEGIN {n=0; print "<eps>\t0";} END {print "#0\t" n+1}' \
 > lmgraphs/words.txt

echo "- Rendering the initial unigram G as produced by \"arpa2fst\" as lmgraphs/G_uni_raw.pdf"
arpa2fst $unigram > lmgraphs/G_uni_raw.fst
fstdraw --portrait=true lmgraphs/G_uni_raw.fst | dot -Tpdf > lmgraphs/G_uni_raw.pdf

echo "- Rendering the initial bigram G as produced by \"arpa2fst\" as lmgraphs/G_bi_raw.pdf"
arpa2fst $bigram > lmgraphs/G_bi_raw.fst
fstdraw --portrait=true lmgraphs/G_bi_raw.fst | dot -Tpdf > lmgraphs/G_bi_raw.pdf

echo "- Converting eps->disambig(#0) for the uni G as lmgraphs/G_uni_eps2disambig.pdf"
cat lmgraphs/G_uni_raw.fst | fstprint | eps2disambig.pl |\
 fstcompile -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt \
 > lmgraphs/G_uni_eps2disambig.fst
cat lmgraphs/G_uni_eps2disambig.fst |\
 fstdraw --portrait=true -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt |\
 dot -Tpdf > lmgraphs/G_uni_eps2disambig.pdf

echo "- Converting eps->disambig(#0) for the bi G as lmgraphs/G_bi_eps2disambig.pdf"
cat lmgraphs/G_bi_raw.fst | fstprint | eps2disambig.pl |\
 fstcompile -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt \
 > lmgraphs/G_bi_eps2disambig.fst
cat lmgraphs/G_bi_eps2disambig.fst |\
 fstdraw --portrait=true -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt |\
 dot -Tpdf > lmgraphs/G_bi_eps2disambig.pdf

echo "- Converting <s> and </s> to <eps> as lmgraphs/G_uni_s2eps.pdf"
cat lmgraphs/G_uni_eps2disambig.fst | fstprint -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt|\
 s2eps.pl |\
 fstcompile -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt \
 > lmgraphs/G_uni_s2eps.fst
cat lmgraphs/G_uni_s2eps.fst |\
 fstdraw --portrait=true -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt |\
 dot -Tpdf > lmgraphs/G_uni_s2eps.pdf

echo "- Converting <s> and </s> to <eps> as lmgraphs/G_bi_s2eps.pdf"
cat lmgraphs/G_bi_eps2disambig.fst | fstprint -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt|\
 s2eps.pl |\
 fstcompile -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt \
 > lmgraphs/G_bi_s2eps.fst
cat lmgraphs/G_bi_s2eps.fst |\
 fstdraw --portrait=true -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt |\
 dot -Tpdf > lmgraphs/G_bi_s2eps.pdf

echo "- Removing <eps> and producing the final lmgraphs/G_uni.pdf"
cat lmgraphs/G_uni_s2eps.fst | fstrmepsilon > lmgraphs/G_uni.fst
fstdraw -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt --portrait=true\
  lmgraphs/G_uni.fst | dot -Tpdf > lmgraphs/G_uni.pdf

echo "- Removing <eps> and producing the final lmgraphs/G_bi.pdf"
cat lmgraphs/G_bi_s2eps.fst | fstrmepsilon > lmgraphs/G_bi.fst
fstdraw -isymbols=lmgraphs/words.txt -osymbols=lmgraphs/words.txt --portrait=true\
  lmgraphs/G_bi.fst | dot -Tpdf > lmgraphs/G_bi.pdf

echo === G graphs rendering finished!

echo
echo '=== Making the lexicon(L) graphs ...'

mkdir -p lexgraphs 2>/dev/null

# Extract the symbols for the phones in the lexicon
cut -f2-  < lexicon.txt | \
 awk 'BEGIN{print "sil <eps>";}{print}' |\
 tr ' ' '\n' | sort -u |\
 awk 'NR==FNR{arr[$1]; next;} ($1 in arr)' FS=' ' - ${phones_raw} \
 > $phones


silphones="sil"; # This would in general be a space-separated list of all silence phones.  E.g. "sil vn"
# Generate colon-separated lists of silence and non-silence phones.
silphones.pl $phones "$silphones" lexgraphs/silphones.csl \
  lexgraphs/nonsilphones.csl

echo '- Creating a lexicon with disambiguation symbols: lexgraphs/lexicon_disambig.txt'
ndisambig=`add_lex_disambig.pl lexicon.txt lexgraphs/lexicon_disambig.txt`
ndisambig=$[$ndisambig+1]; # add one disambig symbol for silence in lexicon FST.
echo '- Adding disambiguation phones to the symtab: lexgraphs/phones_disambig.txt'
#add_disambig.pl $phones $ndisambig > lexgraphs/phones_disambig.txt
( for n in `seq 0 $ndisambig`; do echo '#'$n; done ) >lexgraphs/disambig.txt

# Create phone symbol table.
cat $phones lexgraphs/disambig.txt | \
  awk 'NF==2{high=$2; print; next;} NF==1{high+=1; print $1, high;}' FS=' ' > lexgraphs/phones_disambig.txt 

echo '- Creating lexgraphs/L.pdf - no disambiguation symbols (usually used for training)'
silprob=0.5
make_lexicon_fst.pl lexicon.txt $silprob sil  | \
  fstcompile --isymbols=$phones --osymbols=lmgraphs/words.txt \
   --keep_isymbols=false --keep_osymbols=false | \
   fstarcsort --sort_type=olabel > lexgraphs/L.fst

cat lexgraphs/L.fst |\
 fstdraw -isymbols=$phones -osymbols=lmgraphs/words.txt -portrait=true |\
 dot -Tpdf >lexgraphs/L.pdf

echo '- Creating lexgraphs/L_disambig.pdf - w/ disambiguation symbols (decoding)'
# Create the lexicon FST with disambiguation symbols, and put it in lang_test.
# There is an extra step where we create a loop to "pass through" the
# disambiguation symbols from G.fst.
phone_disambig_symbol=`grep \#0 lexgraphs/phones_disambig.txt | awk '{print $2}'`
word_disambig_symbol=`grep \#0 lmgraphs/words.txt | awk '{print $2}'`
make_lexicon_fst.pl lexgraphs/lexicon_disambig.txt $silprob sil '#'$ndisambig | \
   fstcompile --isymbols=lexgraphs/phones_disambig.txt \
    --osymbols=lmgraphs/words.txt \
    --keep_isymbols=false --keep_osymbols=false |\
   fstaddselfloops  "echo $phone_disambig_symbol |" "echo $word_disambig_symbol |" | \
   fstarcsort --sort_type=olabel \
    > lexgraphs/L_disambig.fst

cat lexgraphs/L_disambig.fst |\
 fstdraw -isymbols=lexgraphs/phones_disambig.txt -osymbols=lmgraphs/words.txt -portrait=true |\
 dot -Tpdf >lexgraphs/L_disambig.pdf

echo === Lexicon graphs rendering finished!

echo
echo === Composing L*G

mkdir -p cascade 2>/dev/null

echo '- L_disambig * G_uni == cascade/LG_uni.pdf'
fsttablecompose lexgraphs/L_disambig.fst lmgraphs/G_uni.fst |\
  fstdeterminizestar --use-log=true | \
  fstminimizeencoded  > cascade/LG_uni.fst || exit 1;

cat cascade/LG_uni.fst |\
 fstdraw -isymbols=lexgraphs/phones_disambig.txt \
  -osymbols=lmgraphs/words.txt -portrait=true |\
 dot -Tpdf >cascade/LG_uni.pdf

echo '- L_disambig * G_bi == cascade/LG_bi.pdf'
fsttablecompose lexgraphs/L_disambig.fst lmgraphs/G_bi.fst |\
  fstdeterminizestar --use-log=true | \
  fstminimizeencoded  > cascade/LG_bi.fst || exit 1;

cat cascade/LG_bi.fst |\
 fstdraw -isymbols=lexgraphs/phones_disambig.txt \
  -osymbols=lmgraphs/words.txt -portrait=true |\
 dot -Tpdf >cascade/LG_bi.pdf

echo '=== L*G composition finished!'
echo

echo '=== Building context-dependency transducer'

mkdir cdgraphs 2>/dev/null

echo "- Creating cdgraphs/C.fst"

grep '#' lexgraphs/phones_disambig.txt | awk '{print $2}' \
  > lexgraphs/disambig_phones.list
subseq_sym=`tail -1 lexgraphs/phones_disambig.txt | awk '{print $2+1;}'`
echo "\$ $subseq_sym" |
 cat lexgraphs/phones_disambig.txt - > cdgraphs/phones_disambig_subseq.txt

fstmakecontextfst --read-disambig-syms=lexgraphs/disambig_phones.list \
 --write-disambig-syms=cdgraphs/disambig_ilabels.list $phones $subseq_sym \
   cdgraphs/ilabels | fstarcsort --sort_type=olabel > cdgraphs/C.fst

# Make context-dependent symbols for rendering
fstmakecontextsyms lexgraphs/phones.txt cdgraphs/ilabels > cdgraphs/ctxsyms.txt

# Render C
fstdraw -portrait=true \
 -isymbols=cdgraphs/ctxsyms.txt -osymbols=cdgraphs/phones_disambig_subseq.txt \
 < cdgraphs/C.fst | dot -Tpdf > cdgraphs/C.pdf


echo "- Adding subseq. loop and saving cdgraphs/LG_uni_subseq.fst" 

# Add a "subsequential loop" to consume the special "$" output symbol
# at the final transitions of C
fstaddsubsequentialloop ${subseq_sym} cascade/LG_uni.fst > cdgraphs/LG_uni_subseq.fst

fstdraw -portrait=true \
  -isymbols=cdgraphs/phones_disambig_subseq.txt \
  -osymbols=lmgraphs/words.txt \
  cdgraphs/LG_uni_subseq.fst | dot -Tpdf > cdgraphs/LG_uni_subseq.pdf

echo "- Adding subseq. loop and saving cdgraphs/LG_bi_subseq.fst" 

# Add a "subsequential loop" to consume the special "$" output symbol
# at the final transitions of C
fstaddsubsequentialloop ${subseq_sym} cascade/LG_bi.fst > cdgraphs/LG_bi_subseq.fst

fstdraw -portrait=true \
  -isymbols=cdgraphs/phones_disambig_subseq.txt \
  -osymbols=lmgraphs/words.txt \
  cdgraphs/LG_bi_subseq.fst | dot -Tpdf > cdgraphs/LG_bi_subseq.pdf

echo "- Composing C*LG_uni_subseq -> cacade/CLG_uni.fst"

fsttablecompose cdgraphs/C.fst cdgraphs/LG_uni_subseq.fst |\
 fstdeterminizestar --use-log=true |\
 fstminimizeencoded \
 > cascade/CLG_uni.fst

fstdraw -portrait=true \
  -isymbols=cdgraphs/ctxsyms.txt \
  -osymbols=lmgraphs/words.txt \
  cascade/CLG_uni.fst | dot -Tpdf > cascade/CLG_uni.pdf

echo "- Composing C*LG_bi_subseq -> cacade/CLG_bi.fst"

fsttablecompose cdgraphs/C.fst cdgraphs/LG_bi_subseq.fst > cascade/CLG_bi.fst

fstdraw -portrait=true \
  -isymbols=cdgraphs/ctxsyms.txt \
  -osymbols=lmgraphs/words.txt \
  cascade/CLG_bi.fst | dot -Tpdf > cascade/CLG_bi.pdf

echo "- Build a physical-to-logical triphone mapping FST"

make-ilabel-transducer --write-disambig-syms=cdgraphs/disambig_ilabels_remapped.list\
 cdgraphs/ilabels $tree $model cdgraphs/ilabels.remapped \
 > cdgraphs/ilabel_map.fst

# Make a symbol table for visualization of the physical C input symbols 
fstmakecontextsyms lexgraphs/phones.txt cdgraphs/ilabels.remapped \
 > cdgraphs/ctxsyms.remapped.txt

fstdraw -portrait=true \
 -isymbols=cdgraphs/ctxsyms.remapped.txt \
 -osymbols=cdgraphs/ctxsyms.txt cdgraphs/ilabel_map.fst |\
 dot -Tpdf > cdgraphs/ilabel_map.pdf


echo "- Build a reduced CLG cascade/CLG_uni_reduced.fst"

fsttablecompose cdgraphs/ilabel_map.fst cascade/CLG_uni.fst |\
 fstdeterminizestar --use-log=true |\
 fstminimizeencoded \
 > cascade/CLG_uni_reduced.fst

fstdraw -portrait=true \
 -isymbols=cdgraphs/ctxsyms.remapped.txt \
 -osymbols=lmgraphs/words.txt cascade/CLG_uni_reduced.fst |\
 dot -Tpdf > cascade/CLG_uni_reduced.pdf

echo "- Stats for the original CLG"
fstinfo cascade/CLG_uni.fst | egrep '(# of states)|(# of arcs)'

echo "- Stats for the reduced CLG"
fstinfo cascade/CLG_uni_reduced.fst | egrep '(# of states)|(# of arcs)'

echo "- Build a reduced CLG cascade/CLG_bi_reduced.fst"

fsttablecompose cdgraphs/ilabel_map.fst cascade/CLG_bi.fst |\
 fstdeterminizestar --use-log=true |\
 fstminimizeencoded \
 > cascade/CLG_bi_reduced.fst

fstdraw -portrait=true \
 -isymbols=cdgraphs/ctxsyms.remapped.txt \
 -osymbols=lmgraphs/words.txt cascade/CLG_bi_reduced.fst |\
 dot -Tpdf > cascade/CLG_bi_reduced.pdf

echo "- Stats for the original CLG"
fstinfo cascade/CLG_bi.fst | egrep '(# of states)|(# of arcs)'

echo "- Stats for the reduced CLG"
fstinfo cascade/CLG_bi_reduced.fst | egrep '(# of states)|(# of arcs)'


echo "=== Context-dependency stage finished"
echo

echo "=== Building HMM level transducer hmmgraphs/Ha.fst ..."

mkdir -p hmmgraphs 2>/dev/null

make-h-transducer --disambig-syms-out=hmmgraphs/disambig_tstate.list \
   --transition-scale=1.0  cdgraphs/ilabels.remapped \
   $tree $model  > hmmgraphs/Ha.fst


if [ `command -v fstmaketidsyms >/dev/null 2>&1` ]; then
# NOTE: not in the official Kaldi distro
fstmaketidsyms ${phones_raw} $model > hmmgraphs/tids.txt
egrep '#' cdgraphs/ctxsyms.txt |\
  awk 'NR==FNR{arr[NR]=$1;next} {print arr[FNR] " " $1;}' \
    - hmmgraphs/disambig_tstate.list \
  >> hmmgraphs/tids.txt
else
 echo "fstmaketidsyms not found - using a pre-built transition-id symbol table."
 cp ./tids.txt hmmgraphs/tids.txt
fi


fstdraw -portrait=true \
 -isymbols=hmmgraphs/tids.txt \
 -osymbols=cdgraphs/ctxsyms.remapped.txt hmmgraphs/Ha.fst |\
 dot -Tpdf > hmmgraphs/Ha.pdf

echo "=== Building HMM transducer finished!"
echo

echo "=== Composing the final HCLG graph"

echo "- Making HCLG graph without self-loops cascade/HCLGa_uni.fst"

fsttablecompose hmmgraphs/Ha.fst cascade/CLG_uni_reduced.fst | \
   fstdeterminizestar --use-log=true | \
   fstrmsymbols hmmgraphs/disambig_tstate.list | \
   fstrmepslocal  | fstminimizeencoded \
   > cascade/HCLGa_uni.fst

fstdraw -portrait=true \
 -isymbols=hmmgraphs/tids.txt \
 -osymbols=lmgraphs/words.txt cascade/HCLGa_uni.fst |\
 dot -Tpdf > cascade/HCLGa_uni.pdf

echo "- Adding the self-loops to HCLGa_uni -> cascade/HCLG_uni.fst"
add-self-loops --self-loop-scale=0.1 \
    --reorder=true $model < cascade/HCLGa_uni.fst > cascade/HCLG_uni.fst

fstdraw -portrait=true \
 -isymbols=hmmgraphs/tids.txt \
 -osymbols=lmgraphs/words.txt cascade/HCLG_uni.fst |\
 dot -Tpdf > cascade/HCLG_uni.pdf

echo "- Making HCLG graph without self-loops cascade/HCLGa_bi.fst"

fsttablecompose hmmgraphs/Ha.fst cascade/CLG_bi_reduced.fst | \
   fstdeterminizestar --use-log=true | \
   fstrmsymbols hmmgraphs/disambig_tstate.list | \
   fstrmepslocal  | fstminimizeencoded \
   > cascade/HCLGa_bi.fst

fstdraw -portrait=true \
 -isymbols=hmmgraphs/tids.txt \
 -osymbols=lmgraphs/words.txt cascade/HCLGa_bi.fst |\
 dot -Tpdf > cascade/HCLGa_bi.pdf

echo "- Adding the self-loops to HCLGa_uni -> cascade/HCLG_bi.fst"
add-self-loops --self-loop-scale=0.1 \
    --reorder=true $model < cascade/HCLGa_bi.fst > cascade/HCLG_bi.fst

fstdraw -portrait=true \
 -isymbols=hmmgraphs/tids.txt \
 -osymbols=lmgraphs/words.txt cascade/HCLG_bi.fst |\
 dot -Tpdf > cascade/HCLG_bi.pdf

echo "=== Building the final HCLG graphs finished"