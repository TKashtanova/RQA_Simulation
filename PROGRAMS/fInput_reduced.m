% Read gDPM output files reduced in size
% Input: 
%       "path" - Path to the gDPM output files
%       "v" - Number of voxels per the phantom side in gDPM
% Output: 
%       "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
%       "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
%       "dose" - Delievered dose in Gy/particle 
% 
% by Dr. Yujie Chi, Tatiana Kashtanova, and Samuel Ydenberg


function [pos, dir, dose] = fInput_reduced(path, v)
    
    % Photon position on the scoring sphere (x, y, z, r)
    fileID = fopen(strcat(path,"posvec.txt"));
    formatSpec = '%f %f %f %f';
    sizeA = [4 Inf];
    A = fscanf(fileID,formatSpec,sizeA);
    fclose(fileID);
    pos = [A(1:2,:)',-A(3,:)',A(4,:)'];
    pos(:,4) = sqrt(pos(:,1).^2 + pos(:,2).^2 + pos(:,3).^2);
    
    % Photon direction (x, y, z) and energy
    fileID1 = fopen(strcat(path,"dirvec.txt"));
    formatSpec = '%f %f %f %f';
    sizeA = [4 Inf];
    A = fscanf(fileID1,formatSpec,sizeA);
    fclose(fileID1);
    dir = [A(1:2,:)',-A(3,:)',A(4,:)'];

    % Delievered dose in Gy/particle
    dose_path = strcat(path,'dose.img');
    fid  = fopen(dose_path);
    data = fread(fid,'single');
    fclose(fid);
    % Dose scaling per the mentors' guidance
    data2 = data.*1.6*10^(-10);
    dose = reshape(data2,[v v v]);
end
