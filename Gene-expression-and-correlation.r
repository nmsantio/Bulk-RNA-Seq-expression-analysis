# INSTALL PACKAGES 
# install and read packages for analysis of
# average expression, correlation and survival
 if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
 BiocManager::install("plyr") 
 BiocManager::install("ggpubr")
 BiocManager::install("Hmisc")

# DOWNLOAD DATA FROM cBioPortal
# Select cBioPortal for Cancer Genomics, Breast Invasive Carcinoma (TCGA, PanCancer Atlas)
# choose Gene set
# download mRNA Expression, RSEM (Batch normalized from Illumina HiSeq_RNASeqV2), rename to mRNA_original
# download mRNA expression z-scores relative to all samples (log RNA Seq V2 RSEM), rename to mRNA_loq2
# Select Oncoprint, Add Clinical Tracks, Select the desired variables, Download Tabular
 
# import expression data to R
mRNA_log2 = read.table("mRNA_log2.txt", header = TRUE, sep = "",row.names = NULL)
 
# import sample_ID made in Excel from mRNA-log2 to contain both SAMPLE_ID-01 values and SAMPLE_ID values for merging
sample_ID = read.table("sample_ID.txt", header = TRUE, sep = "",row.names = NULL)
 
# merge to get correct IDs, choose wanted columns and rename
merge_mRNA = merge(x = mRNA_log2, y = sample_ID, by = "SAMPLE_ID", all = TRUE)
merged_mRNA = merge_mRNA[,c(3:9),]
names(merged_mRNA)[names(merged_mRNA)=="SAMPLE_ID.1"] = "SAMPLE_ID"
 
# import clinical data manually to R with no row or column headers
# transpose data
Patientdata = t(PATIENT_DATA_oncoprint)
write.table(Patientdata, "Patientdata.txt", sep="\t", col.names = FALSE, row.names=FALSE)
Patientdata = read.table("Patientdata.txt", header = TRUE, sep = "",row.names = NULL)

# remove first row to have only sampels on rows
Patientdata = Patientdata[-c(1),]
write.table(Patientdata, "Patientdata.txt", sep="\t", col.names = TRUE, row.names=FALSE)
Patientdata = read.table("Patientdata.txt", header = TRUE, sep = "",row.names = NULL)   

#rename track_name column to match to SAMPE_ID in the expression data
names(Patientdata)[names(Patientdata)=="track_name"] = "SAMPLE_ID"

# combine expression and clinical data by SAMPLE_ID
mergeddata = merge(x = merged_mRNA, y = Patientdata, by = "SAMPLE_ID", all = TRUE)

# order by selected gene name to identify rows for gene expression with values, save and remove NA rows
GENEordered = mergeddata[order(mergeddata$GENE1.x),]
write.table(GENEordered, "Merged_ordered.txt", sep="\t", col.names = TRUE, row.names=FALSE)
Merged_ordered = read.table("Merged_ordered.txt", header = TRUE, sep = "",row.names = NULL) 
Merged_noNA = Merged_ordered[-c(1083:2168),]

# rename expression columns for clarity
# perform same to all, just changes the names
names(Merged_noNA)[names(Merged_noNA)=="GENE.x"] = "GENE"

# save and read again for further processing
write.table(Merged_noNA, "mergedfinal.txt", sep="\t", col.names = TRUE, row.names=FALSE)
mergedfinal = read.table("mergedfinal.txt", header = TRUE, sep = "",row.names = NULL) 

# package for renaming by revalue
library(plyr) 

# rename Breast Cancer Subtype column headers for clarity
mergedfinal$Subtype = revalue(mergedfinal$Subtype, c("BRCA_LumA"="LumA"))
mergedfinal$Subtype = revalue(mergedfinal$Subtype, c("BRCA_LumB"="LumB"))
mergedfinal$Subtype = revalue(mergedfinal$Subtype, c("BRCA_Normal"="Normal"))
mergedfinal$Subtype = revalue(mergedfinal$Subtype, c("BRCA_Basal"="Basal"))
mergedfinal$Subtype = revalue(mergedfinal$Subtype, c("BRCA_Her2"="Her2"))
names(mergedfinal)[names(mergedfinal)=="Neoplasm.Disease.Stage.American.Joint.Committee.on.Cancer.Code"] = "Stage"

# save the edited final version
write.table(mergedfinal, "mergedfinal.txt", sep="\t", col.names = TRUE, row.names=FALSE)
mergedfinal = read.table("mergedfinal.txt", header = TRUE, sep = "",row.names = NULL) 

# take subsets of subtypes and stages for further processing
# of each group separately

LumA = subset(mergedfinal, Subtype == "LumA")
write.table(LumA, "LumA.txt", sep="\t", row.names=TRUE, quote= F)

Her2 = subset(mergedfinal, Subtype == "Her2")
write.table(Her2, "Her2.txt", sep="\t", row.names=TRUE, quote= F)

LumB = subset(mergedfinal, Subtype == "LumB")
write.table(LumB, "LumB.txt", sep="\t", row.names=TRUE, quote= F)

Normal = subset(mergedfinal, Subtype == "Normal")
write.table(Normal, "Normal.txt", sep="\t", row.names=TRUE, quote= F)

Basal = subset(mergedfinal, Subtype == "Basal")
write.table(Basal, "Basal.txt", sep="\t", row.names=TRUE, quote= F)

