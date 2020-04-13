%%=========================================================================
% Tutorial: Radar com gometria side looking
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

%% Plota a posição do sensor e do target===================================
h1 = figure(1);

for n=1:N_azimuth
    clf
    % Plota target
    %-Localização do sensor----------------
    plot3(target.x0, target.y0, 0, 'ok', 'LineWidth',3)
    hold on
    grid on
    % axis([(-Dsf) (Dsf ) -10 R_grd_far+1000 0 10001])
    axis([(-500) (500) -10 R_grd_far+1000 0 h+500])
    view([30,30,30])
    
    %-Azimuth Line-------------------------
    xs = vplat*T;
    y = zeros(size(xs));
    z(1:size(xs,1), 1:size(xs,2)) = h;
    hold on
    plot3(xs, y, z, '-k', 'LineWidth',1)

    %-Localização do sensor----------------
    clear x y z
    x =xs(n);
    y = 0;
    z = h;
    plot3(x,y,z, 'ok', 'LineWidth',3)
    
    %-Slant Range Lines--------------------
    %%--Range
    N = 1024;
    x = ones(1, N+1)*xs(n);
    y = 0:R_grd/N:R_grd;
    z = h:-h/N:0;
    plot3(x, y, z, '-b', 'LineWidth',1)
    
    %%-- Near Range
    x = ones(1, N+1)*xs(n);
    y = 0:R_grd_near/N:R_grd_near;
    z = h:-h/N:0;
    plot3(x, y, z, ':b', 'LineWidth',1)
    
    m = Ds/(2*N);
    x = (0:-m:-Ds/2)+xs(n);
    y = 0:R_grd/N:R_grd;
    z = h:-h/N:0;
    plot3(x, y, z, ':r', 'LineWidth',1)
    
    %%-- Far Range
    x = ones(1, N+1)*xs(n);
    y = 0:R_grd_far/N:R_grd_far;
    z = h:-h/N:0;
    plot3(x, y, z, ':b', 'LineWidth',1)
    
    m = Ds/(2*N);
    x = (0:m:Ds/2)+xs(n);
    y = 0:R_grd/N:R_grd;
    z = h:-h/N:0;
    plot3(x, y, z, ':r', 'LineWidth',1)
    %--------------------------------------
    
    %-Swath Range--------------------------
    x = ones(1, N+1)*xs(n);
    y = R_grd_near:Sgrd/N:R_grd_far;
    z = zeros(1, N+1);
    plot3(x,y,z, ':b', 'LineWidth',1);
    
    x = (-Ds/2:Ds/N:Ds/2)+xs(n);
    y(1, 1:N+1) = R_grd;
    z = zeros(1, N+1);
    plot3(x,y,z, ':r', 'LineWidth',1);
    
    %-Image Foot Print---------------------
    xhist = [];
    yhist = [];
    zhist = [];
    
    x = [-Dsn/2 Dsn/2]+xs(n);
    y = [R_grd_near R_grd_near];
    z = zeros(1, 2);
    
    xhist = [xhist x(1) x(end)];
    yhist = [yhist y(1) y(end)];
    zhist = [zhist z(1) z(end)];
    
    x = [-Dsf/2 Dsf/2]+xs(n);
    y = [R_grd_far R_grd_far];
    z = zeros(1, 2);
    
    xhist = [xhist x(1) x(end)];
    yhist = [yhist y(1) y(end)];
    zhist = [zhist z(1) z(end)];
    
    x = [-Dsn/2 -Dsf/2]+xs(n);
    y = [R_grd_near R_grd_far];
    z = zeros(1, 2);
    
    xhist = [xhist x(1) x(end)];
    yhist = [yhist y(1) y(end)];
    zhist = [zhist z(1) z(end)];
    
    x = [Dsn/2 Dsf/2]+xs(n);
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
    pause(0.000001)
end
%==========================================================================