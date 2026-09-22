#!/bin/bash

#SBATCH -p atlas 
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 20 processor core(s) per node X 2 threads per core
#SBATCH --mem=64G
#SBATCH --partition=atlas    # standard node(s)
#SBATCH --job-name="featureCounts"
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
# conda install bioconda::subread

##### load modules #####
module load miniconda3/25.11.1
source activate /project/pbarc/andy.lee/condaenvs/isoseq

##################################
# input and output paths  
##################################

INPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/egg_8hr/Zeugodacus_cucurbitae_egg_8hr_IsoSeq.flnc.aligned.bam"
INPUT_NAME=$(basename "$INPUT_PATH" .flnc.aligned.bam) # get file name without path and .bam extension 
GTF="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/GCF_028554725.1/genomic.gtf"

OUTPUT_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/isoseq_processing/egg_8hr/"

#####################################################
# convert genome gff into gtf for featureCounts     #
# gffread made a gtf that featureCounts didn't like #
# using agat instead                                #
#####################################################
# conda install bioconda::agat
# 
#    --gtf_version 2.2 \
#    -o /90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/GCF_028554725.1/genomic.gtf

###########################################
# count using featureCounts               #  
# -L count long reads                     #
# --primary count only primary alignments #
###########################################

#using haley's gtf for now, but she doesn't know how she got it

featureCounts \
    -T 16 \
    -a /90daydata/pbarc/haley.arnold/InsecticideResistance/new_isoseq_data/complete.genomic.gtf \
    -o ${OUTPUT_PATH}${INPUT_NAME}.counts.txt \
    -g gene_id \
    -t exon \
    -L \
    --primary \
    ${INPUT_PATH}