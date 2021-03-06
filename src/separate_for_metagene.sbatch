#!/bin/bash
#SBATCH --output=/scratch/Users/zama8258/processed_nascent/e_and_o/%x_%j.out
#SBATCH --error=/scratch/Users/zama8258/processed_nascent/e_and_o/%x_%j.err
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=16gb
#SBATCH --mail-user=zama8258@colorado.edu
# separate_for_metagene.bash --- Separates FPKM normalized calls for metagene
#
# Filename: separate_for_metagene.bash
# Description: Separates FPKM normalized calls for metagene generation
# Author: Student Zachary Maas <zama8258@colorado.edu>
# Maintainer: Student Zachary Maas <zama8258@colorado.edu>
# Created: Thu Feb 28 11:25:26 2019 (-0700)
#

# Commentary:
#
# This script should be fed in the fpkm files from the script
# calc_maximal_isoform.sbatch, and it will generate bedfiles to be fed
# into metagene for both the initiation region and the rest of the
# gene, after some preliminary filtering.
#

# Code:

set -euo pipefail

# Data read-in and tmp files
srcBed=/scratch/Users/zama8258/processed_nascent/fpkm/C413_1_S3_R1_001.trim.sorted.isoform_max
scratch=/scratch/Users/zama8258/processed_nascent/metagene/
filtered="$scratch"/lenfilter.fpkm
sorted="$scratch"/sorted.fpkm

topGenes="$scratch"/topGenes.bed
bottomGenes="$scratch"/bottomGenes.bed
middleGenes="$scratch"/middleGenes.bed

shortGenes="$scratch"/shortGenes.bed
mediumGenes="$scratch"/mediumGenes.bed
mediumLongGenes="$scratch"/mediumLongGenes.bed
longGenes="$scratch"/longGenes.bed

quartile1Genes="$scratch"/quartile1Genes.bed
quartile2Genes="$scratch"/quartile2Genes.bed
quartile3Genes="$scratch"/quartile3Genes.bed
quartile4Genes="$scratch"/quartile4Genes.bed

lendiff="$scratch"/lendiff

# Variable setup
topAndBottomThreshold=500 # Take the top "n" genes off the top and bottom
minLengthThreshold=2000 # Minimum gene length that we require

# Load bedtools
module load bedtools

## TODO Adjust filtering to be used to give a fixed window

# Filter off genes shorter than the threshold
awk -v OFS='\t' -v thresh="$minLengthThreshold" \
		'{if (sqrt($3-$2)^2 > thresh) print $1, $2, $3, $4, $5, $6, $7, $8}' "$srcBed" > "$filtered"
wc -l "$srcBed" > "$lendiff"
wc -l "$filtered" >> "$lendiff"

# Take the top and bottom "threshold" genes as defined above
# First, sort in reverse order
sort -grk7,7 "$filtered" > "$sorted"

echo "Separating All" &
head -n"$topAndBottomThreshold" "$sorted" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$topGenes" &
tail -n"$topAndBottomThreshold" "$sorted" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$bottomGenes" &
head -n-"$topAndBottomThreshold" "$sorted" | \
		tail -n+"$topAndBottomThreshold" | cut -f1-6 | \
		bedtools sort > "$middleGenes" &
wait

# Then, generate tables for different length genes
awk -v OFS='\t' '{if ($3 - $2 < 10000) print $0}' "$filtered" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$shortGenes"
awk -v OFS='\t' '{if ($3 - $2 > 10000 &&  $3 - $2 < 25000) print $0}' "$filtered" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$mediumGenes"
awk -v OFS='\t' '{if ($3 - $2 > 25000 &&  $3 - $2 < 65000) print $0}' "$filtered" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$mediumLongGenes"
awk -v OFS='\t' '{if ($3 - $2 > 65000) print $0}' "$filtered" | \
		sort -k1,1 -k2,2 | cut -f1-6 | bedtools sort > "$longGenes"

pushd "$scratch"

split -n l/4 -d "$sorted" quartile_
sort -k1,1 -k2,2 quartile_00 | cut -f1-6 > "$quartile1Genes" &
sort -k1,1 -k2,2 quartile_01 | cut -f1-6 > "$quartile2Genes" &
sort -k1,1 -k2,2 quartile_02 | cut -f1-6 > "$quartile3Genes" &
sort -k1,1 -k2,2 quartile_03 | cut -f1-6 > "$quartile4Genes" &
wait

popd

echo "Done"
#
# separate_for_metagene.bash ends here
