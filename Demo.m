%% TV denoising using convex and non-convex regularization
%%
% Reference:
% Convex 1-D Total Variation Denoising with Non-convex Regularization
% Ivan W. Selesnick, Ankit Parekh, and Ilker Bayram
% IEEE Signal Processing Letters, 2014
%%
% Code modifie par Gregoire Morin, 2018
%% Start
clear
%% Create data
N = 1024;
sigma = 0.3;
s = MakeSignal('Blocks', N)';
%% Bruit aléatoire
% noise = sigma*randn(N,1);
%% Import du bruit 
fileID = fopen('wBlocksSigma03.txt','r');
formatSpec = '%f';
noise = fscanf(fileID,formatSpec);
fclose(fileID);

y = s + noise;
%% Parameters
lam = 0.25 * sqrt(N) * sigma;
Nit = 100;
%% Variation totale originale (L1)
[x_L1, cost] = TVD_ncvx(y, lam, 'L1', Nit);
MSE_L1 = mean(abs(x_L1 - s).^2)
%% Variation totale avec la fonction arctan
[x_atan, cost_atan] = TVD_ncvx(y, lam, 'atan', Nit);
MSE_atan = mean(abs(x_atan - s).^2)
%% Graphiques
figure
plot(y,'b')
hold on
plot(s,'k')
legend('y','s')
title('Signal pur et bruite')
figure
plot(x_L1,'r')
title('Estime VT L1')
figure
plot(x_atan,'r')
title('Estime VT Arctan')