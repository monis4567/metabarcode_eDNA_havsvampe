# metabarcode_eDNA_havsvampe
metabarcode of eDNA from deep sea sponges

The majority of code provided here is unix bash shell code intended to be secure copied to a remote server using the unix command `scp` to transfer the files to an external HPC server. The large datasets can then be analysed remotely, and the results from each individual analysis can then be monitored after each step.<br/>
To analyse this metabarcode dataset run the individual parts one after the other, and inspect the immediate results that comes from each part.<br/>

## part00
part00 is used for obtaining the raw fastq.gz compressed datafile, and uncompressing the zipped file. <br/>
All pieces of code are intended to be run on the HPC server unless specified otherwise. <br/>
Submit all the part00 files to a new directory on the remote HPC server. You can use the `scp` command to transfer the files.<br/>
On the remote HPP server
Start by running part00A to get the data. You start a run by submitting it as slurm job using the command `sbatch` like this: `part00A_sbatch_wget_tar_file_from_ERDA_Ole_BB_svampe.sh` <br/> 
You can inspect the resulting "stderr" and "stdout" files that are generated, to check if the runs performed as intended.<br/>
Then once this has finished , continue by submitting the next job, like this: `sbatch part00B_unzip_Ole_BB_svampe.sh`<br/>
Again. Inspect the resulting "stderr" and "stdout" files that comes out of this part00B, and check they are without any major errors.<br/>
Then transfer the file "part00C.1_sbatch_unzip_fastq_Ole_BB_svampe.sh" to the HPC server and run this by submitting it to the slurm queue using the `sbatch` command like this: `sbatch part00C.1_sbatch_unzip_fastq_Ole_BB_svampe.sh` <br/>
Wait for this to finish.
Then continue by transfering the file: "part00C.1_sbatch_unzip_fastq_Ole_BB_svampe.sh", and also submit this with the `sbatch` command like this: `sbatch part00C.2_unzip_fastq_Ole_BB_svampe.sh` <br/>
Instead of using the `scp` command to transfer this part00 files individually, you can instead `tar` compress all the part00 files locally with this command `tar -zcvf part00.tar.gz part00*`, as this will compress all files that has the text 'part00' in the first part of the filename. Before you compress the files, make sure you deleted any previous versions of the 'part00.tar.gz' so that this already compressed file does not end up inside the newly compressed file. <br/>
Once you have a 'part00.tar.gz' ready this can be transferred to the HPC server to the directory you are working in, and inside this directory it can uncompressed like this: `tar -zxvf part00.tar.gz`. The you can proceed by submitting each part00 file individually as a slurm job using `sbatch` command as described above.

Once you have finished with part00. Proceed to part01. Start out locally by opening Rstudio. Then open the file : 'Rcode01_match_smpls_w_primertags_OleBB_Svampev01.R', and try to run this inside Rstudio. This should read in an xls file and prepare a file with tags that you will need for demultiplexing. All of part01 is about getting the seqeunce reads demultiplexed. <br/>
After having run the 'Rcode01_match_smpls_w_primertags_OleBB_Svampev01.R' locally, the next step would be to demulitplex your raw data. However, for this deep sea sponge data the fastq files represents already demultiplexed libraries. All of part01 is thus not needed for this metabarcode dataset. Because of this you can skip all part01 related files. <br/>
Just to keep code and instructions on how to demultiplex, the text section here below in this README file that covers part01 is only included for the sake of being able to make use of this code for other similar metabarcode datasets. But for now proceed to part02.<br/>

## part01
Notes on par01 related files: Start out by remove any previous versions of tar compressed "part01.tar.gz". This can be removed with the command `rm part01.tar.gz`. Then locally compress all part01 related files with the tar command:  `tar -zcvf part01.tar.gz part01*`. Then transfer this "part01.tar.gz" to the remote HPC server, and uncompress it on the remote server. Then run the part01A code like this: `./part01A_bash_make_batch_lists_AkvarieOleB_svampe_01.sh`. This is a small shell script that prepares a lot of slurm submission scripts. If it works as intended you should get an instruction that tells you to run: `./part01B_bash_start_all_demultiplexing_v3.sh`. Executing this command should start multiple parallel demultiplexing setups for each fastq library you have. You can navigate into the directory: '00C_raw_decompressed_fastq.gz_files' and check you have a list of fastq files. <br/>

