%%=========================================================================
% Tutorial: Radar com gometria side looking
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

clear 
close all
clc

%% Carrega os parametros 
parametros

%% Plota a posição do sensor e do target===================================
h1 = figure(1);
%-Localização do sensor----------------
plot3(0, 0 , h, 'ok', 'LineWidth',3)

%-Azimuth Line-------------------------
clear x y z
x = (-20:1:20);
y = zeros(size(x));
z(1:size(x,1), 1:size(x,2)) = h;
hold on
plot3(x, y, z, '-k', 'LineWidth',1)

%-Slant Range Lines--------------------
%%--Range
N = 1024;
x = zeros(1, N+1);
y = 0:R_grd/N:R_grd;
z = h:-h/N:0;
plot3(x, y, z, '-b', 'LineWidth',1)

%%-- Near Range
x = zeros(1, N+1);
y = 0:R_grd_near/N:R_grd_near;
z = h:-h/N:0;
plot3(x, y, z, ':b', 'LineWidth',1)

m = Ds/(2*N);
x = 0:-m:-Ds/2;
y = 0:R_grd/N:R_grd;
z = h:-h/N:0;
plot3(x, y, z, ':r', 'LineWidth',1)

%%-- Far Range
x = zeros(1, N+1);
y = 0:R_grd_far/N:R_grd_far;
z = h:-h/N:0;
plot3(x, y, z, ':b', 'LineWidth',1)

m = Ds/(2*N);
x = 0:m:Ds/2;
y = 0:R_grd/N:R_grd;
z = h:-h/N:0;
plot3(x, y, z, ':r', 'LineWidth',1)
%--------------------------------------

%-Swath Range--------------------------
x = zeros(1, N+1);
y = R_grd_near:Sgrd/N:R_grd_far;
z = zeros(1, N+1);
plot3(x,y,z, ':b', 'LineWidth',1);

x = -Ds/2:Ds/N:Ds/2;
y(1, 1:N+1) = R_grd;
z = zeros(1, N+1);
plot3(x,y,z, ':r', 'LineWidth',1);

xhist = [];
yhist = [];
zhist = [];

%-Image Foot Print---------------------
x = [-Dsn/2 Dsn/2];
y = [R_grd_near R_grd_near];
z = zeros(1, 2);

xhist = [xhist x(1) x(end)];
yhist = [yhist y(1) y(end)];
zhist = [zhist z(1) z(end)];

x = [-Dsf/2 Dsf/2];
y = [R_grd_far R_grd_far];
z = zeros(1, 2);

xhist = [xhist x(1) x(end)];
yhist = [yhist y(1) y(end)];
zhist = [zhist z(1) z(end)];
    
x = [-Dsn/2 -Dsf/2];
y = [R_grd_near R_grd_far];
z = zeros(1, 2);

xhist = [xhist x(1) x(end)];
yhist = [yhist y(1) y(end)];
zhist = [zhist z(1) z(end)];
    
x = [Dsn/2 Dsf/2];
y = [R_grd_near R_grd_far];
z = zeros(1, 2);

xhist = [xhist x(1) x(end)];
yhist = [yhist y(1) y(end)];
zhist = [zhist z(1) z(end)];
    
xhistant = [xhist(1) xhist(2) xhist(4) xhist(6) xhist(1)];
yhistant = [yhist(1) yhist(2) yhist(3) yhist(3) yhist(1)];
zhistant = zhist(1:5);
    
h2 = fill3(xhistant,yhistant,zhistant, 'c');
h2.FaceColor = [0.8 0.8 0.8];
h2.EdgeColor = [0.2 0.2 0.2];
%--------------------------------------

grid on
% axis([(-Dsf) (Dsf ) -10 R_grd_far+1000 0 10001])
axis([(-500) (500) -10 R_grd_far+1000 0 10001])

view([30,30,30])
xlabel('Azimute');
ylabel('Range');
zlabel('Altura');
%==========================================================================

% Resolucao em Azimute
delta_a = lambda*R_slt/da;

fprintf('Angulo de abertura - Azimute (deg): %f\n', rad2deg(aba));
fprintf('Angulo de abertura - Elevacao (deg): %f\n', rad2deg(abr));
fprintf('Comprimento da imagem - Ground Range (m): %f\n', Sgrd);
fprintf('Largura da imagem - near range (m): %f\n', Dsn);
fprintf('Largura da imagem - far range (m): %f\n', Dsf);
fprintf('Resolucao em azimute (m): %f\n', delta_a);
