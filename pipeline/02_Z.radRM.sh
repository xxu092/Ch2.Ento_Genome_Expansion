#!/usr/bin/bash -l
#SBATCH -p batch -n 32 --mem 96gb --out logs/Z.radRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/EDTA/genome/Zoophthora_radicans_ATCC_208865_v1.fasta
NAME=Zoophthora_radicans_ATCC_208865_v1.fasta
PREFIX=$(basename $NAME .fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run2/Zoophthora_radicans_ATCC_208865_v1/Zoophthora_radicans_ATCC_208865_v1.fasta.mod.EDTA.TElib.fa


RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast $GENOME

