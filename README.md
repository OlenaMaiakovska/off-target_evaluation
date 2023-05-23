# Off-target evaluation of RNP Cas9 activity

This is the repository of code used for alignment, variant detection and multistep filtering.

## Mapping

DRAGEN BioIT platform using Germline App version 3.7.5
DRAGEN Graph based algorithm uses alt-aware mapping for population haplotypes stitched into the reference with known alignments to establish alternate graph paths that reads could seed-map and align to. The graph mapper reduces mapping ambiguity because reads that contain population variants are attracted to the specific regions where the variants are observed, finally generating a highly specific read alignments to the reference human genome.
Human genome version = hg38
https://www.illumina.com/products/by-type/informatics-products/basespace-sequence-hub/apps/dragen-germline.html 


## Post-alignment Quality Control and Data Processing 

Post-alignment quality control is conducted to evaluate the accuracy and reliability of the aligned reads. This process entails assessing various alignment metrics, including mapping quality, coverage depth, and insert size distribution, which collectively verify the quality of the alignment outcomes.

Scripts used:
```bash
Data_preprocessing.sh
Duplicates_mark_and_removal.sh
Duplicates_removal_samtools.sh
```
Samplot was used as an alternative way of duplicates removal. 

## Variant calling

After the alignment process, variant calling algorithms are utilized to detect genetic variants. These algorithms compare the aligned reads with the reference genome to identify positions where the individual's genome shows variations compared to the reference. The detected variants are categorized into different types such as single nucleotide polymorphisms (SNPs), small insertions or deletions (indels), copy number variations (CNVs), or larger structural variants, based on the specific type and size of the detected variation.

Following scripts run via Slurm:
```bash
Manta.sh
Mutect2.sh
Strelka.sh
VarScan.sh
freebayes.sh
```
Scripts run via docker:
```bash
ClinSV.txt
```
[![DOI](https://zenodo.org/badge/643891130.svg)](https://zenodo.org/badge/latestdoi/643891130)
