
# Ch2.Ento_Genome_Expansion
These codes are used in manuscript for TE-driven genome expansion in Entomophthoraceae

## First run EDTA on genome assembly to build TE library for each genome 
```
module load edta
# change this to reading in filenames from file perhaps

OUTDIR=EDTA_run
mkdir -p $OUTDIR
PREFIX=Zoophthora_radicans_ATCC_208865_v1
GENOME=$(realpath genome/${PREFIX}.fasta)
CDS=$(realpath cds/${PREFIX}.cds.fasta)
mkdir -p $OUTDIR/$PREFIX
pushd $OUTDIR/$PREFIX
EDTA.pl --genome $GENOME --cds $CDS  \
    --overwrite 1 --force 1 --sensitive 1 --anno 1 --evaluate 1 --threads $CPU
```

## Run Repeatmasker with sensitive setting to do whole genome TE annotation
```
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

```
## Plot repeatlandscape from repeatmasker result 
```
module load RepeatMasker
module load kent-tools
module load workspace/scratch

#GENOMEDIR=$(realpath genomes)
#INDIR=$(realpath repeatmasker_reports)
OUTDIR=$(realpath repeatmasker_plots)
#SAMPFILE=samples.csv

mkdir -p $OUTDIR


#IFS=,
#tail -n +2 $SAMPFILE | sed -n ${N}p | while read SPECIES STRAIN VERSION PHYLUM #BIOPROJECT #BIOSAMPLE LOCUS
#do
name=Entomophaga_maimaiga_var_ARSEF_7190
genome=/rhome/xxu092/bigdata/EDTA/genome/Entomophaga_maimaiga_var_ARSEF_7190.fasta
twoBit=/rhome/xxu092/bigdata/EDTA/RepeatLandscape-DeepTE/Entomophaga_maimaiga_var_ARSEF_7190.2bit
if [[ ! -s $twoBit || $genome -nt $twoBit ]]; then
    faToTwoBit $genome $twoBit
fi
# sum all the contigs to get genome size
genomeSize=$(twoBitInfo -noNs $twoBit stdout | cut -f2 | paste -s -d+ - | bc)

RUNDIR=${name}.rmblast1
if [ ! -d $RUNDIR ]; then
echo "No repeatmasker dir $RUNDIR"
fi
TMPDIV=$RUNDIR/${name}.fasta.align
DIVFILE=""
# test to see if we have either an uncompressed version of the file or compressed ones

DIVFILE=$TMPDIV

if [ ! -z $DIVFILE ]; then
echo "using divfile $DIVFILE"
else 
echo "Cannot find a divfile in $RUNDIR ($TMPDIV)"
exit
fi
DIVSUM=$OUTDIR/${name}.divsum
if [[ ! -s $DIVSUM || $DIVFILE -nt $DIVSUM ]]; then
    calcDivergenceFromAlign.pl -s $DIVSUM $DIVFILE
fi
scripts/createRepeatLandscape.pl -div $DIVSUM -twoBit $twoBit > $OUTDIR/${name}.landscape2.html

tail -n 72 $DIVSUM > $DIVSUM.tbl
Rscript scripts/plot_kimuradist_TE.R $DIVSUM.tbl $genomeSize

#done
```
script `createRepeatLandscape.pl` and `plot_kimuradist_TE.R` are in the pipeline folder