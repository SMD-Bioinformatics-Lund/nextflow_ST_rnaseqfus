process  FASTP{
	tag "$sampleId"
    label "process_medium"

    input:
        tuple val(sampleId), path(r1), path(r2) 

    output:
        tuple val(sampleId), path("*.trimmed.R1.fq.gz"), path("*.trimmed.R2.fq.gz"), emit: fq
        tuple val(sampleId), path("*.fastp.json"), path("*.fastp.html"), emit: report
    
    script:
    """
    fastp -i $r1 -I $r2 -o  ${sampleId}.trimmed.R1.fq.gz -O ${sampleId}.trimmed.R2.fq.gz -j fastp.json -h fastp.html -w ${task.cpus} --detect_adapter_for_pe
    mv  fastp.json ${sampleId}.fastp.json
    mv  fastp.html  ${sampleId}.fastp.html 
    """
}