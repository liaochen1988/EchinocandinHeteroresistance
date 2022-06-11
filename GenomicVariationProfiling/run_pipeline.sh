#!/bin/bash

# this script takes two parameters
# first parameter $1: prefix of folders with pair-end fastq files
# second parameter $2: number of threads
# third parameter $3: GATK folder path (no trailing /), e.g., ../gatk-4.1.9.0
# fourth parameter $4: Reference genome folder path (no trailing /), e.g., ../CDC317
# fifth parameter $5: TRF (Tandom Repeat Finder) folder path (no trailing /), e.g., ../TRF

###########################
# get sample ID from header
###########################
./get_sampleID.sh $1 > sampleID.csv

#################################
# align reads to reference genome
#################################
./run_bwa.sh $1 $2 $4

#######################################
# sort sam files and mark up duplicates
#######################################
./run_samtools_sort.sh $1 $2
./run_gatk_markdup.sh $1

#################
# call haploytype
#################
./run_gatk_haplotypecaller.sh $1 $3 $4

##############
# combine GVCF
##############
./run_gatk_combineGVCFs.sh $1 $3 $4

################
# call genotypes
################
./run_gatk_genotypeGVCFs.sh $3 $4

#################
# filter variants
#################
./run_gatk_variant_filter.sh $3 $5

########################
# run variant annotation
########################
./run_variant_annotation.sh $3 $4