## part02
part02 makes use of 'DADA2' and 'sickle' in R to make a table of 'sense' reads. Using DADA2 also allows for inferring chimera sequences, which also are refered to as 'anti-sense' (AS) reads. When dealing with eDNA metabarcode datasets that needs to be demultiplexed before it is possible to use BLAST to match the reads against NCBI GenBank, there would normally be a directory that ends up holding the 'SS' (i.e. sense seqeunces) and a directory that holds the 'AS' (i.e. anti-sense seqeunces). However, for this metabarcode dataset on deep sea sponges, there is no AS directory. <br/> 
Before you can start runnig part02 externally on a remote server, you will need to setup your libraries of R packages. <br/> 

Before you can use R on the  remote server , you will need to install the packages in a directory accesible among your remote directories. You will only have to install these packages once.<br/> 
But before you can install all the packages here below, you will need the 'RCurl' to be installed by an administrator on the remote server<br/> 
If you run these commands locally, you should have administrator rights to get them installed locally<br/> 

Before you can install these package you will need the 'RCurl' package being available for R<br/> On the HPC UCPH server 'RCurl' is installed here:  "libcurl-devel" on fend05<br/> 
Here is a webpage with guide to get 'RCurl' installed:<br/>  https://github.com/sagemath/cloud/issues/114<br/> 
Users of this R-script on HPC UCPH - Note that this 'RCurl' is already installed on UCPH-HPC. So UCPH-HPC users can just go ahead and install the individual packages for R -  as described here below<br/> 

login to your remote directory via a terminal.<br/> 
navigate to the data directory where you have your work<br/> 
First you will need a directory on your remote node where you can place all your packages.<br/> 
in your home directory - e.g. : /groups/hologenomics/phq599/<br/> 
navigate to a directory where you can have your R packages<br/> 
You can create the directory if it does not already exists : <br/> 
`mkdir R_packages_for_Rv4_0_2`<br/>
remove any eventual already loaded modules<br/>
`module purge`<br/>
The command 'module purge' removes any already loaded modules<br/>
It turned out the 'dada2' could not be installed in R v3.6<br/>
And not for R v3.4, and not for R v4.0.2<br/>
But 'dada2' could instead be installed in R v4.0.2 by using "BiocManager"<br/>
check which version of R that are available<br/>
`module avail`<br/>
If you find that practically no modules are available, then it is most likely because it is the First time you login:<br/>
On the UPCH HPC server you will need to set up access to the modules you will be using<br/>
Therefore the first time you login, run this line (ONLY NEED TO RUN THIS ONE TIME)<br/>

`/groups/hologenomics/software/.etc/first_login.sh`<br/>
Follow the instructions...<br/>
Then logout, and close the terminal, and start a new terminal, and login again<br/>

Now try again:<br/>
`module avail`<br/>
You should now see a long list of modules be available<br/>
You can exit this list of modules by typing 'q' for quit<br/>
First make sure no unneeded modules have been loaded<br/>
`module purge`<br/>
You can use 'module spider R' to see which version of R is available on the remote server<br/>
`module spider R`<br/>
I will try installing for Rv4_0_2<br/>
If a more recent version of R is available, then make use this instead<br/>
Start out by making a directory where all the packages can be placed inside<br/>
`mkdir R_packages_for_Rv4_0_2`<br/>
`cd R_packages_for_Rv4_0_2/`<br/>
`module load R/v4.0.2`<br/>
 
 start up R by typing R<br/>
`R`<br/>

In R <br/>
Run the lines below <br/>
You also need to run each of these lines one by one individually<br/>
In R you now first need to specify a path to the directory where you want your packages to be available for your R-code<br/>
Run these lines - changing the path your own directory for where the packages need to be replace my library path to your own library path<br/>
You will have to run each line one at a time<br/>

Run this line in R to specify the path to where you want the packages to placed:<br/>
`lib_path01 <- "/groups/hologenomics/phq599/data/R_packages_for_Rv4_0_2"`<br/>
Continue by running these lines, one by one in R<br/>
`Sys.setenv(R_LIBS_USER="lib_path01")`<br/>
`.libPaths("lib_path01")`<br/>
change the path to where the packages should be installed from # see this website: https://stackoverflow.com/questions/15170399/change-r-default-library-path-using-libpaths-in-rprofile-site-fails-to-work<br/>

`.libPaths( c( lib_path01 , .libPaths() ) )`<br/>
`.libPaths()`<br/>
`.libPaths( c( lib_path01) )`<br/>

Or try pasting one long line with all commands, and installation of the 'taxizedb' library, but make sure you change the path to your own <br/>
`lib_path01 <- "/groups/hologenomics/phq599/data/R_packages_for_Rv4_0_2"; Sys.setenv(R_LIBS_USER="lib_path01"); .libPaths("lib_path01"); .libPaths( c( lib_path01 , .libPaths() ) ); .libPaths(); .libPaths( c( lib_path01) ); install.packages(c("taxizedb", "taxize", "tidyverse"))`<br/>
In R <br/>
You also need to run each of these lines one by one individually<br/>
 `install.packages(c("latticeExtra"))`<br/>
