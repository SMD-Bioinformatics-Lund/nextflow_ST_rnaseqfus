// Assuming FASTP and SUBSAMPLE have been modified to emit version information

include { FASTP } from '../../modules/fastp/main.nf'
include { SUBSAMPLE } from '../../modules/subsample/main.nf'

workflow subSampleWorkflow {
    take:
        sampleReads
        fileInfo
    
    main:
        ch_versions = Channel.empty()
        FASTP (fileInfo)
        ch_versions = ch_versions.mix(FASTP.out.versions)

        SUBSAMPLE (sampleReads, FASTP.out.fq)
        ch_versions = ch_versions.mix(SUBSAMPLE.out.versions)


    emit:
        subSample = SUBSAMPLE.out.sample
        // Combine version information from FASTP and SUBSAMPLE into one channel
        versions = ch_versions
}
