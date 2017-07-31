Codebase associated with the paper

Sankaranarayanan et al. “Video Compressive Sensing for Spatial Multiplexing Cameras using Motion-Flow Models,” SIAM J. Imaging Sciences, 8(3), pp. 1489-1518, 2015


@article{sankaranarayanan15video,
author    = {Aswin C. Sankaranarayanan and
Lina Xu and
Christoph Studer and
Yun Li and
Kevin F. Kelly and
Richard Baraniuk},
title     = {Video Compressive Sensing for Spatial Multiplexing Cameras using Motion-Flow Models},
journal   = {SIAM Journal on Imaging Sciences (SIIMS)},
volume = {8},
number = {3},
pages = {1489--1518},
year      = {2015},
url_Paper={files/paper/2015/CSMUVI_SIIMS.pdf},
pubtype = {Journal},
}

To run the code, you need to install a few codes (instructions below) that do optical flow and l1-recovery.

A. DOWNLOAD Ce Liu's optical flow code from
http://people.csail.mit.edu/celiu/OpticalFlow/OpticalFlow.zip


Dont forget to compile the mex files in there and ADD IT to your matlab path. 

Note that CeLiu's code needs small modifications in compiling in linux. Look in project.h --- you may need to modify opticalflow.cpp as well


B. Download SPG_l1 from
http://www.cs.ubc.ca/labs/scl/spgl1/download.html

Follow install instructions from that page and DO NOT FORGET to add it your matlab path.



C. DO NOT FORGET
THE Code is capable of using multiple-cores automatically thanks to matlab's parallel processing toolbox. 
This does provide significant speedups.
To enable this,
run
>> matlabpool open 6 %opens 6 cores

D. You are free to use any optical flow code as well as any l1-recovery code. But the current setup uses these two above.
Some minimal changes in macroCSMUVI_basic.m can get the code to work on any other toolbox.



DIRECTORIES
- functions: key functions that are used in the code
- data: has pre-generated mat files of compressive measurements (see macroGenerateSyntheticData.m )

- junk: as the name suggests
- intermediate: as the name suggests
- results: as the name suggests


MAIN FILES
1) macroCSMuvi_basic.m : a straightforward implementation of the algorithm in the paper. this is triggered to run on a small-sized problem.

2) macroGenerateSyntheticData.m : simulates the SPC to generate compressive measurements from *highspeed* videos. trying this on a regular low-speed video is pointless since the sPC has a very high sampling rate. You can use the uploaded high-speed videos. Once this code runs, use the commented last line to save a matfile --- this matfile is to be used in macroCSMuvi_basic to recover videos.



