

### **Formatted Workflow and Extracted Tools**

#### **Formatted Workflow**
```yaml
cwlVersion: v1.2
class: Workflow
id: integrated_workflow
label: "Integrated Workflow"
doc: "Workflow integrating all tools for parallel somatic variant analysis.\n\nVersion: 1.3.3\n\nRevision History:\n- v1.0.0: Initial version with all tool integrations.\n- v1.1.0: Corrected output references for 'summarize_mutect' and 'summarize_strelka' to avoid cyclic dependencies.\n- v1.2.0: Updated to reflect user-preferred positions for steps in the workflow.\n- v1.3.0: Added detailed documentation to facilitate understanding of each step.\n- v1.3.3: Fixed sample key field handling in metrics calculation.\n\nAuthor: Dave Roberson\nDate: 2025-01-13"
$namespaces:
  sbg: "https://sevenbridges.com"
inputs:
  - {id: bed_file, type: File, label: "Input BED file", sbg:x: 64.76, sbg:y: 564.06}
  - {id: scatter_count, type: int, label: "Number of intervals to split into", sbg:x: 30.85, sbg:y: 389.20}
  - {id: tumor_bam, type: File, label: "Tumor BAM file", sbg:x: 66.30, sbg:y: -114.88}
  - {id: normal_bam, type: File, label: "Normal BAM file", sbg:x: 126.20, sbg:y: -6.61}
  - {id: reference_genome, type: File, label: "Reference Genome", sbg:x: 4.34, sbg:y: -218.02}
  - {id: germline_resource, type: File, label: "Germline Resource", sbg:x: 334.83, sbg:y: -411.87}
  - {id: annovar_path, type: File, label: "ANNOVAR Path", sbg:x: 987.38, sbg:y: -116.07}
  - {id: annovar_db, type: Directory, label: "ANNOVAR Database", sbg:x: 1081.47, sbg:y: -5.98, loadListing: deep_listing}
outputs:
  - {id: strelka_summary, type: File, outputSource: summarize_strelka/strelka_summary, sbg:x: 1183.65, sbg:y: 232.29}
  - {id: mutect_summary, type: File, outputSource: summarize_mutect/mutect_summary, sbg:x: 1700.13, sbg:y: -173.71}
steps:
  split_intervals:
    {sbg:x: 351.96, sbg:y: 463.85, run: "split_intervals_tool.cwl", in: {scatter_count: scatter_count, bed_file: bed_file}, out: [scattered_intervals]}
  convert_intervals:
    {sbg:x: 563.83, sbg:y: 413.78, run: "convert_intervals_tool.cwl", in: {intervals: split_intervals/scattered_intervals}, out: [interval_bed_files]}
  run_mutect2:
    {sbg:x: 727.01, sbg:y: -160.75, run: "run_mutect2_tool.cwl", in: {tumor_bam: tumor_bam, normal_bam: normal_bam, reference_genome: reference_genome, intervals: split_intervals/scattered_intervals, germline_resource: germline_resource}, out: [mutect_vcf]}
  filter_mutect:
    {sbg:x: 931.42, sbg:y: -263.09, run: "filter_mutect_tool.cwl", in: {mutect_vcf: run_mutect2/mutect_vcf}, out: [filtered_vcf]}
  generate_annovar_avinput:
    {sbg:x: 1234.29, sbg:y: -157.28, run: "generate_annovar_avinput_tool.cwl", in: {vcf: filter_mutect/filtered_vcf, annovar_path: annovar_path, annovar_db: annovar_db}, out: [avinput_files]}
  summarize_mutect:
    {sbg:x: 1465.70, sbg:y: -152.14, run: "summarize_mutect_tool.cwl", in: {avinput: generate_annovar_avinput/avinput_files}, out: [mutect_summary]}
  run_strelka:
    {sbg:x: 734.79, sbg:y: 161.89, run: "run_strelka_tool.cwl", in: {tumor_bam: tumor_bam, normal_bam: normal_bam, reference_genome: reference_genome, bed: convert_intervals/interval_bed_files}, out: [strelka_vcf]}
  summarize_strelka:
    {sbg:x: 980.08, sbg:y: 208.27, run: "summarize_strelka_tool.cwl", in: {vcf: run_strelka/strelka_vcf}, out: [strelka_summary]}
```
---

#### **Extracted Tools**

##### **Tool 1: Split Intervals Tool**
Purpose: Splits a given BED file into a specified number of intervals.
```yaml
class: CommandLineTool
id: split_intervals_tool
label: "Split Intervals"
baseCommand: ["java", "-jar", "SplitIntervals.jar"]
inputs:
  scatter_count: {type: int, inputBinding: {prefix: --scatter-count}}
  bed_file: {type: File, inputBinding: {prefix: --input}}
outputs:
  scattered_intervals: {type: File, outputBinding: {glob: "*.intervals"}}
requirements:
  - {class: DockerRequirement, dockerPull: "mutect2_strelka2:latest"}
```
---

##### **Tool 2: Convert Intervals Tool**
Purpose: Converts intervals into BED format.
```yaml
class: CommandLineTool
id: convert_intervals_tool
label: "Convert Intervals to BED"
baseCommand: ["grep", "-v", "@"]
inputs:
  intervals: {type: File, inputBinding: {position: 1}}
outputs:
  interval_bed_files: {type: File, outputBinding: {glob: "*.bed"}}
requirements:
  - {class: DockerRequirement, dockerPull: "mutect2_strelka2:latest"}
```
---

... (More tools follow in similar format)

