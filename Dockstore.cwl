baseCommand: []
class: CommandLineTool
cwlVersion: v1.0
id: exac_parser
inputs:
  exac_file:
    doc: A .vcf file from ExAC project
    inputBinding:
      position: 1
      prefix: --exac_file
    type: File
  goi_list:
    doc: A .txt file containing a list of genes of interest (gene name, chromosome,
      start and stop positions)
    inputBinding:
      position: 2
      prefix: --goi_list
    type: File
label: ExAC parser
outputs:
  exac_filtered:
    doc: ''
    outputBinding:
      glob: exac_filtered/*
    type: File
requirements:
- class: DockerRequirement
  dockerOutputDirectory: /data/out
  dockerPull: pfda2dockstore/exac_parser:20
s:author:
  class: s:Person
  s:name: Arturo Pineda
