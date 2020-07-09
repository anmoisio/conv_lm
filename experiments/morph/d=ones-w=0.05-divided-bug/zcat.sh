#!/bin/bash -e

for file in segmented-data/web{1..6}.txt
do
    zcat "${file}".gz > "${file}"
done