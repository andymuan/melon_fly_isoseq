#!/bin/bash

#SBATCH -p atlas 
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=16   # 20 processor core(s) per node X 2 threads per core
#SBATCH --mem=64G
#SBATCH --partition=atlas    # standard node(s)
#SBATCH --job-name="cluster_align_collapse"
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
# Demultiplexed and refined reads 
INPUT="./isoseq_processing/egg_4hr/Zeugodacus_cucurbitae_egg_4hr_IsoSeq.flnc.bam"
INPUT_NAME=$(basename "$INPUT" .bam) # get file name without path and .bam extension 

# genome fasta 
REF="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/GCF_028554725.1/GCF_028554725.1_idZeuCucr1.2_genomic.fna" 

# Output dir, name, and path 
PROJECT_DIR="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/" 
OUTDIR="./classification/egg_4hr/"

mkdir -p "${PROJECT_DIR}" # make output directory if it doesn't exist 
cd ${PROJECT_DIR}

#####################################################
# Cluster FLNC reads and generate transcripts 
# Useful for isoform discovery 
# below steps not used for counts  
#####################################################
isoseq cluster2 ${INPUT} ${OUTDIR}${INPUT_NAME}.clustered.bam

####################################################
# Alignment of clusetered reads using pbmm2        
####################################################
pbmm2 align --preset ISOSEQ --sort ${OUTDIR}${INPUT_NAME}.clustered.bam \
  ${REF} \
  ${OUTDIR}${INPUT_NAME}.clustered.aligned.bam

################################################################################
# Collapse mapped reads into unique isoforms using isoseq collapse
# collapse by default will collapse isoforms containing 5p degradation as of version 3.8.0. 
# --do-not-collapse-extra-5exons option used to turn this off and is recommended for bulk Iso-Seq.
################################################################################
isoseq collapse --do-not-collapse-extra-5exons \
    ${OUTDIR}${INPUT_NAME}.clustered.aligned.bam \
    ${INPUT} \
    ${OUTDIR}${INPUT_NAME}.collapsed.gff