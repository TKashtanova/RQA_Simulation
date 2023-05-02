% Record photons detected by PCD with a 3D collimator placed in front of it
% Input: 
%       "pos" - Photon position on the scoring sphere (x, y, z, r) in cm
%       "dir" - Photon momentum direction (x, y, z) in cm and energy in eV
%       "dx" - Distance between the centers of the scoring sphere and PCD sensor area in cm
%       "hexagons" - 3D collimator hexagonal holes
%       "r_pht" - Phantom circumscribed sphere radius
% Output:
%       "posPCD" - Detected photon position on the scoring surface
%       "dirPCD" - Detected photon direction, energy and sensor area injection angle
%       "posPCD_s" - Detected photon position on the PCD sensor area
%
% by Samuel Ydenberg and Tatiana Kastanova


function [posPCD,dirPCD,posPCD_s] = fPCD_col(pos, dir, dx, hexagons, r_pht)
    % Condition 1: Keep photons that left the phantom
    c1 = pos(:,4) > r_pht;
    pos1 = pos(c1,:);
    dir1 = dir(c1,:);
    % Condition 2: Keep photons moving in positive x-direction
    c2 = dir1(:,1) > 0;
    pos2 = pos1(c2,:);
    dir2 = dir1(c2,:);
    % Photon position on the sensor area 
    posPCD_s = zeros(size(pos2,1),3);
    % Photon position on the scoring sphere
    posPCD = zeros(size(pos2,1),3);
    % Photon direction, energy and sensor area injection angle
    dirPCD = zeros(size(pos2,1),5);

    % First hexagon to determine z maximum value
    init_hex = hexagons{1,1};
    % The maximum z value for the photon to "back track" to
    back_track = max(init_hex(3,:));
    count = 1;

    % Find the x and y value points for hexagon holes
    prev_valy = 0;
    prev_valx = 1;
    hex_ycoords = [];
    hex_xcoords = 0.8660;
    yindices = [];
    xindices = 1;
    for i = 1:size(hexagons,2)
        hex = hexagons{1,i};
        valy = (hex(2,2) + hex(2,17)) / 2;
        valx = (hex(1,1) + hex(1,12)) / 2;
        if round(prev_valy,4) ~= round(valy,4)
            hex_ycoords = [hex_ycoords,valy];
            yindices = [yindices,i];
            prev_valy = valy;
        end
        logic = 0;
        for k = 1:length(xindices)
            if hex_xcoords(k) == round(valx,4)
                logic = 1;
                break
            end
            qqq = 0;
        end
        if logic == 0
            hex_xcoords = [hex_xcoords,round(valx,4)];
            xindices = [xindices,i];
            prev_valx = valx;
        end
    end
    szy = length(yindices);
    szx = length(xindices);
    szxx = round(szx/2)+1;
   
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

        % The y position at the front of the collimator
        fpy = py - dir(i,2)*back_track;
        % The z position at the front of the collimator
        fpz = pz - dir(i,3)*back_track;

        prev_diff = inf;
        chosen_ind = 0;
        c = 1;
        
        % The closest row of hexagons 
       for j = 1:length(yindices)
            yclval = hex_ycoords(j);
            if j > round(szy/2)       
                for k = szxx:length(xindices)
                    xclval = hex_xcoords(k);
                    diff_val = abs(fpz - yclval) + abs(fpy - xclval);
                    c = c + 1;
                    if diff_val < prev_diff
                        chosen_ind = c - 1;
                        prev_diff = diff_val;
                    end
                end
            else
                for k = 1:(szxx - 1)
                    xclval = hex_xcoords(k);
                    diff_val = abs(fpz - yclval) + abs(fpy - xclval);
                    c = c + 1;
                    if diff_val < prev_diff
                        chosen_ind = c - 1;
                        prev_diff = diff_val;
                    end
                end
            end
        end

        if chosen_ind > size(hexagons,2)
            chosen_ind = size(hexagons,2);
        end

        % Create 2D hexagon from 3D hexagon
        cur_hex = hexagons{1,chosen_ind};
        front_hex = [cur_hex(1:2,1),cur_hex(1:2,2),cur_hex(1:2,7),cur_hex(1:2,12),cur_hex(1:2,17),cur_hex(1:2,22)];
        % Hexagons y and z points 
        hex_y = front_hex(1,:);
        hex_z = front_hex(2,:);
        % Check if the points land within the hexagon at the front of collimator- 
        % fin is within the hexagon; fon is on the edge of it
        [fin,fon] = inpolygon(fpy,fpz,hex_y,hex_z);
        % Check if the points land within the hexagon at the back of collimator- 
        % bin is within the hexagon; bon is on the edge of it
        [bin,bon] = inpolygon(py,pz,hex_y,hex_z);
        % If the photon is within or on the same hexagon at the front and back of the collimator
        if (fin ~= 0 && bin ~= 0) || (fin ~= 0 && bon ~= 0) || (fon ~= 0 && bin ~= 0) || (fon ~= 0 && bon ~= 0)
            % Sensor area injection angle
            phi = asin(abs(dir2(i,1))/sqrt(dir2(i,1)^2 + dir2(i,2)^2 + dir2(i,3)^2));
            phi = phi *180/pi;  
            % Save values
            posPCD_s(count,:) = [dx py pz];
            posPCD(count,:) = pos2(i,1:3);       
            dirPCD(count,:) = [dir2(i,1:4),phi];
            count = count + 1;
        end
    end
    posPCD_s = posPCD_s(1:(count-1),:);
    posPCD = posPCD(1:(count-1),:);
    dirPCD = dirPCD(1:(count-1),:);
end
