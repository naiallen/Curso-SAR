%%=========================================================================
% Tutorial: Pulso retangular
% Autor: Naiallen Carvalho
% Computção Aplicada
% Instituto Nacional de Pesquisas Espaciais - INPE
% 2020
%==========================================================================
function y = rect_function(t, t0, T)  		
%%=========================================================================
%Entradas:
%    t      [s] vetor de tempo
%    t0     [s] Time shift
%    T      [s] tamanho do pulso
%
%Saída
%    y      [ ] vetor com os valores o pulso retangular
%==========================================================================
y       = zeros(length(t),1);
aux     = find(abs(t-t0)<=T/2);
y(aux)  = 1;


