#!/bin/bash
source ~/micromamba/etc/profile.d/micromamba.sh
micromamba activate AmberTools23

# Function to print current date and time
print_time() {
    date +"%Y-%m-%d %H:%M:%S"
}


for system in $(cat $1); do

    # Run run_gromacs.sh
    echo "Running run_gromacs.sh for $system"
    echo "Start time: $(print_time)"
    bash Scripts/run_gromacs_gromppMD.sh $system
    echo "End time: $(print_time)"
    echo

    if [ -f Output/$system/${system}_solv.amb2gmx/${system}_500ns_1.tpr ]; then
        echo "SUCCESS: $system"
    else
        echo "FAILURE: $system"
    fi

done

