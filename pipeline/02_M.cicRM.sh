#!/usr/bin/bash -l
#SBATCH -p batch -n 32 --mem 96gb --out logs/M.cicRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/EDTA/genome/Massospora_cicadina.dna.fasta
NAME=Massospora_cicadina.dna.fasta
PREFIX=$(basename $NAME .dna.fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run2/Massospora_cicadina.dna/Massospora_cicadina.dna.modi.fasta.mod.EDTA.TElib.fa
CPU=$(expr $CPUS / 4)
RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast1 $GENOME
