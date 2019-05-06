#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00


module load hisat2/2.1.0
module load samtools/1.4


cd ${rtdir}/bams
filePath=${rtdir}/fastqs

#     hg37
#genomeindex=/nfs/rprdata/Anthony/data/HISAT2_Index/grch38_snp_tran/genome_snp_tran
#    hg19/grch37
genomeindex=/nfs/rprdata/RefGenome/HISAT2/grch37_snp_tran/genome_snp_tran


###Align Reads###
hisat2 --new-summary -p 4 -x ${genomeindex} -1 ${filePath}/${Sample}_R1*.fastq.gz \
                              -2 ${filePath}/${Sample}_R2*.fastq.gz \
      2> ${Sample}_aligned.bam.e | samtools view -b1 - > ${Sample}_aligned.bam



###Sort Reads###
samtools sort -@ 4 -T tmp_${Sample}_aligned.bam -o ${Sample}_sorted.bam ${Sample}_aligned.bam
samtools index ${Sample}_sorted.bam
samtools view -c ${Sample}_sorted.bam > ${Sample}_sorted_count.txt



echo ${Sample} >> ALIGNinit_finished.txt

