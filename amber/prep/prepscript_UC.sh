#!/bin/bash -f 

set -x

ROOT=$1



cp ${ROOT}.pdb ${ROOT}_Orig.pdb
reduce -trim ${ROOT}.pdb >tmp.pdb 2>trim.err
grep -v "ATOM.........EPW" tmp.pdb > ${ROOT}_NoH.pdb

# Prepare coordinates for xtal simulation  AMBER
cat > rnatleap << EOF
source leaprc.ff10
loadamberparams frcmod.ionsjc_tip4pew
loadamberparams frcmod.tip4pew
WAT = T4E
HOH = T4E
loadAmberPrep MPD.prepin
x = loadpdb "${ROOT}_NoH.pdb"
bond x.39.SG x.94.SG
bond x.25.SG x.83.SG
bond x.64.SG x.71.SG
bond x.57.SG x.109.SG
bond x.166.SG x.221.SG
bond x.152.SG x.210.SG
bond x.191.SG x.198.SG
bond x.184.SG x.236.SG
setBox x vdw 10.0
saveAmberParm x ${ROOT}.prmtop ${ROOT}.rst7
quit
EOF

tleap -f rnatleap > tleap.out
ambpdb -p ${ROOT}.prmtop < ${ROOT}.rst7 > ${ROOT}.pdb

## Set the unit cell dimensions
#ChBox \
  #-c ${ROOT}.rst7 \
  #-o ${ROOT}.rst7 \
  #-X 30.000 \
  #-Y 38.270 \
  #-Z 53.170 \
  #-al 90.00  \
  #-bt 106.00 \
  #-gm 90.00
