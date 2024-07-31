# for system in 2F 2Fy LNA; do
for system in wt 2F 2Fy LNA; do
    mkdir -p Output/$system
    rm -r Output/$system/*
    bash Scripts/prepare_files.sh $system
    bash Scripts/amber_tools.sh $system
    bash Scripts/prepare_gromacs.sh $system
    bash Scripts/run_gromacs.sh $system
done

