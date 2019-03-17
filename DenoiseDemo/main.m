%--------------------------------------------------------------------------
% 3D Shearlet-MATLAB
%--------------------------------------------------------------------------
% Pooran Singh Negi and Demetrio Labate
%--------------------------------------------------------------------------
% Video Denoising Demo
% created: 08-12-11
% modified 4-20-13
% modified 3-16 -2109: Using release 1.7.0.2 of CONVNFFT
%          to use right mex compilation options for R2018a or later.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Sample Script showing the use of shearlet 3d functions for video  denosing
% In this script we show the the usage of 3D shearlet for removing additive
% white Gaussian noise added to video. This is done via Hard thresholding
% but significant improvement can be acheived by using better denoising techniques
% we used sequence  tempete, mobile2_sequence and coastguard_sequence in our paper
%  Pooran SinghNegi, Demetrio Labate. 3D Discrete Shearlet Transform and Video Processing ,
%  IEEE Trans. Image Processing, vol. 21, no. 6, pp. 2944-2954, June 2012. 
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please use latest CONVNFFT(current CONVNFFT_Folder may have
% incompatibility with latest MATLAB release.) from
% https://www.mathworks.com/matlabcentral/fileexchange/24504-fft-based-convolution 
% to make sure it is compatible with latest MATLAB release.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic;
%matlabpool open 3 
addpath('../CONVNFFT_Folder');
addpath('../3DBP');
addpath('../3DShearTrans');
addpath('../Util');
addpath('../Data');
%--------------------------------------------------------------------------

%current implementation is highly redendent so it running in low memory system
% choose single to save some space
%--------------------------------------------------------------------------

dataClass='double';% 'single' or 'double'
%Thresholding multiplier for hardthresholding
%T=ones(level+1,1)*3.08;
T=[ 3.3 3.0 3.0 3.0];
filterDilationType='422';%%only two type '422' or '442'. currently only 422 supported
filterType='meyer';%%only meyer type implemented
%--------------------------------------------------------------------------

sigma=30; % standard deviation
level=3; % choose level of decomposition ,
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%As per the level choosen different number of directinal band wil be used.
%if level =1, then there will be 8X8 band in each of 3 pyramidal zone for finest level 1
%if level=2, finest level 1 will have 8X8 band and next coarser level 2 
%will have 4X4 in each of the 3 pyramidal zone 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%NOTE::THESE ARE JUST SUGGESTIVE DIRECTIONAL BAND COMPOSITION
%% USER MAY TRY TO PLAY WITH THEM 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cell to specify different directional band at as per level choosen
%In current implementation specifying second number of direction is
%ignored 
%--------------------------------------------------------------------------

dBand={{[ 8  8]}, ... %%%%for level =1
        {[8 8 ],[6 6]}, ...  %%%% for level =2
        {[8 8 ], [6 6],[4 4]}, ...   %%%% for level =3
        {[8 8],[8 8],[4 4],[4 4]}}; %%%%% for level =4
%--------------------------------------------------------------------------

%Load Data and introduce some noise for simulation
%load tempete
load mobile2_sequence  
%load  coastguard_sequence


PlayImageSequence(X)
%choose filter size such that remainder is 0 when divided by number of
%direction in that level

filterSize=[24 24 24 24];

x=double(X);
xn = x + sigma * randn(size(x));
fprintf('introduced  PSNR %f\n',PSNR(x,xn));

disp('Processing ...');
%Build Windowing Filter for different Band
F=GetFilter(filterType,level,dBand,filterSize,filterDilationType ,'double');


%Do the Band Pass of noisy Data
BP=DoPyrDec(xn,level);

%for storing partial reconstructed bandpass data
partialBP=cell(size(BP));
recBP=cell(size(BP));

%--------------------------------------------------------------------------
% Determines via Monte Carlo the standard deviation of
% the white Gaussian noise with for each scale and
% directional components when a white Gaussian noise of
% standard deviation of 1 is feed through.
%--------------------------------------------------------------------------

nsstScalarFileName=['nsstScalarsData' regexprep( num2str( [level dBand{level}{:}]) ,'[^\w'']','') '.mat'];
if exist(nsstScalarFileName,'file')
load(nsstScalarFileName);
else 
nsstScalars = NsstScalars(size(x),F,dataClass);
save(nsstScalarFileName, 'nsstScalars');
end   

%--------------------------------------------------------------------------
%Compute Shearlet Coefficient, Threshold and denoise.
%If large memory is available then can collect all the
%respective pyramidal cone data in a 1X3 cell and can do
%further processing in a single function
%--------------------------------------------------------------------------

for pyrCone=1:3
  shCoeff1=ShDec(pyrCone,F,BP,level,dataClass);
  %clear F{pyrCone,:}
  shCoeff=ThresholdShCoeff(shCoeff1,nsstScalars,pyrCone,sigma,T);
  partialBP{pyrCone}=ShRec(shCoeff);
  %clear shCoeff;
end
%clear F;
%clear shCoeff;
%--------------------------------------------------------------------------
%%%%%%%%%%%%%%Sum Up different pyramidal cone Band Pass Data%%%%%%%%%%%%
%--------------------------------------------------------------------------

for l=1:level      
  %% Assuming different pyramidal zone have same shCoeff size at different 
  %%level
  recBP{l}=zeros(size(partialBP{1}{l}),dataClass);
  for pyrCone =1:3
   recBP{l}=recBP{l}+ partialBP{pyrCone}{l};
  end
end

recBP{level+1}=BP{level+1};

% Do Reconstruction
xRec=DoPyrRec(recBP);

fprintf('PSNR after noise removal %f\n', PSNR(x,xRec));
fprintf(' reconstruction RMS %f\n',froNormMatn(x,xRec))
PlayImageSequence(uint8(xRec))
disp('Done!');
%matlabpool close
toc


