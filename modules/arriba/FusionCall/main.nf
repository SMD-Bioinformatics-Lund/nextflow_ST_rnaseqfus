process ARRIBA_FUSCALL {
    tag "$sampleId"
    label "process_high"

    input:
        tuple val(sampleId), path (bam)
        path fasta
        path gtf
        path blacklist
        path known_fusions
        path protein_domains
    
    output:
        tuple val(sampleId), path("*.fusions.tsv") 
        tuple val(sampleId), path("*.fusions.discarded.tsv")
        
    script:
    def prefix = "${sampleId}" + "."
    
    """
    arriba \\
        -x $bam \\
        -a $fasta \\
        -g $gtf \\
        -o ${prefix}fusions.tsv \\
        -O ${prefix}fusions.discarded.tsv \\
        -b $blacklist \\
        -k $known_fusions  \\
        -p $protein_domains 
    """
}