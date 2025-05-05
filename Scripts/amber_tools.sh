#!/bin/bash

# Retrieve the system argument
system=$1


#for i in $(ls Output/); do last="${i: -1}"; if [[ $last == 'A' ]]; then echo "$last, LNA"; elif [[ $last == 'H' ]]; then echo "$last wt"; elif [[ $last == 'F' ]]; then echo "$last F"; fi; done

# Copy the tleap input file for the given system to the Output directory

# last="${system: -1}"
# if [[ $last == 'A' ]]; then 
#     cp ForceFieldFiles/tleap-LNAxRNA-solv.in Output/${system}/tleap-${system}-solv.in
# elif [[ $last == 'H' ]]; then 
#     cp ForceFieldFiles/tleap-wtxRNA-solv.in Output/${system}/tleap-${system}-solv.in
# elif [[ $last == 'F' ]] || [[ $system == *"Fy"* ]]; then 
#     cp ForceFieldFiles/tleap-2FxRNA-solv.in Output/${system}/tleap-${system}-solv.in
# fi

cp ForceFieldFiles/tleap-xRNA.in Output/${system}/tleap-${system}-solv.in

# Modify the copied tleap input file to replace placeholders with actual system names
sed -i "s/x_/${system}_/g" Output/${system}/tleap-${system}-solv.in
sed -i "s/x\\//${system}\\//g" Output/${system}/tleap-${system}-solv.in

# Run tleap to generate the topology and coordinate files
tleap -f Output/${system}/tleap-${system}-solv.in

# Change to the Output directory for the given system
cd Output/${system}/

# Use acpype to convert Amber files to GROMACS files
acpype -p ${system}_solv.prmtop -x ${system}_solv.inpcrd 

# Return to the original directory
cd ../../

# Wait for 1 second
sleep 1
