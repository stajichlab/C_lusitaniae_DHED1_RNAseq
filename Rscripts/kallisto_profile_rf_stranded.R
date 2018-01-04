library(DESeq2)
library(tximport)
library(dplyr)
library(ggplot2)
library(magrittr)
library(Biobase)
library(pheatmap)
library(RColorBrewer)

samples <- read.table("sample_names.txt",header=FALSE)
files <- file.path("results","kallisto_rf",samples$V1,"abundance.h5")
txi.kallisto <- tximport(files, type = "kallisto", txOut = TRUE)
head(txi.kallisto$counts)
colnames(txi.kallisto$counts) <- samples$V1
colnames(txi.kallisto$abundance) <- samples$V1
write.csv(txi.kallisto$abundance,"reports/kallisto_stranded_rf.TPM.csv")
write.csv(txi.kallisto$counts,"reports/kallisto_stranded_rf.counts.csv")

# DEseq2 analyses
geno = factor(rep( c("L1B","L4C","U10D","U3B","U3E","U5C"), each=4))
benomyl = factor(c( "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl",
                    "untreated","untreated","Benomyl","Benomyl"))

sampleTable <- data.frame(condition=benomyl,
                          genotype = geno)
rownames(sampleTable) = samples$V1


dds <- DESeqDataSetFromTximport(txi.kallisto,sampleTable,~ condition + genotype)

#nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
#nrow(dds)

dds <- estimateSizeFactors(dds)
vsd <- vst(dds, blind=FALSE)
#rld <- rlog(dds, blind=FALSE)
head(assay(vsd), 3)

df <- bind_rows(
  as_data_frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>%
         mutate(transformation = "log2(x + 1)"),
#  as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"),
  as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))

colnames(df)[1:2] <- c("x", "y")

pdf("plots/RNASeq_kallisto_stranded_rf.pdf")
ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) +
  coord_fixed() + facet_grid( . ~ transformation)

select <- order(rowMeans(counts(dds,normalized=TRUE)),
                decreasing=TRUE)[1:20]
df <- as.data.frame(colData(dds)[,c("condition","genotype")])
pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=TRUE,
         cluster_cols=FALSE, annotation_col=df)


sampleDists <- dist(t(assay(vsd)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$condition, vsd$genotype, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

pcaData <- plotPCA(vsd, intgroup=c("condition", "genotype"), returnData=TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))

ggplot(pcaData, aes(PC1, PC2, color=genotype, shape=condition)) +
    geom_point(size=3) +
    xlab(paste0("PC1: ",percentVar[1],"% variance")) +
    ylab(paste0("PC2: ",percentVar[2],"% variance")) +
    coord_fixed()
