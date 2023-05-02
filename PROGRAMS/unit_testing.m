% Unit tests of the code major functions
%
% by Samuel Ydenberg


%% Test of photon movement
clc;
clear;
% Photon position on the scoring sphere (x, y, z, r) in cm
pos = [0,0,0,0; 0,0,0,0;0,0,0,0];
% Photon direction (x, y, z) in cm and photon energy in eV
dir = [1,0,0,0;0,1,0,0;0,0,1,0];
% Distance between the centers of the scoring sphere and PCD sensor area in cm
sensor_dist = 100;
% Visualization space phases
num_frames = 100;
axes_limit = 100;
fin_pos = fAnimation(pos,dir,sensor_dist,axes_limit,num_frames,1,"on");

% Expected final position is 100,0,0
if fin_pos(1) == 100 && fin_pos(2) == 0 && fin_pos(3) == 0
    disp("Test passed, particle movement successful")
end

%% Test of detector sorting
% Distance between the centers of the scoring sphere and PCD sensor area in cm
dx = 100;
% PCD sensor coordinates in cm
sensor_x = [dx;dx;dx;dx];
sensor_y = [0;0;30;30];
sensor_z = [-30;0;0;-30];

% Photon starting at [0,10,-10] and moving in x-direction should
%    collide with the detector
% Photon starting at [0,-1,0] nd moving in x-direction shouldn't
%    collide with the detectoror
% Photon position on the scoring sphere (x, y, z, r) in cm
pos = [0,10,-10,30;30,-1,0,30];
% Photon direction (x, y, z) in cm and photon energy in eV
dir = [1,0,0,1e6;1,0,0,1e6];

[fin_pos,fin_dir,~] = fPCD(pos,dir,dx,sensor_y,sensor_z,0);
[~] = fAnimation(pos,dir,sensor_dist,axes_limit,100,1,"on");

if size(fin_pos,1) == 1
   disp("Test passed, detector sorting successful") 
end

%% Test of photon sorting based on energy threshold
% Photon position on the scoring sphere (x, y, z, r) in cm
pos = [0,10,-10,0;0,20,-20,0;0,25,-25,0];
% Photon direction (x, y, z) in cm and photon energy in eV
dir = [1,0,0,10e5;1,0,0,10e3;1,0,0,10e7];
% Photon position on the PCD sensor area
pos_s = [100,10,-10,0;100,20,-20,0;100,25,-25,0];

% Energy threshold
thresh1 = 10e4;
thresh2 = 10e8;
name = "Test";
collimation = "angle";

[posEn, ~, ~, ~] = fEnergy(pos, dir, pos_s, thresh1, thresh2, dx, name,collimation);

% Plots
figure
subplot(1,2,1)
scatter(pos(:,2),pos(:,3),40,"b","filled")
%set(gca,"color","r")
axis([0 30 -30 0])

subplot(1,2,2)
scatter(posEn(:,2),posEn(:,3),40,"b","filled")
%set(gca,"color","r")
axis([0 30 -30 0])

%% Collimator design test
[~,~, f] = fCollimator(0,5,-5,0,10, "on");

%% Collimation test
% Test of particle sorting using the collimator
% Create single hexagon collimator
[hex,~, fcol] = fCollimator(0,0.1,-1,0,10, "on");

% Create three photons, one that will pass through the collimator, one
% that will collide with the wall and one that would hit the face
pos = [0,0.8,-0.8,27;0,0,0.8,27;0,0.75,-1.6,27];
dir = [1,0,0,0; 0.98,0,-0.18,0; 1,0,0,0];

[posout,dirout,pos_sout] = fPCD_col(pos,dir,10,hex,0);

if posout == pos(1,1:3)
    disp("Collimator sorting successful")
end

%% Testing sorting within the gDPM Architecture
path = strcat("./data/data_dub/");

[pos, dir, dose] = fInput_full(path);
[pos_cut, dir_cut, ~] = fInput_reduced(path);

% PCD sensor coordinates in cm
% Phantom side length in cm
pht = 30;
sy = [0;0;pht;pht];
sz = [-pht;0;0;-pht];
% Phantom circumscribed sphere radius
r_pht = pht * sqrt(3)/2;
dx = 19;
dist = dx - pht/2;

[posPCD, dirPCD, posPCD_s] = fPCD(pos, dir, dx, sy, sz, r_pht);
[posPCDc, dirPCDc, posPCD_sc] = fPCD(pos_cut, dir_cut, dx, sy, sz, r_pht);
collimation = 'Filter';

energy = '>=100 keV';
En = 100000;

[posEn, dirEn, posEn_s, fig_a] = fEnergy(posPCD, dirPCD, posPCD_s, En, dist, energy, collimation);
[posEnc, dirEnc, posEn_sc, fig_ac] = fEnergy(posPCDc, dirPCDc, posPCD_sc, En, dist, energy, collimation);
 
% Longitudinal photon counts
counts = fPcount(posEn_s);

% The gDPM depth-dose profile vs scattered photons' counts
fig_c = fPvsDose(counts, dose, En, dist, energy, collimation);

% Longitudinal photon counts
countsc = fPcount(posEn_sc);

% The gDPM depth-dose profile vs scattered photons' counts
fig_cc = fPvsDose(countsc, dose, En, dist, energy, collimation);