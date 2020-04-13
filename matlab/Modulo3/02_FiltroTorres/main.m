%%=========================================================================
% Tutorial: Filtro Non-Local mean
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================
close all
clear
clc

%% Carrega a imagem
fileID = fopen('C:\Users\naial\Documents\Naiallen\Curso_SAR\CursoFinal\matlab\imagensSAR\simulada\ref_ImagPol240_0.bin', 'r', 'ieee-le');
if fileID == -1, error('Cannot open file: %s', filename); end
format = 'double';
Data = fread(fileID, Inf, format);
fclose(fileID);

col = 240;
row = 240;
bands = 3; 

for ii = 1:bands
    ImSize = col*row*2; %Real and Imag
    clear temp real imag
    temp = Data(1:ImSize,1);
    Data(1:ImSize) = []; 
    
    real = reshape(temp(1:2:end-1), row, col);
    imag = reshape(temp(2:2:end), row, col);
    
    ImTemp(:,:,ii) = real + 1i*imag;  
end
slc = ImTemp(1:50, 1:50, :);
Shh = slc(:,:,1);
Shv = slc(:,:,2);
Svv = slc(:,:,3);

%% Plota imagem colorida
HH = ( abs(Shh) );
HV = ( abs(Shv) );
VV = ( abs(Svv) );

XMIN = min([min(HH(:)) min(HV(:)) min(VV(:))]);
XMAX = 0.4*max([max(HH(:)) max(HV(:)) max(VV(:))]);

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
axis equal

%% Calcula a matriz de covariancia
cov = zeros(size(slc,1), size(slc,2), 9);
cov(:,:,1) = abs(Shh).^2;
cov(:,:,2) = sqrt(2)*Shh.*conj(Shv);
cov(:,:,3) = Shh.*conj(Svv);
cov(:,:,4) = conj(cov(:,:,2));
cov(:,:,5) = 2*abs(Shv).^2;
cov(:,:,6) = sqrt(2)*Shv.*conj(Shv);
cov(:,:,7) = conj(cov(:,:,3));
cov(:,:,8) = conj(cov(:,:,6));
cov(:,:,9) = abs(Svv).^2;

[ymax, xmax, n_bands] = size(cov); %Tamanho da Imagem
outter_window = 7;
inner_window = 5;
pvalor_n = 0.15;
output  = NonLocalFilter(cov, outter_window, inner_window, pvalor_n);

%% Plota imagem
HH = sqrt(abs(output(:,:,1)));
HV = sqrt(abs(output(:,:,5)));
VV = sqrt(abs(output(:,:,9)));

XMIN = min([min(HH(:)) min(HV(:)) min(VV(:))]);
XMAX = 0.4*max([max(HH(:)) max(HV(:)) max(VV(:))]);

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
axis equal


