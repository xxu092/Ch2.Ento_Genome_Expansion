# Ch2.Ento_Genome_Expansion
These codes are used in manuscript for TE-driven genome expansion in Entomophthoraceae

## First run EDTA on genome assembly to build TE library for each genome 
```
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
     --force 1 --sensitive 1 --anno 1 --evaluate 1 --threads $CPU
```

## Run Repeatmasker with sensitive setting to do whole genome TE annotation
```
module load RepeatMasker
if [[ -z ${SLURM_CPUS_ON_NODE} ]]; then
    CPUS=1
else
    CPUS=${SLURM_CPUS_ON_NODE}
fi
cd ..
GENOME=genome/Basidiobolus_meristosporus_CBS_931.73.Basme2finSC.v1.fasta
NAME=Basidiobolus_meristosporus_CBS_931.73.Basme2finSC.v1.fasta
PREFIX=$(basename $NAME .Basme2finSC.v1.fasta)
library=~/bigdata/EDTA/EDTA_run2/Basidiobolus_meristosporus_CBS_931.73.Basme2finSC.v1/Basidiobolus_meristosporus_CBS_931.73.Basme2finSC.v1.fasta.mod.EDTA.TElib.fa
CPU=$(expr $CPUS / 4)
RepeatMasker -pa $CPU -lib $library  -a -s -e rmblast -dir RepeatLandscape2-EDTA/$PREFIX.rmblast $GENOME

```
