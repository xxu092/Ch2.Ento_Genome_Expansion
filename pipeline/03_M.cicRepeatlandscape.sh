#!/bin/bash -l
#SBATCH -p batch -N 1 -n 1  --mem 64G --out logs/M.cicRL%A.log 

hostname
CPU=1
if [ $SLURM_CPUS_ON_NODE ]; then
  CPU=$SLURM_CPUS_ON_NODE
fi
if [ -z $SLURM_JOB_ID ]; then
  SLURM_JOB_ID=$$
fi
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
name=Massospora_cicadina
genome=$(realpath /rhome/xxu092/bigdata/EDTA/EDTA_run2/Massospora_cicadina.dna/Massospora_cicadina.dna.modi.fasta)
twoBit=/rhome/xxu092/bigdata/EDTA/EDTA_run2/Massospora_cicadina.dna/Massospora_cicadina.dna.modi.2bit
if [[ ! -s $twoBit || $genome -nt $twoBit ]]; then
    faToTwoBit $genome $twoBit
fi
# sum all the contigs to get genome size
genomeSize=$(twoBitInfo -noNs $twoBit stdout | cut -f2 | paste -s -d+ - | bc)

RUNDIR=${name}.rmblast1
if [ ! -d $RUNDIR ]; then
echo "No repeatmasker dir $RUNDIR"
fi
TMPDIV=$RUNDIR/${name}.dna.fasta.align
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
