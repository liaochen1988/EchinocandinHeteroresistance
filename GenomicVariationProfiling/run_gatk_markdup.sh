for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == $1* ]] || continue # if not started with a given prefix, skip
    #echo $path
    cd $path

    # get sorted bam file
    bamfile=(*.sort.bam)
    base=${bamfile%.sort.bam} # remove the shortest path in Reads1 after _R*
    $echo $bamfile
    $echo $base

    # continue if $base.marked_duplicates.bam exists
    if test -f "$base.marked_duplicates.bam"; then
      $echo "$base.marked_duplicates.bam exists."
      cd ..
      continue
    fi

    # run picard
    java -jar ../picard.jar MarkDuplicates I=$bamfile O=$base.marked_duplicates.bam M=$base.marked_dup_metrics.txt

    cd ..
done
