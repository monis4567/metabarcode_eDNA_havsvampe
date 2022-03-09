#!/bin/bash
# -*- coding: utf-8 -*-

#put present working directory in a variable
WD=$(pwd)
REMDIR="/groups/hologenomics/phq599/data/Akvarie_Ole_svampe_analyse"
#define input directory
OUDIR01="01_demultiplex_filtered"
OUDIR01="02_demultiplex_filtered"

#rm -rf "$OUDIR01"
#mkdir "$OUDIR01"
#define input directory where the downloaded data files are stored in unzipped format
INDIR02="00C_raw_decompressed_fastq.gz_files"

#define path for b_library numbers
PATH01=$(echo ""${REMDIR}"/"${OUDIR01}"")

# #prepare paths to files, and make a line with primer set and number of nucleotide overlap between paired end sequencing
# Iteration loop over b library numbers
# to prepare slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
	# for fn in $(seq -f "%03g" 9 16)

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
	# write the contents with cat
	cat part02D_sbatch_run_dada2_sickle_R_v01.sh | \
	# and use sed to replace a txt string w the b library number
	sed "s/blibnumber/b"${smp}"/g" > "${PATH01}"/"${BDR}"/part02D_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh
	#make the DADA2 sh script executable
	chmod 755 "${PATH01}"/"${BDR}"/part02D_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh

	
done
