#!/bin/bash
# 01_processing.sh — primer removal/demux (lima) + polyA trim / concatemer removal (isoseq refine)
# Expects DATASET, INPUT_PATH, OUTPUT_PATH, OUTPUT, PRIMER_FASTA to already be set
# (done by common.sh's set_dataset_vars, called from run_pipeline.sbatch).
 
#!/bin/bash
# isoseq_processing/01_processing.sh — primer removal/demux (lima) + polyA trim /
# concatemer removal (isoseq refine). Expects DATASET and RAW_INPUT_PATH to already
# be set (done by common.sh's set_dataset_vars, called from run_pipeline.sbatch).

run_processing() {
    local out_dir
    out_dir="$(analysis_dir isoseq_processing)"
    local out="${out_dir}Zeugodacus_cucurbitae_${DATASET}_IsoSeq"

    echo "[processing] ${DATASET}: primer removal + demultiplexing"
    lima --isoseq --peak-guess \
        "${RAW_INPUT_PATH}" \
        "${PRIMER_FASTA}" \
        "${out}.bam"

    echo "[processing] ${DATASET}: trimming polyA / removing concatemers"
    isoseq refine \
        "${out}.NEB_5p--NEB_Clontech_3p.bam" \
        "${PRIMER_FASTA}" \
        "${out}.flnc.bam"

    # export so the next step knows where to find this step's output
    PROCESSING_OUTPUT="${out}.flnc.bam"
}
 # --peak-guess guesses which primer set was used 