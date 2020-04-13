%%=========================================================================
% Tutorial: Filtros de Speckle
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

close all
clear
clc

%% 1. Carrega a imagem SAR=================================================
foldername = 'C:\Users\naial\Documents\Naiallen\Curso_SAR\CursoFinal\matlab\imagensSAR\';
fileID = fopen(fullfile(foldername, 'CUT_ALPSRP173587130-P1.1__A-HH.dat'));
if fileID == -1, error('Cannot open file: %s', filename); end
format = 'float';
Data = fread(fileID, Inf, format);
fclose(fileID);

col = 1086;
row = 788;
bands = 1; 
offset = size(Data,1) - (col*row*bands*2);
Data(1:offset) = [];

ImTemp = zeros(row, col, bands);
for ii = 1:bands
    ImSize = col*row*2; %Real and Imag
    clear temp_real temp_img real imag
    temp_real = Data( ((ii-1)*2)+1 : ( bands*2) : end ,1);
    temp_img =  Data( ((ii-1)*2)+2 : ( bands*2) : end, 1);

    r = reshape(temp_real, col, row)';
    im = reshape(temp_img, col, row)';

    ImTemp(:,:,ii) = r + 1i*im;
end
image = ImTemp(1:500,751:end,:);
% image = ImTemp(1:end,1:end,:);

%% 2. Seleciona uma banda em amplitude=====================================
Shh = sqrt( real(image(:,:,1)).^2 + imag(image(:,:,1)).^2 ) ;
figure;
plotSAR(Shh)
% picturename = fullfile(foldername, 'inten.png');
% saveas (gcf, picturename, 'png');

box = 9;
%% 3. Filtro da media
Shh_media = fmedia (Shh, box);
figure;
plotSAR(Shh_media);
title('Filtro da media');
% picturename = fullfile(foldername, 'Shh_media');
% saveas (gcf, picturename, 'png');

%% 4. Filtro da mediana
Shh_mediana = fmediana (Shh, box);
figure;
plotSAR(Shh_mediana)
title('Filtro da mediana');
% picturename = fullfile(foldername, 'Shh_mediana');
% saveas (gcf, picturename, 'png');

%% 5. Filtro de Lee
Shh_lee = flee (Shh, box);
figure;
plotSAR(Shh_lee)
title('Filtro de Lee');
% picturename = fullfile(foldername, 'Shh_lee');
% saveas (gcf, picturename, 'png');

