
# Remember to run the respective tasks
tasks.extend(sample_wise(
    "analysis/33_bigwig/{name}.rev.bw"
))
tasks.extend(sample_wise(
    "analysis/33_bigwig/{name}.fwd.bw"
))

def cov_help(wildcards):
    # build list of parameters for file
    if pair_end:
        xs = ['-bg', '-pc']
    else:
        xs = ['-bg']

    # get per million norm factor
    checkpoints.sambamba_count.get(name = wildcards.name)
    path = "analysis/21_sorted/{}-count.txt".format(wildcards.name)
    with open(path, 'r') as h:
        # single line but remove newline
        x = h.readlines()[0][:-1]
        if pair_end:
            # divide by pairs 
            uq = int(x) / 2
        else:
            uq = int(x)
    xs.append( '-scale {}'.format(1e6 / int(uq)) )

    # swap +/- if reverse option set
    mask = sample_files['name'] == wildcards.name
    if pair_end:
        toggle = sample_files.loc[mask, 'reverse'].iloc[0]
    else:
        toggle = sample_files.loc[mask, 'reverse'].bool()
    # Contingency matrix:
    # strand toggle ~ parameter
    # fwd     F        +
    # fwd     T        -
    # rev     F        -
    # rev     T        +
    # => + if fwd xor toggle
    if toggle ^ (wildcards.strand == 'fwd'):
        xs.append( '-strand +' )
    else:
        xs.append( '-strand -' )
    return ' '.join(xs)

################################################################################

rule genomecov_bam:
    input:
        "analysis/21_sorted/{name}.bam",
        # luckily the wrapper ignores anything beyond input[0]
        "analysis/21_sorted/{name}-count.txt"
    output:
        "analysis/30_coverage/{name}.{strand}.bedgraph"
    params:
        cov_help
    log:
        "logs/genomecov/{name}-{strand}.log"
    wrapper:
        "v1.2.0/bio/bedtools/genomecov"

################################################################################
# prepare coverage for browser

# make reverse strand negative, if needed
rule neg_se:
    input:
        "analysis/30_coverage/{name}.{strand}.bedgraph"
    output:
        "analysis/31_negated/{name}.{strand}.bedgraph"
    run:
        res = []
        with open(input[0], 'r') as h:
            for line in h:
                if wildcards.strand == 'fwd':
                    res.append(line)
                else:
                    xs = line.split('\t')
                    xs[3] = '-' + xs[3]
                    res.append('\t'.join(xs))
        with open(output[0], 'w') as h:
            h.writelines(res)

################################################################################

rule bedtools_sort:
    input:
        in_file = "analysis/31_negated/{name}.{strand}.bedgraph"
    output:
        "analysis/32_sorted/{name}.{strand}.bedgraph"
    log:
        "logs/sorted/{name}-{strand}.log"
    wrapper:
        "v1.12.2/bio/bedtools/sort"

################################################################################

# convert to bigwig
rule bedGraphToBigWig:
    input:
        bedGraph = "analysis/32_sorted/{name}.{strand}.bedgraph",
        chromsizes = 'genome.info'
    output:
        "analysis/33_bigwig/{name}.{strand}.bw"
    log:
        "logs/bigwig/{name}-{strand}.log"
    params:
    wrapper:
        "v1.12.2/bio/ucsc/bedGraphToBigWig"
