process ARRIBA_VISUALIZATION {
    tag "$sampleId"
    label "process_medium"

    input:
        tuple val (sampleId), path(bam), path(bai),path (fusion)
        path gtf
        path cytobands
        path proteinDomains
        
    output:
        tuple val(sampleId), path ("*.pdf")
        
    script:
    def prefix = "${sampleId}"
    """    
        draw_fusions.R \\
        --fusions=$fusion \\
        --alignments=$bam \\
        --output=${prefix}.pdf \\
        --annotation=${gtf} \\
        --cytobands=${cytobands} \\
        --proteinDomains=${proteinDomains}
    """
}