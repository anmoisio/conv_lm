#!/bin/bash -e

VOCAB_SIZE="100000"
ARCHITECTURE="word+proj500+lstm1500+htanh1500x4+dropout0.2+softmax"
SEQUENCE_LENGTH="25"
BATCH_SIZE="24"
COST="nce"
OPTIMIZATION_METHOD="adagrad"
STOPPING_CRITERION="annealing-count"
VALIDATION_FREQ="5"
PATIENCE="2"
LEARNING_RATE="5"
GRADIENT_DECAY_RATE=""
EPSILON=""
NUM_NOISE_SAMPLES="100"
NOISE_DAMPENING="0.75"
NOISE_SHARING="batch"
MAX_GRADIENT_NORM="5"
UNK_PENALTY="-20"
LATTICES="chain-fullvocab"
MAX_TOKENS_PER_NODE="62"
BEAM="650"
RECOMBINATION_ORDER="22"
DEBUG=""
PROFILE=""
