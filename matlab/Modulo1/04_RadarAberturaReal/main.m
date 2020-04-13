%% ========================================================================
% Tutorial: Radar de abertura real
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

clear 
close all
clc

%% Carrega os parametros=================================================== 
parametros

%% Plota a geometria=======================================================
subplot(121)
geometria

%% Define o ponto onde o target vai estar (representado por um delta de dirac)
target.x0 = 0;
target.y0 = R_grd; % R_grd; %No meio da imagem (onde o range esta)R_grd_near+R_grd_near/2;%
target.z0 = 0;
target.r0 = sqrt(h^2 + target.y0^2);
fprintf('Posicao do alvo em slant range (m): %f\n', target.r0)

%-Target plot-------------------------
subplot(121)
hold on
plot3(target.x0, target.y0, target.z0, 'ok', 'LineWidth',4)

%% Parametros da Imagem

delta_R = co/(2*bw);                  % [m] resoluçãoem range
fprintf('Resolucao em range (m): %f\n', delta_R)

delta_Az = (lambda/da)*target.r0;     % [rad] resolução em azimute -> radar de abertura real ->depende do range
fprintf('Resolucao em azimute (m): %f\n', delta_Az)

%% Sinal de referencia====================================================
% R = c.t/2 -> t = 2.R/c
t_ini = 0;
t_end = 2*R_slt_far/co;
t = t_ini:Ts:t_end;
range_vec = t*co/2;
ref_range = exp(1i*pi*chirp_rate*t.^2).*rect_function(t,tep/2,tep).';   %Sinal Chrip no domínio do tempo

%% Simula target Estacionario
%-> Processamento somente em fast time
t_target = 2*target.r0/co;
rec = exp(1i*pi*chirp_rate*(t-t_target).^2).*(rect_function(t,t_target+tep/2,tep).');

N_range = length(t);
recft = fft(rec, N_range);
chirpft = fft(ref_range,N_range);
recft = recft.*conj(chirpft);
proc =  ( ifft((recft)));

aziSpace = size( -Ds/2:Ds/2, 2 );
processed = zeros(size(range_vec, 2), aziSpace);
for k1 = 1:aziSpace
    processed(:, k1) = proc;
end
azi_vec = -Ds/2:Ds/2;

subplot(122)
imagesc(azi_vec, range_vec, (abs(processed)));colormap('gray')
title('Processed SAR image Slant Range')
xlabel('Azimute [m]','FontSize',12); ylabel('Range [m]','FontSize',12);
ylim([R_slt_near R_slt_far])
axis equal;










