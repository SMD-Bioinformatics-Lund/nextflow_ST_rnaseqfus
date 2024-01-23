process DEEPTOOLS {
    tag "$sample"
    label "process_low"


    input:
        tuple val(sample), path(bam), path(bai)

    output:
        tuple val(sample), file("${sample}.tsv")

    script:
    """
    bamPEFragmentSize -b ${bam} -hist ${sample}_fragmentSize.png --plotTitle "Fragment Size of ${sample} PE RNAseq data" --maxFragmentLength 0 --samplesLabel ${sample} --table ${sample}.tsv
    """
}