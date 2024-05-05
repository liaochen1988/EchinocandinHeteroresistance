for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == $1* ]] || continue # if not started with a given prefix, skip
    #echo $path
    cd $path

    # get sam file
    samfile=(*.sam.gz)
    base=${samfile%.sam.gz} # remove the shortest path in samfile after .sam.gz
    #echo $samfile
    #echo $base

    # continue if $base.sort.bam exists
    if test -f "$base.sort.bam"; then
      #echo "$base.sort.bam exists."
      cd ..
      continue
    fi

    # run samtools
    samtools sort -O bam -T $base.sort -o $base.sort.bam -@ $2 $samfile

    cd ..
done
