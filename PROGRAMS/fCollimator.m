% Build a 3D collimator 
% Input: 
%          "col_*_***" - Collimator face size values
%          "dx" - Distance between the centers of the scoring sphere and PCD sensor area in cm
%          "view" - Indicator for collimator figure display
% Output: 
%          "hexagons" - 3D Collimator hexagonal holes
%          "border" - Collimator exterior border 
%          "f" - Collimator visualization
%
% by Samuel Ydenberg


function [hexagons,border, f] = fCollimator(col_x_min,col_x_max,col_y_min,col_y_max, dx, view)
    if view == "on"
        f = figure;
    else
        f = 0;
    end
    % Collimator septa thickness in cm
    septa_thick = 0.02;
    % Distance between the left most vertices of hexagons in odd/even
    % columns in cm
    skip_vec = -0.17; 
    % Geometrical triangle shapes in cm
    side_length = 0.0866; 
    tri_adj = 0.075;
    % Drawing start points
    col_z_min = 0;
    % Collimator thickness in cm
    col_z_max = 3.5;
    % Off-set in x-direction
    x_off = dx - col_z_max;
    % Track of hexagon indices
    count = 1;
    % List of hexagons
    hexagons = {};

    % Collimator 3D plot 
    for i = 1:2
        stop_while = false;
        k = [];
        l = [];
        if i == 1
            start_x = col_x_min;
            start_y = col_y_max - tri_adj;
        else
            start_x = col_x_min + ((side_length*1.5)+septa_thick);
            start_y = col_y_max - (septa_thick/2) - (tri_adj*2);
        end
        % Change the angle of the vector outlining a single hexagonal hole
        hexagon_angle = deg2rad(120); % rad
        % Define the next point
        side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
        % Define the vector outlining a single hexagonal hole   
        first_point = [start_x,start_y,col_z_min];
        second_point = first_point - side_vec;
        % Convert hexagone edges to 3D
        line_vec_x = [first_point(1),second_point(1),second_point(1),first_point(1),first_point(1),second_point(1)];
        line_vec_y = [first_point(2),second_point(2),second_point(2),first_point(2),first_point(2),second_point(2)];
        line_vec_z = [first_point(3),second_point(3),second_point(3)+col_z_max,first_point(3)+col_z_max,first_point(3),second_point(3)];
        prev_point = second_point;
        while(stop_while == false)
            % Angle of the next vector rotated by 60 degrees
            hexagon_angle = hexagon_angle + deg2rad(60);
            % If the angle exceeds 2pi, back to zero
            if hexagon_angle >= 6.28 
                hexagon_angle = 0;
            end
            side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
            % Paint hole edges
            %perp = perp_vec(side_vec)*(septa_thick/2);
            first_point = prev_point;
        
            % Prevent hexagons exceed the detector area limits
            if first_point(1) > col_x_max && first_point(2) < col_y_min 
                if i == 1
                    lop = 5;
                else
                    lop = 4;
                end
                for j = 1:lop
                    if j >= 2
                        hexagon_angle = hexagon_angle + deg2rad(60);
                        % If the angle exceeds 2pi, back to zero
                        if hexagon_angle >= 6.28 
                            hexagon_angle = 0;
                        end
                        side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
                        first_point = prev_point;
                    end
                    second_point = first_point - side_vec;
                    line_vec_x = [line_vec_x, second_point(1),second_point(1),first_point(1),first_point(1),second_point(1)];
                    line_vec_y = [line_vec_y, second_point(2),second_point(2),first_point(2),first_point(2),second_point(2)];
                    line_vec_z = [line_vec_z, second_point(3),(second_point(3)+col_z_max),(first_point(3)+col_z_max),first_point(3),second_point(3)];
                    prev_point = second_point;
                end

                if length(line_vec_x ) == 31
                    hold on;
                    plot3(line_vec_z+x_off,line_vec_x,line_vec_y,'k')
                    hexagons{1,count} = [line_vec_x;line_vec_y;line_vec_z];
                    count = count+1;
                end
                stop_while = true;
                
            % If, in the first set of hexagons, the vector outlining a hole
            % exceeds the detector area x-limit, finish the hexagons'
            % drawing and return to the x-minimum value
            elseif first_point(1) > col_x_max + (side_length*5) && i == 1
                if length(line_vec_x ) == 31
                    hold on;
                    plot3(line_vec_x,line_vec_y,line_vec_z,'r')
                    hexagons{1,count} = [line_vec_x;line_vec_y;line_vec_z];
                    count = count+1;
                end
                first_point = [start_x,line_vec_y(1)+skip_vec,0];
                line_vec_x = [first_point(1)];
                line_vec_y = [first_point(2)];
                line_vec_z = [first_point(3)];
                hexagon_angle = deg2rad(120);
                side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
            end
            
            k = [];
            l = [];
            second_point = first_point - side_vec;
            % Find repeated points to avoid infinite looping
            k = find(abs(line_vec_x-second_point(1))<0.001);
            l = find(abs(line_vec_y-second_point(2))<0.001);
            line_vec_x = [line_vec_x, second_point(1),second_point(1),first_point(1),first_point(1),second_point(1)];
            line_vec_y = [line_vec_y, second_point(2),second_point(2),first_point(2),first_point(2),second_point(2)];
            line_vec_z = [line_vec_z, second_point(3),(second_point(3)+col_z_max),(first_point(3)+col_z_max),first_point(3),second_point(3)];

            % Upon reaching the edge of a hexagon in the adjacent column
            if isempty(k) == 0 && isempty(l) == 0 && k(1) == l(1) && i ==2 && second_point(1) > col_x_max
                k = [];
                l = [];
                first_point = [start_x,line_vec_y(1)+skip_vec,0];
                line_vec_x = [first_point(1)];
                line_vec_y = [first_point(2)];
                line_vec_z = [first_point(3)];
                hexagon_angle = deg2rad(120);
                side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
                second_point = first_point - side_vec;
                line_vec_x = [line_vec_x, second_point(1),second_point(1),first_point(1),first_point(1),second_point(1)];
                line_vec_y = [line_vec_y, second_point(2),second_point(2),first_point(2),first_point(2),second_point(2)];
                line_vec_z = [line_vec_z, second_point(3),(second_point(3)+col_z_max),(first_point(3)+col_z_max),first_point(3),second_point(3)];

            % Upon completing the drawing of one hexagon
            elseif isempty(k) == 0 && isempty(l) == 0 && k(1) == l(1)
                k = [];
                l = [];
                
                if length(line_vec_x ) == 31
                    hold on;
                    plot3(line_vec_z+x_off,line_vec_x,line_vec_y,'k')
                    hexagons{1,count} = [line_vec_x;line_vec_y;line_vec_z];
                    count = count+1;
                end
                
                first_point = second_point - [(skip_vec*2+septa_thick*2),0,0];
                line_vec_x = [first_point(1)];
                line_vec_y = [first_point(2)];
                line_vec_z = [first_point(3)];
                hexagon_angle = deg2rad(120);
                side_vec = [cos(hexagon_angle)*side_length, sin(hexagon_angle)*side_length,0];
                second_point = first_point - side_vec;
                line_vec_x = [line_vec_x, second_point(1),second_point(1),first_point(1),first_point(1),second_point(1)];
                line_vec_y = [line_vec_y, second_point(2),second_point(2),first_point(2),first_point(2),second_point(2)];
                line_vec_z = [line_vec_z, second_point(3),(second_point(3)+col_z_max),(first_point(3)+col_z_max),first_point(3),second_point(3)];
            end
            prev_point = second_point;

        end
    end

    % Build an exterior collimator border
    % Find the boder limits
    x_min = col_x_min;
    x_max = -inf;
    y_min = inf;
    y_max = col_y_max-.001;
    ind_ymin = zeros(1,2);
    ind_xmax = zeros(1,2);
    for i = 1:size(hexagons,2)
        hex_num = hexagons{1,i};
        numm = hex_num(3,:)==0;
        new_list = hex_num(:,numm);
        hex_size = size(hex_num,2);
        xs = new_list(1,:);
        ys = new_list(2,:);
        [x_temp_max,max_x_ind] = max(xs);
        [y_temp_min,min_y_ind] = min(ys);
        if x_temp_max > x_max
            x_max = x_temp_max;
            ind_xmax = [i,max_x_ind];
        end
        if y_temp_min < y_min
            y_min = y_temp_min;
            ind_ymin = [i,min_y_ind];
        end
    end
    xminind = [];
    xmaxind = [];
    yminind = [];
    ymaxind = [];
    pind = [0,0,0];
    pind2 = [0,0,0];
    pt_list = [];
    % Find hexagon vertices corresponding to the maximum border limit
    for i = 1:size(hexagons,2)
        hex_num = hexagons{1,i};
        for j = 1:size(hex_num,2)
            pt = hex_num(:,j);
            if pt(3) == 0
                pt_list = [pt_list,pt];
                if pt(1) == x_min && pt(2) ~= pind(2) && pt(2) ~= pind2(2)
                    xminind = [xminind;i,30;i,1;i,2];
                    pind2 = pind;
                    pind = pt;
                elseif pt(1) >= (x_max-.0001) && pt(2) ~= pind2(2)
                    xmaxind = [xmaxind;i,17;i,12;i,7];
                    pind2 = pind;
                    pind = pt;
                elseif pt(2) == y_min && pt(1) ~= pind(1) && pt(1) ~= pind2(1)
                    yminind = [yminind;i,j];
                    pind2 = pind;
                    pind = pt;
                elseif pt(2) >= y_max && pt(1) ~= pind(1) && pt(1) ~= pind2(1)
                    ymaxind = [ymaxind;i,j];
                    pind2 = pind;
                    pind = pt;
                end
            end
        end
    end

    flip_max_x = flip(xmaxind,1);
    flip_max_y = flip(ymaxind,1);
    outer_maxmin = [];
    for i = 1:4
        
        if i == 1
            ind_list = xminind;
        elseif i == 2
            ind_list = yminind;
        elseif i == 3
            ind_list = flip_max_x;
        else
            ind_list = flip_max_y;
        end
           
        for j = 1:size(ind_list,1)
            cellind = ind_list(j,1);
            arrayind = ind_list(j,2);
            nex_hex = hexagons{1,cellind};
        if i == 1 % x min (left)
            x_pt = nex_hex(1,arrayind) - septa_thick;
            ad_pt = [x_pt;nex_hex(2:3,arrayind)];
        elseif i == 2 % y min (bottom)
            x_pt = nex_hex(2,arrayind) - septa_thick;
            ad_pt = [nex_hex(1,arrayind);x_pt;nex_hex(3,arrayind)];
        elseif i == 3 % x max (right)
            x_pt = nex_hex(1,arrayind) + septa_thick;
            ad_pt = [x_pt;nex_hex(2:3,arrayind)];
        else % y max (top)
            x_pt = nex_hex(2,arrayind) + septa_thick;
            ad_pt = [nex_hex(1,arrayind);x_pt;nex_hex(3,arrayind)];
            
        end
        outer_maxmin = [outer_maxmin, ad_pt];
        end
    end

    inds = [xminind(:,1);yminind(:,1);xmaxind(:,1);ymaxind(:,1)];
    hex_len = 1:1:size(hexagons,2);
    
    for i = 1:length(inds)
        hex_len = hex_len(hex_len~=inds(i));
    end

    removed_hex = {1,length(hex_len)};
    for i = 1:length(hex_len)
        removed_hex{1,i} = hexagons{1,hex_len(i)};
    end

    if size(removed_hex{1,1},1) < 3
        border = 0;
    else
        y_min = inf;
        y_max = -inf;
        for i = 1:size(removed_hex,2)
            hex_num = removed_hex{1,i};
            if size(hex_num,1) ~= 3
                removed_hex = removed_hex{1,i-1};
                break
            end
            numm = hex_num(3,:)==0;
            new_list = hex_num(:,numm);
            ys = new_list(2,:);
            [y_temp_max,max_y_ind] = max(ys);
            [y_temp_min,min_y_ind] = min(ys);
            if y_temp_max > y_max
                y_max = y_temp_max;
                ind_ymax = [i,max_y_ind];
            end
            if y_temp_min < y_min
                y_min = y_temp_min;
                ind_ymin = [i,min_y_ind];
            end
        end
    
        ysecind = [];
        ytriind = [];
        pind = [0,0,0];
        pind2 = [0,0,0];
    
        for i = 1:size(removed_hex,2)
            hex_num = removed_hex{1,i};
            for j = 1:size(hex_num,2)
                if hex_num(3,j) == 0
                    if hex_num(2,j) == y_min && hex_num(1,j) ~= pind(1) && hex_num(1,j) ~= pind2(1)
                        ysecind = [ysecind;i,j];
                        pind2 = pind;
                        pind = hex_num(:,j);
                    elseif hex_num(2,j) >= y_max && hex_num(1,j) ~= pind(1) && hex_num(1,j) ~= pind2(1)
                        ytriind = [ytriind;i,j];
                        pind2 = pind;
                        pind = hex_num(:,j);
                    end
                end
            end
        end
        
        outer_sectri = [];
        for i = 1:2
            
            if i == 1
                ind_list = ysecind;
            else
                ind_list = ytriind;
            end
               
            for j = 1:size(ind_list,1)
                cellind = ind_list(j,1);
                arrayind = ind_list(j,2);
                nex_hex = removed_hex{1,cellind};
            if i == 1 % y min (bottom)
                x_pt = nex_hex(2,arrayind) - septa_thick;
                ad_pt = [nex_hex(1,arrayind);x_pt;nex_hex(3,arrayind)];
            else % y max (top)
                x_pt = nex_hex(2,arrayind) + septa_thick;
                ad_pt = [nex_hex(1,arrayind);x_pt;nex_hex(3,arrayind)];
                
            end
            outer_sectri = [outer_sectri, ad_pt];
            end
        end
    
        outer_ring = [outer_maxmin,outer_sectri];
        xminsort = outer_ring(1,1);
        prev_val = 1;
        pind2 = 0;
        for i = 1:size(outer_ring,2)
            val = outer_ring(1,i);
            if val > prev_val
                prev_val = val;
            end
            if val > pind2 && val < prev_val
                pind2 = val;
            end
        end    
        xmaxsort = pind2-side_length;
    
        ind = find(outer_ring(1,:) <= xminsort);
        xmin = outer_ring(:,ind);
        outer_ring(:,ind) = [];
    
        ind = find(outer_ring(1,:) >= xmaxsort);
        xmax = outer_ring(:,ind);
        outer_ring(:,ind) = [];
    
        ind = find(outer_ring(2,:) > (col_y_min/2));
        ymax = outer_ring(:,ind);
        outer_ring(:,ind) = [];
    
        ymin = outer_ring;
    
        [~,I] = sort(ymin(1,:));
        miny = ymin(:,I);
        [~,I] = sort(ymax(1,:));
        I_f = flip(I);
        maxy = ymax(:,I_f);
    
        [~,I] = sort(xmax(2,:));
        maxx = xmax(:,I);
    
        border = [xmin,miny,maxx,maxy,xmin(:,1)];
       
        for i = 2:length(border)
            first_point = border(:,i);
            second_point = border(:,i-1);
            vec_x = [first_point(1), second_point(1),second_point(1),first_point(1)];%,first_point(1),second_point(1)];
            vec_y = [first_point(2), second_point(2),second_point(2),first_point(2)];%,first_point(2),second_point(2)];
            vec_z = [first_point(3), second_point(3),second_point(3)+col_z_max,first_point(3)+col_z_max];%,first_point(1),second_point(1)];
            patch(vec_z+x_off,vec_x,vec_y,"k")
        end
    end

end
