# README.md

## Overview

This document describes the process of converting a genomic VCF (gVCF) file into a Variant Dataset (VDS), as well as the rationale behind this process, based on insights from the ["Efficient Variant Data Storage and Analysis with Hail"](https://academic.oup.com/bioinformatics/advance-article/doi/10.1093/bioinformatics/btae746/7932121). Additionally, it outlines the creation of three Common Workflow Language (CWL) pipelines to streamline this conversion and subsequent variant data analysis.

---

## Process: From gVCF to VDS

### Understanding gVCF and VDS

A genomic VCF (gVCF) is a file format used to represent variation in genomic data, including single nucleotide polymorphisms (SNPs) and insertions/deletions (indels), with a special focus on regions without variation. While gVCFs are highly descriptive, their size and complexity can make downstream analysis cumbersome.

Variant Dataset (VDS) is a more optimized format for storing and analyzing genomic data. It is particularly well-suited for large-scale analyses because of its efficient storage, indexing, and querying capabilities. Converting gVCF to VDS facilitates faster and more scalable analysis.

### Step 2: Conversion Workflow

The gVCF to VDS conversion involves the following steps:

1. **Preprocessing the gVCF**:

   - Ensure that the gVCF is indexed.
   - Validate the format and contents to detect any inconsistencies or errors.

2. **Partitioning by Chromosome**:

   - Split the gVCF file into chromosome-specific datasets to parallelize the conversion process.

3. **Conversion to VDS**:

   - Utilize tools like Hail or custom scripts to convert chromosome-specific gVCF partitions into VDS format.

4. **Validation**:

   - Perform quality checks to ensure that the VDS files accurately represent the data in the original gVCF.

---

## Rationale

The process of converting gVCF to VDS is motivated by the need for:

- **Improved Performance**: VDS enables faster query and analysis operations compared to gVCF.
- **Scalability**: VDS is better suited for large-scale genomic studies, particularly when analyzing cohorts with thousands of samples.
- **Flexibility**: The VDS format supports advanced analytics workflows, such as variant QC and joint genotyping.

These benefits align with the goals highlighted in `svcr_manuscript.pdf`, which emphasize efficient data handling and the ability to perform robust analyses on genomic datasets.

---

## CWL Pipelines

To facilitate the gVCF to VDS conversion and subsequent analyses, we developed the following CWL pipelines:

### 1. GVCF to Chromosome-Specific VDS Conversion

This pipeline automates the conversion of a gVCF file into chromosome-specific VDS files. It:

- Accepts a gVCF as input.
- Splits the gVCF into per-chromosome partitions.
- Converts each partition to a VDS file in parallel.

### 2. VDS File Merger

After generating chromosome-specific VDS files, this pipeline merges them into a single, cohesive VDS dataset. This step is generally done to create a per-chromosome cohort VDS, enabling efficient and scalable analysis of large genomic datasets. It:

- Takes chromosome-specific VDS files as input.
- Resolves overlaps and ensures consistency across chromosomes.
- Outputs a unified VDS file ready for cohort-wide analysis.

### 3. VDS Variant QC Tool

This pipeline performs quality control on the VDS file to:

- Detect and remove low-quality variants.
- Apply user-defined filters for variant frequency, coverage, and other metrics.
- Generate summary statistics for downstream interpretation.

### 4. VDS to VCF

For compatibility with downstream tools that require VCF format, this pipeline converts VDS files back to VCF. It:

- Supports customization of output fields and annotations.
- Generates high-quality VCF files for reporting or further analysis.

---

## Summary

The transition from gVCF to VDS is a critical step in modern genomic data analysis, enabling scalable and efficient workflows. By leveraging our CWL pipelines, users can seamlessly convert, manage, and analyze their genomic datasets while maintaining high standards of quality and reproducibility.

---



