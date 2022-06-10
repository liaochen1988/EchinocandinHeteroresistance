for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == CDCF* ]] || continue # if not start with "CDCF", skip
    echo $path
    cd $path

    # get bam file with marked duplicates
    bamfile=(*.marked_duplicates.bam)
    base=${bamfile%.marked_duplicates.bam} # remove the shortest path in Reads1 after _R*
    echo $bamfile
    echo $base

    # continue if $base.unfiltered.vcf.gz exists
    #if test -f "$base.unfiltered.vcf.gz"; then
    #  echo "$base.unfiltered.vcf.gz exists."
    #  cd ..
    #  continue
    #fi

    # index bam file
    samtools index $bamfile

    # run haplotypecaller
    # gatk 4.1.9.0 does not support --genotyping-mode. use --alleles trigges force calling
    # make sure to include "-ERC GVCF"
    ../../gatk-4.1.9.0/gatk --java-options "-Xms4g -Xmx256g" HaplotypeCaller \
      -R ../../CDC317/C_parapsilosis_CDC317_current_chromosomes.fasta \
      -I $bamfile \
      -O $base.unfiltered.vcf.gz \
      -ERC GVCF &

    # run haplotypecallerspark
    # ../gatk-4.1.9.0/gatk --java-options "-Xmx128g -XX:ParallelGCThreads=1" HaplotypeCallerSpark  \
    #  --spark-master local[*] \
    #  -R ../CDC317/C_parapsilosis_CDC317_current_chromosomes.fasta \
    #  -I $bamfile \
    #  -O $base.unfiltered.vcf.gz \
    #  -ERC GVCF

    cd ..
done
