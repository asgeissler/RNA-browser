import pandas as pd
import os
import re
import sys

from glob import glob
from inspect import cleandoc

from snakemake.utils import validate, min_version
min_version("7.9.0")

# the global config file
configfile: 'config.yaml'

################################################################################
################################################################################
# Load and check samples configuration
sample_files = 'samples.csv'

# Check input file settings
if not os.path.isfile(sample_files):
    raise Exception("Please provide a samples.csv file.")

sample_files = pd.read_csv(sample_files)

# found read files
found_files = glob('data/*.fastq.gz')
# the expected columns, 'pair' and 'reverse' are optional
expect = ['file', 'sample', 'condition', 'dataset']

if not all( i in sample_files.columns \
            for i in expect           ):
    raise Exception(cleandoc("""
        The sample.csv must contain the columns file, sample, condition,
        and dataset.
        The columns 'pair' and 'reverse' are optional.
        """))

# are all files described?
xs = ( 'data/' + i for i in sample_files['file'] )
xs = set(xs).symmetric_difference(found_files)
if len(xs) > 0:
    raise Exception(cleandoc("""
        The samples.csv and the *.fastq.gz file found in the folder data do
        not match. These entries either lack a file or do not have a sample
        entry:

        {}
        """).format(', '.join(xs)))

# Finally, make sure the string content won't make problems
ptn = re.compile('^[-A-Za-z0-9]*$')
for i in ['sample', 'condition', 'dataset']:
    if any( ptn.match(j) is None    \
            for j in sample_files[i]):
        raise Exception(cleandoc("""
            Please use only alpha numeric [A-Za-z0-9] and a '-' symbol in
            the dataset, sample, and condition values.
            (No underscore or other special characters!)
            """))

# pairs correctly noted
if 'pair' in sample_files.columns:
    if set(sample_files['pair']) != {'R1', 'R2'}:
        raise Exception(cleandoc("""
            Please specify the read pairs in R1 and R2 values.
            """))

    x = sample_files.groupby('sample').size()
    if any(x != 2):
        raise Exception(cleandoc("""
            Please specify both read pairs for all samples.

            Missing for: {}
            """).format(', '.join(x.index[x != 2])))

if 'reverse' in sample_files.columns:
    if set(sample_files['reverse']) != {'yes', 'no'}:
        raise Exception(cleandoc("""
            Please use only yes/no in column reverse.
            """))
    sample_files['reverse'] = sample_files['reverse'] == 'yes'
else:
    # Per default do revers.
    # Most common Illumina case seems that the read (paired-end read1) is
    # reverse complementary mapping
    sample_files['reverse'] = True



# assert that genome sequence and annotation exist
for i in ['genome.fna.gz', 'genome.gff.gz']:
    if not os.path.isfile(i):
        raise Exception('Please provide both genome.fna.gz and genome.gff.gz')

# select pair end mode if needed
pair_end = 'pair' in sample_files.columns

################################################################################
################################################################################


# Helper to write output/input of rules
def sample_wise(x):
    "Expand wildcards in x as a generator"
    return list(sample_files.apply(
        lambda row: x.format(**row),
        axis = 1
    ))

# pretty name for samples (excl. potential read-pair indication)
sample_files['name'] = sample_wise('{condition}_{sample}_{dataset}')

################################################################################
################################################################################

tasks = []

include: 'rules/00_symlink.smk'
include: 'rules/10_mapping.smk'
include: 'rules/20_samba.smk'
include: 'rules/30_coverage.smk'
include: 'rules/40_quant.smk'
include: 'rules/50_browser.smk'


################################################################################

rule multiqc:
    input:
        sample_wise("logs/bowtie2_map/{name}.log"),
        sample_wise("analysis/40_subread/{name}.featureCounts.summary"),
    output:
        "multiqc/multiqc.html"
    params:
        ""
    log:
        "logs/multiqc.log"
    wrapper:
        "v1.1.0/bio/multiqc"

################################################################################

# Target rules
rule all:
    input:
        *tasks,
        "multiqc/multiqc.html"
