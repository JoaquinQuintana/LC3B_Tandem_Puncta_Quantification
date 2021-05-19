function [] = IsosurfaceVacuoles(green_Vacs,red_Vacs,nucleus,i,name)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
close all;

%% Display Isosurface Subplots For Each Cell and Channel
figure('WindowState','maximized');
%subplot header
formatfront = "Cell from - %s ";
formatend = name + " CellIndex " + i;
Header = sprintf(formatfront,formatend);
%place subplot header
sgtitle(Header) 

subplot(2,2,1)
title('All Channels')

    gp = patch(isosurface(green_Vacs));
    isonormals(green_Vacs,gp);
    gp.FaceColor = 'green';
    gp.EdgeColor = 'none';
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud

    hold on
    rp = patch(isosurface(red_Vacs));
    isonormals(red_Vacs,rp)
    rp.FaceColor = 'red';
    rp.EdgeColor = 'none';
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud
    hold on

    bp = patch(isosurface(nucleus));
    isonormals(nucleus,bp)
    bp.FaceColor = 'blue';
    bp.EdgeColor = 'none';
    bp.FaceAlpha = 0.3;
    bp.EdgeAlpha = 0.3;
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud
   
subplot(2,2,2)
title('Nucleus')
    bp = patch(isosurface(nucleus));
    isonormals(nucleus,bp)
    bp.FaceColor = 'blue';
    bp.EdgeColor = 'none';
    bp.FaceAlpha = 0.3;
    bp.EdgeAlpha = 0.3;
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud
    
subplot(2,2,3)
title('GFP')
    gp = patch(isosurface(green_Vacs));
    isonormals(green_Vacs,gp);
    gp.FaceColor = 'green';
    gp.EdgeColor = 'none';
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud

subplot(2,2,4)
title('RFP')
    rp = patch(isosurface(red_Vacs));
    isonormals(red_Vacs,rp)
    rp.FaceColor = 'red';
    rp.EdgeColor = 'none';
    daspect([1 1 1])
    view(3);
    axis tight
    camlight
    lighting gouraud

snapnow();
close;
end



