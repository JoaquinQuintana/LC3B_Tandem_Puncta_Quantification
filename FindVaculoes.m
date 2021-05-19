function [SingleCellStructure] = FindVaculoes(r,g,b,bw_stats,name,eGFP_threshold,mCherry_threshold,MinvacVoxeGFP,MinvacVoxmCherry,MinNucVox,MinSolidity)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%create struct for data storage
SingleCellStructure = struct ;
SingleCellStructure.CellIndex = [];
SingleCellStructure.Nucleus_stats = [];
SingleCellStructure.GFP_Vacuoles_stats = [];
SingleCellStructure.RFP_Vacuoles_stats = [];
SingleCellStructure.GFP_matrix = [];
SingleCellStructure.RFP_matrix = [];
SingleCellStructure.Nucleus_matrix = [];
SingleCellStructure.ImageName = [];

%convert input thresholds to double precision 
max  = 65536;min  = 0;
Green_Thresh  = (eGFP_threshold - min)/(max - min);
Red_Thresh  = (mCherry_threshold - min)/(max - min);

%convert BoundingBox to array
Bounds = [bw_stats.BoundingBox]; 
iterBounds = size(Bounds,1);

for i =  1:iterBounds
%iter over boundingboxes
bb = [ceil(Bounds(i,1:3)), Bounds(i,4:6)-1]; 

%crop cells from the volume using boundingbox
gcrop = imcrop3(g,bb);
rcrop = imcrop3(r,bb);
nucleus = imcrop3(b,bb);

%% Process vacuoles

% find vacoles by passing to VacuoleCleansing
[pre_green_Vacs,vacuoles_pCCG] = VacuoleCleansing(gcrop,Green_Thresh,MinvacVoxeGFP,MinSolidity);
[red_Vacs,vacuoles_CCR] = VacuoleCleansing(rcrop,Red_Thresh,MinvacVoxmCherry,MinSolidity);

%get intial stats for vacuoles
red_vacuoles_stats = regionprops3(vacuoles_CCR,red_Vacs,'all');
pre_green_stats = regionprops3(vacuoles_pCCG,pre_green_Vacs,'all');

%only keep green vacoles if a red vacuole is associated with it.
[green_vacuoles_stats] = OverlappingChannels(pre_green_stats,...
    red_vacuoles_stats);

%now create the final binary for green vacuoles which overlap mcherry. 
[~,idx] = intersect(pre_green_stats.EquivDiameter,green_vacuoles_stats.EquivDiameter);

%find indexes to keep
bi_img = ismember(labelmatrix(vacuoles_pCCG),idx); 

%create the final masked eGFP volume
green_Vacs = pre_green_Vacs; %mask containg old data
green_Vacs(~bi_img) = 0; % update grayscale with correct vacuoles

%make sure to get the new connected components for updated eGFP stats
vacuoles_pCCG = bwconncomp(bi_img);

%get stats from final eGFP vacuoles
green_vacuoles_stats = regionprops3(vacuoles_pCCG,green_Vacs,'all'); 
%% Process Nucleus

%create mask for the nuclues 
bwnuc =imbinarize(nucleus);
nucleus(~bwnuc & ~bw_stats.Image{i,1});

nucleus = imbinarize(nucleus);
cc = bwconncomp(nucleus); 
stats = regionprops3(cc,'Volume'); 
idx = find([stats.Volume] > MinNucVox); 
nucleus = ismember(labelmatrix(cc),idx);

%smooth data as it is usually chunky at this resolution
nucleus = smooth3(nucleus);
nucleus_stats = regionprops3(bwconncomp(nucleus),'all'); 

%% Create Isosurface plots for each cell and its respective channels
IsosurfaceVacuoles(green_Vacs,red_Vacs,nucleus,i,name);

%% Accumulate results in singlecellstruct
SingleCellStructure(i).CellIndex = i;
SingleCellStructure(i).Nucleus_stats = nucleus_stats;
SingleCellStructure(i).GFP_Vacuoles_stats = green_vacuoles_stats;
SingleCellStructure(i).RFP_Vacuoles_stats = red_vacuoles_stats;
SingleCellStructure(i).GFP_matrix = green_Vacs;
SingleCellStructure(i).RFP_matrix = red_Vacs;
SingleCellStructure(i).Nucleus_matrix = nucleus;
SingleCellStructure(i).ImageName = name;
end

end

