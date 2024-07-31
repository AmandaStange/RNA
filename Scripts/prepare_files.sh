system=$1

python Scripts/rename.py $system

sed -i '/CONECT/d' Output/${system}/${system}RNA_rename.pdb

