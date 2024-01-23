/*
Import modules according to the subworkflow of the RNA pipelines
*/

include { GENEBODY } from '../../modules/geneBody/main.nf'
include { PROVIDER } from '../../modules/provider/main.nf'
include { DEEPTOOLS } from '../../modules/deeptools/main.nf'
include { QCEXTRACT } from  '../../modules/postalnqc/main.nf'

workflow qcWorkflow {
    take:
        bam
        bed
        hgSize
        ref_bed
        ref_bedXY
        starmetrices

    main:
        // def input = readNumber.combine(sampleInfo)
        GENEBODY ( bam, bed, hgSize)
        PROVIDER  ( ref_bed, ref_bedXY, bam )
        DEEPTOOLS ( bam )
        QCEXTRACT (starmetrices,PROVIDER.out, GENEBODY.out, DEEPTOOLS.out)

    emit:
        QC = QCEXTRACT.out
}