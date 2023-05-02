% Animate the system setup
% Input: 
%          "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
%          "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
%          "dx" - Distance between the centers of the scoring sphere and PCD sensor area in cm
%          "ax_lim" - Axes limits for MATLAB figures
%          "frames" - Visualization space phases
%          "dist_rate" - Space phase movement rate
%          "view": "on" - display an animation; "off" - do not display       
% Output: 
%          "final_pos" - Photon position at the end of animation
%
% by Samuel Ydenberg


function [final_pos] = fAnimation(pos,dir,dx,ax_lim,frames,dist_rate,view)

    % Phantom position
    p_min = -9;
    p_max = 10;
    sensor_x = [dx;dx;dx;dx];
    sensor_y = [0;0;30;30];
    sensor_z = [-30;0;0;-30];
    phantom_x = [p_min,p_min,p_min,p_min,p_min,p_max,p_max,p_min,p_max,p_max,p_min,p_max,p_max,p_min,p_max,p_max];
    phantom_y = [p_min,p_max,p_max,p_min,p_min,p_min,p_min,p_min,p_min,p_max,p_max,p_max,p_max,p_max,p_max,p_min];
    phantom_z = [-p_min,-p_min,-p_max,-p_max,-p_min,-p_min,-p_max,-p_max,-p_max,-p_max,-p_max,-p_max,-p_min,-p_min,-p_min,-p_min];
    
    if view == "off"
        for i = 1:frames
            nx = pos(:,1) + dir(:,1)*dist_rate*i;
            ny = pos(:,2) + dir(:,2)*dist_rate*i;
            nz = pos(:,3) + dir(:,3)*dist_rate*i;
        end
    else    
        % Create an animation
        h = figure;
        % Plot initial positions
        figure
        scatter3(pos(:,1),pos(:,2),pos(:,3),15,'blue','filled')
        hold on;
        patch(sensor_x,sensor_y,sensor_z,"red")
        patch(phantom_x,phantom_y,phantom_z,"green")
        axis([-10 ax_lim -ax_lim ax_lim -ax_lim ax_lim])
        hold off;
        M(frames) = struct('cdata',[],'colormap',[]);
        ax = gca;
        ax.NextPlot = "replacechildren";
        h.Visible = 'off';
        gifFile = 'PSF.gif';
        exportgraphics(gca, gifFile);
    
    %     rad = 30;
    %     rinds = pos(:,4) >= rad;
    %     posan = pos(rinds,:);
    %     diran = dir(rinds,:);
        
        for i = 1:frames
            nx = pos(:,1) + dir(:,1)*dist_rate*i;
            ny = pos(:,2) + dir(:,2)*dist_rate*i;
            nz = pos(:,3) + dir(:,3)*dist_rate*i;
            scatter3(nx,ny,nz,15,'blue','filled')
            hold on;
            patch(sensor_x,sensor_y,sensor_z,"red")
            patch(phantom_x,phantom_y,phantom_z,"green")
            axis([-10 ax_lim -ax_lim ax_lim -ax_lim ax_lim])
            hold off;
            drawnow
            M(i) = getframe;
            exportgraphics(gca, gifFile, Append=true);
        end
        
        h.Visible = 'on';
        movie(M);
    end
    final_pos = [nx,ny,nz];
end