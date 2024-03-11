#!/usr/bin/env nextflow

/*
* nextflow_ST_pipeline - A nextflow  GMS solid tumor fusion pipeline
*/

/*
* General Paramters 
*/

nextflow.enable.dsl = 2

log.info """\
======================================================================
Solid tumor panel RNA fusion analysis pipeline
======================================================================
outdir                  :       $params.outdir
subdir                  :       $params.subdir
crondir                 :       $params.crondir
csv                     :       $params.csv
=====================================================================
"""

/*
Include the subworkflows
*/




include { subSampleWorkflow } from './subworkflows/SubSample/main.nf'
include { arribaWorkflow } from './subworkflows/FusCall/arriba/main.nf'
include { starFusionWorkflow } from './subworkflows/FusCall/starFusion/main.nf'
include { metEgfrWorkflow } from './subworkflows/MetEgfr/main.nf'
include { ighDux4Workflow } from './subworkflows/IghDUx4/main.nf'
include { fusionCatcherWorkflow } from './subworkflows/FusCall/fusionCatcher/main.nf'
include { aggFusionWorkflow } from './subworkflows/FusCall/aggregate/main.nf'
include { coyoteWorkflow } from './subworkflows/Coyote/main.nf'
include { qcWorkflow } from './subworkflows/AlignQC/main.nf'
include { cdmWorkflow } from './subworkflows/CMD/main.nf'
include { CUSTOM_DUMPSOFTWAREVERSIONS   } from './modules/custom/dumpsoftwareversions//main.nf'  

/*
Create data flow channels
*/
Channel
    .fromPath(params.csv)
    .splitCsv(header:true)
    .map{ row-> tuple(row.id, file(row.read1), file(row.read2)) }
    .set { sampleInfo }

Channel
	.fromPath(params.csv)
	.splitCsv(header:true)
	.map{row -> tuple(row.id,row.clarity_sample_id, row.clarity_pool_id)}
    .set { metaCoyote }

Channel
    .fromPath(params.csv)
    .splitCsv(header:true)
    .map{ row-> tuple( row.id, row.read1, row.read2, row.clarity_sample_id, row.clarity_pool_id ) }
    .set { ch_cdm }

ch_outdir = Channel.fromPath(params.outdir)
ch_outdir.view()
//println(sampleInfo)

sampleReads = params.subsampling_number
fastaHuman = params.fasta
fastaIndexFile = params.fastaIndex

gtfGencode = params.gtf
refStar = params.refbase
refStarfusion = params.refbase2
refFusioncatcher = params.fusioncatcher

knownfusionsArriba = params.knownfusions
blaclistArriba = params.blacklists
proteinDomainArriba = params.proteinDomains
cytobandArriba = params.cytobands

cronDir = params.crondir
bedRefRseqc = params.ref_rseqc_bed
hg38 = params.hg38_sizes
refBed = params.ref_bed
refBedXY =  params.ref_bedXY

metEgfrBed = params.metEgfr

/*
 Call all the workflow */

 workflow {
    subSampleWorkflow ( sampleReads,
                        sampleInfo  )

    // prealignmentQC
    
    fusionCatcherWorkflow ( refFusioncatcher,
                           subSampleWorkflow.out.subSample )    

    arribaWorkflow( refStar,
                    subSampleWorkflow.out.subSample, 
                    fastaHuman, 
                    gtfGencode, 
                    blaclistArriba,  
                    knownfusionsArriba, 
                    proteinDomainArriba, 
                    cytobandArriba )
    
    starFusionWorkflow ( params.pairEnd,
                        refStarfusion,
                      subSampleWorkflow.out.subSample )

    metEgfrWorkflow ( metEgfrBed, arribaWorkflow.out.metrices )
    
    aggFusionWorkflow ( fusionCatcherWorkflow.out.fusion,   
                        arribaWorkflow.out.fusion,
                        starFusionWorkflow.out.fusion,
                        metEgfrWorkflow.out.fusion)

    qcWorkflow ( arribaWorkflow.out.bam, 
                 bedRefRseqc,
                 hg38,
                 refBed,
                 refBedXY,
                 arribaWorkflow.out.metrices )
    
    ch_cdm_input = ch_cdm.join(qcWorkflow.out.QC)
    cdmWorkflow (ch_cdm_input, ch_outdir)

    coyoteWorkflow (    aggFusionWorkflow.out.aggregate,
                        metaCoyote,
                        ch_outdir )
    

    // filterFusionWorkflow()
    
    // importCoyoteWorkflow()

    // importCDMWorkflow

    // expressionWorkflow

}

