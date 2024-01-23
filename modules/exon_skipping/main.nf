process MET_EGFR {
    tag "$sample"
    label "process_low"

    input:
      path bedFile
      tuple val(sample), path(log), path(starfinal), path(junctionfile)
    
    output:
		  tuple val(sample), path("${sample}_MET_EGFR.txt")  
    
    script:
    
      """
      exon_skipping.py --bed_file ${bedFile} --junction_file ${junctionfile} --result_file ${sample}_MET_EGFR.txt
      """
}
