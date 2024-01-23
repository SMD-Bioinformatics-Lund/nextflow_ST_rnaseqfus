process PROVIDER {
    tag "$sample"
    label "process_low"

    input:
        path (ref_bed)
        path (ref_bedXY)
        tuple val(sample), path(bam), path(bai)
    
    output:
        tuple val(sample), path ("${sample}.genotypes")
        
    script:
    """
	provider.pl  --out ${sample} \\
        --bed ${ref_bed} \\
        --bam ${bam} \\
        --bedxy ${ref_bedXY}
    """
}