#!/bin/bash

# get sample name from header
#./get_sample_name.sh > sample_to_folder_name_conversion.csv

# align reads to reference genome CDC317
#./run_bwa.sh

# sort sam files and mark up duplicates
#./run_samtools_sort.sh
#./run_gatk_markdup.sh

# call haploytpe
#./run_gatk_haplotypecaller.sh

# combine GVCF
#./run_gatk_combineGVCFs.sh

# call genotypes
#./run_gatk_genotypeGVCFs.sh

# filter variants
./run_gatk_variant_filter.sh

# run variant annotation
./run_variant_annotation.sh




