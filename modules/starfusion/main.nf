process STARFUSION_FUSCALL {
    tag "$sampleId"
    label "process_high"

    input:
        path (star_fusion_ref)
        tuple val(sampleId), path (read1), path(read2)  
    
    output:
        tuple val(sampleId), path("*.star-fusion.fusion_predictions.tsv")
        
    script:
    def option = "--left_fq ${read1} --right_fq ${read2}"

    """
    STAR-Fusion \\
		--genome_lib_dir ${star_fusion_ref} \\
		${option} \\
        --min_FFPM 0.00 \\
		--CPU ${task.cpus} \\
		--output_dir . \\
		--FusionInspector validate \\
		--verbose_level 2  
		
	mv  star-fusion.fusion_predictions.tsv ${sampleId}.star-fusion.fusion_predictions.tsv 
    """
}