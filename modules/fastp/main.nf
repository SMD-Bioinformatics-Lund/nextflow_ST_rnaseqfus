// modules/fastp/main.nf

process FASTP_UMI {
    tag "$sampleId"
    label "process_medium"

    input:
        tuple val(sampleId), path(r1), path(r2)

    output:
        tuple val(sampleId), path("*.trimmed.R1.fq.gz"), path("*.trimmed.R2.fq.gz"), emit: fq
        tuple val(sampleId), path("*.fastp.json"), path("*.fastp.html"), emit: report
        path "versions.yml", emit: versions

    when:
        params.umi

    script:
    """
    fastp -i ${r1} -I ${r2} --stdout -U --umi_loc=per_read --umi_len=3 -w ${task.cpus} | \\
    fastp --stdin --interleaved_in -f 2 -F 2 \\
        -o ${sampleId}.trimmed.R1.fq.gz -O ${sampleId}.trimmed.R2.fq.gz \\
        -j ${sampleId}.fastp.json -h ${sampleId}.fastp.html -w ${task.cpus} --detect_adapter_for_pe -l 30

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastp: \$(fastp --version | sed 's/fastp //')
    END_VERSIONS
    """
}

process FASTP_NO_UMI {
    tag "$sampleId"
    label "process_medium"

    input:
        tuple val(sampleId), path(r1), path(r2)

    output:
        tuple val(sampleId), path("*.trimmed.R1.fq.gz"), path("*.trimmed.R2.fq.gz"), emit: fq
        tuple val(sampleId), path("*.fastp.json"), path("*.fastp.html"), emit: report
        path "versions.yml", emit: versions

    when:
        !params.umi

    script:
    """
    fastp -i ${r1} -I ${r2} \\
        -o ${sampleId}.trimmed.R1.fq.gz -O ${sampleId}.trimmed.R2.fq.gz \\
        -j ${sampleId}.fastp.json -h ${sampleId}.fastp.html -w ${task.cpus} --detect_adapter_for_pe

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastp: \$(fastp --version | sed 's/fastp //')
    END_VERSIONS
    """
}

workflow FASTP {
    take:
        fileInfo

    main:
        if (params.umi) {
            FASTP_UMI(fileInfo)
            fq_out       = FASTP_UMI.out.fq
            report_out   = FASTP_UMI.out.report
            version_out  = FASTP_UMI.out.versions
        } else {
            FASTP_NO_UMI(fileInfo)
            fq_out       = FASTP_NO_UMI.out.fq
            report_out   = FASTP_NO_UMI.out.report
            version_out  = FASTP_NO_UMI.out.versions
        }

    emit:
        fq       = fq_out
        report   = report_out
        versions = version_out
}