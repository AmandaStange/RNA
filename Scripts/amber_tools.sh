#!/bin/bash

# Retrieve the system argument
system=$1

# Copy the tleap input file for the given system to the Output directory
cp ForceFieldFiles/tleap-${system}xRNA-solv.in Output/${system}/tleap-${system}RNA-solv.in

# Modify the copied tleap input file to replace placeholders with actual system names
sed -i "s/xRNA/${system}RNA/g" Output/${system}/tleap-${system}RNA-solv.in
sed -i "s/x\\//${system}\\//g" Output/${system}/tleap-${system}RNA-solv.in

# Run tleap to generate the topology and coordinate files
tleap -f Output/${system}/tleap-${system}RNA-solv.in

# Change to the Output directory for the given system
cd Output/${system}/

# Use acpype to convert Amber files to GROMACS files
acpype -p ${system}RNA_solv.prmtop -x ${system}RNA_solv.inpcrd 

# Return to the original directory
cd ../../

# Wait for 1 second
sleep 1
