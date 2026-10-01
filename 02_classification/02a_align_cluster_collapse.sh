#!/bin/bash
# classification/02_classification.sh — cluster FLNC reads (isoseq cluster2),
# align clustered reads to the genome (pbmm2), and collapse into unique
# isoforms (isoseq collapse). Expects DATASET to already be set (done by
# config.sh's set_dataset_vars). Can be run on its own — looks up the
# processing step's output file by its known naming convention, as long as
# isoseq_processing has been run at some point and left its output file in
# place.
 
run_classification() {
    local in="$(analysis_output 01_processing).flnc.bam"
    local out="$(analysis_output 02_classification)"
 
    #####################################################
    # Cluster FLNC reads and generate transcripts
    # Useful for isoform discovery — steps below not used for counts
    #####################################################
    echo "[classification] ${DATASET}: clustering FLNC reads"
    isoseq cluster2 "${in}" "${out}.clustered.bam"
 
    ####################################################
    # Alignment of clustered reads using pbmm2
    ####################################################
    echo "[classification] ${DATASET}: aligning clustered reads"
    pbmm2 align --preset ISOSEQ --sort \
        "${out}.clustered.bam" \
        "${REF}" \
        "${out}.clustered.aligned.bam"
 
    ################################################################################
    # Collapse mapped reads into unique isoforms using isoseq collapse
    # collapse by default will collapse isoforms containing 5p degradation as of
    # version 3.8.0. --do-not-collapse-extra-5exons option used to turn this off
    # and is recommended for bulk Iso-Seq.
    ################################################################################
    echo "[classification] ${DATASET}: collapsing into unique isoforms"
    isoseq collapse --do-not-collapse-extra-5exons \
        "${out}.clustered.aligned.bam" \
        "${in}" \
        "${out}.collapsed.gff"
}