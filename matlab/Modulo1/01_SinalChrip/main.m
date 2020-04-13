%%=========================================================================
% Tutorial: Sinal Chirp
% Autor: Naiallen Carvalho
% Computção Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

close all
clear
clc

%% -Parametros ============================================================
f = 1e9;                    % [Hz] frequencia da portadora 
fs = f*10;                  % [Hz] frequencia de amostragem
Ts = 1/fs;                  % [s] periodo de amostragem
BW = 500e6;                 % [Hz] largura de banda 
tep = 100e-9;               % [s] duraçao do pulso retangular
tau = -tep*0.5:Ts:1.5*tep;  % [s] chirp time vector
chirpRate = BW/tep;         % chirp rate

%% - Sinal no dominio do tempo=============================================
rect = rect_function(tau,tep/2,tep);
s = cos(pi*chirpRate*tau.^2).*rect_function(tau,tep/2,tep).'; 

%% - Variação da frequencia e fase=========================================
delta_f = -BW/2 + chirpRate*tau;
delta_ph = pi*chirpRate*tau.^2;

%% - Sinal no dominio da frequencia========================================
R = fftshift(fft(rect));
S = fftshift(fft(s));

%% -Plot===================================================================
figure;
plot (tau, s,'b','LineWidth',1);
title('Sinal Chirp');
xlabel('Tempo');
ylabel('Amplitude');

subplot(3,2,1), plot (tau, rect,'g','LineWidth',1);
title('Sinal Retangular');
xlabel('Tempo');
ylabel('Amplitude');

subplot(3,2,2), plot (tau, s,'b','LineWidth',1);
title('Sinal Chirp');
xlabel('Tempo');
ylabel('Amplitude');

subplot(3,2,3), plot (tau, delta_f,'b','LineWidth',1);
title('Variação da frequencia');
xlabel('Tempo');
ylabel('Frequencia');

subplot(3,2,4), plot (tau, delta_ph,'b','LineWidth',1);
title('Variação de fase');
xlabel('Tempo(s)');
ylabel('Fase');

subplot(3,2,5), plot (abs(R),'r','LineWidth',1);
title('Frequencia Instantanea - Sinal Retangular');
xlabel('Frequencia');
ylabel('Amplitude');

subplot(3,2,6), plot (abs(S),'b','LineWidth',1);
title('Frequencia Instantanea - Sinal Chirp');
xlabel('Frequencia');
ylabel('Amplitude');