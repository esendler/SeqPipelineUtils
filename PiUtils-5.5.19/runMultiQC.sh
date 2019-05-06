#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00

#Update these if copied from another directory
cd ${rtdir}


###  MultiQC ###
module load python/3.7
multiqc bams/ fastqc-out/ counts/

