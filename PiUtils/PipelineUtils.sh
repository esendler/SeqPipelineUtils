#############    set up required files
function Pi_Setup {
	#mkdir bams
	#mkdir counts
	ls fastqs/*R1*|sed 's/_R1.*//g'|grep -v PhiX|grep -v Undetermined| sed 's/fastqs\///g'>names.txt
	rtdir=$(pwd)
}


#############   RUN align.sh on all samples    ################
function Pi_runAlign {
mkdir bams
rtdir=$(pwd)
for i in `cat names.txt`; do while :; do if [ `qme | wc -l` -lt 110 ]; then qsub PiUtils/align.sh -v Sample=${i},rtdir="$rtdir"; sleep 1;break; else sleep 1; fi; done; done
}


####################   script to run HTcnt.sh on all samples   ##############################
function Pi_runHTcount {
mkdir counts
rtdir=$(pwd)
for i in `cat names.txt`; do while :; do if [ `qme | wc -l` -lt 110 ]; then qsub PiUtils/HTcnt.sh -v Sample=${i},rtdir="$rtdir"; sleep 1;break; else sleep 1; fi; done; done
}

################    run R script to make plots
function Pi_PlotBamQC {
rtdir=$(pwd)
qsub PiUtils/RunPlots.sh -v rtdir="$rtdir"
}
##############################    make count matrix   #########
function Pi_CountMatrix {
. PiUtils/makeCountMatrix.sh
}

#############################    run fastQC on all fastqs  ##################
function Pi_runFastQC {
rtdir=$(pwd)
mkdir fastqc-out
for i in `cat names.txt`; do while :; do if [ `qme | wc -l` -lt 110 ]; then qsub PiUtils/runFastQC.sh -v Sample=${i},rtdir="$rtdir"; sleep 1;reak; else sleep 1; fi; done; done
}
#######################      MultiQC  (to be run after runFastQC, runAlign) - output file will be multiqc.html in main dir
function Pi_runMultiQC {
rtdir=$(pwd)
qsub PiUtils/runMultiQC.sh -v rtdir="$rtdir"
} 

########################      Clean directory  - remove all batch run output files  ###################
function Pi_Clean {
	rm *sh.e??????
	rm *sh.o??????
}
