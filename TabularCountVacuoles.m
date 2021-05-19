function [Results_Table] = TabularCountVacuoles(dat)
%
% TabularCountVacuoles takes in data accumulated in a structure from the 
% batch processing file LC3B_Tandem_Puncta_QuantificationV2 or the 
% VolumeThresholdhelper function and reorganizes the data into a table. 
% The returned table reports the image fileName and its associated single 
% cell data. The fileName is associated with the single cell index, which is 
% the single cell from which the eGFP and mCherry vacuoles were counted. 
%  
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu


CombineStructures = [dat.SingleCell];
Vacuole_Counts = struct;
Vacuole_Counts.fileName = [];
Vacuole_Counts.CellIndex = [];
Vacuole_Counts.eGFP_Vacuoles = [];
Vacuole_Counts.mCherry_Vacuoles = [];


rows = size(CombineStructures,2);

for i = 1:rows
  Vacuole_Counts(i).fileName = CombineStructures(i).ImageName;
  Vacuole_Counts(i).CellIndex = CombineStructures(i).CellIndex;
  Vacuole_Counts(i).eGFP_Vacuoles = size(CombineStructures(i).GFP_Vacuoles_stats,1);
  Vacuole_Counts(i).mCherry_Vacuoles = size(CombineStructures(i).RFP_Vacuoles_stats,1); 
   
end
Results_Table = struct2table(Vacuole_Counts);
end

