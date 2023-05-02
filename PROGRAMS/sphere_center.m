% Evaluate the scoring sphere center position 
% Input: 
%          Paths to the gDPM output files obtained with the sphere center at 
%          (0,0,0) cm (original set-up) and (15,15,15) cm (modified set-up)
%          The number of simulated particles is 10^5 in both cases.
% Output: 
%          3D and 2D Plots of photons in the scoring sphere 
%          (with and without scattering angle filtering)
% 
% by Tatiana Kashtanova


% Input data
clc;
clear;
% Original scoring sphere center (0, 0,0) cm;
%path=strcat("./data/5_Sphere_0.0.0/");
% Shifted scoring sphere center (15,15,15) cm;
path = strcat("./data/5_Sphere_15.15.15/");

% "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
% "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
[pos, dir, ~] = fInput_full(path);

%% Scoring sphere center position in relation to the phantom (no filtering)
% Plot in 3D
figure
scatter3(pos(:,1), pos(:,2), pos(:,3), 1, dir(:,4), 'filled')
c = colorbar;
xlabel('x (cm)','fontsize',12,'fontweight','bold')
ylabel('y (cm)','fontsize',12,'fontweight','bold')
zlabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_all_3D.png')
%saveas(gcf,'15.15.15_all_3D.png')

% Plot in z-y coordinates
figure
scatter(pos(:,2), pos(:,3), 1, dir(:,4), 'filled')
c = colorbar;
xlabel('y (cm)','fontsize',12,'fontweight','bold')
ylabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_all_zy.png')
%saveas(gcf,'15.15.15_all_zy.png')

% Plot in z-x coordinates
figure
scatter(pos(:,1), pos(:,3), 1, dir(:,4), 'filled')
c = colorbar;
xlabel('x (cm)','fontsize',12,'fontweight','bold')
ylabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_all_zx.png')
%saveas(gcf,'15.15.15_all_zx.png')


%% Scoring sphere center position in relation to the phantom (with filtering)
% Select photons that scatter at a small angle to the sensor area
c = zeros(size(pos,1),1);
for i = 1:size(pos,1)
    phi = asin(abs(dir(i,1))/sqrt(dir(i,1)^2 + dir(i,2)^2 + dir(i,3)^2));
    phi = phi *180/pi;
    if phi >=0 && phi <= 5
        c(i,:) = 1;
    else
        c(i,:) = 0;
    end
end
c = c(:,1) > 0;
pos2 = pos(c,:);
dir2 = dir(c,:);

% Plot in 3D
figure
scatter3(pos2(:,1), pos2(:,2), pos2(:,3), 1, dir2(:,4), 'filled')
c = colorbar;
xlabel('x (cm)','fontsize',12,'fontweight','bold')
ylabel('y (cm)','fontsize',12,'fontweight','bold')
zlabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_filter_3D.png')
%saveas(gcf,'15.15.15_filter_3D.png')

% Plot in z-y coordinates
figure
scatter(pos2(:,2), pos2(:,3), 1, dir2(:,4), 'filled')
c = colorbar;
xlabel('y (cm)','fontsize',12,'fontweight','bold')
ylabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_filter_zy.png')
%saveas(gcf,'15.15.15_filter_zy.png')

% Plot in z-x coordinates
figure
scatter(pos2(:,1), pos2(:,3), 1, dir2(:,4), 'filled')
c = colorbar;
xlabel('x (cm)','fontsize',12,'fontweight','bold')
ylabel('z (cm)','fontsize',12,'fontweight','bold')
colormap turbo
ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
c.Label.Position (1:2) = [3.5 mean(c.Limits)];
%saveas(gcf,'0.0.0_filter_zx.png')
%saveas(gcf,'15.15.15_filter_zx.png')





