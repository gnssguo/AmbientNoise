#/bin/bash

##RMS 2017
#GMT script to plot phase velocity map for Alaska
GMT=gmt

$GMT gmtset BASEMAP_TYPE_FANCY
$GMT set FONT_ANNOT_PRIMARY 20p,Helvetica


J=B-147/56.0/52/73/12i #map projection is Albers Conic Equal Area (see GMT docs)
R=-168/-128/56/71 #Whole of Alaska and Adjacent Canada


Topo=/home/rmartinshort/Documents/Berkeley/Ambient_Noise/Depth_invert/plotting/plottingdata/Alaska_lr.nc
faults=/home/rmartinshort/Documents/Berkeley/Ambient_Noise/Depth_invert/plotting/plottingdata/Alaska_faults.dat
yakslab=/home/rmartinshort/Documents/Berkeley/Ambient_Noise/Depth_invert/plotting/plottingdata/Yakutat_subducted_extent.dat

#Make a multi-panel image of Alaska phase velocities
ps=Example_velmaps.ps



##################
# depth  = 10 km
##################

GRDbase=dslice_10.grd
GRD=dslice_10_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details 
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -Y26.5i -P -K --PS_MEDIA=Custom_43ix38i > $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps

#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

##################
# depth = 15 km
##################

GRDbase=dslice_15.grd
GRD=dslice_15_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth
#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -O -K -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END


##################
# depth = 20 km
##################

GRDbase=dslice_20.grd
GRD=dslice_20_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)


#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END


##################
# depth = 25 km
##################

GRDbase=dslice_25.grd
GRD=dslice_25_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth
#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-19.5i -X-31i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END


##################
# depth = 30 km
##################

GRDbase=dslice_30.grd
GRD=dslice_30_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

##################
# depth = 35 km
##################

GRDbase=dslice_35.grd
GRD=dslice_35_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

##################
# depth = 40 km
##################

GRDbase=dslice_40.grd
GRD=dslice_40_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-19.5i -X-31i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

##################
# depth = 45 km
##################

GRDbase=dslice_45.grd
GRD=dslice_45_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth
#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O -K >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

##################
# depth = 50 km
##################

GRDbase=dslice_50.grd
GRD=dslice_50_masked.grd

#median value
med=$(gmt grdinfo -L1 $GRDbase | sed -n '10p' | cut -d ' ' -f 3)
minvel=$(echo "$med-0.5" | bc)
maxvel=$(echo "$med+0.5" | bc)

#Give the model a name and plot the details
MODNAME="Alaska crustal vels"

depth=$(echo $GRD | awk -F "_" '{print $2}' | awk -F "." '{print $1}')
echo $depth

#make the color scheme
#minval=3.0
#maxval=4.5
#$GMT makecpt -Cjet -T$minval/$maxval/0.01 -Z -I > absvels.cpt

#Generate the appropriate color scheme
./Generate_colscheme.py $minvel $maxvel
cpt=vels.cpt

#plot the image
$GMT grdimage $GRD -R$R -J$J -Ba8.0f2.0/a4.0f2.0 -C$cpt -P -K -O -Y-7i -X11i >> $ps

#plot the coastlines
$GMT pscoast -R$R -J$J -Ia -Wthinnest -A1000 -Di -P -O -K >> $ps

#plot topography
$GMT grdcontour $Topo -J$J -R$R -Wthinnest -C1000 -S1000 -O -K >> $ps

#Plot on the faults
$GMT psxy $faults -m -J$J -Rd$R -Wthickest,purple -O -K  >> $ps

#Plot the extent of the subducted yakutat slab
$GMT psxy $yakslab -J$J -Rd$R -Wthickest -O -K >> $ps


#Make the scale
$GMT psscale -D2.3i/-0.8i/4.0i/0.2ih -E -C$cpt -Ba0.2f0.2g0.2/:"Vs [km/s]": -O -K >> $ps

$GMT pstext << END -X3i -Y7i -R0/10.5/0/11 -Jx1 -O >> $ps
0.75 7.5 22 0 1 LM ${MODNAME} ${depth}
END

#------------------------------------

#Post-processing stuff
$GMT ps2raster $ps -P -Tf
rm *.ps
evince Example_velmaps.pdf
