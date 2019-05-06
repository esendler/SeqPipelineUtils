#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00

#Update these if copied from another directory
cd ${rtdir}

###  fastQC ###
module load fastqc/0.11.8
fastqc -q -t 4 -o fastqc-out fastqs/${Sample}*R1*fastq.gz &
fastqc -q -t 4 -o fastqc-out fastqs/${Sample}*R2*fastq.gz

