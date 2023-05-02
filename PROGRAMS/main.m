% The main program responsible for the execution of other source files
% Input: 
%       "path" - Path to the gDPM output files
%       "size" - Size of the gDPM output files (full or reduced)
%       "pht" - Phantom side length in cm
%
% Output: 
%        A plot with 2D simulated depth-dose profile
%        For specified photon energy, distance between the phantom and
%        detector, and collimation strategy:
%           A plot with 2D detector sensor signal
%           A heatmap of detected photon counts
%           A plot with longitudinal dose and photon counts profiles
%           A plot with dose values vs photon counts and coefficient of determination
% 
% by Tatiana Kashtanova

clear;
clc;


% Input #1. Path to the gDPM output files
% Water phantom with a side length 30 cm
path = strcat("./data/10_W_Ph30_Beam28_cut/");
% Water phantom with a side length 15 cm
%path = strcat("./data/10_W_Ph15_Beam7_cut/");
% Water + bone phantom with a side length 30 cm
%path = strcat("./data/10_WB_Ph30_Beam28_cut/");
% Water + bone + air phantom with a side length 30 cm
%path = strcat("./data/10_WBA_Ph30_Beam28_cut/");

% Input #2. Size of the gDPM output files
% Full / original size 
%size = "full";
% Reduced size 
size = "reduced";

% Input #3. Phantom side length in cm
pht = 30;
%pht = 15;

% Number of voxels per the phantom side in gDPM
v = pht/0.2;

% "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
% "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
% "dose" - Delievered dose in Gy/particle 
if size == "full"
    [pos, dir, dose] = fInput_full(path, v);
else
    [pos, dir, dose] = fInput_reduced(path, v);
end

% Phantom circumscribed sphere radius
r_pht = pht * sqrt(3)/2;

% PCD sensor coordinates in cm
sy = [0; 0; pht; pht];
sz = [-pht; 0; 0; -pht];

% Distances between the centers of the scoring sphere and PCD sensor area in cm
dx_list = [5 + pht/2, 15 + pht/2, 30 + pht/2, 45 + pht/2];

% Photon energy thresholds in eV
% Lower limit
e_min = [100, 0, 100, 100, 150, 200].*1000;
% Upper limit
e_max = [1000, 500, 500, 450, 450, 450].*1000;

% For each distance  
%for i = 1:length(dx_list)
% For distance 45 cm
for i = 4:4
    dx = dx_list(i);

    % Distance between the phantom side and the sensor in cm
    dist = dx - pht/2;

    % For each collimation strategy
    % Photons detected by PCD:
    %   "posPCD" - Photon position on the scoring surface
    %   "dirPCD" - Photon direction, energy and sensor area injection angle
    %   "posPCD_s" - Photon position on the PCD sensor area
    %   "collimation" - collimation strategy: 
    %     'Filter' - collimation by angle
    %     'Collimator' - collimation by a 3D collimator
    for c = 1:1
        if c == 1
            [posPCD, dirPCD, posPCD_s] = fPCD(pos, dir, dx, sy, sz, r_pht);
            collimation = 'Filter';
        else
            [hexagons,~, ~] = fCollimator(sy(1),sy(3),sz(1),sz(2),dx, "on");
            [posPCD, dirPCD, posPCD_s] = fPCD_col(pos, dir, dx, hexagons, r_pht);
            collimation = 'Collimator';
        end

        % For each energy threshold 
        %for j = 1:length(e_min)
        % For energy window "200<=E<=450 keV"
        for j = 6:6
            En_min = e_min(j);
            En_max = e_max(j);
            % "energy" - Energy threshold label
            if j == 1
                energy = '100<=E<=1000 keV';
            elseif j == 2 
                energy = 'E<=500 keV';
            elseif j == 3
                energy = '100<=E<=500 keV';
            elseif j == 4
                energy = '100<=E<=450 keV';
            elseif j == 5
                energy = '150<=E<=450 keV';
            else
                energy = '200<=E<=450 keV';
            end
    
            % Photons detected by PCD and met the energy threshold:
            %   "posEn" - Photon position on the scoring surface
            %   "dirEn" - Photon direction, energy and sensor area injection angle
            %   "posEn_s" - Photon position on the PCD sensor area
            %   "fig_a" - 2D detector sensor signal
            [posEn, dirEn, posEn_s, fig_a] = fEnergy(posPCD, dirPCD, posPCD_s, En_min, En_max,...
                dist, energy, collimation);
        
            % Heatmap of detected photon counts
            fig_b = fPcountMap(posEn_s, sy, sz, En_min, En_max, dist, energy, collimation, pht);
    
            % Photon counts
            %   "step" - Counting step in cm
            %   "counts" - Longitudinal photon counts per the step
            [step, counts] = fPcount(posEn_s, pht, v);
    
            % Simulated dose vs photon counts
            %   "fig_c" - A plot with longitudinal dose and photon counts profiles
            %   "fig_d" - A plot with dose values vs photon counts
            %   "Rsq" - Coefficient of Determination
            [fig_c, fig_d, Rsq]  = fPvsDose(step, counts, dose, En_min, En_max, dist, energy,...
                collimation, pht, v);
        end 
    end
end

% 2D Simulated depth-dose profile   
% Plotting parameters based on the phantom size
if pht == 30
    % Half of the phantom side in voxels
    vh = v/2;
    % xticks
    xt = [0 25 50 75 100 125 150];
    % xticklabels
    xtlabel = {'0', '5', '10', '15', '20', '25', '30'};
    % yticks
    yt = [0 25 50 75 100 125 150];
    % yticklabels
    ytlabel = {'-30', '-25', '-20', '-15', '-10', '-5', '0'};
else
    vh = v/2 + 0.5;
    xt = [0 15 30 45 60 75];
    xtlabel = {'0', '3', '6', '9', '12', '15'};
    yt = [0 15 30 45 60 75];
    ytlabel = {'-15', '-12', '-9', '-6', '-3', '0'};
end

figure('visible','off');
J = imrotate(dose(:,:,vh),180);
contourf(J)
c = colorbar;
colormap turbo
xlabel('Width, y (cm)', 'fontsize', 12, 'fontweight', 'bold')
ylabel('Depth, z (cm)', 'fontsize', 12, 'fontweight', 'bold')
ylabel(c,'Dose (Gy/particle)', 'fontsize', 12, 'fontweight', 'bold', 'Rotation', 270);
c.Label.Position (1:2) = [3 mean(c.Limits)];
xticks(xt)
xticklabels(xtlabel)
yticks(yt)
yticklabels(ytlabel)
title("2D gDPM Dose Profile") 
saveas(gcf, "2D_Dose.png")
