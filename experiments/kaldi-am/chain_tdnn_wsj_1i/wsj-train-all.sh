steps/train_mono.sh --boost-silence 1.25 \
    --nj 10 --cmd "$train_cmd" \
    data/train_si84_2kshort data/lang_nosp exp/mono0a || exit 1;

steps/align_si.sh --boost-silence 1.25 --nj 10 --cmd "$train_cmd" \
    data/train_si84_half data/lang_nosp exp/mono0a exp/mono0a_ali || exit 1;

steps/train_deltas.sh --boost-silence 1.25 --cmd "$train_cmd" \
    2000 10000 \
    data/train_si84_half data/lang_nosp exp/mono0a_ali exp/tri1 || exit 1;




# tri2b.  there is no special meaning in the "b"-- it's historical.
steps/align_si.sh --nj 10 --cmd "$train_cmd" \
    data/train_si84 data/lang_nosp exp/tri1 exp/tri1_ali_si84 || exit 1;

steps/train_lda_mllt.sh --cmd "$train_cmd" \
    --splice-opts "--left-context=3 --right-context=3" 2500 15000 \
    data/train_si84 data/lang_nosp exp/tri1_ali_si84 exp/tri2b || exit 1;





# From 2b system, train 3b which is LDA + MLLT + SAT.

# Align tri2b system with all the si284 data.
steps/align_si.sh  --nj 10 --cmd "$train_cmd" \
    data/train_si284 data/lang_nosp exp/tri2b exp/tri2b_ali_si284  || exit 1;

steps/train_sat.sh --cmd "$train_cmd" 4200 40000 \
    data/train_si284 data/lang_nosp exp/tri2b_ali_si284 exp/tri3b || exit 1;


# Estimate pronunciation and silence probabilities.

# Silprob for normal lexicon.
# steps/get_prons.sh --cmd "$train_cmd" \
# data/train_si284 data/lang_nosp exp/tri3b || exit 1;
# utils/dict_dir_add_pronprobs.sh --max-normalize true \
# data/local/dict_nosp \
# exp/tri3b/pron_counts_nowb.txt exp/tri3b/sil_counts_nowb.txt \
# exp/tri3b/pron_bigram_counts_nowb.txt data/local/dict || exit 1

# utils/prepare_lang.sh data/local/dict \
# "<SPOKEN_NOISE>" data/local/lang_tmp data/lang || exit 1;


# From 3b system, now using data/lang as the lang directory (we have now added
# pronunciation and silence probabilities), train another SAT system (tri4b).
steps/train_sat.sh  --cmd "$train_cmd" 4200 40000 \
    data/train_si284 data/lang exp/tri3b exp/tri4b || exit 1;