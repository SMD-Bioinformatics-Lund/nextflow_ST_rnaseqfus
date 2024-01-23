process FUSIONCATCHER {
    tag "$sampleId"
    label "process_high"

    input:
        path refFusioncatcher
        tuple val(sampleId), path(read1), path(read2)
    
    output:
		tuple val(sampleId), path("${sampleId}.final-list_candidate-fusion-genes.txt") 
    
    script:
    def option =  "${read1},${read2}"
    
    """
    fusioncatcher.py -d ${refFusioncatcher} -i ${option} -p ${task.cpus} -o .

    mv  final-list_candidate-fusion-genes.txt ${sampleId}.final-list_candidate-fusion-genes.txt

    """
}
