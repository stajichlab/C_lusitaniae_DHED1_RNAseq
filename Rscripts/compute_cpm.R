library(edgeR)
readCount <- read.csv("reports/DHED1.DESeq.gene_count.tab",row.names="LOCUS",header=T)
dim(readCount)

geno <- factor(rep(c("L1B","L1B_benomyl","L4C","L4C_benomyl","U10D","U10D_benomyl","U3B","U3B_benomyl",
		  "U3E","U3E_benomyl","U5C","U5C_benomyl"),each=2))
write.csv(file="reports/DHED1.DESeq.CPM.csv",cpm(readCount))
keep <- rowSums(cpm(readCount)>1) >= 2
design <- model.matrix(~geno)

design
y <- DGEList(counts=keep,group=geno)

y <- estimateGLMCommonDisp(y,design)
y
y <- estimateGLMTrendedDisp(y,design)
y <- estimateGLMTagwiseDisp(y,design)

pdf("HTSeq_edgeRplots.pdf")
plotMDS(y)
plotBCV(y)
