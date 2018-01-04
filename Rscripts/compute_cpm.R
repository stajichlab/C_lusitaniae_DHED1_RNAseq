library(edgeR)

dhedset <- read.csv("reports/DHED1.gsnap_frags.tab",
                    row.names="Geneid",header=T,sep="\t")
dim(dhedset)
dhedset = dhedset[6:length(dhedset)]
geno = factor(rep( c("L1B","L4C","U10D","U3B","U3E","U5C"), each=4))

benomyl = factor(c( "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl"))

colData = data.frame(row.names=colnames(dhedset),
                     condition=benomyl,
                     genotype = geno)
dds <- DESeqDataSetFromMatrix(countData = dhedset,
                       colData   = colData,
                       design = ~ condition + genotype)

#nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
#nrow(dds)

write.csv(file="reports/DHED1.gsnap.CPM.csv",cpm(dds))

keep <- rowSums(cpm(dds)>1) >= 2

y <- DGEList(counts=keep,group=geno)

y <- estimateGLMCommonDisp(y,design)
y
y <- estimateGLMTrendedDisp(y,design)
y <- estimateGLMTagwiseDisp(y,design)

pdf("HTSeq_edgeRplots.pdf")
plotMDS(y)
plotBCV(y)
