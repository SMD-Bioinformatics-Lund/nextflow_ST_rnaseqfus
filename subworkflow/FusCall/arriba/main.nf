/*
Import modules according to the subworkflow of the RNA pipelines
*/

include { ARRIBA_ALIGN } from '../../../modules/arriba/align/main.nf'
include { ARRIBA_FUSCALL } from '../../../modules/arriba/FusionCall/main.nf'
include { SAMTOOLS_SORT } from '../../../modules/samtools/sort/main.nf'
include { ARRIBA_VISUALIZATION } from '../../../modules/arriba/visualization/main.nf'


workflow arribaWorkflow {
    take:
        starRef
        readsInfo
        fasta
        gtf
        blacklist
        knownFusions
        proteinDomains
        cytobands

    main:
        // def input = readNumber.combine(sampleInfo)
        ARRIBA_ALIGN ( starRef, readsInfo)
        ARRIBA_FUSCALL ( ARRIBA_ALIGN.out[0], fasta, gtf, blacklist,knownFusions, proteinDomains)
        SAMTOOLS_SORT (ARRIBA_ALIGN.out[0] )
        VIS_INPUT = SAMTOOLS_SORT.out.join(ARRIBA_FUSCALL.out[0])
        SAMTOOLS_SORT.out.join(ARRIBA_FUSCALL.out[0]).view()
        ARRIBA_VISUALIZATION (VIS_INPUT,gtf,cytobands, proteinDomains )
        
    emit:
        fusion = ARRIBA_FUSCALL.out[0]
        fusionDiscarded = ARRIBA_FUSCALL.out[1]
        bam = SAMTOOLS_SORT.out
        metrices = ARRIBA_ALIGN.out[1] 
        report = ARRIBA_VISUALIZATION.out
}