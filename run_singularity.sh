#!/bin/bash
# Helper to run the pipeline

# if no parameter passed to script, run all
if [[ $# -eq 0 ]] ; then
        target='all'
    else
            target="$@"
fi

# make sure output folder for log files exists
if [ ! -d logs ]; then
      mkdir logs
fi


snakemake --cores all                  \
    --use-singularity                  \
    --singularity-prefix /home/local/src/singularity_images/snakemake-pipelines \
    --use-conda --conda-frontend mamba \
    --keep-going                       \
    $target