StageI = subset(mergedfinal, Stage == "STAGE I")
write.table(StageI, "StageI.txt", sep="\t", row.names=TRUE, quote= F)

StageIA = subset(mergedfinal, Stage == "STAGE IA")
write.table(StageIA, "StageIA.txt", sep="\t", row.names=TRUE, quote= F)

StageIB = subset(mergedfinal, Stage == "STAGE IB")
write.table(StageIB, "StageIB.txt", sep="\t", row.names=TRUE, quote= F)

StageIIA = subset(mergedfinal, Stage == "STAGE IIA")
write.table(StageIIA, "StageIIA.txt", sep="\t", row.names=TRUE, quote= F)

StageIIB = subset(mergedfinal, Stage == "STAGE IIB")
write.table(StageIIB, "StageIIB.txt", sep="\t", row.names=TRUE, quote= F)

StageIIIA = subset(mergedfinal, Stage == "STAGE IIIA")
write.table(StageIIIA, "StageIIIA.txt", sep="\t", row.names=TRUE, quote= F)

StageIIIB = subset(mergedfinal, Stage == "STAGE IIIB")
write.table(StageIIIB, "StageIIIB.txt", sep="\t", row.names=TRUE, quote= F)

StageIIIC = subset(mergedfinal, Stage == "STAGE IIIC")
write.table(StageIIIC, "StageIIIC.txt", sep="\t", row.names=TRUE, quote= F)

StageIV = subset(mergedfinal, Stage == "STAGE IV")
write.table(StageIV, "StageIV.txt", sep="\t", row.names=TRUE, quote= F)

# EXPRESSION LEVEL COMPARISON BETWEEN DIFFERENT STAGES AND SUBTYPES
# PREPARE BOX PLOTS AND SAVE AS SVG AND JPEG

# choose gene
# choose Stage or Subtype
# change file name and y axis label accordingly
# example for GENE1 Subtypes

svg("GENE1expr_Stage.svg")
boxplot(GENE1~Stage,
        data=mergedfinal,
        main="Average expression",
        xlab="Subtype",
        ylab="GENE1",
        col="orange",
        border="brown")
dev.off()

# plot and save as jpg to view
jpeg("GENE1_Stage.jpg")
boxplot(GENE1~Stage,
        data=mergedfinal,
        main="Average expression",
        xlab="Subtype",
        ylab="GENE1",
        col="orange",
        border="brown")
dev.off()

# CHECK NORMALITY BY PLOTTING AND SAVE AS SVG AND JPEG

# package to plot normality
library("ggpubr")

# plot GENE1 and save as svg
svg("GENE1expr_normality.svg")
ggdensity(mergedfinal$GENE1, 
          main = "GENE1 normality",
          xlab = "Relative GENE1 expression")
dev.off()

# plot GENE1 and save as jpg
jpeg("GENE1expr_normality.jpg")
ggdensity(mergedfinal$GENE1, 
          main = "GENE1 normality",
          xlab = "Relative GENE1 expression")
dev.off()

# (remove non applicaple (NA) groups from the plots manually during figure preparation if needed)

# T-TEST TO COMPARE DIFFERENCES IN GENE EXPRESSION BETWEEN STAGES OR SUBTYPES
# for analysis of expression level differences open all separate files needed (created above)
# perform t-test to compare data in GENE1 columns
# compare all stages to stage I

# merge stages to compare merged samples
Imerged = rbind(StageI, StageIA, StageIB)
IImerged = rbind(StageIIA, StageIIB)
IIImerged = rbind(StageIIIA, StageIIIB, StageIIIC)

# compare separate or merged stages
# perform to all options, replace the names when necessary
t.test(StageI$GENE1, StageIB$GENE1, alternative = "two.sided", var.equal = FALSE)
t.test(Imerged$GENE1, IImerged$GENE1, alternative = "two.sided", var.equal = FALSE)

# compare all subtypes normal
# select GENE1 and subtypes to compare
# perform to all options, replace the names when necessary
t.test(Normal$GENE1, LumB$GENE1, alternative = "two.sided", var.equal = FALSE)

# MEASURE CORRELATION OF GENE1 AND GENE2 EXPRESSION LEVELS 
# subset expression data to home directory and open for creating expression matrix
# perform to all datasets separately (Stage and Subtype options)

# for example LuminalA (LumA)
Selection = c("GENE1", "GENE2")
Expression = LumA[Selection]
write.table(Expression, "Expression.txt", sep="\t", col.names = TRUE, row.names=FALSE)
Expression = read.table("Expression.txt", header = TRUE)
ExpressionMatrix = as.matrix(Expression)

# read package and perform correlation analysis
library(Hmisc)
rcorr(ExpressionMatrix, type = c("pearson"))

# plot and save as svg for figure preparation
# name according to seelcted genes and stage/ subtype
# for example LuminalA (LumA)
svg("Gene1Gene2_corr_LumA.svg")
plot(LumA$GENE1, LumA$GENE2, main = "Correlation LumA",
     xlab = "GENE1", ylab = "GENE2",
     pch = 19, frame = FALSE)
dev.off()

# plot and save as jpg to view
jpeg("Gene1Gene2_corr_LuminalA.jpg")
plot(LumA$GENE1, LumA$GENE2, main = "Correlation LumA",
     xlab = "GENE1", ylab = "GENE2",
     pch = 19, frame = FALSE)
dev.off()
