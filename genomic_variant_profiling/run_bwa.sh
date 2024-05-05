for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == $1* ]] || continue # if not started with a given prefix, skip
    #echo $path
    cd $path

    # get pair-end read samples
    Reads1=(*R1.fq.gz)
    Reads2=(*R2.fq.gz)
    base=${Reads1%_R*} # remove the shortest path in Reads1 after _R*

    # continue if $base.sam.gz exists
    if test -f "$base.sam.gz"; then
      #echo "$base.sam.gz exists."
      cd ..
      continue
    fi

    # get read group information
    # Example:
    # @RG	ID:K00217_485_HK3HJBBXY_8	SM:K00217_485_HK3HJBBXY_8_NACAGGAC	LB:K00217_485_HK3HJBBXY_8_NACAGGAC	PL:ILLUMINA
    header=$(zcat < $Reads1 | head -n 1)
    id=$(echo $header | head -n 1 | cut -f 1-4 -d":" | sed 's/@//' | sed 's/:/_/g')
    #sm=$(echo $header | head -n 1 | grep -Eo "[ATGCN]+$")
    sm=$(echo $header | head -n 1 | grep -Eo "[ATGCN]+\+[ATGCN]+$" | sed 's/+/_/g')
    # echo "Read Group @RG\tID:$id\tSM:$id"_"$sm\tLB:$id"_"$sm\tPL:ILLUMINA"

    # run bwa-mem
    bwa mem \
     -M \
     -t $2 \
     -R $(echo "@RG\tID:$id\tSM:$id"_"$sm\tLB:$id"_"$sm\tPL:ILLUMINA") \
     ../$3/CpCDC317bwaidx \
     $Reads1 $Reads2 | gzip > $base.sam.gz

    cd ..
done
