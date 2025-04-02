#!/usr/bin/bash -l
#SBATCH -p batch   -N 1 -n 1 -c 64 --mem 128gb --out logs/edta.mcicadina.%A.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

module load edta
# change this to reading in filenames from file perhaps

OUTDIR=EDTA_run2
mkdir -p $OUTDIR
PREFIX=Massospora_cicadina.dna
GENOME=~/bigdata/EDTA/genome/Massospora_cicadina.dna.modi.fasta
CDS=$(realpath cds/${PREFIX}.cds.fasta)
mkdir -p $OUTDIR/$PREFIX
pushd $OUTDIR/$PREFIX
EDTA.pl --genome $GENOME --cds $CDS   \
    --overwrite 0  --sensitive 1 --anno 1 --evaluate 0 --threads $CPU
