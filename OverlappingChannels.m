function [green_vacuoles_stats] = OverlappingChannels(pre_green_stats, red_vacuoles_stats)
%
% OverlappingChannels is a pre-check that ensures eGFP vacuoles found are 
% associated with a mCherry vacuole. If not the eGFP vacuole is removed as an 
% object and considered to be a noise artifact not a vacuole. This was added 
% due to the nature of the LC3B eGFP_mCherry probe which should quench the 
% eGFP signal. This is due to the fact that as the acidity of the vacuole 
% increases it should quench the eGFP signal and if at a neutral pH overlap 
% the two signals in 3D space. If these signals do not overlap, it is 
% considered an acidified vacuole and only mCherry should be present.
%
% The function cross references each objects voxel index list (VoxelIdxList 
% created by regionprops3. See regionprops3 documentation for more information) 
% concatenates them and checks if values repeat in the vector. If there are 
% repeated values in the concatenated vector the two objects share space in 
% the 3D volumes specified location. Objects that are eGFP labeled but do not 
% share values with the mCherry object are removed from the eGFP structure. 
% An updated structure containing the identified eGFP objects is returned.  
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu


gidx = length(pre_green_stats.VoxelIdxList);
ridx = length(red_vacuoles_stats.VoxelIdxList);

%preallocate array of unknown size clean up over unused places after for loop
overlapping = zeros(1, gidx);

all_indexes = 1:gidx;
for g =1:gidx
    for r = 1:ridx
        A = [pre_green_stats.VoxelIdxList{g,1};red_vacuoles_stats.VoxelIdxList{r,1}];
        B = unique(A) ; 
        if length(A)==length(B)
            %do nothing as these two vacuoles do not overlap
        else
            %keep indexes for eGFP vacuoles stats which overlap with
            %mcherry vacuoles
            overlapping(g) = g;
        end
    end
end

%crop off unused elements  
overlap = find(overlapping~=0);

%find the values that are not in their intersection.
d = setxor(overlap,all_indexes);

%delete all rows by using the array of indices which do not have 
%intersection
pre_green_stats(d,:) = [];

%return green_vacuoles_stats
green_vacuoles_stats = pre_green_stats;
end

