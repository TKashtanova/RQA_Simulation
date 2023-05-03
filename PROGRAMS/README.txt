Decription of the code source files:

'run_gDPM.ipynb' contains commands to run the gDPM in Google Colab

'fAnimation.m' animates the system setup

'fCollimator.m' builds a 3D collimator 

'fEnergy.m' filters detected by PCD photons based on the specified energy threshold

'fInput_full.m' reads original (full size) gDPM output files

'fInput_reduced.m' reads gDPM output files reduced in size

'fParticleView.m' shows photon position in the system environment

'fPCD.m' records photons detected by PCD using angular collimation

'fPCD_col.m' records photons detected by PCD with a 3D collimator placed in front of it

'fPcount.m' computes longitudinal photon counts

'fPcountMap.m' creates a heatmap of detected photon counts 

'fPvsDose.m' analyses the longitudinal profiles of simulated dose and scattered photon counts

'Instructions.txt' contains instructions for running the 'main.m' file

'main.m' is the main program responsible for the execution of other source files

'phantom_hmg.m' creates a density file for a water phantom of the desired dimensions

'phantom_htrg.m' creates definition files of two heterogeneous phantoms

'sphere_center.m' evaluates the scoring sphere center position

'unit_testing.m' unit tests of the code major functions



Datasets contain gDPM output files obtained with specific simulation settings.

In '5_Sphere_0.0.0':
  phantom material - water
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (0,0,0) cm, 
  number of simulated histories is 10^5
  files size - original (full)

In '5_Sphere_15.15.15':
  phantom material - water
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^5
  files size - original (full)

In '10_W_Ph30_Beam28_cut':
  phantom material - water
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^10
  files size - reduced

In '10_W_Ph15_Beam7_cut':
  phantom material - water
  phantom side length is 15 cm
  beam is 7 x 7 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^10
  files size - reduced

In '10_WB_Ph30_Beam28_cut':
  phantom material - water + bone
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^10
  files size - reduced

In '10_WBA_Ph30_Beam28_cut':
  phantom material - water + bone + air
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^10
  files size - reduced

In 'data_dub':
  phantom material - water
  phantom side length is 30 cm
  beam is 28 x 28 cm at isocenter
  sphere center is at (15,15,15) cm
  number of simulated histories is 10^8
  files size - both full and reduced



Notations:

PCD - photon counting detector
gDPM - GPU-based dose planning method [1,2]


References:
[1] Jia, X. & Jiang, S.B. (2011). gDPM v2.0. A GPU-based Monte Carlo simulation 
    package for radiotherapy dose calculation. The Center for Advanced Radiotherapy 
    Technologies (CART), UCSD.
[2] Jia, X., Ziegenhein, P., & Jiang, S. B. (2014). GPU-based high-performance 
    computing for radiation therapy. Physics in Medicine and Biology, 59(4), 
    p. R151–R182.

