process QCEXTRACT {
    tag "$sample"
    label "process_low"

    input:
        tuple val(sample), path(log), path(starfinal), path(junctionfile)
        tuple val(sampleID), path(genotypes)
        tuple val(smpl_ID), path(geneBodyCoverage)
        tuple val(ID), path(tsv)

    output:
        tuple val(sample), path("${sample}.STAR.rnaseq_QC")

    """
    postaln_qc_rd_rna.r \
        -s ${starfinal} \
        -i ${sample}  \
        -g ${geneBodyCoverage} \
        -l ${tsv} > ${sample}.STAR.rnaseq_QC
    """
}