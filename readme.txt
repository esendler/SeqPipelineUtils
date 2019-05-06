Contains scripts for sequencing pipeline analysis
	QC
	Alignment
	Gene counts

PiUtils should be placed as subfolder within project folder
(e.g. Project1/PiUtils) where /Project1 starts with demux'd fastqs in Project1/fastqs
PiUtils folder contains
	PipelineUtils.sh - wrapper script (init with "source PiUtils/PipelineUtils.sh from /Project1) - which makes Pi_.... commands available

Pi_Setup
Pi_runFastQC
Pi_runAlign
Pi_PlotBamQC
Pi_runHTcount
Pi_CountMatrix
Pi_runMultiQC
Pi_Clean


