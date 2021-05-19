function [Fused_Volume] = InsertCircles(vol,vol_label)
%
% InsertCircles computes the radius and centroid for each object and places 
% the circles using insertShape onto 2D images extracted from the users volume 
% data. Takes two inputs which are the volume data and the labeled volumes 
% which are labeled matrices created using MATLABs labelmatrix function. 
% Function returns a 4D image array which is reshaped in CircleVacuoles and 
% is passed to MATLAB sliceViewer. 
% 
%  Created by: Joaquin Quintana (last modified: 05-18-2021)      
%  Email: Joaquin.Quintana@Colorado.edu

%get dimensions
[x,y,z] = size(vol);
c = 3;

%preallocate 4D array for RGB image storage
Fused_Volume = zeros(x,y,c,z);

for i =1:z
    stats = regionprops('table',vol_label(:,:,i),'Centroid',...
    'MajorAxisLength','MinorAxisLength');
    %drop rows if NaN appears 
    stats=stats(~any(ismissing(stats),2),:);
    %run if stats has data
        if ~isempty(stats) == true
            centers = stats.Centroid;
            diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
            radii = diameters/2;
            Fused_Volume(:,:,:,i) = insertShape(vol(:,:,i)*2,'circle',[centers,radii]);

        else
            img_gray = vol(:,:,i);
            rgbImage = cat(3, img_gray*2, img_gray*2, img_gray*2);
            Fused_Volume(:,:,:,i) = rgbImage;
        end

end
    
end

