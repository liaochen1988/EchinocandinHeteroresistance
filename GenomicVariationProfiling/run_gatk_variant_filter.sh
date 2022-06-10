#---------------------------------------------------
# Exclude variants marked by flags other than "PASS"
#---------------------------------------------------
#../gatk-4.1.9.0/gatk SelectVariants \
#    -V cohort.unfiltered.gt.vcf.gz \
#    --exclude-filtered true\
#    -O cohort.filtered.raw.gt.vcf.gz
#num_variants_step0=$(bcftools view -H cohort.unfiltered.gt.vcf.gz | wc -l)
#num_variants_step1=$(bcftools view -H cohort.filtered.raw.gt.vcf.gz | wc -l)

#------------------------------------------
# select variants: SNPs, INDELs, Mixed-type
#------------------------------------------
#../gatk-4.1.9.0/gatk SelectVariants \
#    -V cohort.filtered.raw.gt.vcf.gz \
#    -select-type SNP \
#    --exclude-filtered true\
#    -O cohort.filtered.raw.gt.snp.vcf.gz
#num_snps_step1=$(bcftools view -H cohort.filtered.raw.gt.snp.vcf.gz | wc -l)

#../gatk-4.1.9.0/gatk SelectVariants \
#    -V cohort.filtered.raw.gt.vcf.gz \
#    -select-type INDEL \
#    --exclude-filtered true\
#    -O cohort.filtered.raw.gt.indel.vcf.gz
#num_indels_step1=$(bcftools view -H cohort.filtered.raw.gt.indel.vcf.gz | wc -l)

#../gatk-4.1.9.0/gatk SelectVariants \
#    -V cohort.filtered.raw.gt.vcf.gz \
#    -select-type MIXED \
#    --exclude-filtered true\
#    -O cohort.filtered.raw.gt.mixed.vcf.gz
#num_mixed_step1=$(bcftools view -H cohort.filtered.raw.gt.mixed.vcf.gz | wc -l)

#------------------------------------------
# Hard-filtering using GATK recommendations
# For SNP, label SNP clusters and filter
#------------------------------------------
#../gatk-4.1.9.0/gatk VariantFiltration \
#  -V cohort.filtered.raw.gt.snp.vcf.gz \
#  -filter "QD < 2.00" --filter-name "QD2" \
#  -filter "QUAL < 30.0" --filter-name "QUAL30" \
#  -filter "SOR > 3.00" --filter-name "SOR3" \
#  -filter "FS > 60.00" --filter-name "FS60" \
#  -filter "MQ < 40.0" --filter-name "MQ40" \
#  -filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
#  -filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
#  -O cohort.filtered.hf.gt.snp.vcf.gz

#../gatk-4.1.9.0/gatk VariantFiltration \
#  -V cohort.filtered.raw.gt.indel.vcf.gz \
#  -filter "QD < 2.00" --filter-name "QD2" \
#  -filter "QUAL < 30.0" --filter-name "QUAL30" \
#  -filter "FS > 200.0" --filter-name "FS200" \
#  -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
#  -O cohort.filtered.hf.gt.indel.vcf.gz

# mixed variants are evaluated with the indel model
#../gatk-4.1.9.0/gatk VariantFiltration \
#  -V cohort.filtered.raw.gt.mixed.vcf.gz \
#  -filter "QD < 2.00" --filter-name "QD2" \
#  -filter "QUAL < 30.0" --filter-name "QUAL30" \
#  -filter "FS > 200.0" --filter-name "FS200" \
#  -filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
#  -O cohort.filtered.hf.gt.mixed.vcf.gz

