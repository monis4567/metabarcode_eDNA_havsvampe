#!/bin/bash
#SBATCH --account=hologenomics         # Project Account
#SBATCH --partition=hologenomics 
#SBATCH --mem 512M
#SBATCH -c 1
#SBATCH -t 1:00:00
#SBATCH -J p07C_getblast
#SBATCH -o stdout_pa07C_getblast.txt
#SBATCH -e stderr_pa07C_getblast.txt

#load modules required
module purge


WD=$(pwd)
INDIR02="02_demultiplex_filtered"

OUTDIR07="07C_blast_results_and_DADA_tables"
rm -rf "${OUTDIR07}"
mkdir "${OUTDIR07}"

cd "$INDIR02"
# make a list that holds the names of the fastq files
LSSMPL=$(ls | awk 'BEGIN { FS = "_" } ; {print $1"_"$2}' | uniq)
#make the list of samples an array you can iterate over
declare -a SMPLARRAY=($LSSMPL)
 
#change back to the working dir
cd "$WD"

#iterate over samples
for smp in ${SMPLARRAY[@]}
do
	cd "${WD}"/"${INDIR02}"/"${smp}"	
	cp part06_my_classified_otus_*.unfilt_BLAST_results.txt "${WD}"/"${OUTDIR07}"/.
	cp part06_my_classified_otus_*.filt_BLAST_results.txt "${WD}"/"${OUTDIR07}"/.
	cp part03_DADA2_nochim.table.*.txt "${WD}"/"${OUTDIR07}"/.
done
cd "${WD}"
zip -r part07C_blast_results.zip "${OUTDIR07}"
#for fn in $(seq -f "%03g" 9 16);do echo "b0"${fn}"";cd ./01_demultiplex_filtered/b"${fn}"/; rm *part07*;cd /groups/hologenomics/phq599/data/EBIODIV_2021jun25;done