#!/usr/bin/bash -l
#SBATCH -p batch -n 32 --mem 96gb --out logs/C.corRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/EDTA/genome/Conidiobolus_coronatus_NRRL_28638.Conco1.v1.modi.fasta
NAME=Conidiobolus_coronatus_NRRL_28638.Conco1.v1.modi.fasta
PREFIX=$(basename $NAME .modi.fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run2/Conidiobolus_coronatus_NRRL_28638.Conco1.v1/Conidiobolus_coronatus_NRRL_28638.Conco1.v1.modi.fasta.mod.EDTA.TElib.fa
CPU=$(expr $CPUS / 4)
RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast $GENOME