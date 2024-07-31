#!/bin/bash

# Retrieve the system argument
system=$1

# Run the rename script for the given system
python Scripts/rename.py $system

# Remove CONECT records from the PDB file
sed -i '/CONECT/d' Output/${system}/${system}RNA_rename.pdb
