#!/bin/bash -e
#
# Tell Theano to use as the GPUs specified by $DEVICES.

cuda_capability=$("${PROJECT_DIR}/opt/deviceQuery/deviceQuery" |
                  grep 'CUDA Capability' |
                  head -1 |
                  tr -cd [0-9] || true)
declare -a devices=("${DEVICES[@]:-cuda0}")
declare -a contexts
for i in "${!devices[@]}"
do
	contexts+=("dev${i}->${devices[${i}]}")
done
THEANO_FLAGS="floatX=float32,device=${devices[0]}"
if [ ${#devices[@]} -gt 1 ]
then
	THEANO_FLAGS=$(IFS=,; echo "${THEANO_FLAGS},contexts=${contexts[*]}")
fi
cache_dir="${TMPDIR}/theano"
[ -n "${SLURM_JOBID}" ] && cache_dir="${cache_dir}-${SLURM_JOBID}"
THEANO_FLAGS="${THEANO_FLAGS},base_compiledir=${cache_dir}"
THEANO_FLAGS="${THEANO_FLAGS},exception_verbosity=high"
[ -n "${DEBUG}" ] && THEANO_FLAGS="${THEANO_FLAGS},optimizer=None"
#THEANO_FLAGS="${THEANO_FLAGS},nvcc.fastmath=True"
#[ -n "${cuda_capability}" ] && THEANO_FLAGS="${THEANO_FLAGS},nvcc.flags=-arch=sm_${cuda_capability}"
export THEANO_FLAGS
