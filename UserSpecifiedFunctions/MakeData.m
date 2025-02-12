function DataConfig = MakeData()
load('MTdata.mat');                                        % Load MT data and get it into a structure
DataConfig.d = [MTdata.TEappRes' ; MTdata.TEphase'];         % data, log apparent resistivity and phase
DataConfig.s = [MTdata.TEappResErr' ; MTdata.TEphaseErr'];   % errors, log domain
DataConfig.f = MTdata.freqs';                                % frequencies
DataConfig.nd = length(DataConfig.d);                        % number of data

