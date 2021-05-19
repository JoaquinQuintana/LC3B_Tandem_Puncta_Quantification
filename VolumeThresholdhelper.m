function [] = VolumeThresholdhelper(fileName)
%% VolumeThresholdhelper Information
% VolumeThresholdhelper is used to help the user find parameters to use for 
% batch processing with LC3B_Tandem_Puncta_QuantificationV2. The function 
% takes in the fileName of a file in the current directory. It then asks the 
% user to input parameters.
% 
% Function asks the user to enter the following information which is used for 
% thresholding and identifying the cell boundaries. Three GUIs will be opened 
% for the user to do this. 
% 
% Three GUIs propompted to the user are:
% 
% 1.Asks the user to input integers in the range [1,3]  which is used to specify
% the order for the cell markers. This is, the channels for the nuclear 
% marker, eGFP vacuoles and mCherry vacuoles. 
% 
% 2.Asks the user to input integers which are used to threshold the mature 
% eGFP and mCherry vacuoles. Code assumes images are 16-bit so inputs should 
% be in the range of [0, 65535] which specifies the intensity value for 
% unit16 arrays. 
% 
% 3.Asks the user to input approximate volume sizes, in voxels, for the 
% nuclear marker, eGFP vacuoles, mCherry vacuoles and the solidity for the 
% vacuoles which is type float between [0,1].
% 
% Once the parameters are input by the user, the function will use the inputs 
% to label  each slice in the image data with yellow circles wherever it 
% identifies a vacuole and presents the volume data using sliceViewer with 
% the yellow circles overlaid for the users to check if the parameters worked 
% or should be adjusted. A dialogue box is presented for the user to enter 
% Y/N if they would like to try other parameters to improve the segmentation.
% Once satisfied the user can enter N and proceed to see what the Ridgelines 
% and single cell containers look like to verify the SNR is high enough to 
% perform segmentation with Otsu’s method. Finally, subplots for the single 
% cell data with the nuclear marker, eGFP and mCherry vacuoles are presented 
% for viewing as isosurface plots. Note: user should place waitfor() after 
% figures to stop the function at each plot for viewing in the functions 
% WatershedOberserver and IsosurfaceVacuoles. 
% 
% Once the user has identified appropriate parameters for their data they can
% use the parameters in LC3B_Tandem_Puncta_QuantificationV2 to perform batch 
% processing for their data. 
% 
% Created by: Joaquin Quintana (last modified: 05-18-2021)      
% Email: Joaquin.Quintana@Colorado.edu

%% Run while loop until user finds parameters for their data to use
while 1
%clear work space and cmd on each run    
close all;
clc;

%store inputs in struct to return at the end so they know what they decided
%worked for their data
Input.Nuclear_channel = [];
Input.eGFP_channel = [];
Input.mCherry_channel = [];
Input.threshold_eGFP = [];
Input.threshold_mCherry = [];
Input.minGFPvacVolume = [];
Input.minRFPvacVolume = [];
Input.minNucleusVolume = [];
Input.Solidity = [];

%get some info from the user

%ask user what order the channels are in
waitfor(msgbox('Please let us know what order the eGFP, mCherry and nuclear marker are in'));
input = inputdlg({'Nuclear marker','eGFP','mCherry'},...
'Channels',1,{'1','2','3'},'on');

%convert char to double
Input.Nuclear_channel = str2double(input(1));
Input.eGFP_channel = str2double(input(2));
Input.mCherry_channel = str2double(input(3));
  
%ask user to input thresholds for eGFP and mCherry channels 
waitfor(msgbox('Please enter thresholds for developed puncta. This should be for developed eGFP and mCherry vacuoles which are used to identify neutral and acidified vacuoles, respectively.'));
input = inputdlg({'GFP Threshold Value 16-bit [0-65536]','RFP Threshold Value 16-bit [0-65536]'},...
'Thresholds',1,{'25000','20000'},'on');

%convert char to double
Input.threshold_eGFP =  str2double(input(1));
Input.threshold_mCherry =  str2double(input(2));

%get min sizes in voxels for cell markers and solidity
input = inputdlg({'Minimum volume of GFP vacuole in voxels is >',...
    'Minimum volume of RFP vacuole in voxels is >',...
    'Minimum volume of Nucleus vacuole in voxels is >',...
    'Solidity Thershold Vacuoles [0,1]'},...
'Thresholds',1,{'1','15','15000','0.6'},'on');

%convert char to double
Input.minGFPvacVolume =  str2double(input(1));
Input.minRFPvacVolume =  str2double(input(2));
Input.minNucleusVolume =  str2double(input(3));
Input.Solidity =  str2double(input(4));

