for system in wt 2F 2Fy LNA; do
    bash Scripts/prepare_files.sh $system
    bash Scripts/amber_tools.sh $system
done