#-------------------------
# Merge hard filtered VCFs
#-------------------------
#java -jar ../picard.jar MergeVcfs \
#  I=cohort.filtered.hf.gt.snp.vcf.gz \
#  I=cohort.filtered.hf.gt.indel.vcf.gz \
#  I=cohort.filtered.hf.gt.mixed.vcf.gz \
#  O=cohort.filtered.hf.tmp.gt.vcf.gz
#../gatk-4.1.9.0/gatk SelectVariants \
#     -V cohort.filtered.hf.tmp.gt.vcf.gz \
#     --exclude-filtered true\
#     -O cohort.filtered.hf.gt.vcf.gz
#num_variants_step2=$(bcftools view -H cohort.filtered.hf.gt.vcf.gz | wc -l)

#-------------------------------------------------------------------------------------------------------------------------------------------
# Further filtering 1: minimum read depth (DP) and genotype quality (GQ), and ref-to-alt AD ratio
# Note that the -S option changes genotype of samples that do not fulfill the requirement to ./. but does not remove the entire variant site
# & and | apply multiple filters to the same sample simultaneously, while && and || apply to different samples independently
#-------------------------------------------------------------------------------------------------------------------------------------------
#bcftools filter -S . -e 'FMT/DP<10 | FMT/GQ<20' -O z -o cohort.filtered.hf.DP10.GQ20.gt.vcf.gz cohort.filtered.hf.gt.vcf.gz
#num_variants_step3=$(bcftools view -H cohort.filtered.hf.DP10.GQ20.gt.vcf.gz | wc -l)

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
# Further filtering 2: remove monomorphic SNPs/INDELs, multiallelic SNPs and indels, SNPs in the close proximity of INDELS, and clusters of INDELs with a window
# & and | apply multiple filters to the same sample simultaneously, while && and || apply to different samples independently
# Note that we do not remove any site at which only alternative alleles are called!!!
#---------------------------------------------------------------------------------------------------------------------------------------------------------------
#bcftools filter -e 'AC==0' --IndelGap 5 --SnpGap 10 cohort.filtered.hf.DP10.GQ20.gt.vcf.gz | bcftools view -m2 -M2 -O z -o cohort.filtered.hf.DP10.GQ20.allele.gt.vcf.gz
#num_variants_step4=$(bcftools view -H cohort.filtered.hf.DP10.GQ20.allele.gt.vcf.gz | wc -l)

#--------------------------------------------------------------
# Further filtering 3: remove variants in repetitive regions
# Note that tabix would fail if gzip, instead of bgzip, is used
#--------------------------------------------------------------
#bedtools intersect -v -a cohort.filtered.hf.DP10.GQ20.allele.gt.vcf.gz \
#    -b ../TRF/C_parapsilosis_CDC317_current_chromosomes.fasta.2.5.7.80.10.50.2000.bed -wa -header \
#    > cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf
#bgzip cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf
#tabix -fp vcf cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf.gz
#num_variants_step5=$(bcftools view -H cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf.gz | wc -l)

#----------------------------------------
# Further filtering 4: remove SNPclusters
#----------------------------------------
#../gatk-4.1.9.0/gatk VariantFiltration \
#    -V cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf.gz\
#    -cluster 3 -window 10\
#    -O cohort.filtered.hf.DP10.GQ20.allele.trf.sc.tmp.gt.vcf.gz
#../gatk-4.1.9.0/gatk SelectVariants \
#    -V cohort.filtered.hf.DP10.GQ20.allele.trf.sc.tmp.gt.vcf.gz \
#    --exclude-filtered true\
#    -select "FILTER == SnpCluster" --invertSelect \
#    -O cohort.filtered.hf.DP10.GQ20.allele.trf.sc.gt.vcf.gz
#num_variants_step6=$(bcftools view -H cohort.filtered.hf.DP10.GQ20.allele.trf.sc.gt.vcf.gz | wc -l)