%unpack user inputs for passing to functions
Nuclear_channel = Input.Nuclear_channel;
eGFP_channel = Input.eGFP_channel;
mCherry_channel = Input.mCherry_channel;
eGFP_threshold = Input.threshold_eGFP;
mCherry_threshold = Input.threshold_mCherry;
MinvacVoxeGFP = Input.minGFPvacVolume;
MinvacVoxmCherry = Input.minRFPvacVolume;
MinNucVox = Input.minNucleusVolume;
Solidity = Input.Solidity;
%% Use bfopen to read file
img = bfopen(fileName);
name = fileName;

%% Create subvolumes for each channel
[r,g,b] = imreadVolume(img,Nuclear_channel,eGFP_channel,mCherry_channel);

%% Label objects (vacuoles) with yellow circles and present to user with a slice viewer to check if parameters are ideal for segmentation
%%
%set thresholds from user inputs for developed vacuoles.

%THIS IS ALL REDUNDANT TO THE VACUOLE FINDER AND IS JUST BEING USED TO UPDATE AND
%PERFECT THE VACUOLE SEGMENTATION

%convert input thresholds to double precision
max  = 65536;min  = 0;
Green_Thresh  = (eGFP_threshold - min)/(max - min);
Red_Thresh  = (mCherry_threshold - min)/(max - min);

%segment vacuoles
[pre_green_Vacs,green_Vacs_CC] = VacuoleCleansing(g,Green_Thresh,...
    MinvacVoxeGFP,Solidity);
[red_Vacs,red_Vacs_CC] = VacuoleCleansing(r,Red_Thresh,MinvacVoxmCherry...
    ,Solidity);

%get intial stats for vacuoles
red_vacuoles_stats = regionprops3(red_Vacs_CC,red_Vacs,'all');
pre_green_stats = regionprops3(green_Vacs_CC,pre_green_Vacs,'all');

%only keeps green vacoles if a red vacuole is associated with it. Due to the 
%nature of the probe this should be the case. It helps as a precheck for 
%ensuring the vacuole is indeed a LC3B vacuole. 
[green_vacuoles_stats] = OverlappingChannels(pre_green_stats,...
    red_vacuoles_stats);

%now create the final binary for green vacuoles which overlap mcherry. 
[~,idx] = intersect(pre_green_stats.EquivDiameter,...
    green_vacuoles_stats.EquivDiameter);

%return the updated indexes for eGFP binary image
bi_img = ismember(labelmatrix(green_Vacs_CC),idx); 

%make sure to get the new connected components for updated eGFP stats
green_Vacs_CC = bwconncomp(bi_img);

%label the found vacuoles
label_r = labelmatrix(red_Vacs_CC);
label_g = labelmatrix(green_Vacs_CC);
%%
%display current stats for vacuoles. Will probably reduce the outputs in
%the future but as of now everyhting from regionprops3 is returned
disp('Stats for eGFP vacuoles using current parameters')
disp(green_vacuoles_stats)
disp('Stats for mCherry vacuoles using current parameters')
disp(red_vacuoles_stats)

%%
%The published out for disp looks horrible without using a Latex wrapper
%so I've included an image of how it looks in the command window.
%I need to add a Latex wrapper for this
imshow('StatsCmdOutput.png')
snapnow

%% Label vacuoles with circles and display using sliceViewer
CircleVacuoles(label_r,label_g,r,g)

%end while loop if user has found what they seek
options.WindowStyle = 'normal';
resp = inputdlg({'Do you wish to try other inputs? Y/N: '},...
'Retry?',1,{'N'},options);

    if strcmpi(resp,'n')
        % user has typed in N or n so break out of the while loop
        break;
    end
end
%% 
%if user likes the parameters used, proceed and show them what is created
%using the rest of the script. 

%segment cells and get ROIs
[bw_stats] = Watershed2(r,g,b,name,MinNucVox,true);

%%
%find vacuoles in single cells and return the results in a structure
[SingleCellStructure] = FindVaculoes(r,g,b,bw_stats,name,eGFP_threshold,...
    mCherry_threshold,MinvacVoxeGFP,MinvacVoxmCherry,MinNucVox,Solidity);

%close all figures and clear command window as we are done
close all; clc;

%% Accumulate results
dat.FileName = name;
dat.SingleCell = SingleCellStructure;

%return single cell structure containg counts as a table
[Results_Table] = TabularCountVacuoles(dat);

%%
%report the parameters the user decided worked for their data
disp('Inputs used: ')
disp(struct2table(Input))
%%
%diplay the fruits of your labor for this image using the inputs accepted
disp('Results: ')
disp(Results_Table)
%%
%The published display looks horrible without using a Latex wrapper so I've 
%included an image of how it looks in the command window.
%I need to add a Latex wrapper for this
imshow('Resultscmd.png')
snapnow
end



