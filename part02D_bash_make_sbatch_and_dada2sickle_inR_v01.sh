#!/bin/bash
# -*- coding: utf-8 -*-

#put present working directory in a variable
WD=$(pwd)
REMDIR="/groups/hologenomics/phq599/data/Akvarie_Ole_svampe_analyse"
#define input directory
OUDIR01="01_demultiplex_filtered"
OUDIR01="02_demultiplex_filtered"
#define path for b_library numbers
PATH01=$(echo ""${REMDIR}"/"${OUDIR01}"")
#remove previous versions of the outdir
#NOTE that Ole BB's data was demultiplexed before downloaded
# this means 'part01' with demultiplex is skipped in this step
# instead this code works directly on the unzipped files obtained from downloading Ole BBs data
# Remove any previous versions of the output directory
rm -rf "${OUDIR01}"
# make a new directory 
mkdir "${OUDIR01}"
#define input directory where the downloaded data files are stored in unzipped format
INDIR02="00C_raw_decompressed_fastq.gz_files"
# #prepare paths to files, and make a line with primer set and number of nucleotide overlap between paired end sequencing
# Iteration loop over b library numbers
# to prepare slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
#	for fn in $(seq -f "%03g" 9 16)

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
	echo "copying to b"${smp}""
	

	#make directory for holding output files
	mkdir "${PATH01}"/"${BDR}"
	# write the contents with cat
	cat part02E_sbatch_run_dada2_sickle_R_v01.sh | \
		#part02_dada2_sickle_inR_v03.r
	# and use sed to replace a txt string w the b library number
	sed "s/blibnumber/b"${smp}"/g" > "${PATH01}"/"${BDR}"/part02E_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh
	
	# and modify the R file
	cat part02F_dada2_sickle_inR_v03.r | \
	# and modify inside the file
	# modify the #set min length for the 'fastqPairedFilter' function
	sed -E "s;fpfml <- 100;fpfml <- 50;g" | \
	# modify the  #set length for sickle
	sed -E "s;lsick <- 100;lsick <- 50;g" | \
	# modify the #set quality for sickle
	sed -E "s;qsick <- 28;qsick <- 2;g" | \
	# and use sed to replace a txt string w the b library number
	# the R code is set up to copy the fastq files from the directory with the unzipped fastq files
	# and this directory does not have the 'b' added in front.
	sed -E "s/blibnumber/"${smp}"/g" > "${PATH01}"/"${BDR}"/part02F_dada2_sickle_inR_v03_b"${smp}".r
	#make the DADA2 sh script executable
	chmod 755 "${PATH01}"/"${BDR}"/part02F_dada2_sickle_inR_v03_b"${smp}".r


	# LFASTQF=$(ls $INDIR02 | grep "${smp}")
	# #make the list of samples an array you can iterate over
	# declare -a FQARRAY=($LFASTQF)
	# for file in $FQARRAY
	# do
	# 	cp $file "${PATH01}"/"${BDR}"/.
	# done
done


# Iteration loop over b library numbers
# to start slurm submission scripts for each b library number
#iterate over sequence of numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
#	for fn in $(seq -f "%03g" 9 16)

#iterate over samples
for smp in ${SMPLARRAY[@]}
do
	#echo $fn
	#make a directory name for the NGS library
	BDR=$(echo "b"${smp}"")
	echo "${BDR}"
	#W
	cd "${PATH01}"/"${BDR}"/
	#echo ""${PATH01}"/"${BDR}""
	#
	#echo "part02_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh"
	#sbatch part02_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh
	sbatch part02E_sbatch_run_dada2_sickle_R_v01_b"${smp}".sh
	#
	cd "$WD"
done

#NJOBS=$(seq 30222129 30225982); for i in $NJOBS; do scancel $i; done
#30222129 30225982