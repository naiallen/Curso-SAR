%% ========================================================================
% Tutorial: SAR - simulacao de 1 alvo
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
% geometria

%% Sinal de transmitido====================================================
ref_range = exp(1i*pi*chirp_rate*tau.^2).*rect_function(tau,tep/2,tep).';   %Sinal Chrip no domínio do tempo

%% Variacao em Range=======================================================
X = target.x0 + target.vx*T;
Y = target.y0 + target.vy*T;
R = sqrt( (X - vplat*T).^2 + Y.^2 + h^2);
t_R = double(2*R/co); 
figure;
plot(T, R)
title('Variaçao do Range');
xlabel('Tempo Lento (s)')
ylabel('Range (m)')

%% Sinal recebido==========================================================
A = sinc((da/lambda)*atan(vplat*T/target.r0));
data = zeros(N_range, N_azimuth);
for n = 1:N_azimuth    
    t = tau - t_R(n);  
    data(:,n) = A(n)*rect_function(tau, t_R(n) + tep/2, tep).'.*...
                exp(1i*pi*chirp_rate*t.^2).*...
                exp(-1i*4*pi*R(n)/lambda);
end

figure
% subplot(121)
imagesc(vec_azimuth_m, vec_range_m, (abs(data)))
colormap bone
xlabel('Azimuth [m]')
ylabel('Range [m]')
title({'Raw data magnitude', strcat('Slant Range', num2str(target.r0))})
ylim([target.r0*0.99 target.r0*1.05])
view([0 270])

% subplot(122)
% imagesc(vec_azimuth_m, vec_range_m, angle(data))
% colormap bone
% xlabel('Azimuth [m]')
% ylabel('Range [m]')
% title({'Raw data phase', strcat('Slant Range', num2str(target.r0))})
% ylim([target.r0*0.99 target.r0*1.05])
% view([0 270])

%% Processamento em Range==================================================
chirpft = conj(fft(ref_range));
data_rangeft = fft(data,[],1);
for ii = 1:N_azimuth
    data_rangeft(:,ii) = data_rangeft(:,ii).*chirpft.';
end
data_rangecomp = ifft(data_rangeft,[],1);
figure
imagesc(vec_azimuth_m, vec_range_m, abs(data_rangecomp))
colormap bone
xlabel('Azimuth [m]')
ylabel('Range [m]')
title({'Dado processado em range', strcat('Slant Range', num2str(target.r0))})
ylim([target.r0*0.99 target.r0*1.05])
view([0 270])

% figure;
% mesh(vec_azimuth_m, vec_range_m, abs(data_rangecomp))
% xlabel('Azimuth [m]')
% ylabel('Range [m]')
% ylim([target.r0*0.99 target.r0*1.05])

%% Range Cell Migration====================================================
%TODO



%% Processamento em Azimute================================================
data_azft = fft(data_rangecomp,[],2);
ref_az = zeros(size(data));

%Range offset
[~, pos] = max(tau(tau <= 2*(R_slt_near)/co));
for k = pos:N_range
    %Calcula o slow time pra cada range 
    slow_time_k = (lambda/da)*(vec_range_m(k)/vplat);
    Tk = -slow_time_k/2:PRI:slow_time_k/2;
    
    %Calcula a variancao de range pra cada celula em range 
    Rk = sqrt(vec_range_m(k)^2+(Tk*vplat).^2);
    
    %Calcula a variacao de fase em azimute
    temp_az = exp(-1i*4*pi*Rk/lambda);
    pad = round((N_azimuth-length(temp_az))/2);
    if (pad == 0)||(size(temp_az,2)>N_azimuth)
        pad=1;
        temp_az(N_azimuth:end)=[];
        test=1;
    end
    ref_az(k,pad:pad+length(temp_az)-1) = temp_az;
end


data_azft = data_azft.*conj(fft(ref_az,[],2));
data_azcomp = fftshift(ifft(data_azft,[],2),2);

figure
imagesc(vec_azimuth_m, vec_range_m,(abs(data_azcomp)))
colormap bone
xlabel('Azimuth [m]')
ylabel('Range [m]')
title({'Alvo comprimido', strcat('Slant Range', num2str(target.r0))})
ylim([target.r0*0.99 target.r0*1.05])
view([0 270])
axis equal



