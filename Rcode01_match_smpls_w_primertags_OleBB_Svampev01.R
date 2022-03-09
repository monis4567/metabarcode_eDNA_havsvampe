#!/usr/bin/env Rscript
# -*- coding: utf-8 -*-

#set working directory
wd00 <- "/home/hal9000/Documents/shrfldubuntu18/Akvarie_Ole_svampe_eDNA"
setwd(wd00)

#install packages
#get readxl package
if(!require(readxl)){
  install.packages("readxl")
}  
library(readxl)
#define input files
inf1 <- "MiFish_tagged_primers_96tags.xlsx"
inf2 <- "Sample_list_metadata_v5.xlsx"
inf3 <- "SampleSheet.csv" 
# #read in excel files
# tibl_MF01    <- readxl::read_xlsx(inf1, col_names =T)
# tibl_SM01    <- readxl::read_xlsx(inf2, col_names =T)
# read in csv file with tags
tabl_MF01 <- read.table(inf3, skip=20,sep=",")
#make it a data frame
df_MF01 <- as.data.frame(tabl_MF01)
# change column names
colnames(df_MF01) <- df_MF01[1,]
# remove first row
df_MF01 <- df_MF01[-1,]
# # make tibbles data frames
# df_MF01 <- as.data.frame(tibl_MF01)
# df_SM01 <- as.data.frame(tibl_SM01)
#pad with zeros to 3 characters
#see this website: https://stackoverflow.com/questions/5812493/adding-leading-zeros-using-r
#df_SM01$smpNopd <-stringr::str_pad(df_SM01$Sample_number, 3, pad = "0")
#match between data frames to get sample number
#df_MF01$smpNopd <- df_SM01$smpNopd[match(df_MF01$`Well Position`,df_SM01$PCR_well)]
#paste SN in front of sample No to denote it is sample number
#df_MF01$smpNopd2 <- paste("SN",df_MF01$smpNopd,sep="")
#split column as string and retain first and third column
#df_MF01$prmset <- data.frame(do.call('rbind', strsplit(as.character(df_MF01$`Plate Name`),'_',fixed=TRUE)))[,1]
#df_MF01$tagNo <- data.frame(do.call('rbind', strsplit(as.character(df_MF01$`Sequence Name`),'_',fixed=TRUE)))[,3]
#paste SN in front of sample No to denote it is tag number
#df_MF01$tagNo <- paste("tag",df_MF01$tagNo,sep="")

head(df_MF01,3)
#copy sample_ID_column
df_MF01$smpNopd2 <- df_MF01$Sample_ID
# copy tag seq
df_MF01$tagseq1 <- df_MF01$index
df_MF01$tagseq2 <- df_MF01$index2
df_MF01$tagseq2 <- gsub(" ","",df_MF01$tagseq2)
#order tag_seq
orindx1 <- unique(df_MF01$tagseq1)[order(unique(df_MF01$tagseq1))]
orindx2 <- unique(df_MF01$tagseq2)[order(unique(df_MF01$tagseq2))]
# make a number count for indexes
inx1cnt <- seq(1:length(orindx1))
inx2cnt <- seq(1:length(orindx2))

#pad with zeros to 3 characters
#see this website: https://stackoverflow.com/questions/5812493/adding-leading-zeros-using-r
inx1cnt.p <-stringr::str_pad(inx1cnt, 3, pad = "0")
inx2cnt.p <-stringr::str_pad(inx2cnt, 3, pad = "0")
#
df_indx1 <- as.data.frame(cbind(inx1cnt.p,orindx1))
df_indx2 <- as.data.frame(cbind(inx2cnt.p,orindx2))
#make tag names in a column
df_indx1$ix1no <-  paste("ix1no",df_indx1$inx1cnt.p,sep="")
df_indx2$ix2no <-  paste("ix2no",df_indx2$inx2cnt.p,sep="")
#match back to data frame with tag seq
df_MF01$ix1no <- df_indx1$ix1no[match(df_MF01$tagseq1,df_indx1$orindx1)]
df_MF01$ix2no <- df_indx2$ix2no[match(df_MF01$tagseq2,df_indx2$orindx2)]
#Make a column for the primerset
df_MF01$prmset <- "MiFish"
#paste togehter columns to get samplenam_primerset_indexnumbers
df_MF01$smpNopd2 <- paste(df_MF01$Sample_ID,"_",df_MF01$prmset,"_",df_MF01$ix1no,df_MF01$ix2no,sep="")
#head(df_MF01,5)
#define columns to keep
keep <- c("smpNopd2","tagseq1","tagseq2")
# keep only these columns
df_MF03 <-  df_MF01[keep]
#write out the tag file
write.table(df_MF03, file="part01A_tag01_96_MiFiU_AkvarieOleB_svampe.txt",
          sep="\t",
          col.names = F,
          row.names = F,
          quote=F
          )


#