Not available for R v3.4.1<br/>
`install.packages(c("robustbase"))`<br/>
Not available for R v3.4.1<br/>
`install.packages(c("lessR"))`<br/>
Not available for R v3.4.1<br/>
`install.packages(c("readr"))`<br/>
`install.packages(c("dada2"))`<br/>
Not available for R v3.4.1 and not for R v4.0.2<br/>
`install.packages(c("dada2", "readr", "dplyr", "taxize", "tidyr"))`<br/>
`install.packages(c("taxizedb"))`<br/>
`install.packages(c("ShortRead"))`<br/>
Not available for R v3.4.1<br/>

Dependent on 'wikitaxa' which is Not available for R v3.4.1<br/>
`install.packages(c("taxize"))`<br/>
`install.packages(c("tidyverse"))`<br/>
Note that this might exit with an error message . Read on for the next instructions below:<br/>
As I had difficulties getting the 'dada2' package installed on the remote path
I tried to look for solutions <br/>
I then looked up the 'dada2' package for R on the internet here:<br/>
https://www.bioconductor.org/packages/release/bioc/html/dada2.html<br/>
and this webpage recommended that I ran these two commands (again running one line at a time)<br/>
You will need to have "ShortRead" installed before you can install "dada2". Use "BiocManager" to install both<br/>
First start with: "BiocManager". Run each line one by one<br/>
`if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")`<br/>
`BiocManager::install("ShortRead")`<br/>
`BiocManager::install("dada2")`<br/>
This should get your 'dada2' package installed<br/>
Check that R finishes without errors on packages <br/>
It might be that it instead finishes with a warning message. This is okay. As long as you are not getting an error message.<br/>
It might be that some packages fail, but as long as you get "dada2" and "readr" and "BiocManager" installed without<br/>
error I think it is just fine<br/>
Now quit R <br/>

Now that you have installed all packages in your remote path : "/groups/hologenomics/phq599/data/R_packages_for_Rv4_0_2"<br/>
You are almost ready to run parts of the code together with their matching slurm sbatch submission scripts<br/>

___________________________________________________________________________<br/>
Getting 'sickle-master'<br/>
___________________________________________________________________________<br/>
get sickle master <br/>
git clone from this repository: https://github.com/najoshi/sickle<br/>
place it in this directory : /groups/hologenomics/phq599/software/sickle_master<br/>
`git clone https://github.com/najoshi/sickle.git`<br/>
navigate into this directory you just copied 'sickle-master' to<br/>
then make sickle executable like this:<br/>
`chmod 755 sickle`<br/>
check you have all the packages for R available in your remote directory for all your R packages <br/>
I have mine placed in :  "/groups/hologenomics/phq599/data/R_packages_for_Rv4_0_2"<br/>
also check you have made sickle executable <br/>

specify a path to where you have all your packages on your remote node<br/>
NOTICE ! In order to have your packages available on the remote path, you will need to logon to your node, <br/>
and make a directory <br/>
called -e.g. : R_packages_for_Rv4_0_2<br/>
Then load the R module<br/>
`module load R/v4.0.2`<br/>
Then start R byt typing:<br/>
`R`<br/>
Once R is started run the lines here below in section 01<br/>
_______________start section 01__________________________________________ <br/>
replace my library path to your own library path<br/>
`lib_path01 <- "/groups/hologenomics/phq599/data/R_packages_for_Rv4_0_2"`<br/>
`Sys.setenv(R_LIBS_USER="lib_path01")`<br/>
`.libPaths("lib_path01")`<br/>
change the path to where the packages should be installed from # see this website:<br/> https://stackoverflow.com/questions/15170399/change-r-default-library-path-using-libpaths-in-rprofile-site-fails-to-work<br/>
`.libPaths( c( lib_path01 , .libPaths() ) )`<br/>
`.libPaths()`<br/>
_______________end section 01__________________________________________<br/>
You  will need to specify this path again later on when you are to run this R-script. Before you can start this R-script on the remote server you will need to install the packages here<br/>

in section 02 here below <br/>
installing these packages is commented out, as they are not needed when you are to run this R-script<br/>
But I have left them here in section 02 to be used when you install them the first time in your local path<br/>
Before you can install these package you will need the 'RCurl' pakcage being available for R<br/>
On the HPC UCPH server 'RCurl' is installed here:  "libcurl-devel" on fend05<br/>
Here is a wbepage with guide to get 'RCurl' installed:<br/> https://github.com/sagemath/cloud/issues/114<br/>
Users of this R-script on HPC UCPH - Note that this 'RCurl' is already installed. So HPC users can just <br/>
proceed and run the lines in section 02 here below<br/>
 
