#!/usr/bin/env nextflow

/*
 This is an auto-generated checker workflow, please update as needed
*/

nextflow.enable.dsl = 2
version = '0.1.0'  // tool version

// universal params
params.publish_dir = ""
params.container_version = ""

// tool specific parmas go here, add / change as needed
params.input_file = ""
params.expected_output = ""

include { fastqc } from '../fastqc'

Channel
  .fromPath(params.input_file, checkIfExists: true)
  .set { input_file }


process file_diff {
  container "quay.io/junjun_zhang/fastqc:fastqc.${params.container_version ?: version}"

  input:
    path file1
    path file2

  output:
    stdout()

  script:
    """
    diff ${file1} ${file2} && ( echo "Test PASSED" && exit 0 ) || ( echo "Test FAILED, output file mismatch." && exit 1 )
    """
}


workflow checker {
  take:
    input_file
    expected_output

  main:
    fastqc(
      input_file
    )

    file_diff(
      fastqc.out.output,
      expected_output
    )
}


workflow {
  checker(
    file(params.input_file),
    file(params.expected_output)
  )
}
