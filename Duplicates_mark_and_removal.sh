#!/bin/bash
#SBATCH --job-name=rdup_picard    
#SBATCH -c 32                    
#SBATCH -p single
#SBATCH --output=rmdup_picard_%j.log  
#SBATCH --time 10-0

# Set path to java, gatk, picard and reference files: 
JAVA="/home/bq_omaiakovska/jdk-15/bin/java"
PICARD="/home/bq_omaiakovska/picard/build/libs/picard.jar" 
VCF_FILES="/home/input_data"


# Alignment file(s) and output directory

BAM_file="DON-450-WT.hg38.alignment.bam"
OUT="450_WT_Picard"

# COMMANDS:
cd /home
mkdir $OUT 

$JAVA -Djava.io.tmpdir=`pwd`/tmp6 -jar $PICARD MarkDuplicates I=$VCF_FILES/$BAM_file O=$OUT/dedup_{$BAM_file} M=$OUT/file.metrics.txt 
