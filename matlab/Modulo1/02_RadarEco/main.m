%%=========================================================================
% Tutorial: Radar Pulsado
%   1. Pulso retagular encapsulando cossenoide
%   2. Pulso retangular encapsulando sinal chirp
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

clear
close all
clc
%% -Parametros do sensor===================================================
min_range = 5;              % [m] distancia maxima que o radar pode detectar um alvo
max_range = 50;             % [m] distancia maxima que o radar pode detectar um alvo
co = 3e8;                   % [m/s]velocidade da luz
f = 1e9;                    % [Hz] frequencia da portadora 
fs = f*10;                  % [Hz] frequencia de amostragem
Ts = 1/fs;                  % [s] periodo de amostragem
BW = 500e6;                 % [Hz] largura de banda 
tep = 100e-9;               % [s] duração do pulso retangular
k = BW/tep;                 % Chirp rate
t = 2*max_range/co;         % [s] tempo de retorno maximo
tau = 0:Ts:t;               % [s]  vetor de tempo
f_base = 100e6;             % [Hz] frequencia do sinal cossenoidal

range_resolution = tep*co/2;
fprintf('Resolucao em range - Pulso retagular (m): %f\n', range_resolution)

range_resolution = co/(2*BW);
fprintf('Resolucao em range - Pulso chirp (m): %f\n', range_resolution)


%% -Alvos==================================================================
n_alvo = 3;                 % Numero de alvos
d_alvo = [20 21 25];        % [m] distancia em range dos alvos

%% -1. Pulso retangular com senoide========================================
%Sinal Transmitido
St_c = exp(2i*pi*f_base*tau).*rect_function(tau,tep/2,tep).';   %Sinal transmitido no domínio do tempo

%Sinal recebido 1
Sr_c = zeros(size(St_c));
for ii=1:n_alvo
t_range = 2*(d_alvo(ii)/co);
Sr_c = Sr_c + exp(2i*pi*f_base*(tau - t_range)).*rect_function(tau,t_range+tep/2,tep).'; %Sinal recebido no domínio do tempo
end

%Processamento
fft_St = ( fft(St_c) );
fft_Sr = ( fft(Sr_c) );
loc = ifft(fft_Sr.*conj(fft_St));

%Plot
figure;
subplot(311)
plot(tau, real(St_c), '-b', 'LineWidth',1)
title ('Sinal transmitido')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([tau(1) tau(end)])

subplot(312)
plot(tau, real(Sr_c), '-r', 'LineWidth',1)
title ('Sinal recebido')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([tau(1) tau(end)])

subplot(313)
plot(tau*co/2, real(loc),'-g', 'LineWidth',1)
title ('Signal processado')
xlabel('Range (m)')
ylabel('|S|')
xlim([0 tau(end)*co/2])

%% -2. Pulso retangular com chirp==========================================
%Sinal Transmitido
St_c = exp(1i*pi*k*tau.^2).*rect_function(tau,tep/2,tep).';   %Sinal Chirp trasmitido no domínio do tempo

%Sinal recebido 1
Sr_c = zeros(size(St_c));
for ii=1:n_alvo
    t_range = 2*(d_alvo(ii)/co);
    Sr_c = Sr_c + exp(1i*pi*k*(tau - t_range).^2).*rect_function(tau,t_range+tep/2,tep).';   %Sinal Chrip recebido no domínio do tempo
end

%Processamento
fft_St_c = ( fft(St_c) );
fft_Sr_c = ( fft(Sr_c) );
loc = ifft(fft_Sr_c.*conj(fft_St_c));

%Plot
figure;
subplot(311)
plot(tau, real(St_c), '-b', 'LineWidth',1)
title ('Sinal transmitido')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([tau(1) tau(end)])

subplot(312)
plot(tau, real(Sr_c), '-r', 'LineWidth',1)
title ('Sinal recebido')
xlabel('Tempo (s)')
ylabel('Amplitude')
xlim([tau(1) tau(end)])

subplot(313)
plot(tau*co/2, real(loc),'-g', 'LineWidth',1)
title ('Sinal processado')
xlabel('Range (m)')
ylabel('|S|')
xlim([0 tau(end)*co/2])

