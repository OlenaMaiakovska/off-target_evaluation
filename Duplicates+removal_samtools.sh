#!/bin/bash
#SBATCH --job-name=rmdup     
#SBATCH -c 16                    
#SBATCH -p single
#SBATCH --output=rmdup_%j.log  
#SBATCH --time 10-0

SAMTOOLS="/home/samtools-1.11/samtools"
GATK="/home/bq_omaiakovska/gatk-4.2.2.0/gatk" 
PICARD="/home/bq_omaiakovska/picard/build/libs/picard.jar" 
FILES="/home/bam_files"

# File name and directory:
BAM_file="DON-449-6xKO.hg38.alignment.bam"
OUT="449_6KO"

cd /home
#mkdir $OUT 

#Sorting with samtools for names
$SAMTOOLS sort -n -o $OUT/namesort.bam $FILES/$BAM_file

#Adding ms and MC tags for markdup
$SAMTOOLS fixmate -m $OUT/namesort.bam $OUT/fixmate.bam

$SAMTOOLS sort -o $OUT/positionsort.bam $OUT/fixmate.bam

#Remove duplicates
$SAMTOOLS markdup -r $OUT/positionsort.bam $OUT/${BAM_file%.bam}_.rmdup.bam
rm $OUT/namesort.bam
rm $OUT/fixmate.bam
rm $OUT/positionsort.bam   

$SAMTOOLS index $OUT/${BAM_file%.bam}_.rmdup.bam  
$SAMTOOLS flagstat $OUT/${BAM_file%.bam}_.rmdup.bam  > $OUT/${BAM_file%.bam}_rmdup.aln.fstat
