# Since the filename of a sample does not imply the sample/condition
# strings, the nice names need to be 'hard wired' per sample instead of a rule

if pair_end:
    sym_out = '{name}_{pair}.fastq.gz'
else:
    sym_out = '{name}.fastq.gz'

if not os.path.exists('analysis/00_symlink'):
    os.makedirs('analysis/00_symlink')

    for ix, row in sample_files.iterrows():
        x = '{file}'.format(**row)
        y = sym_out.format(**row)
        shell(f'ln -s $(pwd -L)/data/{x} analysis/00_symlink/{y}')
