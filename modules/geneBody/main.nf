process GENEBODY {
    tag "$sample"
    label "process_low"

    input:
        tuple val(sample), path(bam), path(bai)
        path (ref_rseqc_bed)
        path (hg_sizes)
    
    output:
        tuple val(sample), file("${sample}.geneBodyCoverage.txt")
        
    script:

    """
        bam2wig.py -s ${hg_sizes} -i ${bam} -o ${sample} -u
        geneBody_coverage2.py -i ${sample}.bw -r ${ref_rseqc_bed} -o ${sample}
    """
}