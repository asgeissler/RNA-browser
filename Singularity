Bootstrap: docker
From: condaforge/mambaforge:latest
Stage: spython-base

%labels
io.github.snakemake.containerized="true"
io.github.snakemake.conda_env_hash="4fafe741820d19041e141b9ae0793f3a96b1ac746c05833444014dab2677df62"
%post

# Step 1: Retrieve conda environments

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bedtools/genomecov/environment.yaml
#   prefix: /conda-envs/4bc1c7d4971260f38b3717e4c2f2ddf4
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - bedtools =2.31.1
mkdir -p /conda-envs/4bc1c7d4971260f38b3717e4c2f2ddf4
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bedtools/genomecov/environment.yaml -O /conda-envs/4bc1c7d4971260f38b3717e4c2f2ddf4/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bowtie2/align/environment.yaml
#   prefix: /conda-envs/268b7472c1a4796c93dadab56996fe66
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - bowtie2 =2.5.2
#     - samtools =1.19
#     - snakemake-wrapper-utils =0.6.2
mkdir -p /conda-envs/268b7472c1a4796c93dadab56996fe66
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bowtie2/align/environment.yaml -O /conda-envs/268b7472c1a4796c93dadab56996fe66/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bowtie2/build/environment.yaml
#   prefix: /conda-envs/27745e708d957131953ee2d8014548b8
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - bowtie2 =2.5.2
mkdir -p /conda-envs/27745e708d957131953ee2d8014548b8
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/bowtie2/build/environment.yaml -O /conda-envs/27745e708d957131953ee2d8014548b8/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/multiqc/environment.yaml
#   prefix: /conda-envs/a74c0ac65c84ed438731c3397703af31
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - multiqc =1.18
mkdir -p /conda-envs/a74c0ac65c84ed438731c3397703af31
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/multiqc/environment.yaml -O /conda-envs/a74c0ac65c84ed438731c3397703af31/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/sambamba/index/environment.yaml
#   prefix: /conda-envs/77ab24369bc402f38c70bd3f6d76d935
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - sambamba =1.0
mkdir -p /conda-envs/77ab24369bc402f38c70bd3f6d76d935
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/sambamba/index/environment.yaml -O /conda-envs/77ab24369bc402f38c70bd3f6d76d935/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/samtools/faidx/environment.yaml
#   prefix: /conda-envs/19158752836267c8da44d21cd05cc69d
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - samtools =1.19
#     - snakemake-wrapper-utils =0.6.2
mkdir -p /conda-envs/19158752836267c8da44d21cd05cc69d
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/samtools/faidx/environment.yaml -O /conda-envs/19158752836267c8da44d21cd05cc69d/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/subread/featurecounts/environment.yaml
#   prefix: /conda-envs/d9318d504877b504f6a1bac6535ac060
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - subread =2.0.6
mkdir -p /conda-envs/d9318d504877b504f6a1bac6535ac060
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/subread/featurecounts/environment.yaml -O /conda-envs/d9318d504877b504f6a1bac6535ac060/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/bedGraphToBigWig/environment.yaml
#   prefix: /conda-envs/1423c0ac4fa57dfebafd031f95067f48
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - ucsc-bedgraphtobigwig =445
mkdir -p /conda-envs/1423c0ac4fa57dfebafd031f95067f48
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/bedGraphToBigWig/environment.yaml -O /conda-envs/1423c0ac4fa57dfebafd031f95067f48/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/faToTwoBit/environment.yaml
#   prefix: /conda-envs/ebf4a0aa942ecd68a840a3c3d2f014a7
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - ucsc-fatotwobit =455
mkdir -p /conda-envs/ebf4a0aa942ecd68a840a3c3d2f014a7
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/faToTwoBit/environment.yaml -O /conda-envs/ebf4a0aa942ecd68a840a3c3d2f014a7/environment.yaml

# Conda environment:
#   source: https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/twoBitInfo/environment.yaml
#   prefix: /conda-envs/10e85085d7e0c067dd6c2ae36f4db113
#   channels:
#     - conda-forge
#     - bioconda
#     - nodefaults
#   dependencies:
#     - ucsc-twobitinfo =447
mkdir -p /conda-envs/10e85085d7e0c067dd6c2ae36f4db113
wget https://github.com/snakemake/snakemake-wrappers/raw/v3.3.1/bio/ucsc/twoBitInfo/environment.yaml -O /conda-envs/10e85085d7e0c067dd6c2ae36f4db113/environment.yaml

# Step 2: Generate conda environments

mamba env create --prefix /conda-envs/4bc1c7d4971260f38b3717e4c2f2ddf4 --file /conda-envs/4bc1c7d4971260f38b3717e4c2f2ddf4/environment.yaml && \
mamba env create --prefix /conda-envs/268b7472c1a4796c93dadab56996fe66 --file /conda-envs/268b7472c1a4796c93dadab56996fe66/environment.yaml && \
mamba env create --prefix /conda-envs/27745e708d957131953ee2d8014548b8 --file /conda-envs/27745e708d957131953ee2d8014548b8/environment.yaml && \
mamba env create --prefix /conda-envs/a74c0ac65c84ed438731c3397703af31 --file /conda-envs/a74c0ac65c84ed438731c3397703af31/environment.yaml && \
mamba env create --prefix /conda-envs/77ab24369bc402f38c70bd3f6d76d935 --file /conda-envs/77ab24369bc402f38c70bd3f6d76d935/environment.yaml && \
mamba env create --prefix /conda-envs/19158752836267c8da44d21cd05cc69d --file /conda-envs/19158752836267c8da44d21cd05cc69d/environment.yaml && \
mamba env create --prefix /conda-envs/d9318d504877b504f6a1bac6535ac060 --file /conda-envs/d9318d504877b504f6a1bac6535ac060/environment.yaml && \
mamba env create --prefix /conda-envs/1423c0ac4fa57dfebafd031f95067f48 --file /conda-envs/1423c0ac4fa57dfebafd031f95067f48/environment.yaml && \
mamba env create --prefix /conda-envs/ebf4a0aa942ecd68a840a3c3d2f014a7 --file /conda-envs/ebf4a0aa942ecd68a840a3c3d2f014a7/environment.yaml && \
mamba env create --prefix /conda-envs/10e85085d7e0c067dd6c2ae36f4db113 --file /conda-envs/10e85085d7e0c067dd6c2ae36f4db113/environment.yaml && \
mamba clean --all -y
%runscript
exec /bin/bash "$@"
%startscript
exec /bin/bash "$@"
