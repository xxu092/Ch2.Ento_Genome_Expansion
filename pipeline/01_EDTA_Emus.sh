#!/usr/bin/bash -l
#SBATCH -p intel -N 1 -n 1 -c 64 --mem 128gb --out logs/edta.emus.%A.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

conda activate EDTA
# change this to reading in filenames from file perhaps

OUTDIR=EDTA_run3
mkdir -p $OUTDIR
PREFIX=Entomophthora_muscae_UCB.Nanopore10X_v2
GENOME=~/bigdata/EDTA/genome/Entomophthora_muscae_UCB.Nanopore10X_v2.fasta
CDS=$(realpath cds/${PREFIX}.cds.fasta)
mkdir -p $OUTDIR/$PREFIX
pushd $OUTDIR/$PREFIX
EDTA.pl --genome $GENOME --cds $CDS   \
    --overwrite 1  --sensitive 1 --anno 1 --evaluate 0 --threads $CPU
