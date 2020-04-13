%%=========================================================================
% Tutorial: Funcoes densidade de probabilidade SAR
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

close all
clear 
clc

%% Carrega a imagem SAR====================================================
fileID = fopen('C:\Users\naial\Documents\Naiallen\Curso_SAR\CursoFinal\matlab\imagensSAR\simulada\ref_ImagPol240_0.bin', 'r', 'ieee-le');
if fileID == -1, error('Cannot open file: %s', filename); end
format = 'double';
Data = fread(fileID, Inf, format);
fclose(fileID);

col = 240;
row = 240;
bands = 3; %HH HV VV

ImTemp = zeros(row, col, 3);
for ii = 1:bands
    ImSize = col*row*2; %Real and Imag
    clear temp real imag
    temp = Data(1:ImSize,1);
    Data(1:ImSize) = []; 
    
    r = reshape(temp(1:2:end-1), row, col);
    im = reshape(temp(2:2:end), row, col);
    
    ImTemp(:,:,ii) = r + 1i*im;  
end

%% Parte Real==============================================================
HH = real(ImTemp(:,:,1));
figure;
imagesc((HH));
colormap(bone);
title('Imagem Real')

figure;
data_i = HH(85:130, 15:100);
[N,edges] = histcounts(data_i, 'Normalization','pdf');
edges = edges(2:end) - (edges(2)-edges(1))/2;
plot(edges, N, '+','LineWidth',2);
hold on
% Plota a FDP
mu = mean(data_i(:)); % media
sigma = std(data_i(:)); %desvio padrao
x = sort(data_i(:)); %dado organizado
y = ( 1/sqrt(2*pi*sigma^2) ) * exp( -(x-mu).^2/(2*sigma^2) ); %gaussiana
plot(x,y,'LineWidth',1);
title('PDF - Imagem Real')

%% Parte Imaginaria========================================================
HH = imag(ImTemp(:,:,1));
figure
imagesc(imag(HH))
colormap(bone);
title('Imagem Imaginaria')

figure;
data_i = HH(85:130, 15:100);
[N,edges] = histcounts(data_i, 'Normalization','pdf');
edges = edges(2:end) - (edges(2)-edges(1))/2;
plot(edges, N, '+','LineWidth',2);
hold on
% Plota a FDP
mu = mean(data_i(:)); % media
sigma = std(data_i(:)); %desvio padrao
x = sort(data_i(:)); %dado organizado
y = ( 1/sqrt(2*pi*sigma^2) ) * exp( -(x-mu).^2/(2*sigma^2) ); %gaussiana
plot(x,y,'LineWidth',1);
title('PDF - Imagem Imaginaria')

%% Imagem em Intensidade===================================================
HH_i = (real(ImTemp(:,:,1)).^2 + imag(ImTemp(:,:,1)).^2);
figure;
imagesc(HH_i);
colormap(bone);
title('Imagem em Intensidade')

figure;
data_i = HH_i(85:130, 15:100);
[N,edges] = histcounts(data_i, 'Normalization','pdf');
edges = edges(2:end) - (edges(2)-edges(1))/2;
plot(edges, N, '+','LineWidth',2);
hold on

% Plota a FDP
sigma = std(data_i(:))*8; %desvio padrao
x = sort(data_i(:)); %dado organizado
y = ( 1/sigma^2 ) .* exp( -x/sigma^2 ); %exponencial
plot(x,y,'LineWidth',1);
title('PDF - Imagem em Intensidade')

%% Imagem em Amplitude=====================================================
HH_a = sqrt(HH_i);
figure;
imagesc(HH_a);
colormap(bone);
title('Imagem em Amplitude');

figure;
data_a = HH_a(85:130, 15:100);
[N,edges] = histcounts(data_a, 'Normalization','pdf');
edges = edges(2:end) - (edges(2)-edges(1))/2;
plot(edges, N, '+','LineWidth',2);
hold on
% Plota a FDP
sigma = std(data_a(:)); %desvio padrao
x = sort(data_i(:)); %dado organizado
y = ( 2*x/sigma^2 ) .* exp( -x.^2/sigma^2 ); %Rayleigh
plot(x,y,'LineWidth',1);
title('PDF - Imagem em Amplitude');

%% Imagem colorida
HH = 10*log10(abs(ImTemp(:,:,1)));
HV = 10*log10(abs(ImTemp(:,:,2)));
VV = 10*log10(abs(ImTemp(:,:,3)));

XMIN = min([min(HH(:)) min(HV(:)) min(VV(:))]);
XMAX = 0.1*max([max(HH(:)) max(HV(:)) max(VV(:))]);

[m,n] = size(HH);

color = zeros(m, n, 3);
minimo = min(HH(:));
maximo = max(HH(:));
color(:,:,1) = (HH-XMIN)/(XMAX-XMIN);

minimo = min(HV(:));
maximo = max(HV(:));
color(:,:,2) = (HV-XMIN)/(XMAX-XMIN);

minimo = min(VV(:));
maximo = max(VV(:));
color(:,:,3) = (VV-XMIN)/(XMAX-XMIN);

figure;
imagesc(color);
title('Imagem Colorida (Shh, Shv, Svv)');


