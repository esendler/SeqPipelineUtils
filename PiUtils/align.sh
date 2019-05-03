#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00


module load hisat2/2.1.0
module load samtools/1.4

#Update these if copied from another directory
cd ${rtdir}/bams
filePath=${rtdir}/fastqs

#     hg37
#genomeindex=/nfs/rprdata/Anthony/data/HISAT2_Index/grch38_snp_tran/genome_snp_tran
#    hg19/grch37
genomeindex=/nfs/rprdata/RefGenome/HISAT2/grch37_snp_tran/genome_snp_tran


###Align Reads###
hisat2 --new-summary -p 4 -x ${genomeindex} -1 ${filePath}/${Sample}_R1_001.fastq.gz \
                              -2 ${filePath}/${Sample}_R2_001.fastq.gz \
      2> ${Sample}_aligned.bam.e | samtools view -b1 - > ${Sample}_aligned.bam



###Sort Reads###
samtools sort -@ 4 -T tmp_${Sample}_aligned.bam -o ${Sample}_sorted.bam ${Sample}_aligned.bam
samtools index ${Sample}_sorted.bam
samtools view -c ${Sample}_sorted.bam > ${Sample}_sorted_count.txt


###Quality Filter###
samtools view -b1 -q10 ${Sample}_sorted.bam > ${Sample}_quality.bam
samtools index ${Sample}_quality.bam
samtools view -c ${Sample}_quality.bam > ${Sample}_quality_count.txt


###Deduplication###
samtools rmdup ${Sample}_quality.bam ${Sample}_clean.bam
samtools index ${Sample}_clean.bam
samtools view -c ${Sample}_clean.bam > ${Sample}_clean_count.txt

echo ${Sample} >> ALIGN_finished.txt

