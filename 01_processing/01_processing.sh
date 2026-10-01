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
    out_dir="$(analysis_dir 01_processing)"
 
    local bams=("${RAW_INPUT_PATH}"*.bam)

    for bam in "${bams[@]}"; do
        local bam_name
        bam_name="$(basename "${bam}" .bam)"
        local out="${out_dir}Zeugodacus_cucurbitae_${DATASET}_${bam_name}_IsoSeq"
 
        echo "[processing] ${DATASET} (${bam_name}): primer removal + demultiplexing"
        lima --isoseq --peek-guess \
            "${bam}" \
            "${PRIMER_FASTA}" \
            "${out}.bam"
 
        echo "[processing] ${DATASET} (${bam_name}): trimming polyA / removing concatemers"
        isoseq refine \
            "${out}.NEB_5p--NEB_Clontech_3p.bam" \
            "${PRIMER_FASTA}" \
            "${out}.flnc.bam"
    done

}
 # --peak-guess guesses which primer set was used 

 # this is currently set up to process all bam files within a directory
 # need to merge bam files before next steps 



# Merges every per-BAM .flnc.bam produced by run_processing above into one
# file using pbmerge, which is what 02_classification and 03_genecounts both
# expect as their input. 
# merging just one file is okay 

merge_flnc_bams() {
    local processing_dir
    processing_dir="$(analysis_dir 01_processing)"
    local flnc_bams=("${processing_dir}"Zeugodacus_cucurbitae_"${DATASET}"_*_IsoSeq.flnc.bam)
 
    local merged="$(analysis_output 01_merged_bams).flnc.bam"
 
    echo "[processing] ${DATASET}: merging ${#flnc_bams[@]} flnc BAM(s)"
    pbmerge -o "${merged}" "${flnc_bams[@]}"
}