#!/bin/bash

# Retrieve the system argument
system=$1

# Change to the appropriate directory
cd Output/${system}/${system}_solv.amb2gmx/

# Run energy minimization
gmx grompp -f ../../../ForceFieldFiles/mdps/step4.0_minimization.mdp -r ${system}_ions.gro -c ${system}_ions.gro -p topol.top -n index.ndx -o min.tpr -maxwarn 2
gmx mdrun -deffnm min -v

# Run equilibration
gmx grompp -f ../../../ForceFieldFiles/mdps/step4.1_equilibration.mdp -r min.gro -c min.gro -p topol.top -n index.ndx -o eq1.tpr -maxwarn 1
gmx mdrun -deffnm eq1 -v

gmx grompp -f ../../../ForceFieldFiles/mdps/step4.2_equilibration.mdp -r eq1.gro -c eq1.gro -p topol.top -n index.ndx -o eq2.tpr -maxwarn 1
gmx mdrun -deffnm eq2 -v

# Prepare input files for production runs
for i in {1..4}; do
    gmx grompp -f ../../../ForceFieldFiles/mdps/step5_production.mdp -r eq2.gro -c eq2.gro -n index.ndx -p topol.top -o ${system}_500ns_$i.tpr
done

# Return to the original directory
cd ../../../

