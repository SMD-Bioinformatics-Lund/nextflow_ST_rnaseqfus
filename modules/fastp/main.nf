process FASTP {
    tag "$sampleId"
    label "process_medium"

    input:
        tuple val(sampleId), path(r1), path(r2) 

    output:
        tuple val(sampleId), path("*.trimmed.R1.fq.gz"), path("*.trimmed.R2.fq.gz"), emit: fq
        tuple val(sampleId), path("*.fastp.json"), path("*.fastp.html"), emit: report
        path "versions.yml", emit: versions

    script:
    // Stub section for simplified testing

    """
    fastp -i $r1 -I $r2 -o ${sampleId}.trimmed.R1.fq.gz -O ${sampleId}.trimmed.R2.fq.gz -j ${sampleId}.fastp.json -h ${sampleId}.fastp.html -w ${task.cpus} --detect_adapter_for_pe

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastp: \$(fastp --version 2>&1 | sed -e "s/fastp //g")
    END_VERSIONS
    """
    
    stub:
    """
    touch ${sampleId}.trimmed.R1.fq.gz
    touch ${sampleId}.trimmed.R2.fq.gz
    echo '{ "version": "test" }' > ${sampleId}.fastp.json
    echo '<html><body>Test Version</body></html>' > ${sampleId}.fastp.html
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastp: \$(fastp --version 2>&1 | sed -e "s/fastp //g")
    END_VERSIONS

    """
}
