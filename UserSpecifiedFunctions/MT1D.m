function [ApparentResistivity, Phase, Z] = MT1D(rho,h,f)

    % Compute Z:
    Z = Z1D(rho,h,f);
    
    % Convert to apparent resistivity and phase:
    mu = 4*pi*1d-7;
    ApparentResistivity = Z.*conj(Z) ./ (mu*2*pi*f);
    Phase               = 180/pi*angle(Z);


%----------------------------------------------------------------------
function Z = Z1D(rho,h,f)
%---------------------------------------------------------------------- 
%   Kerry Key
%   Scripps Institution of Oceanography
%
%   Computes the surface impedance Z for a 1D resistivity model.
%
%   Inputs: 
%           rho - resistivity of each layer (vector)
%           h   - thickness of each layer, bottom layer thickness is 
%                 ignored and isn't necessary to input (vector)  
%           f   - frequencies to compute Z at (vector) 
%   Outputs: 
%           Z   - complex impedance for model computed at frequencies 
%                 given in f (vector)
%----------------------------------------------------------------------   
    mu = 1.256637062E-06;    
  % Using vector of w, compute all f at once instead of looping over f   
    w = 2*pi*f;
  % Bottom layer k and intrinsic Z 
    ki = sqrt(-sqrt(-1).*w.*mu./rho(end));    
    Z = w.*mu./ki;
  % Impedance recursion through the model layers:
    for i = length(rho)-1:-1:1
        ki = sqrt(-sqrt(-1).*w.*mu./rho(i));
        Zi = w.*mu./ki;    
        Z = Zi .* ( Z + Zi.*tanh(sqrt(-1).*ki.*h(i)) ) ./ ...
                 ( Zi +  Z.*tanh(sqrt(-1).*ki.*h(i)) );  
    end
    return
  % End of function Z1D