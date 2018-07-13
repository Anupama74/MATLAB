%--------------------------------------------------------------------------
function [out] = mydistance(x,y,tipo)
% x and y are input 1D vectors
% out is the measured distance

% Euclidean distance
if tipo == 0
    out = sum((x-y).^2).^0.5;
end

% Distance sum | x -y |
if tipo == 1
    out = sum(abs(x-y));
end

% Weighted distance

if tipo == 2
    pesi = zeros(size(x));



    pesi(1)     = 0.20;
    pesi(2)     = 0.90;
    pesi(3)     = 0.95;
    pesi(4)     = 0.90;
    pesi(5)     = 0.70;
    pesi(6)     = 0.90;
    pesi(7)     = 1.00;
    pesi(8)     = 1.00;
    pesi(9)     = 1.00;
    pesi(10)    = 0.95;
    pesi(11:13) = 0.30;
                  
    out = sum(abs(x-y).*pesi);
    %out = sum(pesi.*(x-y).^2).^0.5;
end
%--------------------------------------------------------------------------
