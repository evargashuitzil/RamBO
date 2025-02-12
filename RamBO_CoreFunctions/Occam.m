function Occam_Out = Occam(OccamConfig, ModelConfig, DataConfig)

% Occam's inversion
%
% Inputs:
%   OccamConfig                 - Configuration of Occam
%   OccamConfig.TargetRMS       - Target Root Mean Square (RMS) error (default is 1.0).
%   OccamConfig.muRange         - Vector specifying the range of regularization strengths (lambda).
%   OccamConfig.MaxIts          - Maximum number of iterations allowed for inversion.
%   OccamConfig.tol             - Tolerance for convergence
%
% Outputs:
%   Occam_Out
%   Occam.modelEst     - (nm x MaxIts) Estimated model after inversion.
%   Occam.predRes      - (nd x MaxIts) Predicted Responses of the model.
%   Occam.muAll        - (MaxIts x 1)  Regularization strengths (mu) used in inversion.
%   OccamRMS          - (MaxIts x 1)  Root Mean Square (RMS) error across iterations.

disp(' ')
fprintf('   Occam \n');
fprintf('========================\n');

MaxIts = OccamConfig.MaxIts;
muRange = OccamConfig.muRange;
TargetRMS = OccamConfig.TargetRMS;
m = ModelConfig.mo;
d = DataConfig.d;
s = DataConfig.s;
h = ModelConfig.h;
n = ModelConfig.nm;         

%% Finite differences for regularization
D = getD(ModelConfig);

%% Pre-allocate arrays
tmpRMS = zeros(length(muRange),1);
tmpMs = zeros(n,length(muRange));
tmpDs = zeros(length(d),length(muRange));

Ms = zeros(length(h),MaxIts); 
Ds = zeros(length(d),MaxIts);
RMS = zeros(MaxIts,1);
muAll = zeros(MaxIts,1);

%% configure exit conditions
for oo=1:MaxIts
    [Fk,J] = F(m,ModelConfig,DataConfig);
    dhat = s.\(d - Fk + J*m);
    Jhat = s.\J;
    for kk=1:length(muRange)
        A = sparse([Jhat; sqrt(10^muRange(kk))*D]);
        tmpMs(:,kk) = A\[dhat; zeros(n,1)];
        tmpDs(:,kk) = F(tmpMs(:,kk),ModelConfig,DataConfig);
        tmpRMS(kk) = rms(s.\(d-tmpDs(:,kk)));
    end
    [MinRMSE,ind] = min(tmpRMS);
    if MinRMSE<TargetRMS
        ind = find(tmpRMS<TargetRMS,1,'last');        
    end
    % save
    muAll(oo) = muRange(ind);
    RMS(oo)   = tmpRMS(ind);
    Ms(:,oo)  = tmpMs(:,ind);
    Ds(:,oo)  = tmpDs(:,ind);

    % next model for linearization
    mOld = m;
    m = tmpMs(:,ind);
    
    % check exit conditions
    fprintf('Occam iteration %g, μ = %g, RMS = %g, roughness = %g \n',oo,muAll(oo),RMS(oo),norm(D*m))
    % check exit conditions
    if oo>MaxIts || oo>1 && abs(norm(D*m)-norm(D*mOld))/norm(D*mOld)<1e-2 
        break
    end
end

%% Write to output structure
Occam_Out.modelEst = Ms(:,1:oo);
Occam_Out.predRes = Ds(:,1:oo);
Occam_Out.RMS = RMS(1:oo);
Occam_Out.muAll = muAll(1:oo);
fprintf('========================\n');