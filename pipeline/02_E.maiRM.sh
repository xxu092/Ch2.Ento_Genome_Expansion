#!/usr/bin/bash -l
#SBATCH -p batch  -n 32 --mem 96gb --out logs/E.maiRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/EDTA/genome/Entomophaga_maimaiga_var_ARSEF_7190.fasta
NAME=Entomophaga_maimaiga_var_ARSEF_7190.fasta
PREFIX=$(basename $NAME .fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run3/Entomophaga_maimaiga_var_ARSEF_7190/Entomophaga_maimaiga_var_ARSEF_7190.fasta.mod.EDTA.TElib.fa
CPU=$(expr $CPUS / 4)
RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast1 $GENOME