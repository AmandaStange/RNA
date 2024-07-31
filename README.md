
# RNA Processing Scripts

This repository contains scripts for preparing and processing RNA structures using various computational tools. The scripts handle tasks such as renaming files, preparing input files for simulation software, and running simulations.

## Scripts Overview


### 1. `prepare_files.sh`

This script performs the following tasks:
- Runs a Python script to rename files for the given system.
- Removes CONECT records from the PDB file.

### 2. `rename.py`

This Python script processes the PDB file for the given system:
- Modifies base names based on specific conditions.
- Formats the PDB lines and writes the modified PDB file to the Output directory.

### 3. `amber_tools.sh`

This script performs the following tasks:
- Copies the tleap input file for the given system to the Output directory.
- Modifies the copied tleap input file to replace placeholders with actual system names.
- Runs tleap to generate the topology and coordinate files.
- Uses acpype to convert Amber files to GROMACS files.

### 4. `prepare_gromacs.sh`

This script performs the following tasks:
- Copies the relevant force field files.
- Modifies the topology file for the given system.
- Prepares the .gro file for GROMACS.
- Sets up the GROMACS environment and runs initial commands.

### 5. `run_gromacs.sh`

This script runs the following GROMACS commands:
- Energy minimization.
- Equilibration.
- Prepares input files for production runs.

## Usage

1. Ensure all required files and directories are in place.
2. Run the main script `dsRNA.sh` to execute the entire workflow:
   ```bash
   ./dsRNA.sh
   ```
3. The output will be generated in the `Output` directory.

## Requirements

- GROMACS 2024.0
- AmberTools23 (python package)
- Python 3

