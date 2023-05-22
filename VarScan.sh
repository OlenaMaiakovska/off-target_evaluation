#!/bin/bash
#SBATCH --job-name=VarScan    
#SBATCH -c 32                  
#SBATCH -p single
#SBATCH --output=VarScan_%j.log  
#SBATCH --time 10-0



# Set path to samtools, bam-readcount and reference genome:

SAMTOOLS="/net/home.isilon/nwg-grimm/Members_current/Olena_Maiakovska/bin/samtools-1.11/samtools"
bam-readcount="/home/bam-readcount"
REF="/mnt/sds-hd/sd21j005/Manuel/Homo_sapiens_assembly38_chr23.fasta"

# File name and directory:
#BAM_FILE="DON-449-1xKO.hg38.alignment_.rmdup.bam"
BAM_DIR="/home/bam_files/Manuel"
DESCR="450_WT_vs_6KO_Pd"
WT="450_WT_Picard/BQSR_RG_dedup_file.selected.sorted.bam"
KO="450_6KO_Picard/BQSR_RG_dedup_file.selected.sorted.bam"

#COMMANDS:
cd $BAM_DIR

#Variant calling with VarScan for ${DESCR}
$SAMTOOLS mpileup -B -f $REF -q 15 -d 10000 $WT > ${WT%.bam}.fifo &
$SAMTOOLS mpileup -B -f $REF -q 15 -d 10000 $KO > ${KO%.bam}.fifo &
varscan somatic ${WT%.bam}.fifo ${KO%.bam}.fifo ${DESCR}_VarScan

rm ${WT%.bam}.fifo
rm ${KO%.bam}.fifo
varscan processSomatic ${DESCR}_VarScan.snp --min-tumor-freq=0.7 --max-normal-freq=0.05 --p-value=0.05
varscan processSomatic ${DESCR}_VarScan.indel --min-tumor-freq=0.7 --max-normal-freq=0.05 --p-value=0.05

mkdir -p ${DESCR}_VarScan
mv ${DESCR}_VarScan.* ${DESCR}_VarScan

# Preparion of file for bam-readcount
sed 1d ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc | awk '{print $1"\t"$2"\t"$2}' > ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc.var 
sed 1d ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc | awk '{print $1"\t"$2"\t"$2}' > ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc.var

#Run bam-readcount to get variant statistics
$bam-readcount -q15 -w1 -b15 -l ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc.var -f $REF $KO > ./${DESCR}_VarScan/${DESCR}.snp.readCounts
$bam-readcount -q15 -w1 -b15 -l ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc.var -f $REF $KO > ./${DESCR}_VarScan/${DESCR}.indel.readCounts

#Preparing file for fpfilter"
var="./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc"
var2="./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc"
cat $var | sed '/^#/d' | sed 1d | cut -f 1-4 > ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc.var.var 
cat $var2 | sed '/^#/d' | sed 1d | cut -f 1-4 > ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc.var.var


#Filtering using fpfilter 
varscan fpfilter ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc.var.var ./${DESCR}_VarScan/${DESCR}.snp.readCounts --min-var-count 5 --min-var-freq 0.25 --min-strandedness 0.01 -output-file ./${DESCR}_VarScan/${DESCR}_VarScan.snp.Somatic.hc.fpfilter
varscan fpfilter ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc.var.var ./${DESCR}_VarScan/${DESCR}.indel.readCounts --min-var-count 2 --min-strandedness 0 -min-var-freq 0.25 -output-file ./${DESCR}_VarScan/${DESCR}_VarScan.indel.Somatic.hc.fpfilter

