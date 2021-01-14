#!/bin/bash -e
#SBATCH --partition batch
#SBATCH --time=2:00:00
#SBATCH --mem=4G

source ../../../scripts/run-expt.sh "${0}"
source "${PROJECT_SCRIPT_DIR}/score-functions.sh"


module purge
module load kaldi-2020/5968b4c-GCC-6.4.0-2.28-OPENBLAS
module load speech-scripts
module load srilm
module load sctk
module list

. ./cmd.sh
. ./path.sh
. ./utils/parse_options.sh

convert () {
	local test_set="${1}"
	local src_dir="${2}"
	local dst_dir="${3}"
	local lang_dir="${4}"

	# local src_dir=$model_dir/decode_${test_set}_word_fullvocab
	# local dst_dir=$model_dir/lattices_${test_set}_word_fullvocab

	local/convert_slf_parallel.sh --cmd "${decode_cmd}" \
	  /scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin/data/${test_set} \
	  "${lang_dir}" \
	  "${src_dir}"

	rm -rf "${dst_dir}"
	mv "${src_dir}/lats-in-htk-slf" "${dst_dir}"
	mv "${dst_dir}/lat_htk.scp" "${dst_dir}/lattice-list"
	sed -i "s:${src_dir}/lats-in-htk-slf:${dst_dir}:" "${dst_dir}/lattice-list"
	echo "Wrote ${dst_dir}/lattice-list."
}

decode () {
	local test_set="${1}"
	local model_dir="${2}"
	local lm="${3}"

	local lattices_file=$model_dir/lattices/lattice-list

	local trn_dir=${model_dir}/trn_${test_set}
	mkdir -p "${trn_dir}"


	for lm_scale in {9..13}
	do
		export DECODE_LATTICES_LM1="${lm}"
		export DECODE_LATTICES_LM_SCALE="${lm_scale}"
		export DECODE_LATTICES_ORDER="4"

		trn_file="${trn_dir}/lats-lms=${lm_scale}.trn"
		decode-lattices.sh "${lattices_file}" >"${trn_file}"
		echo "Wrote ${trn_file}."
	done
}

results () {
    local test_set="${1}"
    local model_dir="${2}"

    "${PROJECT_SCRIPT_DIR}"/score.sh \
        ${test_set} \
        ${model_dir}/trn_${test_set}/lats-lms=*.trn \
        > ${model_dir}/results_${test_set}
}

am_path=/scratch/work/moisioa3/keskustelu2020/experiments/am/converse_fin
am_dir=${am_path}/exp/chain
am=tdnn7q_sp_ensemble2

ngram=_morph_nosp_4-gram
lang_dir=${am_path}/data/lang_test${ngram}

lm=${am_path}/data/morph_lm_4-gram/kn-ip-dsp-web.arpa.gz


for decode_set in devel
do
	
	for model in rescored_lattices_${decode_set}_${am}${ngram}
	do
		# rm ${model}/../final.mdl
		# ln -s "${am_dir}/${am}/final.mdl" ${model}/../final.mdl
		# cp ${am_dir}/${am}/final.ie.id ${model}/../
		# cp ${am_dir}/${am}/num_jobs ${model}/../
		# cp ${am_dir}/${am}/frame_subsampling_factor ${model}/../
		# cp ${am_dir}/${am}/tree ${model}/../
		# cp ${am_dir}/${am}/cmvn_opts ${model}/../

		dst_dir=${model}/lattices
		if  ! [ -d ${model}/lattices_${decode_set}* ] 2> /dev/null  ; then
			echo ${decode_set} "${model}" 
			convert ${decode_set} "${model}" "${dst_dir}" "${lang_dir}"
			# decode ${decode_set} "${model}" ${lm}
			# results ${decode_set} "${model}" 
		fi
	done
done

# for decode_set in devel
# do
# 	for model in decode_${decode_set}_${am}_50best${ngram}/nnlm_weight_*
# 	do
# 		# rm ${model}/../final.mdl
# 		# ln -s "${am_dir}/${am}/final.mdl" ${model}/../final.mdl
# 		# # cp ${am_dir}/${am}/final.ie.id ${model}/../
# 		# cp ${am_dir}/${am}/num_jobs ${model}/../
# 		# cp ${am_dir}/${am}/frame_subsampling_factor ${model}/../
# 		# cp ${am_dir}/${am}/tree ${model}/../
# 		# cp ${am_dir}/${am}/cmvn_opts ${model}/../

# 		dst_dir=${model}/lattices
# 		if  ! [ -d ${model}/lattices_${decode_set}* ] 2> /dev/null  ; then
# 			echo ${decode_set} "${model}" 
# 			convert ${decode_set} "${model}" "${dst_dir}" "${lang_dir}"
# 			# decode ${decode_set} "${model}" ${lm}
# 			# results ${decode_set} "${model}" 
# 		fi
# 	done
# done