#-----------------------------------------------------------
# Create vcf that includes only variants with filter PASS
#-----------------------------------------------------------
#bcftools view -f PASS cohort.filtered.hf.DP10.GQ20.allele.trf.sc.gt.vcf.gz -O z -o cohort.filtered.gt.vcf.gz
#tabix -fp vcf cohort.filtered.gt.vcf.gz
#num_variants_step7=$(bcftools view -H cohort.filtered.gt.vcf.gz | wc -l)
#num_snps_step7=$(bcftools view -H --types snps cohort.filtered.gt.vcf.gz | wc -l)
#num_indels_step7=$(bcftools view -H --types indels cohort.filtered.gt.vcf.gz | wc -l)
#num_mixed_step7=$(bcftools view -H --types other cohort.filtered.gt.vcf.gz | wc -l)

# print number of variants at each filtering step
#echo "number of variants [step0: raw variants] = $num_variants_step0"
#echo "number of variants [step1: exclude filtered variants] = $num_variants_step1($num_snps_step1,$num_indels_step1,$num_mixed_step1)"
#echo "number of variants [step2: hard filtering] = $num_variants_step2"
#echo "number of variants [step3: filter by DP/GQ] = $num_variants_step3"
#echo "number of variants [step4: filter by alleles 1] = $num_variants_step4"
#echo "number of variants [step5: filter by repetitive regions] = $num_variants_step5"
#echo "number of variants [step6: remove sap cluster] = $num_variants_step6"
#echo "number of variants [step7: exclude variants failed to pass our filters] = $num_variants_step7($num_snps_step7,$num_indels_step7,$num_mixed_step7)"

# convert to table
#../gatk-4.1.9.0/gatk VariantsToTable \
#     -V cohort.filtered.gt.vcf.gz \
#     -F CHROM -F POS -F ID -F TYPE -F REF -F ALT -F HET -F HOM-REF -F HOM-VAR -F NO-CALL -F VAR -F NSAMPLES -F NCALLED -F MULTI-ALLELIC -GF AD -GF GT \
#     --error-if-missing-data \
#     -O cohort.filtered.gt.txt

# remove temporary files
rm cohort.filtered.raw.gt.vcf.gz
rm cohort.filtered.raw.gt.snp.vcf.gz
rm cohort.filtered.raw.gt.indel.vcf.gz
rm cohort.filtered.raw.gt.mixed.vcf.gz
rm cohort.filtered.hf.gt.snp.vcf.gz
rm cohort.filtered.hf.gt.indel.vcf.gz
rm cohort.filtered.hf.gt.mixed.vcf.gz
rm cohort.filtered.hf.tmp.gt.vcf.gz
rm cohort.filtered.hf.gt.vcf.gz
rm cohort.filtered.hf.DP10.GQ20.gt.vcf.gz
rm cohort.filtered.hf.DP10.GQ20.allele.gt.vcf.gz
rm cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf.gz
rm cohort.filtered.hf.DP10.GQ20.allele.trf.sc.tmp.gt.vcf.gz
rm cohort.filtered.hf.DP10.GQ20.allele.trf.sc.gt.vcf.gz

rm cohort.filtered.raw.gt.vcf.gz.tbi
rm cohort.filtered.raw.gt.snp.vcf.gz.tbi
rm cohort.filtered.raw.gt.indel.vcf.gz.tbi
rm cohort.filtered.raw.gt.mixed.vcf.gz.tbi
rm cohort.filtered.hf.gt.snp.vcf.gz.tbi
rm cohort.filtered.hf.gt.indel.vcf.gz.tbi
rm cohort.filtered.hf.gt.mixed.vcf.gz.tbi
rm cohort.filtered.hf.tmp.gt.vcf.gz.tbi
rm cohort.filtered.hf.gt.vcf.gz.tbi
rm cohort.filtered.hf.DP10.GQ20.allele.trf.gt.vcf.gz.tbi
rm cohort.filtered.hf.DP10.GQ20.allele.trf.sc.tmp.gt.vcf.gz.tbi
rm cohort.filtered.hf.DP10.GQ20.allele.trf.sc.gt.vcf.gz.tbi
