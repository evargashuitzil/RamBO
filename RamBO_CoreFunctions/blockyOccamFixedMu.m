function [modelEst,predRes,RMS] =...
                blockyOccamFixedMu(blockyOccamModel,RamBOConfig, ModelConfig, DataConfig)
%% Translate basic parameters
m = blockyOccamModel;
MaxIts = RamBOConfig.MaxIts;
BregmanTol = RamBOConfig.BregmanTol;
BregmanMaxIts = RamBOConfig.BregmanMaxIts;
RoughTol = RamBOConfig.RoughTol;
alpha = RamBOConfig.alpha;
mu = RamBOConfig.mu;
nm = ModelConfig.nm;
nd = DataConfig.nd;

%% Construct the D matrix
D = getD(ModelConfig);

%% Perturb data
s = DataConfig.s;
d = DataConfig.d;
dwig = d+s.*randn(nd,1);

%% Perturb prior
nu = laprnd(nm,0,1/mu);

%% Blocky Occam
rOld = norm(D*m);
mOld = m;
for jj=1:MaxIts 
    [Fk,J] = F(m,ModelConfig,DataConfig);
    dhat = s.\(dwig - Fk + J*m);
    Jhat = s.\J;
   
    % Split Bregman solve
    PropM = BregmanSplit(Jhat,dhat,mu,D,nu,BregmanTol,BregmanMaxIts);

    % Stepsize control
    m = alpha*PropM + (1-alpha)*mOld;

    % Check convergence
    rNew = norm(D*m);
    relr = abs(rNew-rOld)/rOld;
    if relr<=RoughTol
        break
    end
    rOld = rNew;
    mOld = m;
end
% save
modelEst = m;
predRes  = F(m,ModelConfig,DataConfig);
RMS      = rms(s.\(d-predRes));
end
