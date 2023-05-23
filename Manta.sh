#!/bin/bash
#SBATCH --job-name=Manta     
#SBATCH -c 32                   
#SBATCH -p single
#SBATCH --output=Manta_%j.log  
#SBATCH --time 10-0


# Set path to java, gatk, manta and reference files:
JAVA="/home/bq_omaiakovska/jdk-15/bin/java"
GATK="/home/bq_omaiakovska/gatk-4.2.2.0/gatk" 
MANTA="/home/bq_omaiakovska/manta-1.6.0.centos6_x86_64/bin/configManta.py"
REF="/home/reference/Homo_sapiens_assembly38.fasta"

# File name and directory:
#BAM_FILE="DON-449-1xKO.hg38.alignment_.rmdup.bam"
BAM_DIR="/home/bam_files"
DESCR="450_WT_vs_6KO_Pd"
WT="450_WT_Picard/BQSR_RG_dedup_file.selected.sorted.bam"
KO="450_6KO_Picard/BQSR_RG_dedup_file.selected.sorted.bam"

#COMMANDS:

cd $BAM_DIR

#Variant calling with Manta:
python $MANTA --normalBam $WT --tumorBam $KO --referenceFasta ${REF%.fasta}.flt.fasta --runDir ${DESCR}_Manta

python $VCF_DIR/${DESCR}_Manta/runWorkflow.py -j 32
