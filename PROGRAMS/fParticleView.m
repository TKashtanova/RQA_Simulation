% Show photon position in the system environment
% Input:
%       "pos" - Particle position
%       "ax_lim" - Figure axes limits
%       "sen_dist_x" - Sensor distance along x axis
% Output:
%        A plot of the simulation environment
%
% by Samuel Ydenberg

function fParticleView(pos,ax_lim,sen_dist_x)
p_min = 0;
p_max = 30;
sensor_x = [sen_dist_x;sen_dist_x;sen_dist_x;sen_dist_x];
sensor_y = [0;0;30;30];
sensor_z = [-30;0;0;-30];
phantom_x = [p_min,p_min,p_min,p_min,p_min,p_max/2,p_max/2,p_min,p_max/2,p_max/2,p_min,p_max/2,p_max/2,p_min,p_max/2,p_max/2];
phantom_y = [-p_min,p_max,p_max,-p_min,-p_min,-p_min,-p_min,-p_min,-p_min,p_max,p_max,p_max,p_max,p_max,p_max,-p_min];
phantom_z = [p_min,p_min,-p_max,-p_max,p_min,p_min,-p_max,-p_max,-p_max,-p_max,-p_max,-p_max,p_min,p_min,p_min,p_min];

    % Plotting initial positions
    figure
    scatter3(pos(:,1),pos(:,2),pos(:,3),15,'blue','filled')
    hold on;
    patch(sensor_x,sensor_y,sensor_z,"red")
    patch(phantom_x,phantom_y,phantom_z,"green")
    [~,~] = collimatorBody(sensor_y(1),sensor_y(3),sensor_z(1),sensor_z(2),sen_dist_x,"on");
    axis([-20 ax_lim -ax_lim ax_lim -ax_lim ax_lim])
    hold off;
end