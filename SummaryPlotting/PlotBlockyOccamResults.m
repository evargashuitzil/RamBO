%% Plots Blocky Occam 
Colors = brewermap(8,'Dark2'); 
nf = length(DataConfig.f);

figure(1),
hold on
stairs(RamBO_Out.BO_modelEst(end:-1:1,end),ModelConfig.z-ModelConfig.z(end),'color',Colors(4,:),'LineWidth',2);
xlabel('Depth (m)');ylabel('Log_{10} resistivity (\Omega-m)');
set(gcf,'color','w')
set(gcf,'Position',[1 1 605 976])
set(gca,'FontSize',20)
box off
title('Blocky Occam model')


figure(2)
subplot(1,2,1),hold on 
errorbar(1./DataConfig.f, DataConfig.d(1:nf), 2*DataConfig.s(1:nf),'ko','MarkerSize', 5, 'LineWidth', 1.5); 
semilogx(1./DataConfig.f,RamBO_Out.BO_predRes(1:nf,end),'color',Colors(4,:),'LineWidth',2)
xlabel('period (s)');ylabel('Log_{10} \rho_a (\Omega m)');
set(gcf,'color','w')
set(gca,'XScale','log')
set(gca,'FontSize',20)
box off
title('Blocky Occam data fit')

subplot(1,2,2),hold on
errorbar(1./DataConfig.f, DataConfig.d(nf+1:end), 2*DataConfig.s(nf+1:end),'ko','MarkerSize', 5, 'LineWidth', 1.5); 
semilogx(1./DataConfig.f,RamBO_Out.BO_predRes(nf+1:end,end),'color',Colors(4,:),'LineWidth',2)
xlabel('period (s)');ylabel('phase (^o)');
set(gcf,'color','w')
set(gcf,'Position',[7 544 1179 433])
set(gca,'XScale','log')
set(gca,'FontSize',20)
box off
title('Blocky Occam data fit')

figure(3), hold on
plot(RamBO_Out.BO_RMS,'.','color',Colors(4,:),'MarkerSize',20)
xlabel('Iteration number');ylabel('RMSE');
set(gcf,'color','w')
set(gca,'FontSize',20)
box off
title('Blocky Occam RMS')