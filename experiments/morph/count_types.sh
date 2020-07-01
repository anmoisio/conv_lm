#!/bin/bash -e
#SBATCH --time=00:10:00
#SBATCH --mem=4G
#SBATCH -o word-types-%j.txt

for corpusdir in ./*/segmented-data*/
do
    echo "${corpusdir}"
    python3 count_types_corpus.py <(zcat "${corpusdir}/dsp.txt.gz" \
                                         "${corpusdir}/web.txt.gz")
done

# for corpusdir in ./*/segmented-data*/
# do
#     echo "${corpusdir}"
#     head <(zcat "${corpusdir}/dsp.txt.gz")
# done