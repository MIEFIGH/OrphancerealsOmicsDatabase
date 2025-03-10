# OrphancerealsOmicsDatabase
## RNA-Seq Analysis Pipeline

This repository contains a set of scripts and Snakemake workflows for processing RNA-Seq data. The pipeline is designed to handle both single-end and paired-end sequencing data, and it includes steps for quality control, alignment, and quantification.

### Prerequisites

Before running the pipeline, ensure you have the following installed:

- **Bash**: For running the shell scripts.
- **Snakemake**: For executing the workflow.
- **Python**: Required by Snakemake.
- **R**: For fpkm tpm calculate.
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

- `single.list`: Contains the list of single-end SRA files.
- `paired.list`: Contains the list of paired-end SRA files.

#### 3. Running the Snakemake Workflow

The pipeline includes two Snakemake workflows:

- `snakemake_single.txt`: For processing single-end data.
- `snakemake.txt`: For processing paired-end data.

Add it at the beginning of the file:
```python
genome = "/data/genome.fa"  # refgenome
annotation = "/data/annotation.gtf"  # gtf file
work_dir = "/analysis/rna_seq"  # workdir
```

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
  1. FastQ File Extraction: Converts SRA files to FASTQ format (commented out in the provided scripts).

  2. Fastp Quality Control: Performs quality control on the FASTQ files (commented out in the provided scripts).

  3. HISAT2 Alignment: Aligns the reads to the reference genome (commented out in the provided scripts).

  4. FeatureCounts: Quantifies gene expression based on the aligned reads.

#### Configuration
The workflows use the following configuration files:

- `single.list`: List of single-end SRA files.
- `paired.list`: List of paired-end SRA files.

Ensure these files are correctly generated before running the Snakemake workflows.

#### Output
The pipeline generates the following outputs:

- BAM files: Sorted BAM files for each SRA file.

- Count files: Gene expression counts in `counts/single/counts_single.txt` or `counts/pair/counts_pair.txt`.

#### Example
Here is an example of how to run the pipeline:
```bash
# Check CSV and directory consistency
./_01_check.bash /path/to/your/file.csv

# Generate single and paired-end file lists
./_02_list.sh /path/to/your/file.csv

# Run the Snakemake workflow for single-end data
snakemake --snakefile snakemake_single.txt --cores 16

# Run the Snakemake workflow for paired-end data
snakemake --snakefile snakemake.txt --cores 16
````

#### 4.RPKM and TPM Calculation (fpkm_tpm.R created by Luoyingting)
Add it at the beginning of the file:

```bash
#!/route/miniconda3/envs/R/bin/Rscript

files_in <- "
/route/RNA/Triticum_durum/G5/counts/pair/counts_pair.txt"

