function [Vacuoles,vacuoles_CC] = VacuoleCleansing(croppedVol,Threshold_Value,MinVacVoxel,MinSolidity)
%
% VacuoleCleansing takes the userInputs for estimated minimum voxel sizes and 
% segments the vacuoles. Outputs the connected components for the identified 
% objects and the masked grayscale image for the objects. Requires the 
% following 4 inputs croppedVol, Threshold_Value, MinVacVoxel, MinSolidity. 
% All but 1 input, croppedVol, are user inputs acquired in the function 
% userInputs. CroppedVol should be the volume from the eGFP or mCherry channel 
% created by the boundingbox associated with the cells ROI created in the 
% function Watershed2. 
%
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu


masked = croppedVol;
BW = croppedVol > Threshold_Value;
masked(~BW) = 0; 

cc = bwconncomp(BW);
stats = regionprops3(cc,'Volume'); 
%added solidity and it removed crazy shaped objects which were not vacuoles 
idx = find(([stats.Volume] > 1));
BW = ismember(labelmatrix(cc),idx); 
masked(~BW) = 0;  

% smooth the data
Vacuoles = smooth3(masked,'gaussian');
bi = imbinarize(Vacuoles);

%make sure the vacoles are of the correct size using user inputs
CC = bwconncomp(bi);
S = regionprops3(CC,'Volume','Solidity'); 
idx = find(([S.Solidity] > MinSolidity) & [S.Volume] > MinVacVoxel);
%update binary images after dropping nonsensical data
bi = ismember(labelmatrix(CC),idx); 

%update gray scale image with pixels only where the binary mask exists
Vacuoles(~bi) = 0;  

%get connected components in the binary image
vacuoles_CC = bwconncomp(bi);
end

