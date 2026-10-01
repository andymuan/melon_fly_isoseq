
#!/bin/bash
# shared config sourced by run_pipeline.sbatch and every stage script.
# Keep anything that's the same across datasets here so you only edit it once.
 
##### conda env #####
module load miniconda3/25.11.1
source activate /project/pbarc/andy.lee/condaenvs/isoseq
 
##### dataset list #####
DATASETS=(
    "egg_4hr"
    "egg_8hr"
    "egg_16hr"
    "ovary_early"
    "ovary_late"
    "testis_early"
    "testis_late"
)
 
##### analysis folders #####
# Literal folder names under BASE_PATH, one per analysis.
# Add a line here whenever you add a new stage script/folder.
ANALYSIS=(
    "01_processing"
    "01_merged_bams"
    "02_classification"
    "03_genecounts"
)

##### shared paths #####
PRIMER_FASTA="/project/pbarc/andy.lee/files/primer.fasta" #primer path for pre MAS-seq isoseq
REF="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/ref/GCF_028554725.1/GCF_028554725.1_idZeuCucr1.2_genomic.fna"
GTF="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae/ref/Zeugodacus_cucurbitae_egapx/complete.genomic.gtf"

# Root project directory — raw_data/ and every analysis stage folder live here
BASE_PATH="/90daydata/pbarc/andy.lee/Zeugodacus_cucurbitae"
RAW_DATA_PATH="${BASE_PATH}/rawdata"

# Called once per array task (from run_pipeline.sbatch) to set DATASET and
# RAW_INPUT_PATH, and to pre-create every analysis stage directory for this
# dataset so stage scripts never need to worry about the folder existing.
set_dataset_vars() {
    local task_id="$1"
    DATASET="${DATASETS[$task_id]}"
    RAW_INPUT_PATH="${RAW_DATA_PATH}/${DATASET}/"
}

# Returns BASE_PATH/<analysis>/<dataset>/ — call inside an analysis step script
# to get that step's own directory. Directory is guaranteed to already
# exist (created by set_dataset_vars above), but mkdir -p here too is
# harmless, cheap insurance if a step script is ever run on its own.
analysis_dir() {
    local analysis="$1"
    local dir="${BASE_PATH}/${analysis}/${DATASET}/"
    mkdir -p "${dir}"
    echo "${dir}"
}


# Returns the shared output-file basename (no extension) for a given
# analysis step

analysis_output() {
    local analysis="$1"
    echo "$(analysis_dir "${analysis}")Zeugodacus_cucurbitae_${DATASET}_IsoSeq"
}
