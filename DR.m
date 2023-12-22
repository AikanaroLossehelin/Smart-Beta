function dr = DR(w)
%DR computes the decomposition ratio
%w is the weight vector
%sigma is the volatility vector
%rho is the corremation matrix
global sigma
global rho

AC = VWAC(w) ;
CR = VWCR(w) ;
dr = 1/sqrt(CR*(1-AC)+AC) ;
end

