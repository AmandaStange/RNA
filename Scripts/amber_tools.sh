system=$1


cp ForceFieldFiles/tleap-${system}xRNA-solv.in Output/${system}/tleap-${system}RNA-solv.in



sed -i "s/xRNA/${system}RNA/g" Output/${system}/tleap-${system}RNA-solv.in
sed -i "s/x\//${system}\//g" Output/${system}/tleap-${system}RNA-solv.in

tleap -f Output/${system}/tleap-${system}RNA-solv.in

cd Output/${system}/

acpype -p ${system}RNA_solv.prmtop -x ${system}RNA_solv.inpcrd 

cd ../../

sleep 1