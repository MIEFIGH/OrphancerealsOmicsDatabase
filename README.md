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
````
This script will output any discrepancies between the CSV file and the directory contents.

#### 2. Generating Single and Paired-End File Lists

The `_02_list.sh` script processes a CSV file to generate lists of single-end and paired-end SRA files.

```bash
./_02_list.sh /path/to/your/file.csv
````

This script will create two files:

`single.list`: Contains the list of single-end SRA files.
`paired.list`: Contains the list of paired-end SRA files.

#### 3. Running the Snakemake Workflow

The pipeline includes two Snakemake workflows:

- `snakemake_single.txt`: For processing single-end data.
- `snakemake.txt`: For processing paired-end data.

To run the workflow, use the following command:
```bash
snakemake --snakefile snakemake_single.txt --cores <number_of_cores>
````
or
```bash
snakemake --snakefile snakemake.txt --cores <number_of_cores>
````
Replace `<number_of_cores>` with the number of CPU cores you want to use.


#### Workflow Steps
FastQ File Extraction: Converts SRA files to FASTQ format (commented out in the provided scripts).

Fastp Quality Control: Performs quality control on the FASTQ files (commented out in the provided scripts).

HISAT2 Alignment: Aligns the reads to the reference genome (commented out in the provided scripts).

FeatureCounts: Quantifies gene expression based on the aligned reads.

#### Configuration
The workflows use the following configuration files:

`single.list`: List of single-end SRA files.

`paired.list`: List of paired-end SRA files.

Ensure these files are correctly generated before running the Snakemake workflows.

Output
The pipeline generates the following outputs:

BAM files: Sorted BAM files for each SRA file.

Count files: Gene expression counts in counts/single/counts_single.txt or counts/pair/counts_pair.txt.

Example
Here is an example of how to run the pipeline:
