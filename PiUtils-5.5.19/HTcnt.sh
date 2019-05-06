#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00

#Update these if copied from another directory
cd ${rtdir}/counts

#gtffile=/nfs/rprdata/Anthony/data/HISAT2_Index/grch38_snp_tran/testmake/Homo_sapiens.GRCh38.84.gtf
gtffile=/nfs/rprdata/ALOFT/AL/bams/Homo_sapiens.GRCh37.75.gtf.gz

###  htseq count ###
module load python/3.7
htseq-count ../bams/${Sample}_clean.bam $gtffile --stranded=reverse -f bam >${Sample}.cnts

