#!/bin/bash


#SBATCH -p atlas 
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 20 processor core(s) per node X 2 threads per core
#SBATCH --mem=64G
#SBATCH --partition=atlas    # standard node(s)
#SBATCH --job-name="isoseq_alighment"
#SBATCH --mail-user=andy.lee2@usda.gov   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.out" # job standard output file (%j replaced by job id)
#SBATCH --error="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.err" # job standard error file (%j replaced by job id)
#SBATCH --account=ag100pest


########################
##### load modules #####
########################
module load miniconda3/25.11.1
source activate /project/pbarc/andy.lee/condaenvs/isoseq

##################################
# input and output paths 
##################################
# Demultiplexed and refined reads (not clustered or classified) 
INPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/egg_8hr/Zeugodacus_cucurbitae_egg_8hr_IsoSeq.flnc.bam"
INPUT_NAME=$(basename "$INPUT_PATH" .bam) # get file name without path and .bam extension 

# Primer FASTA used for IsoSeq 
REF="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/GCF_028554725.1/GCF_028554725.1_idZeuCucr1.2_genomic.fna" 

# Output dir, name, and path 
OUTPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/egg_8hr/"

#############
# Alignment # 
#############
pbmm2 align --preset ISOSEQ --sort ${INPUT_PATH} ${REF} ${OUTPUT_PATH}${INPUT_NAME}.aligned.bam