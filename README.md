# OrphancerealsOmicsDatabase
## RNA-Seq Analysis Pipeline

This repository contains a set of scripts and Snakemake workflows for processing RNA-Seq data. The pipeline is designed to handle both single-end and paired-end sequencing data, and it includes steps for quality control, alignment, and quantification.

### Prerequisites

Before running the pipeline, ensure you have the following installed:

- **Bash**: For running the shell scripts.
- **Snakemake**: For executing the workflow.
- **Python**: Required by Snakemake.
- **Bioinformatics tools**:
  - `parallel-fastq-dump`: For converting SRA files to FASTQ format.
  - `fastp`: For quality control of FASTQ files.
  - `HISAT2`: For aligning reads to a reference genome.
  - `samtools`: For sorting and manipulating BAM files.
  - `featureCounts`: For quantifying gene expression.

### Usage

#### 1. Checking CSV and Directory Consistency

Before running the pipeline, you can check if the SRA numbers in the CSV file match the files in the directory using the `_01_check.bash` script.

```bash
./_01_check.bash /path/to/your/file.csv
