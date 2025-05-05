#!/bin/bash

# Retrieve the system argument
system=$1


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
