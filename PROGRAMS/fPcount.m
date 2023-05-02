% Compute longitudinal photon counts
% Input: 
%       "pos" - Photon position on the scoring surface  
%       "pht" - Phantom side length in cm
%       "v" - Number of voxels per the phantom side in gDPM
% Output:
%       "step" - Counting step in cm
%       "counts" - Longitudinal photon counts per the step
%
% by Tatiana Kashtanova


function [step, counts] = fPcount(pos_s, pht, v)   
    % Counting step in cm
    step = pht/v;
    % Longitudinal photon counts per the step
    counts = zeros(v,1);
    k = 0;
    for h = 1:v
        ct = nnz(pos_s(:,3)<=0-k & pos_s(:,3)>-step-k);
        counts(h) = ct;
        k = k + step;
    end
end

















