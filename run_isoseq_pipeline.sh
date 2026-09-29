#!/bin/bash

#SBATCH -p atlas
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --mem=64G
#SBATCH --partition=atlas
#SBATCH --job-name="isoseq_pipeline"
#SBATCH --mail-user=andy.lee2@usda.gov
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --output="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%A_%a-%x.out"
#SBATCH --error="/project/pbarc/andy.lee/Zeugodacus_cucurbitae/scripts/slurm_out/std-%A_%a-%x.err"
#SBATCH --account=ag100pest
#SBATCH --array=0-6                     # one index per dataset — keep in sync with DATASETS in common.sh

################################################################
# This script is just a router: it loads shared config/env,
# figures out which dataset this array task handles (and
# pre-creates that dataset's analysis directories), then calls
# each pipeline stage in order. Add a new stage by:
#   1. adding its folder name to ANALYSIS in common.sh
#   2. writing <folder>/0N_name.sh with a run_<name> function
#   3. sourcing it and calling it below
################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${SCRIPT_DIR}/confit.sh"
source "${SCRIPT_DIR}/isoseq_processing/01_processing.sh"
source "${SCRIPT_DIR}/classification/02_classification.sh"
source "${SCRIPT_DIR}/genecounts/03_genecounts.sh"

set_dataset_vars "${SLURM_ARRAY_TASK_ID}"
echo "[Array task ${SLURM_ARRAY_TASK_ID}] Running pipeline for dataset: ${DATASET}"

##### run stages in order — comment out any you don't want this run #####
run_processing
run_classification
run_genecounts
