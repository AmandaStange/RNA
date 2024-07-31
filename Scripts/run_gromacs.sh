#!/bin/bash

# Retrieve the system argument
system=$1

# Change to the appropriate directory
cd Output/${system}/${system}RNA_solv.amb2gmx/

# Run energy minimization
gmx grompp -f ../../../ForceFieldFiles/mdps/step4.0_minimization.mdp -r ${system}RNA_ions.gro -c ${system}RNA_ions.gro -p topol.top -n index.ndx -o min.tpr -maxwarn 2
gmx mdrun -deffnm min -v

# Run equilibration
gmx grompp -f ../../../ForceFieldFiles/mdps/step4.1_equilibration.mdp -r min.gro -c min.gro -p topol.top -n index.ndx -o eq.tpr -maxwarn 1
gmx mdrun -deffnm eq -v

# Prepare input files for production runs
for i in {1..4}; do
    gmx grompp -f ../../../ForceFieldFiles/mdps/step5_production.mdp -r eq.gro -c eq.gro -n index.ndx -p topol.top -o ${system}RNA_500ns_$i.tpr
done

# Return to the original directory
cd ../../../
