#!/usr/bin/bash -l
#SBATCH -p batch --time=21-24:00:00 -N 1 -n 1 -c 32 --mem 128gb --out logs/edta.Bmeristosporus.%A.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

module load edta
# change this to reading in filenames from file perhaps

OUTDIR=EDTA_run2
mkdir -p $OUTDIR
PREFIX=Basidiobolus_meristosporus_CBS_931.73.Basme2finSC.v1
GENOME=$(realpath genome/${PREFIX}.fasta)
CDS=$(realpath cds/${PREFIX}.cds.fasta)
mkdir -p $OUTDIR/$PREFIX
pushd $OUTDIR/$PREFIX
EDTA.pl --genome $GENOME --cds $CDS  \
    --overwrite 1 --force 1 --sensitive 1 --anno 1 --evaluate 1 --threads $CPU
