function [r,g,b] = imreadVolume(img,Nuclear_channel,eGFP_channel,mCherry_channel)
% 
% imreadVolume takes the multidimensional tiff or ND2 files and creates a 
% volume which is then deinterleaved into subvolumes for their respective 
% channels which contain the nuclear marker, eGFP vacuoles and mCherry 
% vacuoles. 
% 
% The function takes in four inputs. The first is a cell structure containing 
% the img volume read in from Bioformats function bfopen. The next three are 
% the user inputs collected in the function UserInputs to identify which 
% channels to assign to each volume and are integers in the range [1,3]. 
% The function returns the subvolumes in the variables r,g,b which are the 
% subvolumes for the mCherry channel, eGFP channel and the nuclear marker 
% channel, respectively. Returned subvolumes are grayscale double precision 
% 3D volumes. 
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu

%get dimensions 
[x,y] = size(img{1,1}{1,1});
number_of_slices = size(img{1,1},1);

%preallocate array to help MATLAB with memory allocation
Volume(:,:,:)= zeros(x, y, number_of_slices);

for i = 1:number_of_slices
Volume(:,:,i) = im2double(img{1,1}{i,1});
end

% Separate channels into subvolumes based on channel.
r = Volume(:,:,mCherry_channel:3:end);
g = Volume(:,:,eGFP_channel:3:end);
b = Volume(:,:,Nuclear_channel:3:end);
end

