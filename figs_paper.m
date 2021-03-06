%% fig 1 example of good reconstruction
load('data/rec_first_example.mat')
timeSeries = 'data/tseries/tseries_first_example.mat';
load(timeSeries)

plot_recons(Mtilde,Mrec,H,W,timeSeries)
%print('-dpdf','../manuscript/figures/recons_example.pdf')
%% fig 2 mean error vs delta from equilibrium
% results from delta_equi_error.m
load('data/rec_delta_equi.mat')
figure
fs = 20;
plot(deltaEquiV, mean(reconsErrorM), 'ob', 'linewidth',3)
% hold on
% plot(stepsV, modErrorM,'s','linewidth',1.5)
legend boxoff
xlabel('$\delta$ from equilibrium','fontsize',fs,'interpreter','latex')
ylabel('$\overline{Error}_{rec}$',...
        'interpreter','latex','fontsize',fs)
yl = ylim;
ylim([0 yl(2)]) 
setfigure(15,10,10,6)
%print('-dpdf','../manuscript/figures/delta_from_equilibrium.pdf')

%% fig 4 examples mod to nest reconstruction with the three methods
clear all
load('data/params/params_feasible')
load('data/params/matrices_10by10_100_invertible.mat')
load('data/rec_multi_v_single_examples.mat')
mS = 3;
mar = 1;
width = 6*mar + 3*mS+1;% +2 for colorbar
height = 6*mar + 4*mS;


figure
setfigure(width,height,10,16)
%
nExp = 20;
steps = 10;
tfinal = 96;
matV = [100 27 1];
dt = 0.01;
 
colormap jet
map = colormap;
map(1,:) = 1;

for i= 1:3        
        M = matrices(:,:,matV(i));
        [r,a,phi,beta,m] = params{matV(i),:}; 
        Mtilde = M.*phi.*beta;
    
        axes('units','centimeters','pos',[mar ((i*2-1)*mar + (i-1)*mS) mS mS])
        imagesc(Mtilde)
        set(gca,'ytick',[],'xtick',[])
        xlabel(['$Nestedness = ' num2str(sortNest(matV(i)),'%.2f') '$'],...
         'interpreter','latex','fontsize',12)
        colormap(map)
        if i == 1
          s = caxis;
        else
            caxis(s)
        end

        Mrec = Mrec_single_V(:,:,i);                             

        
        axes('units','centimeters','pos',[3*mar+mS ((i*2-1)*mar + (i-1)*mS) mS mS])
        imagesc(Mrec)
        set(gca,'ytick',[],'xtick',[])
        xlabel(['$Error_{rec}  = ' num2str(error_recons(Mrec,Mtilde),'%.2f') '$'],...
                 'interpreter','latex','fontsize',12)
        colormap(map)
        caxis(s)

        Mrec = Mrec_multi_V(:,:,i); 
    
        axes('units','centimeters','pos',[5*mar+2*mS ((i*2-1)*mar + (i-1)*mS) mS mS])
        imagesc(Mrec)
        set(gca,'ytick',[],'xtick',[])
        xlabel(['$Error_{rec}  = ' num2str(error_recons(Mrec,Mtilde),'%.2f') '$'],...
                 'interpreter','latex','fontsize',12)
        colormap(map)
        caxis(s)
        %colorbar
end
    
fs = 20;
axes('units','centimeters','pos',[1.2 17 mS mS],'visible','off')
text(0,0, 'Original','interpreter','latex','fontsize',fs)

axes('units','centimeters','pos',[7.2 17 mS mS],...
        'visible','off')
text(0,0, 'Reconstruction','interpreter','latex','fontsize',fs)

axes('units','centimeters','pos',[6 15.28 mS mS],...
        'visible','off')
text(0,0, {'Single', 'experiment'},'interpreter','latex','fontsize',15)

axes('units','centimeters','pos',[11 15.28 mS mS],...
        'visible','off')
text(0,0, {'Multiple', 'experiments'},'interpreter','latex','fontsize',15)
%print('-dpdf','../manuscript/figures/example_recons_mod_nest.pdf')
%% fig 5 comparing single v multi
load('data/rec_multi_v_single.mat')
load('data/params/matrices_10by10_100_invertible.mat')
figure;
setfigure(25,10,68,6)
fs = 24;
plot(sortNest, reconsErrorMulti, '-ok', 'linewidth',3)
hold on
plot(sortNest, mean(reconsErrorSingle), '-ob', 'linewidth',3)
hold off
% hold on
% plot(matV, mean(reconsErrorSingle)+std(reconsErrorSingle),...
%     '--k', 'markersize',8,'linewidth',3)
% plot(matV, mean(reconsErrorSingle)-std(reconsErrorSingle),...
%     '--k', 'markersize',8,'linewidth',3)
% hold off

h_legend = legend('Multiple Experiments','Mean Single Experiment',...
                    'location','northwest')
set(h_legend,'FontSize',12);
set(gca,'fontsize',14);
legend boxoff
xlabel('Nestedness','fontsize',fs,'interpreter','latex')
ylabel('$\overline{Error}_{rec}$',...
        'interpreter','latex','fontsize',fs)
ylim([0 0.42])
%print('-dpdf','../manuscript/figures/multi_v_mean_single.pdf')

