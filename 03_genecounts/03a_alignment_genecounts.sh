#!/bin/bash
# genecounts/03a_isoseq_alignment_genecount.sh — align FLNC reads (not
# clustered or classified) to the genome, for quantifying gene counts.
# Expects DATASET to already be set (done by config.sh's set_dataset_vars).
# Can be run on its own — looks up 01_processing's merged flnc.bam
# (in 01_merged_bams, produced by merge_flnc_bams() in 01_processing.sh)
# by its known naming convention, as long as that file exists.

run_alignment_for_genecount() {
    local in="$(analysis_output 01_merged_bams).flnc.bam"
    local out="$(analysis_output 03_genecounts)"
 
    echo "[genecounts] ${DATASET}: aligning FLNC reads"
    pbmm2 align --preset ISOSEQ --sort \
        "${in}" \
        "${REF}" \
        "${out}.aligned.bam"
}
