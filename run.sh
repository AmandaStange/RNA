#!/bin/bash
source ~/micromamba/etc/profile.d/micromamba.sh
micromamba activate rna

# Function to print current date and time
print_time() {
    date +"%Y-%m-%d %H:%M:%S"
}


for system in exampleRNA-OH; do
    mkdir -p Output/$system
    rm -r Output/$system/*

    # Run prepare_files.sh
    echo "Running prepare_files.sh for $system"
    echo "Start time: $(print_time)"
    bash Scripts/prepare_files.sh $system
    echo "End time: $(print_time)"
    echo

    # Run amber_tools.sh
    echo "Running amber_tools.sh for $system"
    echo "Start time: $(print_time)"
    bash Scripts/amber_tools.sh $system
    echo "End time: $(print_time)"
    echo

    # Run prepare_gromacs.sh
    echo "Running prepare_gromacs.sh for $system"
    echo "Start time: $(print_time)"
    bash Scripts/prepare_gromacs.sh $system
    echo "End time: $(print_time)"
    echo

    # Run run_gromacs.sh
    echo "Running run_gromacs.sh for $system"
    echo "Start time: $(print_time)"
    bash Scripts/run_gromacs.sh $system
    echo "End time: $(print_time)"
    echo

    if [ -f Output/$system/${system}_solv.amb2gmx/${system}_500ns_1.tpr ]; then
        echo "SUCCESS: $system"
    else
        echo "FAILURE: $system"
    fi

done

