#!/bin/bash
#SBATCH --job-name=Strelka     
#SBATCH -c 32                   
#SBATCH -p single
#SBATCH --output=Strelka_%j.log  
#SBATCH --time 14-0

#Set path to java, gatk, picard and reference files:
STRELKA="/home/bq_omaiakovska/bin/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py"
SAMTOOLS="/home/samtools-1.11/samtools"
SEQKIT="/home/bq_omaiakovska/seqkit"
REF="/home/reference/Homo_sapiens_assembly38.fasta"

#File name and directory: 

BAM_DIR="/home/bam_files"
DESCR="450_WT_vs_1KO_Pd"
WT="450_WT_Picard/BQSR_RG_dedup_file.selected.bam"
KO="450_1KO_Picard/BQSR_RG_dedup_file.selected.bam"


#COMMANDS:
cd $BAM_DIR
#Selection of genomic regions with chromosomes and large scaffolds
#$SAMTOOLS view -L $BAM_DIR/Homo_sapiens_assembly38.bed -o $BAM_DIR/${WT%.bam}.selected.bam $BAM_DIR/$WT
#$SAMTOOLS view -L $BAM_DIR/Homo_sapiens_assembly38.bed -o $BAM_DIR/${KO%.bam}.selected.bam $BAM_DIR/$KO

#Sorting & Indexing for alignment files:
#$SAMTOOLS sort $BAM_DIR/$WT -o $BAM_DIR/${WT%.bam}.sorted.bam
#$SAMTOOLS index $BAM_DIR/${WT%.bam}.sorted.bam
#$SAMTOOLS sort $BAM_DIR/$KO -o $BAM_DIR/${KO%.bam}.sorted.bam
#$SAMTOOLS index $BAM_DIR/${KO%.bam}.sorted.bam

#To remove small scaffolds and contigs from reference genome and after this command now ref called REF%.fasta}.flt.fasta:
$SEQKIT grep -rvip "^HLA-" $REF > ${REF%.fasta}.flt.fasta

#Indexing reference genome:
$SAMTOOLS faidx ${REF%.fasta}.flt.fasta

#Variant Calling with Strelka Somatic Workflow:
$STRELKA --normalBam $BAM_DIR/${WT%.bam}.sorted.bam --tumorBam $BAM_DIR/${KO%.bam}.sorted.bam --referenceFasta ${REF%.fasta}.flt.fasta --indelCandidates ${DESCR}_Manta/results/variants/candidateSmallIndels.vcf.gz --runDir ${DESCR}_Strelka
$BAM_DIR/${DESCR}_Strelka/runWorkflow.py -m local -j 32 



