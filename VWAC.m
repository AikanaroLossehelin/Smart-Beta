function vwac = VWAC(w)
% VWAC computes the volatility-weighted average correlation
%w is the weight vector
%sigma is the volatility vector
%rho is the corremation matrix

global sigma
global rho

ws = w.*sigma ;
N = size(sigma,2) ;
vwac = 0 ;
coef = 0 ;
for i=1:N
    for j = 1:N
        if j ~= i
            vwac = vwac + ws(i)*ws(j)*rho(i,j) ;
            coef = coef + ws(i)*ws(j) ;
        end
    end
end
vwac = vwac/coef ;
end