%% fig 6 error vs number of experiments 
load('data/rec_nExp')
nExpV = 1:50;
figure
fs = 13;
plot(nExpV, mean(reconsErrorM), '-b', 'linewidth',2)
% hold on
% plot(stepsV, modErrorM,'s','linewidth',1.5)
legend boxoff
xlabel('Number of experiments','fontsize',fs,'interpreter','latex')
ylabel('$\overline{Error}_{rec}$',...
        'interpreter','latex','fontsize',fs)
setfigure(10,7,68,6)
set(gca,'fontsize',8);
hold on
error_std = std(reconsErrorM);
plot(nExpV, mean(reconsErrorM)+error_std, '--k', 'linewidth',2)
plot(nExpV, mean(reconsErrorM)-error_std, '--k', 'linewidth',2)
%print('-dpdf','../manuscript/figures/error_v_nExp.pdf')

%% fig 7 Reconstruction error vs noise
load('data/rec_snr')
snrV = 1:40;
fs = 13;
figure
plot(snrV, mean(reconsErrorM),'-b', 'markersize',8,'linewidth',2)
hold on
plot(snrV, mean(reconsErrorM)+std(reconsErrorM),'--k', 'markersize',8,'linewidth',2)
plot(snrV, mean(reconsErrorM)-std(reconsErrorM),'--k', 'markersize',8,'linewidth',2)
hold off
xlabel('SNR (dB)','fontsize',fs)
ylabel('$\overline{Error}_{rec}$','interpreter','latex','fontsize',fs)
setfigure(10,7,68,6)
set(gca,'fontsize',8);
%print('-dpdf','../manuscript/figures/error_vs_noise.pdf')

%%
%% error as a function of delta t and total time
close all
load('data/rec_steps_tfinal.mat')
reconsErrorM = mean(reconsErrorA,3);

figure
width = 15;
height = 12;
fs = 25;
setfigure(width,height,70,16)

% error
imagesc(flipud(reconsErrorM))
hold on
colormap jet
colorbar

%isoclines
N_vector = [100 200 400];
dt_iso = [0; 0.21];%rescale for the new x axis determined with set
x_iso_mat = repmat(dt_iso*100,1,length(N_vector));
y_iso_mat = [];
for N = N_vector;
    'heyt'
    T = dt_iso*N;
    y_iso = 23 - (T-10)./4; %rescale for the new x axis determined with set
    y_iso_mat = [y_iso_mat ,y_iso];
end
plot(x_iso_mat, y_iso_mat, '-k', 'linewidth', 3)
hold off

% % text for isoclines 100 200 400
% x = 0.08;
% x_text = x*100;
% N = 400;
% y_text = 23 - (x*N-10)./4;
% 
% text(x_text+0.5, y_text, {'1000',  'meas.'},'fontweight', 'bold', ...
%         'color', 'white','fontsize', 15)
%     
% x = 0.13;
% x_text = x*100;
% N = 500;
% y_text = 23 - (x*N-10)./4;
% 
% text(x_text, y_text+1, {'500',  'meas.'},'fontweight', 'bold', ...
%         'color', 'black','fontsize', 15)
%     
% x = 0.16;
% x_text = x*100;
% N = 250;
% y_text = 23 - (x*N-10)./4;
% 
% text(x_text, y_text+1, {'250',  'meas.'},'fontweight', 'bold', ...
%         'color', 'black','fontsize', 15)

% text for isoclines 250 500 1000
x = 0.17;
x_text = x*100;
N = 400;
y_text = 23 - (x*N-10)./4;

text(x_text, y_text-4.2, {'400',  'meas.'},'fontweight', 'bold', ...
        'color', 'black','fontsize', 15)
    
x = 0.17;
x_text = x*100;
N = 200;
y_text = 23 - (x*N-10)./4;

text(x_text, y_text-2.8, {'200',  'meas.'},'fontweight', 'bold', ...
        'color', 'black','fontsize', 15)
    
x = 0.17;
x_text = x*100;
N = 100;
y_text = 23 - (x*N-10)./4;

text(x_text, y_text-2, {'100',  'meas.'},'fontweight', 'bold', ...
        'color', 'black','fontsize', 15)

flip_tfinalV = fliplr(tfinalV)
set(gca,'ytick',1:4:length(tfinalV),'yticklabel',flip_tfinalV(1:4:end),...
       'xtick',1:4:length(stepsV),'xticklabel',stepsV(1:4:end)*dt,...
       'fontsize',15)
xlabel('$\Delta t$ (hours)', 'interpreter', 'latex', 'fontsize', fs)
ylabel('Total hours', 'interpreter', 'latex', 'fontsize', fs)
title('$\overline{Error}_{rec}$',...
        'interpreter','latex','fontsize',fs)
%print('-dpdf','../manuscript/submission_rsopen/figures/error_deltat_finalt.pdf')
%% Error vs delta t for fixed number of measurements
close all
load('data/rec_deltat.mat')
reconsErrorM = mean(reconsErrorA,3);

figure
fs = 18;
setfigure(10,7,68,6)
semilogx(stepsV(10:end)*dt,reconsErrorM(:,10:end),'o-','linewidth',3)
legend({'100 Meas.','200 Meas.','400 Meas.'})
legend boxoff
xlabel('$\Delta t$ (hours)','fontsize',fs,'interpreter','latex')
ylabel('$\overline{Error}_{rec}$',...
        'interpreter','latex','fontsize',fs)
%print('-dpdf','../manuscript/submission_rsopen/figures/er