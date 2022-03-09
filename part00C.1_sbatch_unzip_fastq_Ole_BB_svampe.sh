#!/bin/bash
#SBATCH --account=hologenomics         # Project Account
#SBATCH --partition=hologenomics 
#SBATCH --mem 128M
#SBATCH -c 1
#SBATCH -t 6:00:00
#SBATCH -J 00C_unzip_gz
#SBATCH -o stdout_00C_unzip.txt
#SBATCH -e stderr_00C_unzip.txt

#load modules required
module purge
#module load python/v2.7.12
#module load cutadapt/v1.11
#module load vsearch/v2.8.0

#Start bash code that iterates over gz files and unpacks them
#
./part00C.2_unzip_fastq_Ole_BB_svampe.sh