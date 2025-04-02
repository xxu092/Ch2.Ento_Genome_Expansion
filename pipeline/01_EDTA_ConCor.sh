#!/usr/bin/bash -l
#SBATCH -p batch -N 1 -n 1  --mem 96gb --out logs/edta.con.coronatus.%A.log


CPU=2
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi

module load edta
# change this to reading in filenames from file perhaps

OUTDIR=EDTA_run2
mkdir -p $OUTDIR
PREFIX=Conidiobolus_coronatus_NRRL_28638.Conco1.v1
GENOME=$(realpath genome/Conidiobolus_coronatus_NRRL_28638.Conco1.v1.modi.fasta)
CDS=$(realpath /bigdata/stajichlab/shared/projects/ZyGoLife/Condidiobolus/Phylogenomics/cds.skip/Conidiobolus_coronatus_NRRL_28638.Conco1.v1.cds.fasta)
mkdir -p $OUTDIR/$PREFIX
pushd $OUTDIR/$PREFIX
EDTA.pl --genome $GENOME --cds $CDS  \
    --overwrite 1 --force 1 --sensitive 1 --anno 1 --evaluate 1 --threads $CPU
