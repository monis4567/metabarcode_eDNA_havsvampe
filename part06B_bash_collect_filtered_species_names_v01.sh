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
#define path for b_library numbers
PATH01=$(echo ""${REMDIR}"/"${OUDIR01}"")
# After having completed
OUTF02="part06_my_classified_otus.filt_BLAST_results_allbibs.txt"
OUTF03="part06_my_classified_otus.filt_BLAST_results_allbibs02.txt"

OUTF04="part06_my_classified_otus.unfilt_BLAST_results_allbibs.txt"
OUTF05="part06_my_classified_otus.unfilt_BLAST_results_allbibs02.txt"
#remove any previous versions of the outputfile
rm "${WD}"/"${OUTF02}"
rm "${WD}"/"${OUTF03}"

rm "${WD}"/"${OUTF04}"
rm "${WD}"/"${OUTF05}"
#write a new output file to write to
touch "${WD}"/"${OUTF02}"
iconv -f UTF-8 -t UTF-8 "${WD}"/"${OUTF02}"

#write a new output file to write to
touch "${WD}"/"${OUTF04}"
iconv -f UTF-8 -t UTF-8 "${WD}"/"${OUTF04}"

# Iteration loop over b library numbers
# to collect results  for each b library number
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
	#make a directory name for the NGS library
	BDR=$(echo "b"${smp}"")
	# change directory to the subdirectory
	cd "${PATH01}"/"${BDR}"
	# write out th results file

	cat part06_my_classified_otus_b"${smp}".02.filt_BLAST_results.txt | \
	cut -d$'\t' -f9-15 | \
	uniq >> "${WD}"/"${OUTF02}"


	cat part06_my_classified_otus_b"${smp}".01.unfilt_BLAST_results.txt | \
	cut -d$'\t' -f9-15 | \
	uniq >> "${WD}"/"${OUTF04}"

	# change directory to the working directory
	cd "${WD}"
# end iteration over sequence of numbers	
done

cd ${WD}
cat "${OUTF02}" | uniq > "${OUTF03}"
cat "${OUTF04}" | uniq > "${OUTF05}"

# cat part06_my_classified_otus_b012.02.filt_BLAST_results.txt | cut -d$'\t' -f15 | uniq
# part06_my_classified_otus_b012.02.filt_BLAST_results.txt
#