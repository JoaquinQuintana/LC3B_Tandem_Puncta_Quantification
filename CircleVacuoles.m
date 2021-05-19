function [] = CircleVacuoles(label_r,label_g,r,g)
%
% CircleVacuoles is called from the VolumeThresholdHelper and inserts circles 
% on objects (suspected vacuoles) identified in the segmentation. It calls a 
% sub function called InsertCircles which computes the radius and centroid for 
% each object and places the circles using insertShape. InsertCircles returns 
% a 4D image array and this is reshaped for use in CircleVacuoles so it can 
% be passed to MATLABs SliceViewer for the user to observe the data. Function 
% requires 4 inputs, the first two are the labeled matrices created using 
% MATLABs labelmatrix function for the mCherry vacuoles and eGFP vacuoles, 
% respectively. The last two inputs are the original subvolumes created in the 
% function imreadVolume and are variables r and g, respectively. 
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu

[fVol_r] = InsertCircles(r,label_r);
[fVol_g] = InsertCircles(g,label_g);

%display motage with thumnails at full resolution 

% montage(fVol_r,'ThumbnailSize',[])
% title('mCherry Circled Vacolues -  If there are any')
% figure 

% montage(fVol_g,'ThumbnailSize',[])
% title('eGFP Circled Vacolues - If there are any')
    
fVol_r = permute(fVol_r,[1,2,4,3]);
fVol_g = permute(fVol_g,[1,2,4,3]);

figure();
sliceViewer(fVol_r);
title('mCherry Circled Vacolues -  If there are any')
snapnow();

figure();
sliceViewer(fVol_g);
title('eGFP Circled Vacolues - If there are any')
snapnow()
end

