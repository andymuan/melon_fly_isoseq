#!/bin/bash


#SBATCH -p atlas 
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 20 processor core(s) per node X 2 threads per core
#SBATCH --mem=64G
#SBATCH --partition=atlas    # standard node(s)
#SBATCH --job-name="isoseq_processing"
#SBATCH --mail-user=andy.lee2@usda.gov   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.out" # job standard output file (%j replaced by job id)
#SBATCH --error="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.err" # job standard error file (%j replaced by job id)
#SBATCH --account=ag100pest

################################################################
# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE
################################################################
###### install software (do this only once) 
# conda create --prefix /project/pbarc/andy.lee/condaenvs/isoseq 
# conda install lima 
# conda install bioconda::isoseq
# conda install bioconda::pbmm2

##### load modules #####
module load miniconda3/25.11.1
source activate /project/pbarc/andy.lee/condaenvs/isoseq

##################################
# input and output paths 
##################################

# Aligned and sorted bam files 
# Note: pbmm2 has --sort, so no need to use samtools to sort 

INPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/egg_8hr/"
INPUT_NAME=$(basename "$INPUT_PATH" .bam) # get file name without path and .bam extension 

# Primer FASTA used for IsoSeq 
PRIMER_FASTA="/project/pbarc/andy.lee/files/primer.fasta" 

# Output dir, name, and path 
OUTPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/"
OUTPUT="Zeugodacus_cucurbitae_egg_8hr_IsoSeq" 

mkdir -p "${OUTPUT_PATH}" # make output directory if it doesn't exist 

#######################################
# Primer removal and demultiplexing   #
#######################################

# --peak-guess guesses which primer set was used 
# lima --isoseq --peek-guess ${INPUT_PATH} ${PRIMER_FASTA} ${OUTPUT_PATH}${OUTPUT}.bam

##################################################
# Trimming poly A tails and remove concatemers   #
##################################################
# isoseq refine ${OUTPUT_PATH}${OUTPUT}.NEB_5p--NEB_Clontech_3p.bam ${PRIMER_FASTA}  ${OUTPUT_PATH}${OUTPUT}.flnc.bam


