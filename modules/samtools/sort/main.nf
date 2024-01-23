process SAMTOOLS_SORT {

    tag "$sampleId"
    label 'process_medium'

input:
    tuple val(sampleId), path(bam)

output: 
    tuple val(sampleId), path("*.sorted.bam"), path("*.sorted.bam.bai")

script:
def prefix = "${sampleId}" + ".sorted"
println (prefix)

"""
samtools sort -@ ${task.cpus-1} -o ${prefix}.bam -T $sampleId $bam

samtools index -@ ${task.cpus-1} ${prefix}.bam 
"""

}