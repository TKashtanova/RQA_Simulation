% Read original (full size) gDPM output files
% Input: 
%       "path" - Path to the gDPM output files
%       "v" - Number of voxels per the phantom side in gDPM
% Output: 
%       "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
%       "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
%       "dose" - Delivered dose in Gy/particle 
% 
% by Dr. Yujie Chi, Tatiana Kashtanova, and Samuel Ydenberg


function [pos, dir, dose] = fInput_full(path, v)

    % Photon position on the scoring sphere (x, y, z, r)
    fp = strcat(path,"PSFpos.dat");
    f = fopen(fp);
    pos = fread(f,'float');
    fclose(f);
    pos = reshape(pos,[4,length(pos)/4]); 
    pos = pos';
    pos(:,4)=sqrt(sum(pos(:,1:3).*pos(:,1:3),2));
     
    % Photon direction (x, y, z) and energy
    fp = strcat(path,"PSFdir.dat");
    f = fopen(fp);
    dir = fread(f,'float');
    fclose(f);
    dir = reshape(dir,[4,length(dir)/4]);
    dir = dir'; 
    
    % Flip z-coordinates
    pos(:,3) = -pos(:,3);
    dir(:,3) = -dir(:,3);
   
    % Delievered dose in Gy/particle
    dose_path = strcat(path,'dose.img');
    fid  = fopen(dose_path);
    data = fread(fid,'single');
    fclose(fid);
    % Dose scaling per the mentors' guidance
    data2 = data.*1.6*10^(-10);
    dose = reshape(data2,[v v v]);
end






