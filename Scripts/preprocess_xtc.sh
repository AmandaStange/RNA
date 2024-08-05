for i in wt 2F 2Fy LNA; do
    gmx trjcat -f $i/${i}RNA_solv.amb2gmx/*part*.xtc -o $i/${i}RNA_solv.amb2gmx/$i.xtc
    printf 'del 0-20\n ri 1-16\n ri 5\n q\n' | gmx make_ndx -f $i/${i}RNA_solv.amb2gmx/${i}*1.tpr -o $i/${i}RNA_solv.amb2gmx/center.ndx
    echo 0 | gmx traj -f $i/${i}RNA_solv.amb2gmx/$i.xtc -s $i/${i}RNA_solv.amb2gmx/${i}*1.tpr -pbc yes -nojump yes -oxt $i/${i}RNA_solv.amb2gmx/${i}_traj.xtc -n $i/${i}RNA_solv.amb2gmx/center.ndx
    echo 0 0 | gmx trjconv -f $i/${i}RNA_solv.amb2gmx/${i}_traj.xtc -s $i/${i}RNA_solv.amb2gmx/${i}*1.tpr -fit rot+trans -o $i/${i}RNA_solv.amb2gmx/${i}_fit.xtc -n $i/${i}RNA_solv.amb2gmx/center.ndx
    echo 0 0 | gmx trjconv -f $i/${i}RNA_solv.amb2gmx/${i}_traj.xtc -s $i/${i}RNA_solv.amb2gmx/${i}*1.tpr -fit rot+trans -o $i/${i}RNA_solv.amb2gmx/${i}_fit.gro -dump 0 -n $i/${i}RNA_solv.amb2gmx/center.ndx
done


