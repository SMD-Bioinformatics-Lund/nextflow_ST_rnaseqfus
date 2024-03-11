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
        ch_versions = Channel.empty()

        GENEBODY ( bam, bed, hgSize)
        ch_versions = ch_versions.mix(GENEBODY.out.versions) 

        PROVIDER  ( ref_bed, ref_bedXY, bam )
        ch_versions = ch_versions.mix(PROVIDER.out.versions) 

        DEEPTOOLS ( bam )
        ch_versions = ch_versions.mix(DEEPTOOLS.out.versions) 

        QCEXTRACT ( starmetrices,
                    PROVIDER.out.genotypes,
                    GENEBODY.out.gene_body_coverage, 
                    DEEPTOOLS.out.fragment_size)
        ch_versions = ch_versions.mix(QCEXTRACT.out.versions) 

    emit:
        QC = QCEXTRACT.out.rnaseq_qc
        versions = ch_versions
}