#!/bin/bash -e

source ../../../scripts/run-expt.sh "${0}"

module purge
module load kaldi-vanilla

cd "${EXPT_SCRIPT_DIR}"
mkdir -p "${PROJECT_DIR}/lattices"

src_dir="${EXPT_WORK_DIR}/models/chain/decode"
dst_dir="${PROJECT_DIR}/lattices/movies"

../tdnn/utils/convert_slf_parallel.sh --cmd "${DECODE_CMD}" \
	"${EXPT_WORK_DIR}/data_movies" \
	"${EXPT_WORK_DIR}/../tdnn/lang/baseline-nosp" \
	"${src_dir}"

rm -rf "${dst_dir}"
mv "${src_dir}/lats-in-htk-slf" "${dst_dir}"
mv "${dst_dir}/lat_htk.scp" "${dst_dir}/lattice-list"
sed -i "s:${src_dir}/lats-in-htk-slf:${dst_dir}:" "${dst_dir}/lattice-list"
echo "Wrote ${dst_dir}/lattice-list."

