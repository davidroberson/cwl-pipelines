cwlVersion: v1.2
class: Workflow
id: integrated_workflow
label: "Integrated Workflow"
doc: "Workflow integrating all tools for parallel somatic variant analysis.\n\nVersion: 1.3.3\n\nRevision History:\n- v1.0.0: Initial version with all tool integrations.\n- v1.1.0: Corrected output references for 'summarize_mutect' and 'summarize_strelka' to avoid cyclic dependencies.\n- v1.2.0: Updated to reflect user-preferred positions for steps in the workflow.\n- v1.3.0: Added detailed documentation to facilitate understanding of each step.\n- v1.3.3: Fixed sample key field handling in metrics calculation.\n\nAuthor: Dave Roberson\nDate: 2025-01-13"
$namespaces:
  sbg: "https://sevenbridges.com"
inputs:
  [
    {id: bed_file, type: File, label: "Input BED file", sbg:x: 64.76100158691406, sbg:y: 564.0642700195312},
    {id: scatter_count, type: int, label: "Number of intervals to split into", sbg:x: 30.84556007385254, sbg:y: 389.20751953125},
    {id: tumor_bam, type: File, label: "Tumor BAM file", sbg:x: 66.30328369140625, sbg:y: -114.88610076904297},
    {id: normal_bam, type: File, label: "Normal BAM file", sbg:x: 126.20405578613281, sbg:y: -6.612162113189697},
    {id: reference_genome, type: File, label: "Reference Genome", sbg:x: 4.340350151062012, sbg:y: -218.0167999267578},
    {id: germline_resource, type: File, label: "Germline Resource", sbg:x: 334.83349609375, sbg:y: -411.8694152832031},
    {id: annovar_path, type: File, label: "ANNOVAR Path", sbg:x: 987.3822631835938, sbg:y: -116.06640625},
    {id: annovar_db, type: Directory, label: "ANNOVAR Database", sbg:x: 1081.472412109375, sbg:y: -5.978379726409912, loadListing: deep_listing}
  ]
outputs:
  [
    {id: strelka_summary, type: File, outputSource: summarize_strelka/strelka_summary, sbg:x: 1183.652587890625, sbg:y: 232.2886199951172},
    {id: mutect_summary, type: File, outputSource: summarize_mutect/mutect_summary, sbg:x: 1700.1251220703125, sbg:y: -173.71487426757812}
  ]

steps: {
  split_intervals: { sbg:x: 351.96337890625, sbg:y: 463.8456726074219, run: { class: CommandLineTool, id: split_intervals_tool, label: "Split Intervals", baseCommand: ["java", "-jar", "SplitIntervals.jar"], inputs: { scatter_count: { type: int, inputBinding: { prefix: --scatter-count } }, bed_file: { type: File, inputBinding: { prefix: --input } } }, outputs: { scattered_intervals: { type: File, outputBinding: { glob: "*.intervals" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { scatter_count: scatter_count, bed_file: bed_file }, out: [scattered_intervals] },

  convert_intervals: { sbg:x: 563.8330688476562, sbg:y: 413.7801818847656, run: { class: CommandLineTool, id: convert_intervals_tool, label: "Convert Intervals to BED", baseCommand: ["grep", "-v", "@"], inputs: { intervals: { type: File, inputBinding: { position: 1 } } }, outputs: { interval_bed_files: { type: File, outputBinding: { glob: "*.bed" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { intervals: split_intervals/scattered_intervals }, out: [interval_bed_files] },

  run_mutect2: { sbg:x: 727.0090942382812, sbg:y: -160.746337890625, run: { class: CommandLineTool, id: run_mutect2_tool, label: "Run Mutect2", baseCommand: ["java", "-jar", "GATK4.jar", "Mutect2"], inputs: { tumor_bam: { type: File, inputBinding: { prefix: -I } }, normal_bam: { type: File, inputBinding: { prefix: -I } }, reference_genome: { type: File, inputBinding: { prefix: -R } }, intervals: { type: File, inputBinding: { prefix: -L } }, germline_resource: { type: File, inputBinding: { prefix: --germline-resource } } }, outputs: { mutect_vcf: { type: File, outputBinding: { glob: "*.vcf.gz" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { tumor_bam: tumor_bam, normal_bam: normal_bam, reference_genome: reference_genome, intervals: split_intervals/scattered_intervals, germline_resource: germline_resource }, out: [mutect_vcf] },

  filter_mutect: { sbg:x: 931.4227905273438, sbg:y: -263.0936279296875, run: { class: CommandLineTool, id: filter_mutect_tool, label: "Filter Mutect2 Results", baseCommand: ["java", "-jar", "GATK4.jar", "FilterMutectCalls"], inputs: { mutect_vcf: { type: File, inputBinding: { prefix: -V } } }, outputs: { filtered_vcf: { type: File, outputBinding: { glob: "*.vcf.gz" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { mutect_vcf: run_mutect2/mutect_vcf }, out: [filtered_vcf] },

  generate_annovar_avinput: { sbg:x: 1234.28857421875, sbg:y: -157.2830047607422, run: { class: CommandLineTool, id: generate_annovar_avinput_tool, label: "Generate ANNOVAR AVInput", baseCommand: ["zcat"], inputs: { vcf: { type: File, inputBinding: { position: 1 } }, annovar_path: { type: File }, annovar_db: { type: Directory, loadListing: deep_listing } }, outputs: { avinput_files: { type: File, outputBinding: { glob: "*.avinput" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { vcf: filter_mutect/filtered_vcf, annovar_path: annovar_path, annovar_db: annovar_db }, out: [avinput_files] },

  summarize_mutect: { sbg:x: 1465.69677734375, sbg:y: -152.14324951171875, run: { class: CommandLineTool, id: summarize_mutect_tool, label: "Summarize Mutect2 Results", baseCommand: ["python", "summarize_script.py"], inputs: { avinput: { type: File, inputBinding: { position: 1 } } }, outputs: { mutect_summary: { type: File, outputBinding: { glob: "*.txt" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { avinput: generate_annovar_avinput/avinput_files }, out: [mutect_summary] },

  run_strelka: { sbg:x: 734.7900390625, sbg:y: 161.88565063476562, run: { class: CommandLineTool, id: run_strelka_tool, label: "Run Strelka2", baseCommand: ["python", "strelka_runner.py"], inputs: { tumor_bam: { type: File, inputBinding: { prefix: --tumor } }, normal_bam: { type: File, inputBinding: { prefix: --normal } }, reference_genome: { type: File, inputBinding: { prefix: --reference } }, bed: { type: File, inputBinding: { prefix: --bed } } }, outputs: { strelka_vcf: { type: File, outputBinding: { glob: "*.vcf.gz" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { tumor_bam: tumor_bam, normal_bam: normal_bam, reference_genome: reference_genome, bed: convert_intervals/interval_bed_files }, out: [strelka_vcf] },

  summarize_strelka: { sbg:x: 980.0845336914062, sbg:y: 208.27394104003906, run: { class: CommandLineTool, id: summarize_strelka_tool, label: "Summarize Strelka2 Results", baseCommand: ["python", "summarize_strelka.py"], inputs: { vcf: { type: File, inputBinding: { position: 1 } } }, outputs: { strelka_summary: { type: File, outputBinding: { glob: "*.txt" } } }, requirements: [ { class: DockerRequirement, dockerPull: "mutect2_strelka2:latest" } ] }, in: { vcf: run_strelka/strelka_vcf }, out: [strelka_summary] }
}

