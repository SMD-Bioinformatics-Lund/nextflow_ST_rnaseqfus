/*
Import modules according to the subworkflow of the RNA pipelines
*/

include { FUSIONCATCHER } from '../../../modules/fusionCatcher/main.nf'

workflow fusionCatcherWorkflow {
    take:
        referenceFusionCatcher
        fileInfo
        
    main:
        // def input = readNumber.combine(sampleInfo)
        FUSIONCATCHER (referenceFusionCatcher, fileInfo)

    emit:
        fusion = FUSIONCATCHER.out
}