%% Plots Blocky Occam 
Colors = brewermap(8,'Dark2'); 
nf = length(DataConfig.f);

%% Plotting
figure(10),hold on
stairs(RamBO_Out.RamBO_modelEst(end:-1:1,:),(ModelConfig.z-ModelConfig.z(end))'*ones(1,RamBO_Out.RamBO_nos),'Color',Colors(3,:),'LineWidth',1);
stairs(RamBO_Out.BO_modelEst(end:-1:1,end),ModelConfig.z-ModelConfig.z(end),'Color',Colors(4,:),'LineWidth',4);
xlabel('Depth (m)');ylabel('Log_{10} resistivity (\Omega m)');
set(gcf,'color','w')
set(gcf,'Position',[1 1 605 976])
set(gca,'FontSize',20)
xlim([-1 3])
box off
title('RamBO and blocky Occam models')

figure(11)
subplot(121),hold on
semilogx(1./DataConfig.f,RamBO_Out.RamBO_predRes(1:nf,:),'color',Colors(3,:),'LineWidth',1)
errorbar(1./DataConfig.f, DataConfig.d(1:nf), 2*DataConfig.s(1:nf),'o','Color',Colors(8,:)); 
semilogx(1./DataConfig.f,RamBO_Out.BO_predRes(1:nf,end),'color',Colors(4,:),'LineWidth',2)
xlabel('period (s)');ylabel('Log_{10} \rho_a (\Omega m)');
set(gcf,'color','w')
set(gca,'XScale','log')
set(gca,'FontSize',20)
box off
title('RamBO data fits')

figure(11)
subplot(122),hold on
semilogx(1./DataConfig.f,RamBO_Out.RamBO_predRes(nf+1:end,:),'color',Colors(3,:),'LineWidth',1)
errorbar(1./DataConfig.f, DataConfig.d(nf+1:end), 2*DataConfig.s(nf+1:end),'o','Color',Colors(8,:)); 
semilogx(1./DataConfig.f,RamBO_Out.BO_predRes(nf+1:end,end),'color',Colors(4,:),'LineWidth',2)
xlabel('period (s)');ylabel('phase (^o)');
set(gcf,'color','w')
set(gca,'XScale','log')
set(gca,'FontSize',20)
box off
title('RamBO data fits')
set(gcf,'Position',[7 544 1179 433])

figure(12)
histogram(RamBO_Out.RamBO_RMS,20,'normalization','pdf','FaceColor',[.2 .2 .2],'FaceAlpha',.2);
xlabel('RMS');ylabel('Probability');
set(gcf,'color','w')
set(gca,'XScale','log')
set(gca,'FontSize',20)
box off
title('RamBO RMS')
