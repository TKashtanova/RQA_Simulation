% Create a heatmap of photon counts on the detector sensor
% Input: 
%       "pos_s" - photon position on the PCD sensor area
%       "sy", "sz" - PCD sensor coordinates in cm
%       "En_min" - Lower photon energy threshold in eV
%       "En_max" - Upper photon energy threshold in eV
%       "dist" - Distance between the phantom side and the sensor in cm
%       "energy" - Energy threshold label
%       "collimation" - collimation strategy
%       "pht" - Phantom side length in cm
% Output: 
%       A heatmap of detected photon counts
%       
% by Samuel Ydenberg


function f = fPcountMap(pos_s, sy, sz, En_min, En_max, dist, energy, collimation, pht)
    
    % Heatmap grid
    grid_x = linspace(sy(1),sy(3),pht);
    grid_y = linspace(sz(1),sz(2),pht);
    [xq,yq] = meshgrid(grid_x,grid_y);
    % Photon counts per cm^2
    zg = zeros(size(xq));
    for i = 1:size(pos_s,1)
        pt = pos_s(i,2:3);
        for j = 1:size(xq)-1
            for k = 1:size(yq)-1
                cond1 = xq(1,j) - pt(1);
                cond2 = xq(1,j+1) - pt(1);
                cond3 = yq(k,1) - pt(2);
                cond4 = yq(k+1,1) - pt(2);
                if cond1 < 0 && cond2 > 0 && cond3 < 0 && cond4 > 0
                    zg(j,k) = zg(j,k) + 1;
                end
            end
        end
    end

    f = figure('visible','off');
    contourf(xq, yq, zg')
    xlabel('Width, y (cm)','fontsize',12,'fontweight','bold')
    ylabel('Depth, z (cm)','fontsize',12,'fontweight','bold')
    c = colorbar;
    colormap turbo
    ylabel(c,'Photon Counts per cm^2','fontsize',12,'fontweight','bold','Rotation',270);
    c.Label.Position (1:2) = [3.5 mean(c.Limits)];
    title(energy + "; Distance " + dist + " cm; " + collimation) 
    saveas(gcf, strcat(string(En_max-En_min), "_", string(dist), "_", collimation, "_", "CountMap.png"))
 end
  
