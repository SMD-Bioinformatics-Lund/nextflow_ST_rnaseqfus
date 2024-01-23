process STAR_ALIGNMENT {
    tag "$sampleId"
    label "process_high"

    input:
        path (index)
        path (gtf)
        tuple val(sampleId), path(read1), path(read2)
    
    output:
        tuple val(sampleId), path ("${sampleId}.Aligned.sortedByCoord.out.bam")
        tuple val (sampleId), path ("${sampleId}.Log.final.out")

    script:
    """
    STAR --genomeDir ${index} \\
        --readFilesIn ${read1} ${read2} \\
        --outSAMtype BAM SortedByCoordinate \\
        --runThreadN $task.cpus \\
        --readFilesCommand zcat \\
        --limitBAMsortRAM 10000000000 
    
    mv Aligned.sortedByCoord.out.bam  ${sampleId}.Aligned.sortedByCoord.out.bam
    mv Log.final.out ${sampleId}.Log.final.out
    """
}

