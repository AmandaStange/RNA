#!/bin/bash

# Retrieve the system argument
system=$1



# Change to the appropriate directory
cd Output/${system}/${system}_solv.amb2gmx/

# Copy the relevant force field files
#cp -r ../../../ForceFieldFiles/toppar_$system/ toppar/
# last="${system: -1}"
# if [[ $last == 'A' ]]; then 
#     cp -r ../../../ForceFieldFiles/toppar_LNA/ toppar/
# elif [[ $last == 'H' ]]; then 
#     cp -r ../../../ForceFieldFiles/toppar_wt/ toppar/
# elif [[ $last == 'F' ]]; then 
#     cp -r ../../../ForceFieldFiles/toppar_2F/ toppar/
# fi

if [[ $system == *"F"* ]]; then
    cp -r ../../../ForceFieldFiles/toppar_2F/ toppar/
else
    cp -r ../../../ForceFieldFiles/toppar_wt/ toppar/
fi


# Modify the topology file for the given system
cp ../../../ForceFieldFiles/topol.top topol.top
sed -i "s/x/${system}/g" topol.top

# Update the .itp file for the given system
cp ${system}_solv_GMX.top toppar/${system}.itp
sed -i "s/${system}\\_solv/${system}/g" toppar/${system}.itp

# Remove unnecessary lines from the .itp file
first=$(sed -n "/molecule/{=;q;}" toppar/${system}.itp)
first=$(( first - 1 ))
sed -i "1,${first}d" toppar/${system}.itp

first=$(awk "/molecule/{c++} c==2{print NR;exit}" toppar/${system}.itp)
first=$(( first - 1 ))
sed -i "${first},$ d" toppar/${system}.itp

sed -i "/MG/d" toppar/${system}.itp

# Prepare the .gro file for GROMACS
cp ${system}_solv_GMX.gro ${system}.gro
first=$(sed -n "/MG/{=;q;}" ${system}.gro)
last=$(cat ${system}.gro | wc -l)
last=$(( last - 1 ))
sed -i "$first,${last}d" ${system}.gro

nr=$(cat ${system}.gro | wc -l)
nr=$(( nr - 3 ))
sed -i "2s/.*/ $nr/" ${system}.gro

# Set up the GROMACS environment and run initial commands
gmx editconf -f ${system}.gro -bt dodecahedron -d 1.2 -o ${system}_box.gro -c
gmx solvate -cp ${system}_box.gro -cs tip4p -p topol.top -o ${system}_solv.gro
gmx grompp -f em.mdp -r ${system}_solv.gro -c ${system}_solv.gro -p topol.top -o ion.tpr -maxwarn 100
printf 'SOL\n' | gmx genion -s ion.tpr -p topol.top -nname CL- -nq -1 -pname Mg2+ -pq +2 -conc 0.05 -neutral yes -o ${system}_ions.gro

# Create index file for GROMACS

nr_rna=$(sed '2q;d' ${system}_box.gro)

printf 'del 0-100 \n a 1-%s \n name 0 SOLU \n !0 \n name 1 SOLV \n q\n' "$nr_rna" | gmx make_ndx -f ${system}_ions.gro -o index.ndx


# Generate position restraints
echo SOLU | gmx genrestr -f ${system}_ions.gro -n index.ndx -o RNA_posres.itp

# Return to the original directory
cd ../../../
