#!/bin/bash
# -*- coding: utf-8 -*-

#put present working directory in a variable
WD=$(pwd)
#REMDIR="/groups/hologenomics/phq599/data/EBIODIV_2021jun25"
REMDIR="${WD}"
#define input directory
OUDIR01="01_demultiplex_filtered"
#define input directory
OUDIR01="02_demultiplex_filtered"


#define input directory where the downloaded data files are stored in unzipped format
INDIR02="00C_raw_decompressed_fastq.gz_files"

# #prepare paths to files, and make a line with primer set and number of nucleotide overlap between paired end sequencing
# Iteration loop over b library numbers
# to prepare slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
# change dire to the dir that holds the fastq files
cd "$INDIR02"
# make a list that holds the names of the fastq files
LSSMPL=$(ls | awk 'BEGIN { FS = "_" } ; {print $1"_"$2}' | uniq)
#make the list of samples an array you can iterate over
declare -a SMPLARRAY=($LSSMPL)
 
#change back to the working dir
cd "$WD"

# rm stdout_pa01A.txt
# touch "$WD"/stdout_pa01A.txt
# iconv -f UTF-8 -t UTF-8 "$WD"/stdout_pa01A.txt

#iterate over samples
for smp in ${SMPLARRAY[@]}
 	do
	#echo $fn

		echo "b"${smp}""
		cd ./"${OUDIR01}"/b"${smp}"/
		cp *part07*pdf "${WD}"/.
		cd "${WD}"
	done
tar -zcvf part07_plots.pdf.tar.gz part07_*stacked*pdf
rm part07_*stacked*pdf

#
# use a one line to get all resulting csv files in a compressed file

#iterate over samples
for smp in ${SMPLARRAY[@]}
 	do
	#echo $fn
	echo "b"${smp}""
	cd ./"${OUDIR01}"/b"${smp}"/
	cp *part07*csv "${WD}"/.
	cd "${WD}"
done
tar -zcvf part07_csv_files.tar.gz part07_*csv
rm part07_*csv

#
#