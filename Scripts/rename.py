import sys


#for i in Structures/*; do sed -i  "s/ H2' UFT/H2'' UFT/" $i ; done
#for i in Structures/*; do sed -i  "s/ H2' CFZ/H2'' CFZ/" $i ; done

# Retrieve the system argument
system = sys.argv[1]

motif = system[:2]


amino = "ALA CYS ASP GLU PHE GLY HIS ILE LYS LEU MET ASN PRO GLN ARG SER THR VAL TRP TYR NMA NME ACE".split()

# Read the input PDB file for the given system
with open(f'Structures/{system}.pdb', 'r') as f:
    new_file = ''
    lines = f.readlines()
    for line in lines:
        l = line.split()
        if l[0] in ['ATOM', 'HETATM']:
            base = l[3]
            resid = int(l[5])

            # Modify base names based on specific conditions
            if base in ['CFZ', 'UFT', 'AF2', 'GF2']:
                base = 'F' + base[0]



            if base in ['UMX']:
                base = 'LCU'

            if system != '2Fy' and base != 'LCA':
                if motif == 'tl':
                    if resid in [49]:
                        base += '5'
                    if resid in [64]:
                        base += '3'
                elif motif == 'co':
                    if 'long' in system or "J" in system:
                        if resid in [190,220,110,137]:
                            base += '5'
                        if resid in [212,243,132,159]:
                            base += '3'
                    else:
                        if resid in [116,141,196,225]:
                            base += '5'
                        if resid in [128,153,208,237]:
                            base += '3'
                elif motif == 'kl':
                    #if resid in [197,332]:
                    if resid in [194,330]:
                        base += '5'
                    if resid in [214,348]:
                        base += '3'
                elif motif == 'ah':
                    #if resid in [197,332]:
                    if resid in [1,27]:
                        base += '5'
                    if resid in [22,48]:
                        base += '3'
                elif motif == '5H':
                    if resid in [1]:
                        base += '5'
                    if resid in [552]:
                        base += '3'
                elif motif == 'PX':
                    if resid in [1]:
                        base += '5'
                    if resid in [238]:
                        base += '3'
                elif motif == 'sp':
                    if resid in [84]:
                        base += '5'
                    if resid in [134]:
                        base += '3'

            # Format the new PDB line
            if base in ['LCA','LCU','LCC','LCG']:
                new_file += f'HETATM {l[1]:>4} {l[2]:<4} {base:<3} {l[4]} {resid:>3}    {l[6]} {l[7]} {l[8]}  {l[9][:4]}{l[9][4:]:>6}           {l[10]}\n'
            else:
                atom = l[2]
                if 'F' in base and atom == "H2'":
                    atom = "H2''"
                    print(base, atom)
                
                if base == 'NMA':
                    base = 'NME'

                if base == 'NME' and atom == 'CA':
                    atom = 'C'


                # if base in ['ACE', 'NME'] and atom[:2] in ['1H', '2H', '3H']:
                #     atom = f'HH3{atom[0]}'

                

                if base in amino :
                    new_file += f'ATOM  {l[1]:>5} {atom:<4} {base:<3} {l[4]}{resid:>4}    {l[6]:<8}{l[7]:<8}{l[8]:<8}{l[9]:>6}{l[10]:>6}           {l[11]}\n'
                else:
                    new_file += f'HETATM{l[1]:>5} {atom:<4} {base:<3} {l[4]}{resid:>4}    {l[6]:<8}{l[7]:<8}{l[8]:<8}{l[9][:4]:>6}{l[9][4:]:>6}           {l[10]}\n'

        else:
            new_file += line

    # Write the modified PDB file to the Output directory
    with open(f'Output/{system}/{system}_rename.pdb', 'w') as f_out:
        f_out.write(new_file)


# ATOM   1664
# HETATM 1664