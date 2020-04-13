%%=========================================================================
% Tutorial: parametros do radar de abertura real
% Autor: Naiallen Carvalho
% Computação Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================

%% -Parametros do Meio=====================================================
co = 299792458;             % [m/s] velocidade da luz

%% -Parametros da Plataforma===============================================
h = 10e3;                   % [m] altura da platforma
vplat = 700;                % [m/s] velocidade da plataforma

%% -Parametrosdo Sensor====================================================
%--Tamanho do antena do radar
da = 1.8;                   %[m] comprimento efetivo da antena: dobro da resolução em azimute
de = 0.18;                  %[m] largura da antena (range)

%--Parâmetros Eletônicos do Radar
fp = 9.67e9;                % [Hz] frequencia da portadora (banda X)
lambda = co/fp;             % [m]  comprimento de onda
bw = 10e6;                 % [Hz] largura de banda
fs = bw*2;                  % [Hz] frequencia de amostragem
Ts = 1/fs;                  % [s] período de amostragem

%--Geometria 
alpha = deg2rad(60);        % [rad] angulo de incidência
aba = lambda/da;            % [rad] abertura da antena em azimute
abr = lambda/de;            % [rad] abertura da imagem em elevação (slant range)
    
%% -Parametros da cena=====================================================
theta = deg2rad(90 - rad2deg(alpha));       %[rad] média do angulo de depressão
%--Range
R_grd = h*tan(alpha);                       %[m] Ground Range
R_slt = sqrt(h^2 + R_grd^2);                %[m] Slant Range
    %Near Range--
R_grd_near = h*tan(alpha - lambda/(2*de));  %[m] Ground Range Near
R_slt_near = sqrt(h^2 + R_grd_near^2);      %[m] Slant Range Near
    %Far Range--
R_grd_far = h*tan(alpha + lambda/(2*de));   %[m] Ground Range Far
R_slt_far = sqrt(h^2 + R_grd_far^2);        %[m] Slant Range Far
    %Largura do Swath
Sgrd = R_grd_far - R_grd_near;              %[m] Ground Range Swath
Sslt = Sgrd*sin(theta);                     %[m] Slant Range Swath

%--Azimute Definitions
Ds = R_slt*aba;                             %[m] Foot Print em Azimute 
    %Near Range
Dsn = R_slt_near*aba;                       %[m] Foot Print em Azimute no near range
    %Far Range
Dsf = R_slt_far*aba;                        %[m] Foot Print em Azimute no far range

delta_R = co/(2*bw);                        % [m] range resolution
delta_Az = da/2;                            % [m]azimuth resolution

%% define targets
target.x0 = 20;
target.y0 = 18000;
target.z0 = 0;
target.r0 = sqrt(h^2 + target.y0^2);
target.vx = 0;
target.vy = 0; %nao aplicavel

%% -Parametros do Chirp====================================================
bw_slowtime = (2*vplat/da);         % [] largura de banda em slow time
PRF = bw_slowtime*2;                % [] frequencia de repetição de pulso
PRI = 1/PRF;                        % [] intervalo de repetição de pulso
tep = 5e-6;                         % [s] duração do pulso
chirp_rate = bw/tep;                % [ ] chirp rate

%% Fast time
t_ini = 0;
t_end = 2*(R_slt_far*1.1)/co;
tau = t_ini:Ts:t_end;               % [s] chirp time vector
N_range = length(tau);

%% - Slow time
slow_time = (lambda/da)*(R_slt_far/vplat); 
T = -slow_time/2:PRI:slow_time/2;
N_azimuth = length(T);

%% - vetor de tempo
vec_azimuth_m = T*vplat;
vec_range_m = co*tau/2;
