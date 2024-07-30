system=$1

cp ForceFieldFiles/tleap-${system}xRNA-solv.in Output/tleap-${system}RNA-solv.in
sed -i "s/xRNA/${system}RNA/g" Output/tleap-${system}RNA-solv.in

tleap -f Output/tleap-${system}RNA-solv.in

acpype -p Output/${system}RNA_solv.prmtop -x Output/${system}RNA_solv.inpcrd

sleep 5