#!/bin/bash
#SBATCH --account=hologenomics         # Project Account
#SBATCH --partition=hologenomics 
#SBATCH --mem 1G
#SBATCH -c 2
#SBATCH -t 1:00:00
#SBATCH -J p02Csetup
#SBATCH -o stdout_pa02C_setup.txt
#SBATCH -e stderr_pa02C_setup.txt



cd "$WD"
##source activate YOUR_CONDA_ENV
##source /com/extra/R/3.5.0/load.sh
#load modules required
module purge
#module load python/v2.7.12
#module load cutadapt/v1.11
#module load vsearch/v2.8.0

# the 'dada2' package for R requires R v3.4
# the 'dada2' package for R requires R v4.0.2 - in July-2021 it requires R v4.0.2

#module load R/v3.4.3
#module load R/v4.0.2

# start the job with sbatch
#srun part02_dada2_sickle_v2_AMRH_AL_v02.r
./part02D_bash_make_sbatch_and_dada2sickle_inR_v01.sh
#	 part02_dada2_sickle_inR_v03.r