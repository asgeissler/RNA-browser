#!/bin/bash
# Helper to run snakemake workflow

# if no parameter passed to script, run all
if [[ $# -eq 0 ]] ; then
    target='all'
else
    target="$@"
fi

echo "Targets: $target"

# make sure output folder for log files exists
if [ ! -d logs ]; then
  mkdir logs
fi
if [ ! -d slurmlogs ]; then
  mkdir slurmlogs
fi

snakemake --profile slurmprofile $target