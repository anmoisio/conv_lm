#!/bin/bash

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla
module list

. utils/parse_options.sh  # e.g. this parses the --stage option if supplied.
. path.sh

for data in devel eval
do
    nspk=$(wc -l <data/test_${data}/spk2utt)
    steps/decode.sh --nj $nspk --cmd "$decode_cmd" exp/tri1/graph_nosp_tgpr \
    data/test_${data} exp/tri1/decode_nosp_tgpr_${data} || exit 1;

    # test various modes of LM rescoring (4 is the default one).
    # This is just confirming they're equivalent.
    for mode in 1 2 3 4 5
    do
    steps/lmrescore.sh --mode $mode --cmd "$decode_cmd" \
        data/lang_nosp_test_{tgpr,tg} data/test_${data} \
        exp/tri1/decode_nosp_tgpr_${data} \
        exp/tri1/decode_nosp_tgpr_${data}_tg$mode  || exit 1;
    done
    # later on we'll demonstrate const-arpa LM rescoring, which is now
    # the recommended method.
done