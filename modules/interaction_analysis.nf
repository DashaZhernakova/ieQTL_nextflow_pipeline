#! /usr/bin/env nextflow
nextflow.enable.dsl = 2

/*
 * run QTL mapping per SNP-Gene pair
 */
process IeQTLmappingPerSNPGene {
    tag "Chunk: $chunk"

    input:
    tuple path(tmm_expression), path(bed), path(bim), path(fam), path(covariates), path(limix_annotation), path(gte), path(qtls_to_test), val(covariate_to_test), val(chunk)
    

    output:
    //path "limix_out/*"

    shell:
    '''
     geno=!{bed}
     plink_base=${geno%.bed}
     outdir=${PWD}/limix_out/
     mkdir $outdir
     ls $PWD

     python /limix_qtl/Limix_QTL/run_interaction_QTL_analysis.py \
     --plink ${plink_base} \
      -af !{limix_annotation} \
      -cf !{covariates} \
      -pf !{tmm_expression} \
      -smf !{gte} \
      -fvf !{qtls_to_test} \
      -od ${outdir} \
      --interaction_term !{covariate_to_test} \
      -gr !{chunk} \
      -np 0 \
      -maf 0.05 \
      -c -gm gaussnorm \
      -w 1000000 \
      -hwe 0.0001
      
      echo !{params.outdir}
      if [ ! -d !{params.outdir}/limix_output/ ]
      then
      	mkdir !{params.outdir}/limix_output/
      fi
      if [ ! -z "$(ls -A ${outdir}/)" ]
      then
      	cp ${outdir}/* !{params.outdir}/limix_output/
      else
	echo "No limix output to copy"      
      fi
      ls -la ${outdir}/  
      
    '''
}

/*
 * run QTL mapping for all SNPs arounnd the specified Gene for a given chunk
 */
process IeQTLmappingPerGene {
    tag "Chunk: $chunk"
    echo true

    input:
    tuple path(tmm_expression), path(bed), path(bim), path(fam), path(covariates), path(limix_annotation), path(gte), path(genes_to_test), val(covariate_to_test), val(chunk)


    output:
    //path "limix_out/*"

    shell:
    '''
     geno=!{bed}
     plink_base=${geno%.bed}
     outdir=${PWD}/limix_out/
     mkdir $outdir

     python /limix_qtl/Limix_QTL/run_interaction_QTL_analysis.py \
     --plink ${plink_base} \
      -af !{limix_annotation} \
      -cf !{covariates} \
      -pf !{tmm_expression} \
      -ff !{genes_to_test} \
      -od ${outdir} \
      --interaction_term !{covariate_to_test} \
      -np 0 \
      -maf 0.05 \
      -c -gm gaussnorm \
      -w 1000000 \
      -hwe 0.0001 \
      -gr !{chunk}
      
      echo !{params.outdir}
      if [ ! -d !{params.outdir}/limix_output/ ]
      then
        mkdir !{params.outdir}/limix_output/
      fi
      if [ ! -z "$(ls -A ${outdir}/)" ]
      then
        cp ${outdir}/* !{params.outdir}/limix_output/
      else
        echo "No limix output to copy"
      fi
      ls -la ${outdir}/

    '''
}

process IeQTLmappingPerGeneNoChunks {
    echo true
    input:
    tuple path(tmm_expression), path(bed), path(bim), path(fam), path(covariates), path(limix_annotation), path(gte), path(genes_to_test), val(covariate_to_test)
    

    output:
    //path "limix_out/*"
     
    shell:
    '''
     geno=!{bed}
     plink_base=${geno%.bed}
     outdir=${PWD}/limix_out/
     mkdir $outdir
     
     python /limix_qtl/Limix_QTL/run_interaction_QTL_analysis.py \
     --plink ${plink_base} \
      -af !{limix_annotation} \
      -cf !{covariates} \
      -pf !{tmm_expression} \
      -ff !{genes_to_test} \
      -od ${outdir} \
      --interaction_term !{covariate_to_test} \
      -np 0 \
      -maf 0.05 \
      -c -gm gaussnorm \
      -w 1000000 \
      -hwe 0.0001 \
      -gr 2:1-400000000
      
      echo !{params.outdir}
      if [ ! -d !{params.outdir}/limix_output/ ]
      then
        mkdir !{params.outdir}/limix_output/
      fi
      if [ ! -z "$(ls -A ${outdir}/)" ]
      then
        cp ${outdir}/* !{params.outdir}/limix_output/
      else
        echo "No limix output to copy"
      fi
      ls -la ${outdir}/

    '''
}


/*
 * run QTL mapping for all SNPs arounnd the specified Gene for a given chunk
 */
process IeQTLmappingPerGeneBgen {
    tag "Chunk: $chunk"
    echo true

    input:
    tuple path(tmm_expression), path(covariates), path(limix_annotation), path(gte), path(genes_to_test), val(covariate_to_test), val(chr), val(chunk), path(bgen), path(bgen_sample)


    output:
    //path "limix_out/*"

    shell:
    '''
     geno=!{bgen}
     bgen_base=${geno%.bgen}
     outdir=${PWD}/limix_out/
     mkdir $outdir

     python /limix_qtl/Limix_QTL/run_interaction_QTL_analysis.py \
     --bgen ${bgen_base} \
      -af !{limix_annotation} \
      -cf !{covariates} \
      -pf !{tmm_expression} \
      -ff !{genes_to_test} \
      -od ${outdir} \
      --interaction_term !{covariate_to_test} \
      -np 0 \
      -maf 0.05 \
      -c -gm gaussnorm \
      -w 1000000 \
      -hwe 0.0001 \
      -gr !{chunk} \
      -smf /groups/umcg-fg/tmp01/projects/eqtlgen-phase2/output/2023-03-16-sex-specific-analyses/test_nextflow/test_data/output/tmp_gte.txt
      
      echo !{params.outdir}
      if [ ! -d !{params.outdir}/limix_output/ ]
      then
        mkdir !{params.outdir}/limix_output/
      fi
      if [ ! -z "$(ls -A ${outdir}/)" ]
      then
        cp ${outdir}/* !{params.outdir}/limix_output/
      else
        echo "No limix output to copy"
      fi
      ls -la ${outdir}/

    '''
}
