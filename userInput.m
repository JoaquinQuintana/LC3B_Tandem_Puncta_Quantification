function [Input] = userInput()
% 
% UserInputs asks the user to enter the following information which is used 
% for thresholding and identifying vacuoles and cell boundaries. Four GUIs 
% will be opened for the user to do this. 
% 
% Four GUIs propompted to the user are:
% 
% 1.Opens a file explorer and allows the user to navigate to the location where 
% their multidimensional tiff or ND2 files are located.  
% 
% 2.Asks the user to input integers in the range [1,3]  which is used to 
% specify the order for the cell markers. This is, the channels for the 
% nuclear marker, eGFP vacuoles and mCherry vacuoles. 
% 
% 3.Asks the user to input integers which are used to threshold the mature 
% eGFP and mCherry vacuoles. Code assumes images are 16-bit so inputs should 
% be in the range of [0, 65535] which specifies the intensity value for 
% unit16 arrays. 
% 
% 4.Asks the user to input approximate volume sizes, in Voxels, for the 
% nuclear marker, eGFP vacuoles, mCherry vacuoles and the solidity for the 
% vacuoles which is a value between [0,1].
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu

% Ask user to navigate to folder
Input = [];
Input.Indir = [];
Input.Nuclear_channel = [];
Input.eGFP_channel = [];
Input.mCherry_channel = [];
Input.threshG = [];
Input.threshR = [];
Input.minGFPvacVolume = [];
Input.minRFPvacVolume = [];
Input.minNucleusVolume = [];
Input.Solidity = [];

%Begin asking for user inputs
waitfor(msgbox('Please select the folder where your images reside'));
% Open file explorer so the user can navigate to the in directory
Input.Indir = uigetdir();

%Ask user what order the channels are in
waitfor(msgbox('Please let us know what order the eGFP, mCherry and nuclear marker are in'));

%get min sizes for cell markers
input = inputdlg({'Nuclear marker','eGFP','mCherry'},...
'Channels',1,{'1','2','3'},'on');
% Convert char to double
Input.Nuclear_channel = str2double(input(1));
Input.eGFP_channel = str2double(input(2));
Input.mCherry_channel = str2double(input(3));
  
%Ask user to input threshold for GFP and RFP 
waitfor(msgbox('Please enter thresholds for developed puncta. This should be for developed eGFP and mCherry vacuoles which are used to identify neutral and acidified vacuoles, respectively.'));

input = inputdlg({'GFP Threshold Value 16-bit [0-65536]','RFP Threshold Value 16-bit [0-65536]'},...
'Thresholds',1,{'25000','20000'},'on');
% Convert char to double
Input.threshG =  str2double(input(1));
Input.threshR =  str2double(input(2));

%get min sizes for cell markers and solidity
input = inputdlg({'Minimum volume of GFP vacuole in voxels is >',...
    'Minimum volume of RFP vacuole in voxels is >',...
    'Minimum volume of Nucleus vacuole in voxels is >',...
    'Solidity Thershold Vacuoles [0,1]'},...
'Thresholds',1,{'1','15','15000','0.6'},'on');

% Convert char to double
Input.minGFPvacVolume =  str2double(input(1));
Input.minRFPvacVolume =  str2double(input(2));
Input.minNucleusVolume =  str2double(input(3));
Input.Solidity =  str2double(input(4));
end


