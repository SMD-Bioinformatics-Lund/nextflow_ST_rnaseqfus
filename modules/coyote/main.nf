process COYOTE {
    tag "$sampleId"
    label "process_low"

	input:
		tuple val(sampleId), path(agg_vcf)
        tuple val(sampleId2), path(qc_val)
        tuple val(sample), val(clarityId), val(poolId), val (assay), val (diagnosis)
        val(outdir)

	output:
		path("*.coyote"), emit: coyote_output

	script:
		def id = "${sampleId}-fusions"
		def group = 'solidRNA_GMSv5'
		def finaloutdir = "${outdir}/solid_ST_RNA/finalResults/"


        // Actual script
        """
        echo "import_fusion_to_coyote.pl \\
            --fusions ${finaloutdir}${agg_vcf} \\
            --qc ${finaloutdir}${qc_val} \\
            --id ${id} \\
            --group ${assay} \\
            --subpanel  ${diagnosis} \\
            --clarity-sample-id ${clarityId} \\
            --clarity-pool-id ${poolId}" > ${id}.coyote
        """

        // Stub section for simplified testing
        stub:
        """
        echo "import_fusion_to_coyote.pl \\
            --fusions ${outdir}/solid_ST_RNA/finalResults/${agg_vcf} \\
            --id ${sampleId}-fusions \\
             --group ${assay} \\
            --subpanel  ${diagnosis} \\
            --clarity-sample-id ${clarityId} \\
            --clarity-pool-id ${poolId}" > ${sampleId}-fusions.coyote
        """
}
