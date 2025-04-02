#!/usr/bin/bash -l
#SBATCH -p batch -n 32 --mem 96gb --out logs/C.thromRM%A.log -N 1

module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
GENOME=/rhome/xxu092/bigdata/genomes/Conidiobolus_thromboides_FSU_785.Conth1.v1.sorted.fasta
NAME=Conidiobolus_thromboides_FSU_785.Conth1.v1.sorted.fasta
PREFIX=$(basename $NAME .sorted.fasta)
library=/rhome/xxu092/bigdata/EDTA/EDTA_run2/Conidiobolus_thromboides_FSU_785.Conth1.v1/conthrom_genome.fna.mod.EDTA.TElib.fa
RepeatMasker -pa $CPUS -lib $library  -a -s -e rmblast -dir $PREFIX.rmblast $GENOME