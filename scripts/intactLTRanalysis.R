library(tidyverse)
library(readr)
library(ggplot2)
library(cowplot)
library(wesanderson)
setwd("~/bigdata/TE_composition-EDTA/")
intactZrad <- read_tsv("Zoophthora_radicans_ATCC_208865_v1.fasta.mod.LTR.intact.clean.gff3",
                       col_names = c("CHROM","SOURCE","TYPE","START","END","SCORE","STRAND","PHASE","GROUP"),
                       comment = "##")
intactZrad1 <- intactZrad %>% mutate(TE_type = str_replace(GROUP, "^.+Name=([^;]+);Classification=.+$","\\1")) %>%
  mutate(TE_family = str_replace(GROUP,"^.+Classification=([^;]+);Sequence_ontology=.+$","\\1")) %>% 
  mutate(Identity = str_replace(GROUP,"^.+Identity=([^;]+);Method=.+$","\\1")) %>% 
  mutate(Method = str_replace(GROUP,"^.+Method=(.+)$","\\1")) %>%
  mutate(length = END - START + 1) %>%
  select(-c(GROUP,SOURCE,TYPE,PHASE,SCORE))
intactZrad1 <-intactZrad1 %>% mutate(Identity = str_replace(Identity,"^.+ltr_identity=([^;]+);Method=.+$","\\1" )) %>%
  mutate(Method=str_replace(Method,"^.+Method=([^;]+);motif=.+$","\\1")) 

intactZrad1$Identity <- as.numeric(intactZrad1$Identity)
intactZrad1 <- intactZrad1 %>% mutate(MYO=(1-Identity)/(2*1.05e-9)*1e-6)
write_tsv(intactZrad1,"intactLTRZrad.tsv")
bottlerocket2_palette <- wes_palette("BottleRocket2")
bottlerocket2_palette

zrad<-intactZrad1 %>% ggplot(aes(x=MYO)) +
  geom_histogram(binwidth = 3,fill="#FAD510") +
  ggtitle("Z.radicans") +
  theme_cowplot(12) +
  xlab("MYA")+
  ylab("Copy number")+
  theme(plot.title = element_text(face = "italic"))
  

#M.cicadina
intactMcic <- read_tsv("M.cicadina_UCR_MCPNR19_1.0_genomic.fna.mod.LTR.intact.clean.gff3",
                       col_names = c("CHROM","SOURCE","TYPE","START","END","SCORE","STRAND","PHASE","GROUP"),
                       comment = "##")
intactMcic1 <- intactMcic %>% mutate(TE_type = str_replace(GROUP, "^.+Name=([^;]+);Classification=.+$","\\1")) %>%
  mutate(TE_family = str_replace(GROUP,"^.+Classification=([^;]+);Sequence_ontology=.+$","\\1")) %>% 
  mutate(Identity = str_replace(GROUP,"^.+Identity=([^;]+);Method=.+$","\\1")) %>% 
  mutate(Method = str_replace(GROUP,"^.+Method=(.+)$","\\1")) %>%
  mutate(length = END - START + 1) %>%
  select(-c(GROUP,SOURCE,TYPE,PHASE,SCORE))
intactMcic1 <-intactMcic1 %>% mutate(Identity = str_replace(Identity,"^.+ltr_identity=([^;]+);Method=.+$","\\1" )) %>%
  mutate(Method=str_replace(Method,"^.+Method=([^;]+);motif=.+$","\\1")) 

intactMcic1$Identity <- as.numeric(intactMcic1$Identity)
intactMcic1 <- intactMcic1 %>% mutate(MYO=(1-Identity)/(2*1.05e-9)*1e-6)
write_tsv(intactMcic1,"intactLTRMcic.tsv")
mcic<-intactMcic1 %>% ggplot(aes(x=MYO)) +
  geom_histogram(binwidth = 3,fill="#CB2314") +
  ggtitle("M.cicadina") +
  theme_cowplot(12) +
  ylab("Copy number")+
  xlab("MYA")+
  theme(plot.title = element_text(face = "italic"))


#E.muscae
intactEmus <- read_tsv("Entomophthora_muscae_UCB.scaffolds.fa.mod.EDTA.intact.clean.gff3",
                       col_names = c("CHROM","SOURCE","TYPE","START","END","SCORE","STRAND","PHASE","GROUP"),
                       comment = "##")
