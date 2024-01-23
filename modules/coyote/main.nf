process COYOTE {
    tag "$sampleId"
    label "process_low"

	input:
		tuple val(sampleId), path(agg_vcf)
        tuple val(sample), val(clarityId), val(poolId) 
        val (outdir)

	output:
		path ("*.coyote")
	
	script:
		def id = "${sampleId}-fusions"
		def group = 'fusion'
		def finaloutdir = "${outdir}/rnaseq_fusion/finalResults/"
	
	"""
	echo "import_fusion_to_coyote.pl \\
        --fusions ${finaloutdir}${agg_vcf} \\
        --id ${id} \\
        --group ${group} \\
        --clarity-sample-id ${clarityId} \\
         --clarity-pool-id ${poolId}" > ${id}.coyote
	"""
	}