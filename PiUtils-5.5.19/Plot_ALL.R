#  script in bams folder
# ../names.txt has all sample names

counts<-data.frame("Filename"=character(0), "Sorted"=integer(0), "Quality"=integer(0), "Clean"=integer(0))
names<-readLines("names.txt")

setwd("bams")
for (Filename in names) {
    i<-Filename
    Sorted<-readLines(paste0(i,"_sorted_count.txt"))
    Quality<-readLines(paste0(i,"_quality_count.txt"))
    Clean<-readLines(paste0(i,"_clean_count.txt"))
    r<-data.frame(Filename,Sorted,Quality,Clean)
    counts<-rbind(counts,r)
    }


counts$Sorted<-as.integer(as.character.factor(counts$Sorted))
counts$Quality<-as.integer(as.character.factor(counts$Quality))
counts$Clean<-as.integer(as.character.factor(counts$Clean))

counts$Sorted.adj <- counts$Sorted - counts$Quality
counts$Quality.adj <- counts$Quality - counts$Clean

# Get total reads from summary stats files.  2nd line has total PAIRs
reads<-data.frame("Filename"=character(0),"Total.Reads"=integer(0),"Unique.Reads"=integer(0))
for (Filename in names) {
    stats<-readLines(paste0(Filename,"_aligned.bam.e"))
    Total.Reads<-2*as.integer(gsub(".*Total pairs: ","",stats[2]))
    t<-gsub(".*Aligned conc.*time: ","",stats[4])
    Unique.Reads<-2*as.integer(gsub(" .*","",t))
    r<-data.frame(Filename,Total.Reads,Unique.Reads)
    reads<-rbind(reads,r)
    }

total_reads<-reads[,c(1,2)]

library(reshape2)
countsMelted <- melt(counts, id.vars = "Filename", measure.vars = c( "Sorted.adj", "Quality.adj", "Clean"))

library(ggplot2)

levels(countsMelted$variable)

#countsMelted$variable <- factor(countsMelted$variable, levels = c("Clean", "Quality.adj", "Sorted.adj"))
countsMelted<-merge(countsMelted, total_reads, by="Filename")
countsMelted<-rbind(countsMelted[countsMelted$variable == "Clean",], countsMelted[countsMelted$variable == "Quality.adj",],countsMelted[countsMelted$variable == "Sorted.adj",])
countsMelted$Total.Reads<-countsMelted$Total.Reads  #(already changed paired read counts to total reads)

#  put plots in bams/Plots
system(paste0("mkdir -p Plots"))
setwd("Plots")

pdf("all_counts.pdf",width=12,height=16)
p <- ggplot(data = countsMelted, aes(x = Filename, y = value, fill = factor(variable))) + geom_bar(stat="identity") + coord_flip() +
      geom_point(data=countsMelted, aes(y = Total.Reads, x=Filename))
p
dev.off()

####
#  scatterplot of Percent Clean Mapped
clean<-data.frame(reads$Total.Reads,counts$Clean)
colnames(clean)<-c("Total.Reads","Clean")
clean$Percent<-clean$Clean/clean$Total.Reads

pdf("Percent Clean Mapped.pdf")
p <- ggplot(clean, aes(Total.Reads, Clean/Total.Reads))
p + geom_point() + labs(title = "Fraction Clean Mapped", x = "Total Reads", y = "Fraction Clean Mapped")
dev.off()