intactEmus1 <- intactEmus %>% mutate(TE_type = str_replace(GROUP, "^.+Name=([^;]+);Classification=.+$","\\1")) %>%
  mutate(TE_family = str_replace(GROUP,"^.+Classification=([^;]+);Sequence_ontology=.+$","\\1")) %>% 
  mutate(Identity = str_replace(GROUP,"^.+Identity=([^;]+);Method=.+$","\\1")) %>% 
  mutate(Method = str_replace(GROUP,"^.+Method=(.+)$","\\1")) %>%
  mutate(length = END - START + 1) %>%
  select(-c(GROUP,SOURCE,TYPE,PHASE,SCORE))
intactEmus1 <-intactEmus1 %>% mutate(Identity = str_replace(Identity,"^.+ltr_identity=([^;]+);Method=.+$","\\1" )) %>%
  mutate(Method=str_replace(Method,"^.+Method=([^;]+);motif=.+$","\\1")) 
intactEmus1 %>% group_by(TE_family) %>%
  summarise(n=n())
intactEmus2 <- subset(intactEmus1, TE_family %in% c("LTR/Gypsy", "LTR/Copia", "LTR/unknown"))
intactEmus2$Identity <- as.numeric(intactEmus2$Identity)
intactEmus2 <- intactEmus2 %>% mutate(MYO=(1-Identity)/(2*1.05e-9)*1e-6)
write_tsv(intactEmus2,"intactLTREmus.tsv")
emus<-intactEmus2 %>% ggplot(aes(x=MYO)) +
  geom_histogram(binwidth = 3,fill="#273046") +
  ggtitle("E.muscae") +
  theme_cowplot(12) +
  xlab("MYA")+
  ylab("Copy number")+
  theme(plot.title = element_text(face = "italic"))


#E.maimaiga
intactEmai <- read_tsv("Entomophaga_maimaiga_var_ARSEF_7190.fasta.mod.EDTA.intact.clean.gff3",
                       col_names = c("CHROM","SOURCE","TYPE","START","END","SCORE","STRAND","PHASE","GROUP"),
                       comment = "##")
intactEmai1 <- intactEmai %>% mutate(TE_type = str_replace(GROUP, "^.+Name=([^;]+);Classification=.+$","\\1")) %>%
  mutate(TE_family = str_replace(GROUP,"^.+Classification=([^;]+);Sequence_ontology=.+$","\\1")) %>% 
  mutate(Identity = str_replace(GROUP,"^.+Identity=([^;]+);Method=.+$","\\1")) %>% 
  mutate(Method = str_replace(GROUP,"^.+Method=(.+)$","\\1")) %>%
  mutate(length = END - START + 1) %>%
  select(-c(GROUP,SOURCE,TYPE,PHASE,SCORE))
intactEmai1 <-intactEmai1 %>% mutate(Identity = str_replace(Identity,"^.+ltr_identity=([^;]+);Method=.+$","\\1" )) %>%
  mutate(Method=str_replace(Method,"^.+Method=([^;]+);motif=.+$","\\1")) 

intactEmai2 <- subset(intactEmai1, TE_family %in% c("LTR/Gypsy", "LTR/Copia", "LTR/unknown"))
intactEmai2$Identity <- as.numeric(intactEmai2$Identity)
intactEmai2 <- intactEmai2 %>% mutate(MYO=(1-Identity)/(2*1.05e-9)*1e-6)
write_tsv(intactEmai2,"intactLTREmai.tsv")

emai<-intactEmai2 %>% ggplot(aes(x=MYO)) +
  geom_histogram(binwidth = 3,fill="#354823") +
  ggtitle("E.maimaiga") +
  theme_cowplot(12) +
  ylab("Copy number")+
  xlab("MYA")+
  theme(plot.title = element_text(face = "italic"))

supfig4<-plot_grid(emai,mcic,emus,zrad,nrow = 2)
print(supfig4)
ggsave("~/bigdata/TE_composition-EDTA/plots/supfig4LTRinsertion.pdf", supfig4,
       dpi = 500)
