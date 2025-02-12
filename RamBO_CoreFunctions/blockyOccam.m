function [modelEst,predRes,RMS,muAll] =...
                blockyOccam(RamBOConfig, ModelConfig, DataConfig)
disp(' ')
fprintf('   Blocky Occam  \n');
fprintf('========================\n');
%% Translate basic parameters
m = ModelConfig.mo;
TargetRMS = RamBOConfig.TargetRMS ;
muRange = RamBOConfig.muRange;
MaxIts = RamBOConfig.MaxIts;
RoughTol = RamBOConfig.RoughTol;
BregmanTol = RamBOConfig.BregmanTol;
BregmanMaxIts = RamBOConfig.BregmanMaxIts;

%% Translate handy model parameters
nm = ModelConfig.nm;  % number of model parameters (nm)
nd = DataConfig.nd;  % number of data points (nd)

%% Construct the D matrix
D = getD(ModelConfig);

%% Get data
d = DataConfig.d;
s = DataConfig.s;

%% Pre-allocate arrays
tmpRMS = zeros(length(muRange),1);
tmpmodelEst = zeros(nm,length(muRange));
tmpResponse = zeros(nd,length(muRange));

modelEst = zeros(nm,MaxIts); 
predRes = zeros(nd,MaxIts);
RMS = zeros(MaxIts,1);
muAll = zeros(MaxIts,1);

rOld = norm(D*m);
%% Blocky Occam
for jj=1:MaxIts 
    [Fk,J] = F(m,ModelConfig,DataConfig);
    dhat = s.\(d - Fk + J*m);
    Jhat = s.\J;
   
    %% Loop over regularization parameters (log-scale)
    for kk=1:length(muRange)
        tmpmodelEst(:,kk) = BregmanSplit(Jhat,dhat,10^muRange(kk),D,0,BregmanTol,BregmanMaxIts);
        tmpResponse(:,kk) = F(tmpmodelEst(:,kk),ModelConfig,DataConfig);
        tmpRMS(kk)  = rms(s.\(d-tmpResponse(:,kk)));
    end
    [MinRMSE,ind] = min(tmpRMS);
    if MinRMSE<TargetRMS
        ind = find(tmpRMS<TargetRMS,1,'last');        
    end

    %% save
    muAll(jj)  = muRange(ind);
    RMS(jj)   = tmpRMS(ind);
    modelEst(:,jj)  = tmpmodelEst(:,ind);
    predRes(:,jj)  = tmpResponse(:,ind);
    
    %% next model for linearization
    m = modelEst(:,jj);

    %% Show progress
    rNew = norm(D*m);
    fprintf('Blocky-Occam iteration %g, μ = %g, RMS = %g, roughness = %g \n',jj,muAll(jj),RMS(jj),rNew)
    
    %% Check convergence
    relr = abs(rNew-rOld)/rOld;
    if relr<=RoughTol
        break
    end
    rOld = rNew;
end
muAll    = muAll(1:jj);
RMS      = RMS(1:jj);
modelEst = modelEst(:,1:jj);
predRes  = predRes(:,1:jj);
fprintf('========================\n');