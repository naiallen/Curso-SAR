%%=========================================================================
% Tutorial: Decomposicao de Cloud Pottier
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================
close all
clear
clc

%% Carrega as imagens da matriz de coerencia
foldername = 'C:\Users\naial\Documents\Naiallen\Curso_SAR\CursoFinal\matlab\imagensSAR\';
fileID = fopen(fullfile(foldername, 'ALOS_COERENCIA.tif'));
col = 1536;
row = 2304;
bands = 9;
coh = carregaimagem(fileID, col, row, bands);
%% Plota imagem colorida
HH = ( sqrt(abs(coh(:,:,1))) );
HV = ( sqrt(abs(coh(:,:,5))) );
VV = ( sqrt(abs(coh(:,:,9))) );

XMIN = min([min(HH(:)) min(HV(:)) min(VV(:))]);
XMAX = max([max(HH(:)) max(HV(:)) max(VV(:))]);

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

%% Calcula a entropia e angulo alpha
entropia  = zeros(size(coh,1), size(coh,2));
alpha  = zeros(size(coh,1), size(coh,2));
anisotropia  = zeros(size(coh,1), size(coh,2));

for ii = 1:size(coh,1)
    for jj=1:size(coh,2)
         m = reshape(coh(ii, jj,:),3,3)' ;
        [V, D] = eig(m); 
        
        %Ordena os autovalores do maior pro menor
        [autovalor, b] = sort(diag(D), 'descend');
        autovetor = zeros(size(V));
        for ev = 1:size(autovalor, 1)
            autovetor(:, ev) = V(:, b(ev));
        end
        
        %Calcula a entropia
        soma_lambda = sum(autovalor);
        PP = zeros(3,1);
        PP(1) = double( autovalor(1)/soma_lambda);
        PP(2) = double( autovalor(2)/soma_lambda);
        PP(3) = double( autovalor(3)/soma_lambda);
        
        for ev = 1:size(autovalor, 1)
            if(PP(ev)>0)
                entropia(ii, jj) = entropia(ii, jj) - ( PP(ev)*(log10(PP(ev))/log10(3)) );
            end
        end
        entropia(ii, jj) = abs(entropia(ii, jj));
        
        %Angulo alpha
        a = zeros(3,1);
        a(1) = acos(abs(autovetor(1, 1)));
        a(2) = acos(abs(autovetor(1, 2)));
        a(3) = acos(abs(autovetor(1, 3)));
        alpha(ii, jj) = abs(a(1)*PP(1) + a(2)*PP(2) + a(3)*PP(3));
        
        %Anisotropia
        anisotropia(ii, jj) = abs((autovalor(2) - autovalor(3)) / (autovalor(2) + autovalor(3)));
    end
end
alpha = abs(rad2deg(alpha));
imagem = zeros(size(coh,1), size(coh, 2), 3);
imagem(:,:,1) = (entropia);
imagem(:,:,2) = alpha/90;
imagem(:,:,3) = (anisotropia);
figure;
imagesc(imagem);
axis equal

% Cria Plano H-Alfa
figure;
m = 0:1/512:1;
log_3 =  log10(3.0);

%curva I
a1 = m .* 180 ./ (1 + 2 .* m);
h1 = -( 1 ./(1+2 .* m) ) .* log10( (m .^ (2 .* m)) ./ ( (1 + 2 .* m).^(2 .* m+1) ) ) ./ log_3;
plot (h1, a1,'k', 'LineWidth',2);

%curva II
a2 = zeros(1,513);
h2 = zeros(1,513);
ss = 256;
ss2 = ss+1;
a2(1:ss)  = 90;
a2(ss2:513) = 180 ./ (1 + 2 .* m(ss2:513));
h2(1:ss)    = - ( 1 ./ (1 + 2 .* m(1:ss))) .* log10( (2 .*m(1:ss).^(2 .*m(1:ss))) ./ ( (1 + 2 .*m(1:ss)) .^ (2 .* m(1:ss)+1) ) )./log_3;
h2(ss2:513) = - ( 1 ./ (1 + 2 .* m(ss2:513)) ).*log10( (2.*m(ss2:513)-1).^(2.*m(ss2:513)-1) ./ ((1+2 .* m(ss2:513)) .^(2 .* m(ss2:513)+1)) )./log_3;
hold on;
plot (h2,a2,'k', 'LineWidth',2);

%Plota dados
hold on
plot(entropia(:),  alpha(:), '*')

%linha 1
x = m .* 0.5;
y(1:513) = 42.5;
hold on;
plot (x, y, ':k', 'LineWidth',1);

%linha 2
y(1:513) = 47.5;
hold on;
plot (x, y, ':k', 'LineWidth',1);

%linha 3
x = 0.5+m.*(0.4);
y(1:513)= 50;
hold on;
plot (x, y, ':k', 'LineWidth',1);
  
%linha 4
y(1:513)= 40;
hold on;
plot (x, y, ':k', 'LineWidth',1);
  
%linha 5
x = 0.9 + m.*(0.1);
hold on;
plot (x, y, ':k', 'LineWidth',1);
   
%linha 6
y(1:513) = 55;
hold on;
plot (x, y, ':k', 'LineWidth',1);
   
%coluna 1
x(1:513) = 0.5;
y = m.*90;
hold on;
plot (x, y, ':k', 'LineWidth',1);
    
%coluna 2 
x(1:513) = 0.9;
hold on;
plot (x, y, ':k', 'LineWidth',1);
 
axis([0 1 0 90])
