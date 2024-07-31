import sys

# Retrieve the system argument
system = sys.argv[1]

# Read the input PDB file for the given system
with open(f'dsRNA/{system}_dsRNA.pdb', 'r') as f:
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

            if system != '2Fy' and base != 'LCA':
                if resid == 1:
                    base += '5'
                if resid == 8:
                    base += '3'

            # Format the new PDB line
            if base == 'LCA':
                new_file += f'HETATM  {l[1]:>3}  {l[2]:<3} {base:<3} {l[4]}  {resid:>2}     {l[6]} {l[7]} {l[8]}  {l[9]}  {l[10]}           {l[11]}\n'
            else:
                new_file += f'HETATM  {l[1]:>3}  {l[2]:<3} {base:<3} {l[4]}  {resid:>2}     {l[6]} {l[7]} {l[8]}  {l[9]}  {l[10]}           {l[11]}\n'

        else:
            new_file += line

    # Write the modified PDB file to the Output directory
    with open(f'Output/{system}/{system}RNA_rename.pdb', 'w') as f_out:
        f_out.write(new_file)
