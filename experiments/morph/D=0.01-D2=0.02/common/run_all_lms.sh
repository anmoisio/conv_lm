#Begin options
dataset=yle-dev-new
iter=final
write_opts='exp/chain_tdnn_blstm'
recog_langs=data/recog_langs
lm_dir=data/lm
nj=8
#End options

. utils/parse_options.sh || return;
. cmd.sh

if [ $# -ne 1 ]; then
   echo "usage: common/run_all_lms.sh [options] <acoustic model>"
   echo "e.g.:  common/run_all_lms.sh --dataset yle-dev exp/chain/model/tdnn"
   echo "main options (for others, see top of script file)"

   exit 0;
fi

am=$1

dsname=$(basename $dataset)
extra=_$dsname

if [ "$iter" != "final" ]; then
  extra=${iter}${extra}
fi

mkdir -p logs data/recog_langs 

for model_type in word; do  
    for lm_type in lin.web.dsp.arpa; do 

    timestamp=`date +%s`
    
    if [ ! -f ${recog_langs}/${model_type}_${lm_type}/G.fst ]; then
        outdir=$(dirname ${recog_langs})
        lm=${lm_dir}/${model_type}/${lm_type}/arpa
        echo "Creating G.fst for ${model_type} ${lm_type}";
        common/process_lm.sh ${lm} ${outdir} &> logs/process_lm.${timestamp}.out
    fi
    
    case ${am} in
    *chain*)   

        if [ ! -f ${am}/feats/$dataset/feats.scp ]; then
            echo "Creating MFCCs for ${am} $dataset"
            common/prep_dataset.sh --mfcc-config conf/mfcc_hires.conf --mfcc-out-dir ${am}/feats/$dataset --ivecs-extractor "" data/$dataset > logs/feats.${timestamp}.out
        fi

        if [ ! -f ${write_opts}/graph_${model_type}_${lm_type}/HCLG.fst ]; then
            echo "Creating HCLG for ${am} ${model_type} ${lm_type}";
            utils/mkgraph.sh --self-loop-scale 1.0 ${recog_langs}/${model_type}_${lm_type} ${am} ${write_opts}/graph_${model_type}_${lm_type} &> logs/mkgraph.${timestamp}.out
        fi
    
        if [ ! -f ${write_opts}/decode${extra}_${model_type}_${lm_type}/scoring_kaldi/best_wer ]; then
            echo "Decoding ${am} ${model_type} ${lm_type}";
            common/recognize.sh --dataset $dataset --iter $iter --write-to ${write_opts} ${am} ${recog_langs}/${model_type}_${lm_type} &>logs/recognize.d${dataset}.${timestamp}.out
        fi
        ;;
    *tri3*)
        if [ ! -f ${write_opts}/graph_${model_type}_${lm_type}/HCLG.fst ]; then
            echo "Creating HCLG for ${am} ${model_type} ${lm_type}";
            utils/mkgraph.sh ${recog_langs}/${model_type}_${lm_type} ${am} ${write_opts}/graph_${model_type}_${lm_type} &> logs/mkgraph.${timestamp}.out
        fi

        if [ ! -f ${write_opts}/decode${extra}_${model_type}_${lm_type}/scoring_kaldi/best_wer ]; then
            echo "Decoding ${am} ${model_type} ${lm_type}";
            steps/decode_fmllr.sh --nj ${nj} --cmd "${decode_cmd}" --max-fmllr-jobs ${nj} ${write_opts}/graph_${model_type}_${lm_type} ${write_opts}/feats/${dataset} ${write_opts}/decode${extra}_${model_type}_${lm_type} &>logs/recognize.d${dataset}.${timestamp}.out
        fi
        ;;
    esac

    done
done
