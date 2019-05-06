#!/bin/bash
#PBS -l nodes=1:ppn=4,mem=20gb
#PBS -l walltime=8:00:00

#Update these if copied from another directory
cd ${rtdir}

###  R script to make plots ###
module load R/3.5.2
Rscript PiUtils/Plot_MERGED.R 

