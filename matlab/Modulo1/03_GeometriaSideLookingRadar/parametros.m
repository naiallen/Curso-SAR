%%=========================================================================
% Tutorial: parametros do radar de abertura real
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

%% -Parametros do Meio=====================================================
co = 299792458;                     % [m/s] velocidade da luz

%% -Parametros da Plataforma===============================================
h = 10e3;                           % [m] altura da platforma

%% -Parametrosdo Sensor====================================================
%--Tamanho do antena do radar
da = 1.8;                           %[m] comprimento efetivo da antena: dobro da resolução em azimute
de = 0.18;                          %[m] largura da antena (range)

%--Parâmetros Eletônicos do Radar
fp = 9.67e9;                        % [Hz] frequencia da portadora (banda X)
lambda = co/fp;                     % [m] comprimento de onda

%--Geometria 
aba = lambda/da;                    % [rad] abertura da antena em azimute
abr = lambda/de;                    % [rad] abertura da imagem em elevação (slant range)
alpha = deg2rad(15);                % [rad] angulo de incidência
alpha_n = alpha - lambda/(2*de);    % [rad] angulo de incidencia em near range    
alpha_f = alpha + lambda/(2*de);    % [rad] angulo de incidencia em far range

%% -Parametros da cena=====================================================
%-- Comprimento do Swath
    %--Near Range
R_grd_near = h*tan(alpha_n);            %[m] Ground Range Near
R_slt_near = sqrt(h^2 + R_grd_near^2);  %[m] Slant Range Near

    %--Far Range
R_grd_far = h*tan(alpha_f);             %[m] Ground Range Far
R_slt_far = sqrt(h^2 + R_grd_far^2);    %[m] Slant Range Far

    %--Range
R_grd = h*tan(alpha);                       %[m] Ground Range
R_slt = sqrt(h^2 + R_grd^2);                %[m] Slant Range

%-- Slant Range Swath
theta = deg2rad(90 - rad2deg(alpha));   %[rad] média do angulo de depressão
Sslt = R_grd*sin(theta);                %[m] Slant Range Swath
Sgrd = R_grd_far - R_grd_near;              %[m] Ground Range Swath

%--Largura do Swath 
Ds = R_slt*aba;                         %[m] Foot Print em Azimute 
    %--Near Range
Dsn = R_slt_near*aba;                   %[m] Foot Print em Azimute no near range
    %--Far Range
Dsf = R_slt_far*aba;                    %[m] Foot Print em Azimute no far range