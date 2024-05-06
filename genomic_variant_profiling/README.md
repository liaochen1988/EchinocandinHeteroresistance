DATA: Whole-genome-sequence of each sample (with R1.fq.gz and R2.fq.gz) should be put in an individual folder (the same directory as the scripts).

OUTPUT: The intermediate outputs (e.g., bam files) for each sample will be stored in the same folder of their fastq files. The summary files of genetic variables are outputted to the same directory of the scripts.

USAGE: ./run_pipeline.sh [prefix of samples] [number of threads] [GATK folder path] [Reference genome folder path] [Tandom Repeat Finder folder path]

The reference genome folder must contain the following file(s):
C_parapsilosis_CDC317_current_chromosomes.fasta
C_parapsilosis_CDC317_current_features.gff

The TRF folder must contain the following file(s):
C_parapsilosis_CDC317_current_chromosomes.fasta.2.5.7.80.10.50.2000.bed
