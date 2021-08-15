#!/bin/bash
#SBATCH --time=04:00:00
#SBATCH --job-name=finetunefinbert-hf
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=1
#SBATCH --output=/scratch/work/moisioa3/conv_lm/finbert-finetune/slurm-output/%x-%j.out
#SBATCH --gres=gpu:1

module purge
module load cuDNN/7-CUDA-9.0.176
module load miniconda/4.9.2
module list

source activate hf-mlm-finetune

project_dir="/scratch/work/moisioa3/conv_lm"
data_dir="${project_dir}/data/lm-train"
# train_file_name="dsp"
# train_file_name="web-dsp"
train_file_name="opensubtitles_all"
# devel_file="${project_dir}/data/devel/plain.txt"
devel_file="${data_dir}/momaf-14-movies-preprocessed.txt"

cased="cased"
# cased="uncased"
pretrained="TurkuNLP/bert-base-finnish-${cased}-v1"

python ../transformers/examples/pytorch/language-modeling/run_mlm.py \
    --model_name_or_path "${pretrained}" \
    --train_file "${data_dir}/${train_file_name}.txt" \
    --validation_file "${devel_file}" \
    --do_train \
    --do_eval \
    --output_dir "${project_dir}/finbert-finetune/${pretrained}-finetuned-${train_file_name}"
