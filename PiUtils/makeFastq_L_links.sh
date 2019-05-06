find /wsu/home/groups/piquelab/OurData/Nextseq/ALOFT.new/ -name 'AL*.fastq.gz' \
    | sed 's/.*\///g;s/_S.*//' \
    | sort | uniq \
    | while read f0; do
    echo "**** $f0 ****"
    find /wsu/home/groups/piquelab/OurData/Nextseq/ALOFT.new/ -name "${f0}*_R1*.fastq.gz" \
        | awk '{print $0,NR}' \
        | while read f r; do
            b=${f//R1/R2};
            echo "- $f ${f0}_L${r}";
            ln -s $f ${f0}_L${r}_R1.fastq.gz
            ln -s $b ${f0}_L${r}_R2.fastq.gz
    done;
done;
done

