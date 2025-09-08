#! /bin/bash
#$ -e /Griffin/err
#$ -o /Griffin/out
#$ -pe smp 5 -R y -binding linear:5
#$ -l h_vmem=20G
#$ -l h_rt=12:00:00
#$ -N GV_Deeptools

source /broad/software/scripts/useuse
reuse Anaconda3

source activate deeptools_conda_GV


cd /Griffin/BAM_files


bamPEFragmentSize -b BAM1.bam BAM2.bam -hist histogram.png --maxFragmentLength 300 --samplesLabel BAM1 BAM2
