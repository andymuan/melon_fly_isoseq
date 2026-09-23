#!/bin/bash

#SBATCH -p atlas 
#SBATCH --time=48:00:00   # walltime limit (HH:MM:SS)
#SBATCH --nodes=1   # number of nodes
#SBATCH --ntasks-per-node=4   # 20 processor core(s) per node X 2 threads per core
#SBATCH --mem=8G
#SBATCH --partition=atlas    # standard node(s)
#SBATCH --job-name="gff2gtf"
#SBATCH --mail-user=andy.lee2@usda.gov   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.out" # job standard output file (%j replaced by job id)
#SBATCH --error="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%j-%x.err" # job standard error file (%j replaced by job id)
#SBATCH --account=ag100pest

#####################################################
# convert genome gff into gtf for downstream analysis
# including pigeon and featureCounts     
#####################################################

##### load modules #####
module load miniconda3/25.11.1
source activate /project/pbarc/andy.lee/condaenvs/isoseq

# conda install bioconda::gffread

# Directory of the reference genome 
REFDIR="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/GCF_028554725.1/"
cd ${REFDIR}

# clean up GFF first, there are a few genes missing "gene_id"
# [andy.lee2@atlas-0002 GCF_028554725.1]$ grep -v 'gene_id' genomic.gtf | head
# NC_071667.1     Gnomon  exon    1767413 1767741 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    1767806 1768032 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    1768144 1768449 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    1768501 1768666 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    1768841 1769116 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    1769178 1769291 .       -       .       transcript_id "gene-LOC114805233"; gene_name "LOC114805233";
# NC_071667.1     Gnomon  exon    4322165 4322376 .       +       .       transcript_id "gene-LOC105208447"; gene_name "LOC105208447";
# NC_071667.1     Gnomon  exon    4322620 4322806 .       +       .       transcript_id "gene-LOC105208447"; gene_name "LOC105208447";
# NC_071667.1     Gnomon  exon    4323079 4323337 .       +       .       transcript_id "gene-LOC105208447"; gene_name "LOC105208447";
# NC_071667.1     Gnomon  exon    4323399 4323767 .       +       .       transcript_id "gene-LOC105208447"; gene_name "LOC105208447";

# use GFF to convert to GTF 
gffread genomic.gff -T -o genomic.gtf

# haley's gtf: /90daydata/pbarc/haley.arnold/InsecticideResistance/new_isoseq_data/complete.genomic.gtf