command="../gatk-4.1.9.0/gatk CombineGVCFs -R ../CDC317/C_parapsilosis_CDC317_current_chromosomes.fasta"

counter=0
for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == CDCF* ]] || continue # if not start with "CDCF", skip
    #echo $path
    cd $path

    # get base name from bamfile
    bamfile=(*.marked_duplicates.bam)
    base=${bamfile%.marked_duplicates.bam} # remove the shortest path in Reads1 after _R*

    # continue if $base.unfiltered.vcf.gz exists
    if test -f "$base.unfiltered.vcf.gz"; then
        #echo "$base.unfiltered.vcf.gz exists."
        command="$command --variant $path$base.unfiltered.vcf.gz"
        counter=$((counter+1))
    else
        echo "$base.unfiltered.vcf.gz does not exist."
    fi

    cd ..
done

echo $counter
command="$command -O cohort.unfiltered.vcf.gz"
echo $command
eval $command
