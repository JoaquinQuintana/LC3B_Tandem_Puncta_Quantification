function [] = WatershedObserver(g,Boundaries_Are_Important,RidgeLineFinder)
%
% WatershedObserver shows a 3D reconstruction of the ridgelines and ROIs 
% identified as single cells. WatershedObserver can be called from the 
% function Watershed2 as an optional input. The final optional input in 
% Watershed2 is a boolean which if true uses the function WatershedObserver 
% to present the ROIs with color coding along with the ridgelines used to 
% create the ROIs. Data is presented using labelvolshow. After viewing the 
% labels and ridgelines the volume data for the cell boundaries is shown as a 
% 3D Maximum Intensity Projection.  The function takes in the three following 
% inputs:
% 
% 1.The original green subvolume created in the imreadVolume. This variable is 
% g which is output from imreadVolume.
% 
% 2.The variable RidgeLineFinder which is created in the function Watershed2.
% 
% 3.The variable Boundaries_Are_Important which is created in the function Watershed2.
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu 

close all;


%find connected componets for the ridgelines and label them
CC = bwconncomp(RidgeLineFinder);
L = labelmatrix(CC);

%find connected componets for single cell containers and label them
CC2 = bwconncomp(Boundaries_Are_Important);
L2 = labelmatrix(CC2);
%% Display 3D Reconstruction Ridge Lines and Cell Boundaries
%observe the single cell containers and ridgelines which seperates them
ViewPnl = uipanel(figure,'Title','Single Cell Masks and Ridge Lines');
V = labelvolshow(L2,L,'Parent',ViewPnl);
%waitfor(V)
snapnow()
close;

%% Display 3D MIP Cell of Boundaries
maskedgreen = g;
maskedgreen(~Boundaries_Are_Important) = 0;

ViewPnl = uipanel(figure,'Title','Cell Boundaries Maximum Intensity Projection');
MIP = volshow(maskedgreen,'Renderer', 'MaximumIntensityProjection','Parent',ViewPnl);
%waitfor(MIP)

snapnow()
close;
end


