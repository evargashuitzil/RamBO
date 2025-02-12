function RamBO_Out = RamBO(RamBOConfig, ModelConfig, DataConfig)

% RamBO - Randomized blocky Occam
%
% Inputs:
%   RamBOConfig                 - Configuration of RamBO
%   RamBOConfig.TargetRMS       - Target Root Mean Square (RMS) error (default is 1.0).
%   RamBOConfig.muRange         - Vector specifying the range of regularization strengths (lambda).
%   RamBOConfig.MaxIts          - Maximum number of iterations allowed for inversion.
%   RamBOConfig.RoughTol        - Tolerance for convergence in roughness
%   RamBOConfig.BregmanTol      - Tolerance for split Bregman
%   RamBOConfig.BregmanMaxIts   - Max. number of iterations in split Bregman
%
%   For UQ
%   RamBOConfig.nos             - Number of RamBO samples
%   RamBOConfig.mu              - Regularization parameter
%   RamBOConfig.alpha           - Step size
%   RamBOConfig.RMSThreshold    - Declare optimization as failed if RMS is above this threshold 
%
% Outputs:
%   Blocky Occam Outputs
%   RamBO_Out.BO_modelEst     - Blocky Occam model in each iteration
%   RamBO_Out.BO_predRes      - Response in each iteration
%   RamBO_Out.BO_muAll        - Regularization strengths (mu) in each iteration
%   RamBO_Out.BO_RMS          - Root Mean Square (RMS) error in each iteration
%
%   UQ
%   RamBO_Out.RamBO_modelEst  - Posterior samples
%   RamBO_Out.RamBO_predRes   - Responses of posterior samples
%   RamBO_Out.RamBO_RMS       - RMS of posterior samples
%   RamBO_Out.RamBO_nos       - Number of posterior samples
    
%% Blocky Occam
[modelEst,predRes,RMS,muAll] =...
                blockyOccam(RamBOConfig, ModelConfig, DataConfig);
RamBO_Out.BO_modelEst = modelEst;
RamBO_Out.BO_predRes = predRes;
RamBO_Out.BO_RMS = RMS;
RamBO_Out.BO_muAll = muAll;

%% UQ
if RamBOConfig.nos > 1
    nos   = RamBOConfig.nos;
    blockyOccamModel = modelEst(:,end);
    % initialize arrays
    modelEst = zeros(ModelConfig.nm,nos);
    predRes  = zeros(DataConfig.nd,nos);
    RMS      = zeros(nos,1);

    disp(' ')
    fprintf('   RamBO \n');
    fprintf('========================\n');
    for kk=1:nos
        % Optimize with blocky Occam and fixed regularization
        [tmpModel,tmpPredRes,tmpRMS] =...
                        blockyOccamFixedMu(blockyOccamModel,RamBOConfig, ModelConfig, DataConfig);
        % Save
        modelEst(:,kk) = tmpModel;
        predRes(:,kk)  = tmpPredRes;
        RMS(kk)        = tmpRMS;

        % Show progress
        fprintf('Sample %g/%g. RMS = %g \n',kk,nos,RMS(kk))
    end
    fprintf('========================\n');
    
    % Delete failed optimization attempts
    inds = find(RMS<RamBOConfig.RMSThreshold);
    modelEst = modelEst(:,inds);
    predRes  = predRes(:,inds);
    RMS      = RMS(inds);

    % Save to output struct
    RamBO_Out.RamBO_modelEst = modelEst;
    RamBO_Out.RamBO_predRes = predRes;
    RamBO_Out.RamBO_RMS = RMS;
    RamBO_Out.RamBO_nos = length(RMS);
end

end