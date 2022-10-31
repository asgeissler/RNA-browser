# Filter and sort the mapping bam files with sambamba

if pair_end:
    filter_para = config['filter_pe']
else:
    filter_para = config['filter_se']

# Remember to run the respective tasks
tasks.extend(sample_wise(
    "analysis/21_sorted/{name}-count.txt"
))

################################################################################

rule sambamba_filter:
    input:
        "analysis/10_mapping/{name}.bam"
    output:
        "analysis/20_filter/{name}.bam"
    log:
        "logs/sambamba-filter/{name}.log"
    params:
        # corresponds mapq probability of mapping other position 0.001
        extra = filter_para
    threads: 16
    wrapper:
        "v1.12.2/bio/sambamba/view"

################################################################################


rule sambamba_sort:
    input:
        "analysis/20_filter/{name}.bam"
    output:
        "analysis/21_sorted/{name}.bam"
    log:
        "logs/sambamba-sort/{name}.log"
    params:
        ""
    threads: 16
    wrapper:
        "v1.12.2/bio/sambamba/sort"

################################################################################

rule sambamba_index:
    input:
        "analysis/21_sorted/{name}.bam"
    output:
        "analysis/21_sorted/{name}.bam.bai"
    log:
        "logs/sambamba-index/{name}.log"
    threads: 8
    wrapper:
        "v1.12.2/bio/sambamba/index"

################################################################################

checkpoint sambamba_count:
    input:
        "analysis/21_sorted/{name}.bam"
    output:
        "analysis/21_sorted/{name}-count.txt"
    log:
        "logs/sambamba-count/{name}.log"
    params:
        extra="-c"
    threads: 8
    wrapper:
        "v1.12.2/bio/sambamba/view"
