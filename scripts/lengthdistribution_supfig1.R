library(tidyverse)
library(readr)
library(dplyr)
library(ggsci)
library(gridExtra)
library(ggplot2)
library(hrbrthemes)

mcic <- read_tsv("~/bigdata/TE_composition-EDTA/tables/McicTEtableV3.tsv")
zrad <- read_tsv("~/bigdata/TE_composition-EDTA/tables/ZradTEtableV3.tsv")
emus <- read_table("~/bigdata/EDTA/RepeatLandscape2-EDTA/Entomophthora_muscae_UCB.Nanopore10X_v2.rmblast/Entomophthora_muscae_UCB.Nanopore10X_v2.fasta.out",skip=3,col_names = F)
colnames(emus) <-c("score","div.","del.","ins.","query","beginq","endq","leftq","strand","family","class","beginr","endr","leftr","ID","overlap")
emus <- emus %>% mutate(length=endq-beginq +1) 
emus1 <- subset(emus,class != "Low_complexity")
emus2 <- subset(emus1,class != "Simple_repeat")

emai <- read_table("~/bigdata/EDTA/RepeatLandscape2-EDTA/Entomophaga_maimaiga_var_ARSEF_7190.rmblast1/Entomophaga_maimaiga_var_ARSEF_7190.fasta.out",skip=3,col_names = F)
colnames(emai) <-c("score","div.","del.","ins.","query","beginq","endq","leftq","strand","family","class","beginr","endr","leftr","ID","overlap")
emai <- emai %>% mutate(length=endq-beginq +1) 
emai1 <- subset(emai,class != "Low_complexity")
emai2 <- subset(emai1,class != "Simple_repeat")

mcic$overlap[is.na(mcic$overlap)] <- 1
mcicNO<-mcic %>% filter(overlap != "*")

zrad$overlap[is.na(zrad$overlap)] <- 1
zradNO<-zrad %>% filter(overlap != "*")

emus2$overlap[is.na(emus2$overlap)] <- 1
emusNO<-emus2 %>% filter(overlap != "*")

emai2$overlap[is.na(emai2$overlap)] <- 1
emaiNO<-emai2 %>% filter(overlap != "*")
mcicNO$family<-sub("_INT","",mcicNO$family)
mcicNO$family<-sub("_LTR","",mcicNO$family)
mcicNO <- mcicNO %>% mutate(familyname = paste("Mcic",mcicNO$family,mcicNO$class))

library(viridis)
mcicNO<-mcicNO %>% mutate(Identity=100-div.)
mcicNO1<-mcicNO %>% group_by(ID,familyname) %>% summarise(Identity=mean(Identity),Len=sum(length))
zradNO<-zradNO %>% mutate(Identity=100-div.)
zradNO$family<-sub("_INT","",zradNO$family)
zradNO$family<-sub("_LTR","",zradNO$family)
zradNO <- zradNO %>% mutate(familyname = paste("Zrad",zradNO$family,zradNO$class))

emusNO<-emusNO %>% mutate(Identity=100-div.)
emusNO$family<-sub("_INT","",emusNO$family)
emusNO$family<-sub("_LTR","",emusNO$family)
emusNO <- emusNO %>% mutate(familyname = paste("Emus",emusNO$family,emusNO$class))
emaiNO<-emaiNO %>% mutate(Identity=100-div.)
emaiNO$family<-sub("_INT","",emaiNO$family)
emaiNO$family<-sub("_LTR","",emaiNO$family)
emaiNO <- emaiNO %>% mutate(familyname = paste("Emai",emaiNO$family,emaiNO$class))
emaiNO1<-emaiNO %>% group_by(ID,familyname) %>% summarise(Identity=mean(Identity),Len=sum(length))
emaiNO3<-subset(emaiNO1, Len > 80)
emaiNO3 %>% group_by(class) %>% summarise(n=n())
emaiLTR<- subset(emaiNO3,grepl("LTR",class)) %>% mutate(superfam = "LTR") %>% select(c(superfam,Len))
emaiNO3$class<-sub("TIR","DNA",emaiNO3$class)
emaiDNA<- subset(emaiNO3,grepl("DNA",class)) %>% mutate(superfam = "DNA") %>% select(c(superfam,Len))
emaiMITE<- subset(emaiNO3,grepl("MITE",class)) %>% mutate(superfam = "MITE") %>% select(c(superfam,Len))
emailength<-rbind(emaiLTR,emaiDNA,emaiMITE) %>% mutate(species = "E.maimaiga")
ggplot(emailength, aes(x=as.factor(superfam), y=log(Len))) + 
  geom_boxplot(fill="slateblue", alpha=0.2,outlier.size = 0) + 
  xlab("superfamily") +
  ggtitle("E.maimaiga length distribution")


