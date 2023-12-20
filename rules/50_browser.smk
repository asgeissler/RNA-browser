# Use the generated files to build the basic browser with configuration

tasks.extend([
    'browser/files/genome.fna',
    'browser/files/genome.gff',
    'browser/files/genome.fna.fai',
    'browser/config.json'
])
tasks.extend(sample_wise(
    "browser/files/{name}.rev.bw"
))
tasks.extend(sample_wise(
    "browser/files/{name}.fwd.bw"
))


rule browser_skeleton:
    output:
        'browser/download.flag'
    shell:
        """
        wget {config[jbrowse_url]}
        if [ ! -d browser ]; then
          mkdir browser
        fi
        unzip -d browser $(basename {config[jbrowse_url]})
        touch {output}
        """


rule browser_genome:
    input:
        'browser/download.flag', # wait with copying until downloaded
        'genome.gff.gz',
        'genome.fna.gz'
    output:
        'browser/files/genome.fna',
        'browser/files/genome.gff'
    shell:
        """
        if [ ! -d browser/files ]; then
          mkdir browser/files
        fi
        gunzip -c genome.gff.gz > browser/files/genome.gff
        gunzip -c genome.fna.gz > browser/files/genome.fna
        """


rule browser_genome_index:
    input:
        'browser/files/genome.fna'
    output:
        'browser/files/genome.fna.fai'
    params:
        extra=""
    wrapper:
        "v3.3.1/bio/samtools/faidx"



rule browser_wig:
    input:
        "analysis/33_bigwig/{name}.{strand}.bw",
        'browser/download.flag'
    output:
        "browser/files/{name}.{strand}.bw"
    shell:
        """
        cp {input[0]} {output}
        """

rule browser_conf:
    input:
        'browser/download.flag'
    output:
        'browser/config.json'
    script:
        '51_config.py'
