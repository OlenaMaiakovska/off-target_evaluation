#!/bin/bash
#SBATCH --job-name=freebayes    
#SBATCH -c 32       
#SBATCH -p single
#SBATCH --output=freebayes_%j.log  
#SBATCH --time 14-0 
#SBATCH --error=freebayes_32CPU_bench_%j.err

# Set path to java, gatk, picard and reference files:
FREEBAYES="/home/bq_omaiakovska/freebayes/build/freebayes"
FREEBAYES_PARALLEL="/home/bq_omaiakovska/freebayes/scripts/freebayes-parallel"
REF="/home/reference/Homo_sapiens_assembly38.fasta"
#bamlist="/home/bq_omaiakovska/slurm_jobs/BAMFILENAMES.lst"
SEQKIT="/home/bq_omaiakovska/bin/seqkit"
SAMTOOLS="/net/home.isilon/nwg-grimm/Members_current/Olena_Maiakovska/bin/samtools-1.11/samtools"
bamaddrg="/home/bq_omaiakovska/bamaddrg"

# File name and directory:
#BAM_FILE="DON-449-1xKO.hg38.alignment_.rmdup.bam"
BAM_DIR="/home/bam_files"
DESCR="freebayes_DON_450_Pc"
S1="450_WT"
S2="450_1KO"
S3="450_6KO"
INPUT_DIR1="450_WT_Picard"
INPUT_DIR2="450_1KO_Picard"
INPUT_DIR3="450_6KO_Picard"

#COMMAND:

#mkdir -p $VCF_DIR/$DESCR

# Sample labelling and variant calling with freebayes for ${DESCR}
$bamaddrg -b $BAM_DIR/$INPUT_DIR1/BQSR_RG_dedup_file.selected.sorted.bam -s $S1 \
-b $BAM_DIR/$INPUT_DIR2/BQSR_RG_dedup_file.selected.sorted.bam -s $S2 \
-b $BAM_DIR/$INPUT_DIR3/BQSR_RG_dedup_file.selected.sorted.bam -s $S3 \
| $FREEBAYES --stdin -f $REF --report-all-haplotype-alleles --min-mapping-quality 30 --min-base-quality 20 --min-coverage 10 --report-genotype-likelihood-max -v $VCF_DIR/${DESCR}.vcf

#Freebayes-parallel
#bamaddrg -b $BAM_DIR/$INPUT_DIR1/BQSR_RG_dedup_file.bam -s $S1 \
#-b $VCF_DIR/$INPUT_DIR2/BQSR_RG_dedup_file.bam -s $S2 \
#-b $VCF_DIR/$INPUT_DIR3/BQSR_RG_dedup_file.bam -s $S3 \
#| $FREEBAYES_PARALLEL <(/home/bq_omaiakovska/freebayes/scripts/fasta_generate_regions.py ${REF}.fai 100000) 32 --stdin -f $REF --report-all-haplotype-alleles --min-mapping-quality 30 --min-base-quality 20 --min-coverage 6 --report-genotype-likelihood-max -v $BAM_DIR/${DESCR}_Freebayes_parallel.vcf

