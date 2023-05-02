% Filter detected by PCD photons based on the specified energy threshold
% Input: 
%       "posPCD" - Detected photon position on the scoring surface
%       "dirPCD" - Detected photon direction, energy and sensor area injection angle
%       "posPCD_s" - Detected photon position on the PCD sensor area
%       "En_min" - Lower photon energy threshold in eV
%       "En_max" - Upper photon energy threshold in eV
%       "dist" - Distance between the phantom side and the sensor in cm
%       "energy" - Energy threshold label
%       "collimation" - collimation strategy
%       
% Output:
%       "posEn" - Filtered photon position on the scoring surface
%       "dirEn" - Filtered photon direction, energy and sensor area injection angle
%       "posEn_s" - Filtered photon position on the PCD sensor area
%       "f" - 2D detector sensor signal
% 
% by Tatiana Kashtanova


function [posEn, dirEn, posEn_s, f] = fEnergy(posPCD, dirPCD, posPCD_s, En_min, En_max, dist, energy, collimation)
    c = find((dirPCD(:,4) >= En_min) & (dirPCD(:,4) <= En_max));
    posEn = posPCD(c,:);
    dirEn = dirPCD(c,:);
    posEn_s = posPCD_s(c,:);

    f = figure('visible','off');
    scatter(posEn_s(:,2), posEn_s(:,3), 10, dirEn(:,4), 'filled')
    c = colorbar;
    xlabel('Width, y (cm)','fontsize',12,'fontweight','bold')
    ylabel('Depth, z (cm)','fontsize',12,'fontweight','bold')
    colormap turbo
    ylabel(c,'Energy (eV)','fontsize',12,'fontweight','bold','Rotation',270);
    c.Label.Position (1:2) = [3.5 mean(c.Limits)];
    title({'2D Detector Signal',(energy + "; Distance " + dist + " cm; " + collimation) }) 
    saveas(gcf, strcat(string(En_max-En_min), "_", string(dist), "_", collimation, "_", "2DSignal.png"))
end








