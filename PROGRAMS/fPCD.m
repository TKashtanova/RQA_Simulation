% Record photons detected by PCD using angular collimation
% Input: 
%       "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
%       "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
%       "dx" - Distance between the centers of the scoring sphere and PCD sensor area in cm
%       "sy" and "sz" - PCD sensor coordinates in cm
%       "r_pht" - Phantom circumscribed sphere radius
% Output:
%       "posPCD" - Detected photon position on the scoring surface
%       "dirPCD" - Detected photon direction, energy and sensor area injection angle
%       "posPCD_s" - Detected photon position on the PCD sensor area
% 
% by Tatiana Kashtanova


function [posPCD, dirPCD, posPCD_s] = fPCD(pos, dir, dx, sy, sz, r_pht)
    % Filter photons based on conditions
    % Condition 1: Keep photons that left the phantom
    c1 = pos(:,4) > r_pht;
    pos1 = pos(c1,:);
    dir1 = dir(c1,:);
    % Condition 2: Keep photons moving in positive x-direction
    c2 = dir1(:,1) > 0;
    pos2 = pos1(c2,:);
    dir2 = dir1(c2,:);
    % Condition 3: Record photons collided with the sensor area
    % at 88.5-90 degrees angle 
    c3 = zeros(size(pos2,1),1);
    % Photon position on the sensor area 
    posPCD_s = zeros(size(pos2,1),3);
    % Photon position on the scoring sphere
    posPCD = zeros(size(pos2,1),3);
    % Photon direction, energy and sensor area injection angle
    dirPCD = zeros(size(pos2,1),5);
    for i = 1:size(pos2,1)
        % Forward-track or back-track photons from the scoring sphere
        % surface depending on their position relative to the sensor plane
        if pos2(i,1) <= dx
            dirr1 = dir2(i,1);
            dirr2 = dir2(i,2);
            dirr3 = dir2(i,3);
        else
            dirr1 = -dir2(i,1);
            dirr2 = -dir2(i,2);
            dirr3 = -dir2(i,3);
        end
        % Parametric representation of photon trajectory
        % px = pos_x + t*dir_x = dx
        t = (dx - pos2(i,1))/dirr1;
        % py = pos_y + t*dir_y
        py = pos2(i,2) + t*dirr2;
        % pz = pos_z + t*dir_z
        pz = pos2(i,3) + t*dirr3;
        if(py >= sy(1) && py <= sy(3) && pz >= sz(1) && pz <= sz(2))
            % Sensor area injection angle
            phi = asin(abs(dir2(i,1))/sqrt(dir2(i,1)^2 + dir2(i,2)^2 + dir2(i,3)^2));
            phi = phi *180/pi;
            if phi >=88.5 && phi <= 90
                c3(i,:) = 1;
                % Save values
                posPCD_s(i,:) = [dx py pz];
                posPCD(i,:) = pos2(i,1:3);       
                dirPCD(i,:) = [dir2(i,1:4) phi]; 
            else
                c3(i,:) = 0;
                posPCD_s(i,:) = [0 0 0];
                posPCD(i,:) = [0 0 0];
                dirPCD(i,:) = [0 0 0 0 0];
            end
        else
            c3(i,:) = 0;
            posPCD_s(i,:) = [0 0 0];
            posPCD(i,:) = [0 0 0];
            dirPCD(i,:) = [0 0 0 0 0];
        end
    end
    c3 = c3(:,1) > 0;
    posPCD_s = posPCD_s(c3,:);
    posPCD = posPCD(c3,:);
    dirPCD = dirPCD(c3,:);
end


















