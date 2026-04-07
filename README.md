# IMPORTANT

The files `f-sugars.lib` and `f-sugars.frcmod` are placeholders included only so the repository structure is complete (`f-sugars.frcmod` contains no data and `f-sugars.lib` is a copy of the UN parameters from parmBSC1.lib). Actual parameters for fluorinated sugars are required only for fluorinated systems and should be requested from the authors of:

El-Khoury, R, et al. *Formation of left-handed helices by C2′-fluorinated nucleic acids under physiological salt conditions.* Nucleic Acids Research (2024).

These files are not required for the non-fluorinated demo system included in this repository,

# RNA processing and simulation setup workflow

This repository contains scripts for preparing RNA structures for molecular simulations with AmberTools and GROMACS. The workflow renames residues and atoms where needed, prepares Amber input files, converts Amber outputs to GROMACS format, builds the solvated system, adds ions, performs minimisation and equilibration, and prepares production `.tpr` files.


## Repository layout

```text
RNA/
├── ForceFieldFiles/
├── Output/
├── Scripts/
│   ├── amber_tools.sh
│   ├── prepare_files.sh
│   ├── prepare_gromacs.sh
│   ├── rename.py
│   └── run_gromacs.sh
├── Structures/
│   ├── PDB files used in the manuscript
├── example/
│   ├── README.md
│   ├── expected_output/
│   └── PLACE_DEMO_INPUT_FILES_HERE.txt
├── CITATION.cff
├── environment.yml
├── LICENSE
├── README.md
└── run.sh
```

## What the workflow does

### `run.sh`
Top-level driver script. It:
1. activates the `rna` micromamba environment;
2. loops over all files in `Structures/`;
3. creates a per-system output directory in `Output/<system>/`;
4. runs all processing and preparation scripts in sequence;
5. checks whether production `.tpr` files were created successfully.

### `Scripts/prepare_files.sh`
Runs `Scripts/rename.py` and removes `CONECT` records from the generated PDB file.

### `Scripts/rename.py`
Reads `Structures/<system>.pdb`, renames bases according to hard-coded rules, adjusts some atom names, and writes `Output/<system>/<system>_rename.pdb`.

### `Scripts/amber_tools.sh`
Copies and edits the `tleap` input, runs `tleap`, and converts the resulting Amber files to GROMACS format with `acpype`.

### `Scripts/prepare_gromacs.sh`
Copies topology support files, adapts the topology for the current system, prepares the coordinate file, solvates the system, adds ions, creates an index file, and generates position restraints.

### `Scripts/run_gromacs.sh`
Runs:
- energy minimisation;
- two equilibration stages;
- preparation of four production `.tpr` files.

## System requirements

### Operating systems tested
- Ubuntu 20.04 LTS

### Software dependencies
The current repository explicitly requires:
- Python 3
- AmberTools23
- GROMACS 2024.0
- `acpype`
- `tleap`
- standard Unix tools: `bash`, `sed`, `awk`, `cp`, `rm`


### Non-standard hardware
No non-standard hardware is required for structure preparation and file generation.

For production molecular dynamics, multi-core CPUs are recommended and GPU acceleration may substantially reduce runtime, depending on your GROMACS build and local hardware.

## Installation

### micromamba

```bash
git clone https://github.com/AmandaStange/RNA.git
cd RNA
micromamba env create -f environment.yml
micromamba activate rna
```

Using micromamba this environment should take about 10 minutes to install.

## Input files required

For each system, the repository expects:
- `Structures/<system>.pdb`
- compatible force-field support files in `ForceFieldFiles/`
- a `tleap` template file at `ForceFieldFiles/tleap-xRNA.in`
- GROMACS mdp files in `ForceFieldFiles/mdps/`

The workflow assumes that the system name is derived from the file name stem in `Structures/`.

### Fluorinated sugar parameters

The files `f-sugars.frcmod` and `f-sugars.lib` included in this repository are placeholder files and must be replaced with the actual parameter files before running the workflow.

The required fluorinated sugar parameters should be requested from:

El-Khoury R, et al. *Formation of left-handed helices by C2′-fluorinated nucleic acids under physiological salt conditions.* Nucleic Acids Research (2024).

Once obtained, place the supplied `f-sugars.frcmod` and `f-sugars.lib` files in the appropriate force field directory before running the preparation scripts.

