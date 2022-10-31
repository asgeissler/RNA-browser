if pair_end:
    fc_para = config['featurecount_pe']
else:
    fc_para = config['featurecount_se']

# Remember to run the respective tasks
tasks.append('genes.saf')
tasks.extend(sample_wise(
    'analysis/40_subread/{name}.featureCounts'
))
tasks.append('analysis/41_counts.tsv')

################################################################################

rule saf:
    input:
        "genome.gff.gz"
    output:
        "genes.saf"
    run:
        res = ['GeneID\tChr\tStart\tEnd\tStrand\n']
        fmt = "{id}\t{chr}\t{start}\t{end}\t{strand}\n"
        import gzip
        with gzip.open(input[0], 'rt') as h:
            for line in h:
                if not line.startswith('#'):
                    xs = dict(zip(
                        ['chr', 'src', 'type', 'start', 'end', 'score',
                         'strand', 'phase', 'attr'],
                        line.split('\t')
                    ))
                    if xs['type'] == 'gene':
                        xs['id'] = re.sub(
                            r'^.*ID=([^;]+).*$',
                            r'\1',
                            xs['attr']
                        ).strip()
                        res.append(fmt.format(**xs))
        with open(output[0], 'w') as h:
            h.writelines(res)

################################################################################

def fc_helper(wildcards):
    "Lookup if to count forward or reverse read for this library"
    mask = sample_files['name'] == wildcards.name
    if pair_end:
        toggle = sample_files.loc[mask, 'reverse'].iloc[0]
    else:
        toggle = sample_files.loc[mask, 'reverse'].bool()
    if toggle:
        return fc_para + ' -s 2'
    else:
        return fc_para + ' -s 1'

rule feature_counts:
    input:
        sam = "analysis/21_sorted/{name}.bam",
        annotation = "genes.saf"
    output:
        multiext("analysis/40_subread/{name}",
                 ".featureCounts",
                 ".featureCounts.summary",
                 ".featureCounts.jcounts")
    threads:
        8
    params:
        extra = fc_helper
    log:
        "logs/subread/{name}.log"
    wrapper:
        "v1.1.0/bio/subread/featurecounts"

################################################################################

rule feature_counts_combine:
    input:
        sample_wise('analysis/40_subread/{name}.featureCounts')
    output:
        'analysis/41_counts.tsv'
    shell:
        """
        tmp=$(mktemp -d)
        # Extract the gene names etc
        tail +2 {input[0]} | cut -f 1-6 > $tmp/00_annot
        # for each file extract only the counts
        for i in {input} ; do
            bsn=$(basename $i .featureCounts)
            echo $bsn > $tmp/$bsn
            tail +3 $i | cut -f 7 >> $tmp/$bsn
        done
        # collect columns together
        paste $tmp/* > {output}
        rm -rf $tmp
        """
