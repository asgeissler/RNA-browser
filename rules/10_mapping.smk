
# Configure input outputs dependent if SE or PE
if pair_end:
    bowtie_in = [
        'analysis/00_symlink/{name}_R1.fastq.gz',
        'analysis/00_symlink/{name}_R2.fastq.gz'
    ]
    bowtie_out = "analysis/10_mapping/{name}.bam"
    bowtie_para = config['bowtie_pe']
else:
    bowtie_in = [
        'analysis/00_symlink/{name}.fastq.gz'
    ]
    bowtie_out = "analysis/10_mapping/{name}.bam"
    bowtie_para = config['bowtie_se']


# Remember to run the respective tasks
tasks.extend(sample_wise(
    "analysis/10_mapping/{name}.bam"
))

################################################################################

rule faToTwoBit_fa_gz:
    input:
        "genome.fna.gz"
    output:
        "genome.2bit"
    wrapper:
        "v1.12.2/bio/ucsc/faToTwoBit"

################################################################################

rule twoBitInfo:
    input:
        "genome.2bit"
    output:
        "genome.info"
    wrapper:
        "v1.12.2/bio/ucsc/twoBitInfo"

################################################################################

rule bowtie2_build:
    input:
        reference = "genome.fna.gz"
    output:
        multiext(
            "genome",
            ".1.bt2", ".2.bt2", ".3.bt2", ".4.bt2", ".rev.1.bt2", ".rev.2.bt2",
        ),
    params:
        extra="--seed 123"
    log:
        'logs/bowtie2_build.log'
    threads: 8
    wrapper:
        "v1.1.0/bio/bowtie2/build"

################################################################################

rule bowtie2:
    input:
        sample = bowtie_in,
        wait_for_index = 'genome.1.bt2'
    output:
        bowtie_out
    params:
        index = 'genome',
        extra = bowtie_para
    log:
        "logs/bowtie2_map/{name}.log"
    threads: 16
    wrapper:
        "v1.1.0/bio/bowtie2/align"
