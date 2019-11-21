## Instructions

1. Run a 1D 1H spectrum with DSS (10 to 500 uM) as an internal standard. Subsequent 2D and 3D spectra must be run using the same o1 value.

2. Process the 1D 1H spectrum with NMRPipe, setting the carrier xCAR to 0.000 ppm in the fid.com script.

3. Take the absolute value of the DSS peak position and use as the new xCAR in the fid.com script.

4. Process the 1D spectrum again with the new xCAR value. DSS should fall exactly on 0.000 ppm.

5. Copy this script in the directory of the 2D/3D spectrum and run by:

		bash brukref.sh <acqus file> <xCAR>
	
	For example, if the DSS shift was -4.725 ppm and step 3, then the command should be 
		
		bash brukref.sh acqus 4.725
	
6. Use output values as y/zCAR for 15N/13C nuclei in fid.com script for 2D/3D spectra.