files_out_fpkm <- "
/route/fpkm/Triticum_durum_G5_pair_fpkm.csv
"
files_out_tpm <- "
/route/tpm/Triticum_durum_G5_pair_tpm.csv
"
```

Execute the script using the following command:
```bash
./fpkm_tpm.R
```



## SNP Calling Pipeline

This repository contains a set of scripts and Snakemake workflows for processing sequencing data, including quality control, alignment, and SNP calling. The pipeline supports both **single-end** and **paired-end** sequencing data.

---

### Prerequisites

Before running the pipeline, ensure the following tools are installed:

- **Bash**: For running shell scripts.
- **Snakemake**: For workflow management.
- **Python**: Required by Snakemake.
- **Bioinformatics tools**:
  - `parallel-fastq-dump`: For converting SRA files to FASTQ format.
  - `fastp`: For quality control of FASTQ files.
  - `bwa`: For aligning reads to a reference genome.
  - `samtools`: For manipulating BAM files and calculating coverage/flagstat.
  - `samtools index`: For indexing BAM files.
  - `gatk`: For creating sequence dictionaries.

---

### Pipeline Overview

The pipeline consists of the following steps:

1. **Reference Genome Indexing**:
   - Builds BWA and samtools indexes for the reference genome.
   - Creates a sequence dictionary using GATK.

2. **Convert SRA to FASTQ**:
   - Converts SRA files to FASTQ format using `parallel-fastq-dump`.

3. **Quality Control**:
   - Trims and filters reads using `fastp`.

4. **Alignment**:
   - Aligns reads to a reference genome using `bwa mem`.

5. **BAM Processing**:
   - Sorts and indexes BAM files using `samtools`.

6. **Coverage and Flagstat**:
   - Calculates coverage and flagstat metrics using `samtools coverage` and `samtools flagstat`.

7. **Chromosome List Extraction**:
   - Extracts chromosome names from the reference genome.

---

### Usage

#### 1. Reference Genome Indexing

Before running the pipeline, you need to build indexes for the reference genome. The `_03_index.snake.txt` script automates this process.

##### Input

- A list of reference genome files (`fasta.list`), where each line contains the path to a reference genome file (e.g., `/path/to/reference_genome.fa`).

##### Running the Indexing Workflow

1. Create a `fasta.list` file with the paths to your reference genome files:
   ```bash
   echo "/path/to/reference_genome.fa" > fasta.list
    ```
2. Run the Snakemake workflow to build the indexes:
   ```bash
   snakemake --snakefile _03_index.snake.txt --cores <number_of_cores>
    ```
This will generate the following index files for each reference genome:

BWA indexes: `.amb`, `.ann`, `.bwt`, `.pac`, `.sa`

samtools index: `.fai`

GATK sequence dictionary: `.dict`
#### 2. Checking CSV and Directory Consistency
Before running the pipeline, check if the SRA numbers in the CSV file match the files in the directory using the `_01_check.bash` script:
  ````bash
  ./_01_check.bash /path/to/your/file.csv
  ````
This script will output:

- SRA numbers in the CSV file that are missing in the directory.
- SRA numbers in the directory that are not in the CSV file.

#### 3. Generating Single and Paired-End File Lists
The `_02_list.sh` script processes a CSV file to generate lists of single-end and paired-end SRA files:
  ````bash
  ./_02_list.sh /path/to/your/file.csv
  ````
#### 4. Running the Snakemake Workflow
The pipeline includes two Snakemake workflows:

- callsnp_snake.txt: For processing paired-end data.
- callsnp_snake_single.txt: For processing single-end data.

##### Configuration
Before running the workflow, ensure the following variables are set in the configuration file (`.yaml`):
````yaml
ref: "/path/to/reference_genome.fa"  # Path to the reference genome
sample:  # List of sample names
  - sample1
  - sample2
````
##### Running the Workflow
For paired-end data:
````bash
snakemake --snakefile callsnp_snake.txt --cores <number_of_cores>
````
For single-end data:
````bash
snakemake --snakefile callsnp_snake_single.txt --cores <number_of_cores>
````

##### Output Files
The pipeline generates the following outputs:

- Index files:

  - BWA indexes: .amb, .ann, .bwt, .pac, .sa

  - samtools index: .fai

  - GATK sequence dictionary: .dict

- BAM files: Sorted and indexed BAM files for each sample.

- Coverage files: Coverage statistics for each sample.

- Flagstat files: Alignment statistics for each sample.

- Chromosome list: A list of chromosome names from the reference genome.

#### 4.GATK
##### Prerequisites
- bam.list: a file with bam file route
- perl file(cited from https://github.com/dongyawu/Vavilovian_mimicry/tree/master/VarianceCalling_pipeline): need to change the refgenome and chromosome name 
##### Usage:
1. get bam.list
````bash
   find /route/mapping | grep "bam" | grep -v "bai" > bam.list
````
2. change the refgenome and chromosome name in `2_genotyping_pipeline.pl`
  

5. run perl script
   ````bash
   /usr/bin/perl 2_genotyping_pipeline.pl bam.list
   ````
