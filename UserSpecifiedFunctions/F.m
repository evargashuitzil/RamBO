function [ModelOutput,J] = F(m,ModelConfig,DataConfig)

% This function implements the forward model
% RamBO expects the output to be a vector of the size of the data
% The second output is the Jacobian of the model

nd  = DataConfig.nd;
h   = ModelConfig.h;
f   = DataConfig.f; 
ModelOutput = callMT(m,h,f);

% Jacobian
if nargout == 2
    J = Jac(m,h,f,nd,0.05);
end

end


