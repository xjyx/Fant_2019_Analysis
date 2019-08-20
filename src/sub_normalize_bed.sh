#!/bin/bash

echo "Submitting Multiple NormalizeBed Jobs"
c1=/scratch/Users/zama8258/processed_nascent/samtools/C413_1_S3_R1_001.trim.sorted.bam
c2=/scratch/Users/zama8258/processed_nascent/samtools/C413_2_S4_R1_001.trim.sorted.bam
p1=/scratch/Users/zama8258/processed_nascent/samtools/PO_1_S1_R1_001.trim.sorted.bam
p2=/scratch/Users/zama8258/processed_nascent/samtools/PO_2_S2_R1_001.trim.sorted.bam
sbatch --export	InterestFile="$c1" --job-name="C1-FPKM" normalizeBed.sh
# sbatch --export	InterestFile="$c2" --job-name="C2-FPKM" normalizeBed.sh
# sbatch --export	InterestFile="$p1" --job-name="P1-FPKM" normalizeBed.sh
# sbatch --export	InterestFile="$p2" --job-name="P2-FPKM" normalizeBed.sh
