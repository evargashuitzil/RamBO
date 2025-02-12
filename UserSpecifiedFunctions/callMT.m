function dhat = callMT(rho,h,f)
% rho is a vector of layer resistivities, in log10(ohm-m)
% h is a vector of layer thicknesses, in meters
% f is a vector of frequencies, in Hz
% this function converts rho from log to linear; calls MT1D; converts
% apparent resistivity from linear to log; combines apparent resistivity
% with phase into one vector; then returns the predicted data vector

[AppRes, Phase, ~] = MT1D(10.^(rho),h,f);
AppRes = log10(AppRes);
dhat = [ AppRes ; Phase ];

end