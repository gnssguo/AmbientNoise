#!/bin/bash 

#RMS Feb 2017 
#Script to run individual instance of the itomo program
#This should be in the dispersion curves directory

if [ "$#" != 2 ]; then
    echo "Usage: Run_tomo.sh input_file period"
    echo "e.g. Run_tomo.sh data30s_ph.txt 30"
    echo "Best used in conjunction with a wrapper"
    exit 1 
fi

data_file=$1
period=$2


latmin=51.5
latmax=73.5
longmin=188.5
longmax=237.5

#increment in lat/lon for the tomography (defines number of points)
inc=0.1

#strength of smoothing penalty function
alpha=600

#roughly 1 wavelength radius smoothing (claim v = 3.2)
sigma=`echo $period 3.2 | awk '{print $1 * $2}'`

#strength of damping function
beta=40

###NOTE!
#The directory where this script is run must contain a file called contour.ctr

if [ ! -f contour.ctr ]; then 
    echo "contour.ctr not found!"
    exit 1
fi 


#Tomography code run
/data/dna/rmartin/Ambient_noise/CODES/src/ITOMO/bin/itomo.exe $data_file $data_file $period << EOF
me
4
5
$beta
6
$alpha
$sigma
$sigma
7
$latmin $latmax $inc
8
$longmin $longmax $inc
12
0.1
0.5
16
19
q
go
EOF

# the itomo program doesn't do a great job putting values at every point it should, so here the gmt command surface is used to interpolate onto a common grid
temp_file=`ls ${data_file}_${period}.1`
surface $temp_file -Gtemp_${data_file}.grd -R${longmin}/${longmax}/${latmin}/${latmax} -I${inc}/${inc}
grd2xyz temp_${data_file}.grd > $temp_file
