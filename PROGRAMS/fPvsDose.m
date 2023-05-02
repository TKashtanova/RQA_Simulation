% Analyse the longitudinal profiles of simulated dose and scattered photon counts
% Input: 
%       "step" - Counting step in cm
%       "counts" - Longitudinal photon counts per the step
%       "dose" - gDPM delievered dose in Gy/particle
%       "En_min" - Lower photon energy threshold in eV
%       "En_max" - Upper photon energy threshold in eV
%       "dist" - Distance between the phantom side and the sensor in cm
%       "energy" - Energy threshold label
%       "collimation" - collimation strategy 
%       "pht" - Phantom side length in cm
%       "v" - Number of voxels per the phantom side in gDPM
% Output:
%       "f1" - A plot with longitudinal dose and photon counts profiles
%       "f2" - A plot with dose values vs photon counts
%       "Rsq" - Coefficient of Determination
%
% by Tatiana Kashtanova


function [f1, f2, Rsq] = fPvsDose(step, counts, dose, En_min, En_max, dist, energy, collimation, pht, v)
    
    % Simulated longitudinal dose profile in Gy
    % by Samuel Ydenberg
    dose_data = zeros(v,1);
    for i = 1:v
        J = dose(:,:,i);
        for j  = 1:v
            K = sum(J(j,:));
            dose_data(j) = dose_data(j) + K;
        end
    end

    %  Longitudinal dose and photon counts profiles
    % Plotting parameters based on the phantom size
    if pht == 30
        xt = [0 50 100 150];
        xtlabel = {'0', '-10', '-20', '-30'};
    else
        xt = [0 25 50 75];
        xtlabel = {'0', '-5', '-10', '-15'};
    end
    f1 = figure('visible','off');
    yyaxis left
    plot(dose_data, 'linewidth', 1, 'color', 'black', 'DisplayName', 'gDPM')
    ylim1 = max(dose_data) + min(dose_data);
    ylim([0 ylim1])
    xlabel('Depth, z (cm)', 'fontsize', 12, 'fontweight', 'bold')
    ylabel('Dose (Gy)', 'fontsize', 12, 'fontweight', 'bold', 'color', 'black')
    yyaxis right
    plot(counts, 'linewidth', 1, 'color', "#0072BD", 'DisplayName', energy)
    ylim2 = max(counts) + min(counts);
    ylim([0 ylim2])
    ylabel(strcat("Photon Counts per ", string(step), " cm"),...
        'fontsize', 12, 'fontweight', 'bold')
    yl = get(gca,'ylabel');                                                      
    yl_pos = get(yl, 'Position');
    yl_pos(1) =  yl_pos(1) + 5;
    set(yl, 'Rotation', -90,  'Position', yl_pos, 'VerticalAlignment', 'middle',...
        'HorizontalAlignment', 'center')
    xticks(xt)
    xticklabels(xtlabel)
    ax = gca;
    ax.Position = [0.12 0.12 0.75 0.8];
    ax.YAxis(1).Color = "black";
    ax.YAxis(2).Color = "#0072BD";
    title(energy + "; Distance " + dist + " cm; " + collimation) 
    saveas(gcf, strcat(string(En_max-En_min), "_", string(dist), "_", collimation, "_", "PvsDose.png"))

    % Coefficient of Determination (R-squared)
    test = [dose_data, counts];
    R = corrcoef(test);
    Rsq = round(R(2,1)^2,4);

    % Dose vs. photon counts
    f2 = figure('visible','off');
    scatter(counts, dose_data, "MarkerEdgeColor", "#77AC30")
    ylabel('Dose (Gy)', 'fontsize', 12, 'fontweight', 'bold')
    xlabel(strcat("Photon Counts per ", string(step), " cm"),...
        'fontsize', 12, 'fontweight', 'bold')
    text(0.7*ylim2, 0.4*ylim1, strcat("R^2 = ", string(Rsq)))
    title(energy + "; Distance " + dist + " cm; " + collimation) 
    saveas(gcf, strcat(string(En_max-En_min), "_", string(dist), "_", collimation, "_",...
        "PvsDose_corr.png"))
end


















