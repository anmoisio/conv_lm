## Starting basic training on MFCC features
steps/train_mono.sh --nj 30 --cmd "$train_cmd" \
                      data/train_30kshort data/lang_nosp exp/mono

steps/align_si.sh --nj 30 --cmd "$train_cmd" \
                    data/train_100k_nodup data/lang_nosp exp/mono exp/mono_ali

steps/train_deltas.sh --cmd "$train_cmd" \
                        3200 30000 \
                        data/train_100k_nodup data/lang_nosp exp/mono_ali exp/tri1




# tri2
steps/align_si.sh --nj 30 --cmd "$train_cmd" \
                data/train_100k_nodup data/lang_nosp exp/tri1 exp/tri1_ali

steps/train_deltas.sh --cmd "$train_cmd" \
                    4000 70000 \
                    data/train_100k_nodup data/lang_nosp exp/tri1_ali exp/tri2

                    


# The 100k_nodup data is used in the nnet2 recipe.
steps/align_si.sh --nj 30 --cmd "$train_cmd" \
                data/train_100k_nodup data/lang_nosp exp/tri2 exp/tri2_ali_100k_nodup

# From now, we start using all of the data (except some duplicates of common
# utterances, which don't really contribute much).
steps/align_si.sh --nj 30 --cmd "$train_cmd" \
                data/train_nodup data/lang_nosp exp/tri2 exp/tri2_ali_nodup

# Do another iteration of LDA+MLLT training, on all the data.
steps/train_lda_mllt.sh --cmd "$train_cmd" \
                          6000 140000 data/train_nodup \
                          data/lang_nosp exp/tri2_ali_nodup exp/tri3


# Now we compute the pronunciation and silence probabilities from training data,
# and re-create the lang directory.
# steps/get_prons.sh --cmd "$train_cmd" data/train_nodup data/lang_nosp exp/tri3
# utils/dict_dir_add_pronprobs.sh --max-normalize true \
#                                 data/local/dict_nosp exp/tri3/pron_counts_nowb.txt exp/tri3/sil_counts_nowb.txt \
#                                 exp/tri3/pron_bigram_counts_nowb.txt data/local/dict


# Train tri4, which is LDA+MLLT+SAT, on all the (nodup) data.
steps/align_fmllr.sh --nj 30 --cmd "$train_cmd" \
                    data/train_nodup data/lang exp/tri3 exp/tri3_ali_nodup


steps/train_sat.sh  --cmd "$train_cmd" \
                    11500 200000 data/train_nodup data/lang exp/tri3_ali_nodup exp/tri4



# MMI training starting from the LDA+MLLT+SAT systems on all the (nodup) data.
steps/align_fmllr.sh --nj 50 --cmd "$train_cmd" \
                    data/train_nodup data/lang exp/tri4 exp/tri4_ali_nodup

steps/make_denlats.sh --nj 50 --cmd "$decode_cmd" \
                    --config conf/decode.config --transform-dir exp/tri4_ali_nodup \
                    data/train_nodup data/lang exp/tri4 exp/tri4_denlats_nodup

# 4 iterations of MMI seems to work well overall. The number of iterations is
# used as an explicit argument even though train_mmi.sh will use 4 iterations by
# default.
num_mmi_iters=4
steps/train_mmi.sh --cmd "$decode_cmd" \
                    --boost 0.1 --num-iters $num_mmi_iters \
                    data/train_nodup data/lang exp/tri4_{ali,denlats}_nodup exp/tri4_mmi_b0.1


# Now do fMMI+MMI training
steps/train_diag_ubm.sh --silence-weight 0.5 --nj 50 --cmd "$train_cmd" \
                        700 data/train_nodup data/lang exp/tri4_ali_nodup exp/tri4_dubm

steps/train_mmi_fmmi.sh --learning-rate 0.005 \
                        --boost 0.1 --cmd "$train_cmd" \
                        data/train_nodup data/lang exp/tri4_ali_nodup exp/tri4_dubm \
                        exp/tri4_denlats_nodup exp/tri4_fmmi_b0.1