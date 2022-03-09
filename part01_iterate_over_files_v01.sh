#!/bin/bash
# -*- coding: utf-8 -*-
echo $BASH_VERSION

##get the present directory
WD=$(pwd)
#define input sub directory
SBWD01="00C_raw_decompressed_fastq.gz_files"

#define input sub directory
SBWD02="01_demultiplexed"
# define path to sub directory
WD01=$(echo "$WD""/""$SBWD01")
WD02=$(echo "$WD""/""$SBWD02")

rm -rf "$WD02"
mkdir "$WD02"
#change directory to path to sub directory
#cd $WD01
#make list of paired samples
#LSSMPL=$(ls | awk 'BEGIN { FS = "_" } ; {print $1}' | uniq)

LSSMPL=$(cat list_of_fastq_files.txt | cut -d' ' -f10 | awk 'BEGIN { FS = "_" } ; {print $1}' | uniq)
#make the list of samples an array you can iterate over
declare -a smplarray=($LSSMPL)
 
#change dir to the output dir
cd $WD02 
#iterate over samples
for smp in ${smplarray[@]}
do
	#make a new dir name
	NWD=$(echo "sampledir_"$smp"")
	#echo $NWD
	#make the new dir
	mkdir $NWD
done

cd "$WD02"
ls -lh

