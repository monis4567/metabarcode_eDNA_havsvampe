#!/bin/bash
# -*- coding: utf-8 -*-


# Fra Ole Bjørn Brodnicke
# Tue 01/18, 2:44 PMSteen Wilhelm Knudsen
# Hej Steen,
# Så fedt du er med på havsvampe projektet. Det kan jo evt vise sig at være værd at lave noget lignende i DK en dag.
# I forhold til data’en så tror jeg filen når den er pakket ud har nogle mapper og nogle filer.
# For at finde .fastq filerne skal man først ind i Data, så ind i mappen der hedder : 211001_M00527_0183_000000000-JPJDH. I den mappe skal man så ind i Data igen, videre ind i Intensities og til slut BaseCalls mappen.
# I denne mappe finder vi .fastq filerne. Der er nogle negative men ellers kører sample numrene bare der ud af. Men enden er lidt sjov. Så vidt jeg kan se har de kørt hver prøve i triplicater som vi har bedt dem om. Dog virker det som om der er en R1 og R2 som måske referer til et run?
# I hvertfald er der 6 filer per prøve.
# SW er vandprøverne og WB er havsvamp.
# Håber vi kan finde noget fisk i dem her J Og at det ikke er de forkerte.


#211001_M00527_0183_000000000-JPJDH/Data/Intensities/BaseCalls

#get working directory and place in variable
WD=$(pwd)

# define output directory where the  unzipped 'fastq.gz' files are to be placed 
OUDR1="00C_raw_decompressed_fastq.gz_files"
# define input directory with 'fastq.gz' files 
INDIR1="/Ole_BB_eDNA_data_2021oct/X204SC21080438-Z01-F001/raw_data"
INDIR1="Ole_BB_eDNA_Schulz_Bank_data_2022jan/Data/211001_M00527_0183_000000000-JPJDH/Data/Intensities/BaseCalls"
# remove the previous version of the output directory
rm -rf "${OUDR1}"
# make a new version of the output directory
mkdir -p "${OUDR1}"


# In order to keep the original gz files you can gunzip them to a different directory:
# See this website: https://superuser.com/questions/139419/how-do-i-gunzip-to-a-different-destination-directory
# gunzip -c file.gz > /THERE/file

# Iterate over sequence numbers
# but pad the number with zeroes: https://stackoverflow.com/questions/8789729/how-to-zero-pad-a-sequence-of-integers-in-bash-so-that-all-have-the-same-width
#pcrlbs=$(seq -f \"%03g\" 1 4)

# use sed to retain the first part of string to get base directory
BWD=$(echo $WD | sed -E 's;(.*)/.*$;\1;g')
# paste directories together to get sub directory
SBWD1=$(echo "$BWD""/""$INDIR1")

#iteratre over sequence
# for n in $(seq 1 4)
# 	do 
cd "${SBWD1}/"

		# Iterate over uncompressed files
		for f in *fastq.gz
		do
			#echo $f
			#modify the filename with the sed command, to delete the end of the file name
			nf=$(echo $f | sed -E 's/^.*[/]//g' | sed 's/.gz//g')
			echo $nf
			#echo ""${WD}"/"${OUDR1}""
			
			#uncompress the gz files
			gunzip -c "$f" > ""${WD}"/"${OUDR1}""/$nf
			# and character modify the uncompressed file
			chmod 755 ""${WD}"/"${OUDR1}""/$nf
		done
# done

#tar -zcvf part00.tar.gz part00*

#
#scp part00.tar.gz phq599@fend01.hpc.ku.dk:/groups/hologenomics/phq599/data/Akvarie_Ole_eDNA_analyse/.
