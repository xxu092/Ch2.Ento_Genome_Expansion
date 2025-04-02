#!/usr/bin/bash -l
#SBATCH -p batch -n 32 --mem 96gb --out logs/E.musRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/EDTA/genome/Entomophthora_muscae_UCB.Nanopore10X_v2.fasta
NAME=Entomophthora_muscae_UCB.Nanopore10X_v2.fasta
PREFIX=$(basename $NAME .fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run3/Entomophthora_muscae_UCB.Nanopore10X_v2/Entomophthora_muscae_UCB.Nanopore10X_v2.fasta.mod.EDTA.TElib.fa
CPU=$(expr $CPUS / 4)
RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast $GENOME