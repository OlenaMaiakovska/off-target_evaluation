#!/bin/bash
#SBATCH --job-name=Mutect2      
#SBATCH -c 32                  
#SBATCH -p single
#SBATCH --output=Mutect2_%j.log  
#SBATCH --time 14-0

# Set path to java, gatk, picard and reference files:
JAVA="/home/bq_omaiakovska/jdk-15/bin/java"
GATK="/home/bq_omaiakovska/atk-4.1.0.0/gatk"
BAM_DIR="/home/bam_files" 
REF="/home/reference/Homo_sapiens_assembly38.fasta"
Mutect2="/home/Mutect2"

# File name and directory:
#BAM_FILE="DON-449-1xKO.hg38.alignment_.rmdup.bam"

DESCR="450_WT_vs_1KO_Pd"
NORMAL_NAME="450_WT"
TUMOR_NAME="450_1KO"
WT="450_WT_Picard/BQSR_RG_dedup_file.bam"
KO="450_1KO_Picard/BQSR_RG_dedup_file.bam"

#COMMAND:
cd $BAM_DIR

#Variant Calling with Mutect2 for ${DESCR}
$GATK Mutect2 -R $REF -I $BAM_DIR/$WT -normal $NORMAL_NAME -I $BAM_DIR/$KO -tumor $TUMOR_NAME -O somatic_${DESCR}.vcf.gz

$GATK IndexFeatureFile -F somatic_${DESCR}.vcf.gz

#Filtering raw variants after first Mutect2 call for ${DESCR}
$GATK FilterMutectCalls -V ${DESCR}_Mutect/somatic_${DESCR}.vcf.gz -R $REF -O ${DESCR}_Mutect/filtered_som_${DESCR}.vcf.gz


