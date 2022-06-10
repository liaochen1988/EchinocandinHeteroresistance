../gatk-4.1.9.0/gatk --java-options "-Xmx128g" GenotypeGVCFs \
   -R ../CDC317/C_parapsilosis_CDC317_current_chromosomes.fasta \
   -V cohort.unfiltered.vcf.gz \
   -O cohort.unfiltered.gt.vcf.gz
gunzip -k cohort.unfiltered.gt.vcf.gz
