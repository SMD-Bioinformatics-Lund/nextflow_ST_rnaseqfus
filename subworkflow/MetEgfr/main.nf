/*
Import modules according to the subworkflow of the RNA pipelines
*/

include { MET_EGFR } from '../../modules/exon_skipping/main.nf'

workflow metEgfrWorkflow {
    take:
        bedFile
        starMetrices

    main:
        MET_EGFR ( bedFile, starMetrices )

    emit:
        fusion = MET_EGFR.out
}