## How to run the demo

A small demo dataset is included in `example/`. To run only the demo:

```bash
cp example/exampleRNA-OH.pdb Structures/
./run.sh
```

## Expected output

For a successfully processed system named `exampleRNA-OH`, the workflow should create:

```text
Output/exampleRNA-OH/
├── exampleRNA-OH_rename.pdb
├── tleap-exampleRNA-OH-solv.in
├── exampleRNA-OH_solv.inpcrd
├── exampleRNA-OH_solv.prmtop
├── exampleRNA-OH_solvated.pdb
└── exampleRNA-OH_solv.amb2gmx/
    ├── exampleRNA-OH_solv_GMX.gro
    ├── posre_exampleRNA-OH_solv.itp
    ├── exampleRNA-OH_solv_GMX.top
    ├── em.mdp
    ├── acpype.log
    ├── md.mdp
    ├── rungmx.sh
    ├── toppar/
    ├── exampleRNA-OH.gro
    ├── exampleRNA-OH_box.gro
    ├── exampleRNA-OH_solv.gro
    ├── ion.tpr
    ├── topol.top
    ├── exampleRNA-OH_ions.gro
    ├── index.ndx
    ├── RNA_posres.itp
    ├── min.tpr
    ├── min.gro
    ├── min.edr
    ├── min.trr
    ├── min.log
    ├── eq1.tpr
    ├── eq1.cpt
    ├── eq1.gro
    ├── eq1.edr
    ├── eq1.xtc
    ├── eq1.trr
    ├── eq1.log
    ├── eq2.tpr
    ├── eq2.cpt
    ├── eq2.xtc
    ├── eq2.log
    └── eq2.edr
    ├── eq2.gro
    ├── exampleRNA-OH_500ns_1.tpr
    ├── exampleRNA-OH_500ns_2.tpr
    ├── exampleRNA-OH_500ns_3.tpr
    └── exampleRNA-OH_500ns_4.tpr
```

The final success criterion currently used by `run.sh` is the presence of:

```text
Output/exampleRNA-OH/exampleRNA-OH_solv.amb2gmx/exampleRNA-OH_500ns_1.tpr
```

## Typical runtime on a normal desktop computer

On a desktop running Ubuntu 20.04 with an NVIDIA GeForce RTX 4090 GPU and an Intel(R) Xeon(R) w5-3435X processor (32 cores) expected runtimes are:
- 5 minutes for a small motifs (such as an isolated kissing loop or the example pdb) for the creation of files and the minimization and first equilibration. The second equilibration will then take roughly 1 hour if equilibration kept at 50 ns.
- 30 minutes for a larger construct (such as the PXT aptamer) for the creation of files and the minimization and first equilibration. The second equilibration will then take roughly 13 hours if equilibration kept at 50 ns.

## Running the workflow on your own data

To prepare a new RNA system:

1. Place the PDB file in `Structures/`.
2. Name the file so that the stem is the intended system name.
3. Ensure the residue and atom naming conventions are compatible with the renaming logic in `Scripts/rename.py`.
4. Make sure `ForceFieldFiles/tleap-xRNA.in` and the topology support files are appropriate for the new system.
5. Run:

```bash
./run.sh
```

### Important assumptions built into the current code
- `rename.py` contains **system-specific renaming rules** based on the first two characters of the system name and selected residue numbers.
- the workflow assumes a fixed repository layout;
- the `run.sh` script activates a micromamba environment named `rna`;
- the conversion and GROMACS preparation steps assume that the generated filenames follow the current AmberTools/acpype naming scheme.

If you apply the workflow to a substantially different RNA construct, inspect `rename.py` and the `tleap` input carefully before running the full pipeline.


## Licence

This repository is released under the MIT Licence. See `LICENSE`.

## Citation

If you use this repository, please cite the associated manuscript and the force-field reference below.

### Software citation
See `CITATION.cff`.

### Force-field reference
El-Khoury, R, et al. *Formation of left-handed helices by C2′-fluorinated nucleic acids under physiological salt conditions.* Nucleic Acids Research (2024).
Zgarbova, M. et ak. *Refinement of the Cornell et al. Nucleic Acids Force Field Based on Reference Quantum Chemical Calculations of Glycosidic Torsion Profiles*. J. Chem. Theory Comput., 2011, 7, 2886–2902. 


