function D = getD(ModelConfig)
%% Make the finite differencing matrix for regularization
nm = ModelConfig.nm;  % number of model parameters (nm)

% Finite differences for regularization
D = diag(ones(nm,1),0) - diag(ones(nm-1,1),-1);
D(1,1) = 0;