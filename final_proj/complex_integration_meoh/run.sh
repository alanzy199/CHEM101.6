#!/bin/bash
#
# Note that you might have to adapt this script in order to use it on your
# machine or cluster. In particular, the name of the Gromacs executable will
# depend on your installation: e.g. gmx, gmx_avx, gmx_sse
# Also, if you run this on your machine it might take several hours, and
# you might want to decide not to use all available cores you have.

for d in lambda.*/; do
  d1=$(basename $d)
  lam="${d1##*.}"

  cd $d
  mkdir ENMIN
  cd ENMIN
  gmx_mpi grompp -f ../../MDP/ENMIN/enmin.$lam.mdp -c ../../complex.gro -p ../../complex.top -n ../../index.ndx -o enmin.tpr -maxwarn 1
  gmx_mpi mdrun -v -stepout 1000 -s enmin.tpr -deffnm enmin

  cd ../
  mkdir NVT
  cd NVT
  gmx_mpi grompp -f ../../MDP/NVT/nvt.$lam.mdp -c ../ENMIN/enmin.gro -p ../../complex.top -r ../ENMIN/enmin.gro -n ../../index.ndx -o nvt.tpr
  mpirun -np 2 gmx_mpi mdrun -gpu_id 01 -v -pin on -nb gpu -bonded gpu -pme gpu -npme 1 -ntomp 4 -pinoffset 6 -pinstride 0 -s nvt.tpr -deffnm nvt

  cd ../
  mkdir NPT
  cd NPT
  gmx_mpi grompp -f ../../MDP/NPT/npt.$lam.mdp -c ../NVT/nvt.gro -r ../NVT/nvt.gro -t ../NVT/nvt.cpt -p ../../complex.top -n ../../index.ndx -o npt.tpr -maxwarn 1
  mpirun -np 2 gmx_mpi mdrun -gpu_id 01 -v -pin on -nb gpu -bonded gpu -pme gpu -npme 1 -ntomp 4 -pinoffset 6 -pinstride 0 -s npt.tpr -deffnm npt

  cd ../
  mkdir PROD
  cd PROD
  gmx_mpi grompp -f ../../MDP/PROD/prod.$lam.mdp -c ../NPT/npt.gro -t ../NPT/npt.cpt -p ../../complex.top -n ../../index.ndx -o prod.tpr
  mpirun -np 2 gmx_mpi mdrun -gpu_id 01 -v -pin on -nb gpu -bonded gpu -pme gpu -npme 1 -ntomp 4 -pinoffset 6 -pinstride 0 -s prod.tpr -deffnm prod -dhdl dhdl

  cd ../../
done
