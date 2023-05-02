% Create a density file for a water phantom of the desired dimensions
% Input: 
%       "v" - Number of voxels per the phantom side in gDPM
% Output:
%       "density.img" - a Water phantom density file
% 
% by Tatiana Kashtanova

clear;
clc;

% Number of voxels per the phantom side in the gDPM
% 150 voxels correspond to 30 cm
% 75 voxels correspond to 15 cm
%v = 150;
v = 75;

% Density file
density = ones(v, v, v);
fid  = fopen("./density.img", "w");
fwrite(fid,density, 'single');
fclose(fid);



