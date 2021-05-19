%% LC3B_Tandem_Puncta_QuantificationV2 
% Code requires bioformats MATLAB Toolbox and MATLAB version R2021a or later.  
% 
%  Creator
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu
% 
% LC3B_Tandem_Puncta_QuantificationV2 is a batch processing function used to 
% identify LC3B vacuoles labeled with eGFP and mCherry signals and is 
% designed for researchers investigating autophagy. Code expects the users 
% data to be grayscale 16-bit volume data either in the form of 
% multidimensional tiff stacks or ND2 files with three channels corresponding 
% to the eGFP, mCherry and nuclear marker for mammalian cells. Data used to 
% test this function was acquired using a confocal microscope as out-of-focus 
% light will introduce issues with segmentation and other modes of image 
% acquisition that do not minimize out-of-focus light will not produce 
% quality results. 
% 
% The file calls the functions:
% 
% userInputs 
% imreadVolume
% Watershed2
% FindVaculoes
% TabularCountVacuoles
% 
% Data for single cell analysis is reported as the number of eGFP and mCherry
% vacuoles counted for each cell and is printed to the command window along 
% with the fileName the data was extracted from and the cellindex 
% corresponding to which cell the vacuoles were found in with respect to the 
% image used. This data is returned as a table to the command window and can 
% also be viewed by calling or opening the structure Results_Table. 
% 
% NOTE: Each cell line is different and each optical system is as well. Users 
% should experimentally determine the parameters to use for their data. 
% A helper function is provided with the code to help users access and 
% identify parameters for their data called  VolumeThresholdhelper. 
% 
% NOTE: Users can use MATLABs publishing option to capture all the outputs 
% (recommended) for all figures created by the subfunctions above or place a 
% waitfor() call after each figure to observe the results of each figure 
% created as the processing is occuring. See MATLABs documentation for 
% publishing options and using watifor(). See github account for an example 
% of the published output. 

%%
%clear the command window, users workspace and close all figures
clc;
clear;
close all;

%% Ask for userInputs
[Input] = userInput();

%% Create image data store 
imds = imageDatastore(Input.Indir,...
'IncludeSubfolders',true,'FileExtensions',{'.tif','.ND2'},'LabelSource',...
    'foldernames');
imds_NumerOfFiles = size(imds.Files(),1);

%% Initialize data storage 
dat = struct ;
dat.FileName = [];
dat.SingleCell = [];

%% Start processing images 
for ii = 1:imds_NumerOfFiles
%pull images from data store one at a time by indexing
img = bfopen(imds.Files{ii,:});

%get file name
[pathstr,name] = fileparts(imds.Files{ii,:});

%%
%let the user know which image is being processed. Print the name to command
%window
disp("Begin processing image: ") 
disp(name) 

%unpack user inputs for passing to functions
Nuclear_channel = Input.Nuclear_channel;
eGFP_channel = Input.eGFP_channel;
mCherry_channel = Input.mCherry_channel;
eGFP_threshold = Input.threshG;
mCherry_threshold = Input.threshR;
MinvacVoxeGFP = Input.minGFPvacVolume;
MinvacVoxmCherry = Input.minRFPvacVolume;
MinNucVox = Input.minNucleusVolume;
Solidity = Input.Solidity;
%% Create subvolumes for each channel
[r,g,b] = imreadVolume(img,Nuclear_channel,eGFP_channel,mCherry_channel);

%% 3D controlled watershed 
[bw_stats] = Watershed2(r,g,b,name,MinNucVox,true);

%% Find the vacuoles for each cell identified
[SingleCellStructure] = FindVaculoes(r,g,b,bw_stats,name,eGFP_threshold,...
    mCherry_threshold,MinvacVoxeGFP,MinvacVoxmCherry,MinNucVox,Solidity);

%% Accumulate results
dat(ii).FileName = name;
dat(ii).SingleCell = SingleCellStructure;
end
%% Return counts for vacuoles as table
close all;
[Results_Table] = TabularCountVacuoles(dat);

disp(Results_Table)
imshow('Results.png')
snapnow