_______________start section 02__________________________________________ <br/>
Run this line below with <br/>
`install.packages(c("dada2", "readr", "dplyr", "taxize", "tidyr"))`<br/>
Having difficulties getting the 'dada2' package installed on the remote path tried looking for solutions <br/>
I then looked up the 'dada2' package for R on the internet here:<br/>
https://www.bioconductor.org/packages/release/bioc/html/dada2.html<br/>
and this webpage recommended that I ran these two commands<br/>

`if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")`<br/>
`BiocManager::install("dada2")`<br/>

This should get your 'dada2' package installed <br/>
Check that R finishes without errors on packages <br/>
Now quit R <br/>
_______________end section 02__________________________________________ <br/>

Start out by locally removing any previous versions of tar compressed "part02.tar.gz". This can be removed with the command `rm part02.tar.gz`. Then locally compress all part02 related files with the tar command:  `tar -zcvf part02.tar.gz part02*`. Then transfer this "part02.tar.gz" to the remote HPC server, and uncompress it on the remote server. Then run the part02A code with `sbatch` like this: `sbatch part02A_sbatch_setup01_dada2_sickle_R_v01.sh`. This will start part02B. Which will prepare a lot of slurmsubmission files. Then once part02A has finished running part02B, proceed by running part02C on the remote HPC server with the `sbatch` like this: `sbatch part02C_sbatch_setup02_dada2_sickle_R_v01.sh`. This will make use of part02D and part02E and part02F. All these part02 codes makes use of a list of files in this directory: '00C_raw_decompressed_fastq.gz_files' where the raw fastq files are stored. Because each fastq file represents a demultiplexed library, the idea with this part02 is to iterate over all these fastq files and prepare separate directories for each demultiplexed library and place these inside the directory: "02_demultiplex_filtered". You can navigate in to this directory and then inspect the resulting files that are generated. Ensure they all complete as intended without errors in the stdout and stderr files that ends up being placed in the subdirectories under "02_demultiplex_filtered".<br/>

## part03
part03 arranges the SS and AS tables. Since there are no AS tables, this R code has had the AS parts commented out. Inspect the R code to check out what have been commented out.<br/>
Start out by locally removing any previous versions of tar compressed "part03.tar.gz". This can be removed with the command `rm part03.tar.gz`. Then locally compress all part03 related files with the tar command:  `tar -zcvf part03.tar.gz part03*`. Then transfer this "part03.tar.gz" to the remote HPC server, and uncompress it on the remote server. Then run the part03A code with `sbatch` like this: `sbatch part03B_bash_make_sbatch_and_dada2_end_inR_v01.sh`. This will start part03B. Which will prepare a lot of slurmsubmission files. Starting part03A which starts part03B  will a list of files in this directory: '00C_raw_decompressed_fastq.gz_files' where the raw fastq files are stored. Because each fastq file represents a demultiplexed library, the idea with this part03 is to iterate over all these fastq files as they each represents demultiplexed libraries. Check the resulting "stderr" and "stdout" that are written to subdirectories inside '02_demultiplex_filtered'. <br/>
If they all finish without errors, then proceed to part04<br/>

## part04
part04 is for starting multiple parallel blast searches. Again as in part02 and part03 the idea is to iterate over the fastq files that have been demulitplexed and arranged in to tables.  <br/>
Start out by locally removing any previous versions of tar compressed "part04.tar.gz". This can be removed with the command `rm part04.tar.gz`. Then locally compress all part04 related files with the tar command:  `tar -zcvf part04.tar.gz part04*`. Then transfer this "part04.tar.gz" to the remote HPC server, and uncompress it on the remote server. Then run the part04A code by executing it directly in the remote HPC terminal like this:  `./part04A_bash_make_sbatch_and_blast_v01.sh`. This will start part04B. Which will prepare a lot of slurmsubmission files, that each starts multiple parallel blast searches. One for each fastq demultiplexed sequence set.<br/>
Inspect how the resulting "stderr" and "stdout" performs. Check the contents of these files. Also check if the slurm submission jobs ends up being cancelled. You can check it like this : `sacct | grep bW | grep CANCE` <br/>
The most likely reason for these jobs to end up being cancelled is that they need more RAM memory to be able to perform the blast search. One immediate solution is then to adjust the line '#SBATCH --mem 16G ' in the part04B file. Increase the '--mem 16G' to '--mem 32G' or perhaps to '--mem 124G', and then reinspect the resulting "stderr" and "stdout" and their contents.<br/>




 


