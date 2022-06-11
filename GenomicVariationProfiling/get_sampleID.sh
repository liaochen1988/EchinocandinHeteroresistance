for path in */; do
    # iterate each sample folder
    [ -d "${path}" ] || continue # if not a directory, skip
    [[ $path == $1* ]] || continue # if not started with a given prefix, skip
    cd $path

    # get pair-end read samples
    Reads1=(*R1.fq.gz)
    Reads2=(*R2.fq.gz)
    base=${Reads1%%_*}

    # get read group information
    header=$(zcat < $Reads1 | head -n 1)
    id=$(echo $header | head -n 1 | cut -f 1-4 -d":" | sed 's/@//' | sed 's/:/_/g')
    #sm=$(echo $header | head -n 1 | grep -Eo "[ATGCN]+$")
    sm=$(echo $header | head -n 1 | grep -Eo "[ATGCN]+\+[ATGCN]+$" | sed 's/+/_/g')
    echo "$base,$id"_"$sm"

    cd ..
done
