#!/bin/bash
#SBATCH --account=hologenomics         # Project Account
#SBATCH --partition=hologenomics 
#SBATCH --mem 128M
#SBATCH -c 1
#SBATCH -t 24:00:00
#SBATCH -J 00B_unzip_file
#SBATCH -o stdout_00B_unzip.txt
#SBATCH -e stderr_00B_unzip.txt

#load modules required
module purge
#module load python/v2.7.12
#module load cutadapt/v1.11
#module load vsearch/v2.8.0

rm -rf Process/
rm -rf Data/
rm -rf Analysis/

#Get file from ERDA
#
tar -zxf GC-OBB-9347.tar.gz