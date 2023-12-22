function vwcr = VWCR(w)
%VWCR computes the volatility-weighted concentration ratio
%w is the weight vector
%sigma is the volatility vector

global sigma

ws = (w.*sigma) ;
vwcr = ws*ws'/(sum(ws)^2) ;
end

