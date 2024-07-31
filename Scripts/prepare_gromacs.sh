#!/bin/bash

# Retrieve the system argument
system=$1

# Change to the appropriate directory
cd Output/${system}/${system}RNA_solv.amb2gmx/

# Copy the relevant force field files
cp -r ../../../ForceFieldFiles/toppar_$system/ toppar/

# Modify the topology file for the given system
cp ../../../ForceFieldFiles/topol.top topol.top
sed -i "s/xRNA/${system}RNA/g" topol.top

# Update the .itp file for the given system
cp ${system}RNA_solv_GMX.top toppar/${system}RNA.itp
sed -i "s/${system}RNA\\_solv/${system}RNA/g" toppar/${system}RNA.itp

# Remove unnecessary lines from the .itp file
first=$(sed -n "/molecule/{=;q;}" toppar/${system}RNA.itp)
first=$(( first - 1 ))
sed -i "1,${first}d" toppar/${system}RNA.itp

first=$(awk "/molecule/{c++} c==2{print NR;exit}" toppar/${system}RNA.itp)
first=$(( first - 1 ))
sed -i "${first},$ d" toppar/${system}RNA.itp

sed -i "/MG/d" toppar/${system}RNA.itp

# Prepare the .gro file for GROMACS
cp ${system}RNA_solv_GMX.gro ${system}RNA.gro
first=$(sed -n "/MG/{=;q;}" ${system}RNA.gro)
last=$(cat ${system}RNA.gro | wc -l)
last=$(( last - 1 ))
sed -i "$first,${last}d" ${system}RNA.gro

nr=$(cat ${system}RNA.gro | wc -l)
nr=$(( nr - 3 ))
sed -i "2s/.*/ $nr/" ${system}RNA.gro

# Set up the GROMACS environment and run initial commands
gmx editconf -f ${system}RNA.gro -bt dodecahedron -d 2 -o ${system}RNA_box.gro -c
gmx solvate -cp ${system}RNA_box.gro -cs tip4p -p topol.top -o ${system}RNA_solv.gro
gmx grompp -f em.mdp -r ${system}RNA_solv.gro -c ${system}RNA_solv.gro -p topol.top -o ion.tpr -maxwarn 100
printf 'SOL\n' | gmx genion -s ion.tpr -p topol.top -nname CL- -nq -1 -pname Mg2+ -pq +2 -conc 0.05 -neutral yes -o ${system}RNA_ions.gro

# Create index file for GROMACS
printf 'del 0-20\n ri 1-16\n name 0 SOLU \n !0 \n name 1 SOLV \n q\n' | gmx make_ndx -f ${system}RNA_ions.gro -o index.ndx

# Generate position restraints
echo SOLU | gmx genrestr -f ${system}RNA_ions.gro -n index.ndx -o RNA_posres.itp

# Return to the original directory
cd ../../../