emusNO3<-subset(emusNO1, Len > 80)
emusNO3 %>% group_by(class) %>%summarise(n=n())
emusLTR<- subset(emusNO3,grepl("LTR",class)) %>% mutate(superfam = "LTR") %>% select(c(superfam,Len))
emusNO3$class<-sub("TIR","DNA",emusNO3$class)
emusDNA<- subset(emusNO3,grepl("DNA",class)) %>% mutate(superfam = "DNA") %>% select(c(superfam,Len))
emusMITE<- subset(emusNO3,grepl("MITE",class)) %>% mutate(superfam = "MITE") %>% select(c(superfam,Len))
emuslength<-rbind(emusLTR,emusDNA,emusMITE) %>% mutate(species="E.muscae")
ggplot(emuslength, aes(x=as.factor(superfam), y=log(Len))) + 
  geom_boxplot(fill="slateblue", alpha=0.2,outlier.size = 0) + 
  xlab("superfamily") +
  ggtitle("E.muscae length distribution")

mcicNO3<-subset(mcicNO1, Len > 80)
mcicNO3 %>% group_by(class) %>%summarise(n=n())

mcicLTR<- subset(mcicNO3,grepl("LTR",class)) %>% mutate(superfam = "LTR") %>% select(c(superfam,Len))
mcicNO3$class<-sub("TIR","DNA",mcicNO3$class)
mcicNO3$class<-sub("polinton","DNA/Maverick",mcicNO3$class)
mcicDNA<- subset(mcicNO3,grepl("DNA",class)) %>% mutate(superfam = "DNA") %>% select(c(superfam,Len))
mcicMITE<- subset(mcicNO3,grepl("MITE",class)) %>% mutate(superfam = "MITE") %>% select(c(superfam,Len))
mciclength<-rbind(mcicLTR,mcicDNA,mcicMITE) %>% mutate(species="M.cicadina")
ggplot(mciclength, aes(x=as.factor(superfam), y=log(Len))) + 
  geom_boxplot(fill="slateblue", alpha=0.2,outlier.size = 0) + 
  xlab("superfamily") +
  ggtitle("M.cicadina length distribution")

zradNO3<-subset(zradNO1, Len > 80)
zradNO3 %>% group_by(class) %>%summarise(n=n())
zradLTR<- subset(zradNO3,grepl("LTR",class)) %>% mutate(superfam = "LTR") %>% select(c(superfam,Len))
zradNO3$class<-sub("TIR","DNA",zradNO3$class)
zradDNA<- subset(zradNO3,grepl("DNA",class)) %>% mutate(superfam = "DNA") %>% select(c(superfam,Len))
zradMITE<- subset(zradNO3,grepl("MITE",class)) %>% mutate(superfam = "MITE") %>% select(c(superfam,Len))
zradlength<-rbind(zradLTR,zradDNA,zradMITE) %>% mutate(species="Z.radicans")
ggplot(zradlength, aes(x=as.factor(superfam), y=log(Len))) + 
  geom_boxplot(fill="slateblue", alpha=0.2,outlier.size = 0) + 
  xlab("superfamily") +
  ggtitle("Z.radicans length distribution")
install.packages("wesanderson")
library(wesanderson)
wholelength<-rbind(emailength,emuslength,mciclength,zradlength)
supfig1<-ggplot(wholelength, aes(x=species, y=log(Len), fill=superfam)) + 
  geom_boxplot( outlier.size = 0.1) + 
  xlab("species") +
  ylab("log(length)")+
  scale_fill_manual(values=wes_palette("Moonrise2",n=3)) +
  theme_cowplot(12) +
  theme(axis.text.x = element_text(face = 3)) +
  labs(fill = "type")


ggsave("~/bigdata/TE_composition-EDTA/plots/supfig1LengthDistribution.jpg",supfig1,
       dpi = 300)