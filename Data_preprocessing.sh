#!/bin/bash
#SBATCH --job-name=BAM_preproc      
#SBATCH -c 16                   
#SBATCH -p single
#SBATCH --output=bam_preproc_%j.log  
#SBATCH --time 10-0

# Set path to java, gatk, picard and reference files:
JAVA="/home/bin/jdk-15/bin/java"
GATK="/home/gatk-4.2.2.0/gatk" 
REF="/home/reference/Homo_sapiens_assembly38.fasta"
KNOWN_SITES_SNP="/home/reference/Homo_sapiens_assembly38.dbsnp138.vcf"
KNOWN_SITES_INDEL="/home/reference/Homo_sapiens_assembly38.known_indels.vcf.gz"
PICARD="/home/picard/build/libs/picard.jar"

# File name and directory:
BAM_FILE="dedup_DON-449-6xKO.hg38.alignment.bam"
BAM_DIR="/home/449_6KO_Picard"

# Read Group Sample:
RGSM=449_6KO

# COMMANDS:
cd $VCF_DIR

#RGPl:read group platform, LB: read group library, RGPU:platform unit, SM: sample name
$JAVA -jar $PICARD AddOrReplaceReadGroups I=$BAM_DIR/$BAM_FILE O=RG_dedup_file.bam RGID=DON RGLB=lib1 RGPL=ILLUMINA SORT_ORDER=coordinate RGPU=unit1 RGSM=$RGSM

$GATK --java-options -Xmx16G BaseRecalibrator -R $REF -I RG_dedup_file.bam --known-sites $KNOWN_SITES_SNP --known-sites $KNOWN_SITES_INDEL -O ./recal_data_file.table 

#Apply generated model to our dataset:
$GATK --java-options -Xmx16G ApplyBQSR -R $REF -I RG_dedup_file.bam --bqsr-recal-file ./recal_data_file.table -O BQSR_RG_dedup_file.bam


