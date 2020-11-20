# INSTALL PACKAGES 
# install and read packages for analysis of
# average expression, correlation and survival
 if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
 BiocManager::install("survival")
 BiocManager::install("survminer")

# KAPLAN MEIER ANALYSIS
# perform analysis by kmplotter https://kmplot.com/analysis/
# select mRNA gene chip
# Start KM Plotter for breast cancer
# use multiple genes and select probes
# select Plot options: export plot data as text
# split patients by Auto select best cutoff
# choose OS (or RFS)
# restrict analysis to subtypes

# read the txt files into R
kmplot = read.table("GENE1.txt", header = TRUE, sep = "",row.names = NULL) 

# read the packages needed for Kaplan Meier analysis
library("survival")
library("survminer")

# rename columns
colnames(kmplot) = c("Sample", "GENE1", "OS", "Event")

# Plot Kaplan-Meier Overall Survival and save 
KM_OS = survfit(Surv(OS, Event) ~ GENE1, data=kmplot)

# save each plot separately to home directory (select correct) 
# changes file names accordingly

# save as svg
svg("GENE1_KMOS.svg")
ggsurvplot(KM_OS, data = kmplot, risk.table = TRUE, palette = "igv")
dev.off()

# save as jpg
jpeg("GENE1_KMOS.jpg")
ggsurvplot(KM_OS, data = kmplot, risk.table = TRUE, palette = "igv")
dev.off()
