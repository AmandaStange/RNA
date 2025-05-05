#!/bin/bash

# Retrieve the system argument
system=$1

# Change to the appropriate directory
cd Output/${system}/${system}_solv.amb2gmx/

# Prepare input files for production runs
for i in {1..4}; do
    gmx grompp -f ../../../ForceFieldFiles/mdps/step5_production.mdp -r eq2.part0001.gro -c eq2.part0001.gro -n index.ndx -p topol.top -o ${system}_500ns_$i.tpr || gmx grompp -f ../../../ForceFieldFiles/mdps/step5_production.mdp -r eq2.part0002.gro -c eq2.part0002.gro -n index.ndx -p topol.top -o ${system}_500ns_$i.tpr
done

# Return to the original directory
cd ../../../
