# Off-target evaluation of RNP Cas9 activity

This is the repository of code used for alignment, variant detection and multistep filtering.

##Mapping: 

DRAGEN BioIT platform using Germline App version 3.7.5
DRAGEN Graph based algorithm uses alt-aware mapping for population haplotypes stitched into the reference with known alignments to establish alternate graph paths that reads could seed-map and align to. The graph mapper reduces mapping ambiguity because reads that contain population variants are attracted to the specific regions where the variants are observed, finally generating a highly specific read alignments to the reference human genome.
Human genome version = hg38
https://www.illumina.com/products/by-type/informatics-products/basespace-sequence-hub/apps/dragen-germline.html 

