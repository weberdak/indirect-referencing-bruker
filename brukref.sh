#!/bin/bash

# Written by Daniel Weber. Revised Feb 21 2019.
# Shell script to indirectly reference 13C and 15N dimensions to DSS 1H chemical shift.
# Method as per Wishart, D.S., Bigam, C.G., Yao, J. et al. J Biomol NMR (1995) 6: 135. https://doi.org/10.1007/BF00211777
#
# INSTRUCTIONS
# ------------
# 1. Run a 1D 1H spectrum with DSS (10 to 500 uM) as an internal standard. Subsequent 2D and 3D spectra must be run using the same o1 value.
# 2. Process the 1D 1H spectrum with NMRPipe, setting the carrier xCAR to 0.000 ppm in the fid.com script.
# 3. Take the absolute value of the DSS peak position and use as the new xCAR in the fid.com script.
# 4. Process the 1D spectrum again with the new xCAR value. DSS should fall exactly on 0.000 ppm.
# 5. Copy this script in the directory of the 2D/3D spectrum and run by: 
#    bash brukref.sh <acqus file> <xCAR>
# For example, if the DSS shift was -4.725 ppm and step 3, then the command should be "bash brukref.sh acqus 4.725"
# 6. Use output values as y/zCAR for 15N/13C nuclei in fid.com script for the 2D/3D spectra.

# Associative array of gamma values. Add additional nuclei if desired. Values from above citation.
declare -A gammas
gammas=( ['1H']=1.000000000 ['15N']=0.101329118 ['13C']=0.251449530 )

# Retrieve nuclei and transmitter frequencies from acqus file
PAR=$1
REF=$2
NUC1=$(awk -F '[<|>]' '/NUC1/ {print $2}' $1)
NUC2=$(awk -F '[<|>]' '/NUC2/ {print $2}' $1)
NUC3=$(awk -F '[<|>]' '/NUC3/ {print $2}' $1)
SFO1=$(awk '/SFO1/ {print $2}' $1)
SFO2=$(awk '/SFO2/ {print $2}' $1)
SFO3=$(awk '/SFO3/ {print $2}' $1)

# Calculate zero frequencies from specified reference and ratios of gammas
ZERO1=$(echo "$SFO1-(($2/1000000)*$SFO1)" | bc -l)
ZERO2=$(echo "$ZERO1*(${gammas[$NUC2]}/${gammas[$NUC1]})" | bc -l)
ZERO3=$(echo "$ZERO1*(${gammas[$NUC3]}/${gammas[$NUC1]})" | bc -l)

# Calculate referenced chemical shift of carrier frequencies for NMRPipe fid.com script
CAR1=$(echo "(($SFO1-$ZERO1)/$SFO1)*1000000" | bc -l)
CAR2=$(echo "(($SFO2-$ZERO2)/$SFO2)*1000000" | bc -l)
CAR3=$(echo "(($SFO3-$ZERO3)/$SFO3)*1000000" | bc -l)

# Output values to terminal
echo Set $NUC1 CAR at $(printf "%.*f\n" 3 $CAR1) ppm
echo Set $NUC2 CAR at $(printf "%.*f\n" 3 $CAR2) ppm
echo Set $NUC3 CAR at $(printf "%.*f\n" 3 $CAR3) ppm

