#!/bin/bash
#SBATCH -p short
#SBATCH -N 1
#SBATCH -c 32
#SBATCH --mem=64gb
#SBATCH --mail-user=zama8258@colorado.edu
#SBATCH --output=/scratch/Users/zama8258/processed_nascent/e_and_o/%x_%j.out
#SBATCH --error=/scratch/Users/zama8258/processed_nascent/e_and_o/%x_%j.err

# Bed files
beddir=/scratch/Users/zama8258/processed_nascent/bedtools
cr1="$beddir"/C413_1_S3_R1_001.trim.bedGraph
cr2="$beddir"/C413_2_S4_R1_001.trim.bedGraph
pr1="$beddir"/PO_1_S1_R1_001.trim.bedGraph
pr2="$beddir"/PO_2_S2_R1_001.trim.bedGraph

# FPKM files
fpkmdir=/scratch/Users/zama8258/processed_nascent/fpkm
cr1f="$fpkmdir"/C413_1_S3_R1_001.trim.sorted.isoform_max.bed
cr2f="$fpkmdir"/C413_2_S4_R1_001.trim.sorted.isoform_max.bed
pr1f="$fpkmdir"/PO_1_S1_R1_001.trim.sorted.isoform_max.bed
pr2f="$fpkmdir"/PO_2_S2_R1_001.trim.sorted.isoform_max.bed

outdir=/scratch/Users/zama8258/pause_output/testing
script=/scratch/Users/zama8258/pause_analysis_src/calculate_pause_index_to_polya.sh
upstream=-30
downstream=300
tag=TEST

bash "$script" \
		 --ref="$cr1f" \
		 --pus="$upstream" \
		 --pds="$downstream" \
		 --gds="$tag" \
		 --outdir="$outdir" \
		 --bedfile="$cr1" &
bash "$script" \
		 --ref="$cr2f" \
		 --pus="$upstream" \
		 --pds="$downstream" \
		 --gds="$tag" \
		 --outdir="$outdir" \
		 --bedfile="$cr2" &
bash "$script" \
		 --ref="$pr1f" \
		 --pus="$upstream" \
		 --pds="$downstream" \
		 --gds="$tag" \
		 --outdir="$outdir" \
		 --bedfile="$pr1" &
bash "$script" \
		 --ref="$pr2f" \
		 --pus="$upstream" \
		 --pds="$downstream" \
		 --gds="$tag" \
		 --outdir="$outdir" \
		 --bedfile="$pr2" &
wait

# ScriptDir=/scratch/Users/zama8258/pause_analysis_src
# python "$ScriptDir"/convert_isoform.py -l "$ScriptDir"/refseq_to_common_id.txt \
		# 			 -f "$StrandsMerged" \
		# 			 -o "$FPKMCommonID"
