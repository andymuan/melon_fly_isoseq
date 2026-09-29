#!/bin/bash


#SBATCH --time=120:00:00   # walltime limit (HH:MM:SS)
#SBATCH -N1
#SBATCH -n8
#SBATCH --partition=mem    # standard node(s)
#SBATCH --mem=800G
#SBATCH --job-name="egapx"
#SBATCH --mail-user=andy.lee2@usda.gov   # email address
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output="egapx-%j.out" # job standard output file (%j replaced by job id) combined with error file since egapx splits result to both
#SBATCH --account=pbarc

# LOAD MODULES, INSERT CODE, AND RUN YOUR PROGRAMS HERE

# module load miniconda
module load egapx/0.5.2 

# source activate /project/pbarc/sheina.sim/condaenvs/egapx

export APPTAINER_CACHEDIR=$TMPDIR
export APPTAINER_TMPDIR=$TMPDIR

egapx_outdir="Zeugodacus_cucurbitae_egapx"
yaml="egapx.yaml"

date
# egapx.py ${yaml} -o ${egapx_outdir} -e slurm 
bash Zeugodacus_cucurbitae_egapx/nextflow/resume.sh # resume timed out run 
date

cp `cat ${egapx_outdir}/nextflow/run.trace.txt | grep "egapx:annot_proc_plane:generate_fasta_from_annots:gnomon_asn2fasta" | awk -v OFS='\t' '{print $22"/output/*"}'` ${egapx_outdir}/.
mv $egapx_outdir/EGAPx_Test_Assembly_EGAPx_Test_Assembly.prot.fa $egapx_outdir/one_isoform_per_gene.protein.fasta
