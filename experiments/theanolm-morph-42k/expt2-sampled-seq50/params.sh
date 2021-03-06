#!/bin/bash -e

VOCAB_SIZE=""
ARCHITECTURE="word+proj500+lstm1500+htanh1500x4+dropout0.2+softmax"
SEQUENCE_LENGTH="50"
BATCH_SIZE="24"
WEIGHTS="${EXPT_SCRIPT_DIR}/weights"
COST="cross-entropy"
OPTIMIZATION_METHOD="adagrad"
STOPPING_CRITERION="annealing-count"
VALIDATION_FREQ="5"
PATIENCE="2"
MAX_EPOCHS="25"
LEARNING_RATE="0.1"
GRADIENT_DECAY_RATE=""
EPSILON=""
NUM_NOISE_SAMPLES="500"
NOISE_DAMPENING="0.5"
NOISE_SHARING="batch"
MAX_GRADIENT_NORM="5"

UNK_PENALTY="-20"
MAX_TOKENS_PER_NODE="62"
BEAM="650"
RECOMBINATION_ORDER="22"
SUBWORD_STYLE="prefix-affix"
DEBUG=""
# LATTICES="chain-morph-42k"
LATTICES='morph-srilm-5-gram'
