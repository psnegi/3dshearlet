# 3-D discrete shearlet transform


## Table of Contents

0. [Introduction](#introduction)
0. [Citation](#citation)
0. [Disclaimer and known issues](#disclaimer)
0. [Installation](#INSTALLATION)
0. [Gaussina Denoising  Demo](#DEMO)


## Introduction

This repository contains the MATLAB/Octave  implementation of [3D discrete shearlet transform](https://www.math.uh.edu/~dlabate/3DDST_IEEE_2011.pdf) and a video denosing demo using 3Dshearlet

By 	[Pooran Singh Negi](https://sites.google.com/site/poorannegi/) and [Demetrio Labate](https://www.math.uh.edu/~dlabate/index.html)

Department of Mathematics, University of Houston


## Disclaimer
This software is provided "as-is", without any express or implied
warranty. In no event will the authors be held liable for any 
damages arising from the use of this software.


## Citation

If you use 3D Shearlet in your research, please cite:

	@article{negilabate20123,
         title = {3-D discrete shearlet transform and video processing},
         author = {Negi, Pooran Singh and Labate, Demetrio},
         journal = {IEEE transactions on Image Processing},
         volume = {21},
         number = {6},
         pages = {2944--2954},
         year = {2012},
         publisher = {IEEE}
	}


## INSTALLATION

### Ubuntu
#### Using octave
See this link for instllation instruction of octave in ubuntu Linux

https://askubuntu.com/questions/645600/how-to-install-octave-4-0-0-in-ubuntu-14-04


**Change convnfft in shDec to convn if you plan to use octave to run this code. Code can run slow**


#### MATLAB

For running 3DShearlet code user need to  run
convnfft_install.m from CONVNFFT_Folder  first.

Please use latest CONVNFFT from
https://www.mathworks.com/matlabcentral/fileexchange/24504-fft-based-convolution to make sure it is compatible with latest MATLAB release.

Restriction on the size of .mat file

Due to nature of upsampling and downsampling for better denoising performance
dimension of data need to be divisible by 3*2^(number of decomposition level required).

## DEMO

Gaussian Denoising script is  in **DenoiseDemo** folder with file name **main.m**

If user need to save data please use appropriate save statement after deonising is done.
Current script setting  denoises coastguard_sequence with simulated noise.
This script can be run in background in Unix/Linux using hmatbg in DenoiseDemo folder.
./hmatbg main.m outfile 
hmatbg can be modified  to change priority level using nice command.


For data corrupted by unknown Gaussian noise parameter, sdest3 function in Util directory
can used to estimate standard deviation of the noise which is based on median of the wavelet coefficients at the finer scale.


*NOTE:* Files in 3DBP directory for doing bandpass are from SurfBox toolbox implemented by  Yue Lu and Minh N. Do

