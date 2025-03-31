#4.3.2024 heatmap with new taxa
library(RColorBrewer)
library(pheatmap)
library(NatParksPalettes)
library(wesanderson)
library(ggplot2)
setwd("~/bigdata/TE_composition-EDTA/")
DNATE <- read.table("~/bigdata/TE_composition-EDTA/tables/DNATEcomp.tsv",sep="\t",row.names = 1,header=T)
#as.data.frame(DNATE)
#DNATE<-sapply(DNATE,as.numeric)
#row_names <- rownames(DNATE)
#italic_row_names <- paste0("<i>", row_names, "</i>")
newnames <- lapply(
  rownames(DNATE),
  function(x) bquote(italic(.(x))))
p1<-pheatmap(DNATE,display_numbers = T,cluster_rows = F,cluster_cols = F,labels_row = as.expression(newnames),fontsize_number = 12)


ggsave("~/bigdata/TE_composition-EDTA/plots/supfig2.pdf",width = 7, height= 4, p1)