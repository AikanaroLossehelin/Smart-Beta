clear all ; close all

addpath("C:\Documents\MINES ST-Etienne\2023-2024\Cours Dauphine\Cryptomonnaies\TOBAM\Project 1_ Smart Beta in Crypto\Data") ;

data = readtable("daily_crypto_data.csv") ;

global cosigma
global sigma
global rho
global lbd

T = size(data,1)-1 ;
N = size(data,2)-1 ;
rdt = zeros(T,N) ;

for i = 1:N
    colData = table2array(data(:, i+1));
    rdt(:,i) = diff(log(colData)) ; 
end
clear colData ;

figure(1) ;
hold on ;
for i = 1:N
    colname = data.Properties.VariableNames{i};
    subplot((N+3)/4, 4, i) ; plot(rdt(:,i)) ;
    legend(['rendement ' colname]) ;
end
clear colname ;
hold off ;

sigma = sqrt(var(rdt)) ;
cosigma = cov(rdt) ;
rho = corr(rdt) ;

corr_table = 'C:\Documents\MINES ST-Etienne\2023-2024\Cours Dauphine\Cryptomonnaies\TOBAM\Project 1_ Smart Beta in Crypto\Smart-Beta\corr_table.xlsx';
writematrix(rho, corr_table);

weight = ones(1,N) * 1/N ;

vwac = VWAC(weight) ;
vwcr = VWCR(weight) ;
dr = DR(weight) ;

nb_risk_factor_approx = dr^2 ;

Aeq = ones(1,N); beq = 1; 
lb = zeros(1,N);
ub = ones(1,N); 
lbd = zeros(1,N) ;

fun = @(w)log(DR(w)) ;
%options= optimoptions('fmincon', 'MaxIterations', 500) ;
%[w_opt,dr_opt,exitflag,output,lambda,grad,hessian] = fmincon(fun, weight, A, b, Aeq, beq, lb, ub, [], options) ;

%options = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxIterations', 1000);
%[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(fun, weight, A, b, Aeq, beq, lb, ub, [], options);

%options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'MaxIterations', 2000);
%[w_opt,dr_opt,exitflag,output,lambda,grad,hessian] = fmincon(fun, weight, [], [], Aeq, beq, lb, ub, @constraint, options);

options = optimoptions('fmincon', 'Algorithm', 'sqp', 'MaxIterations', 2000, 'OutputFcn', @stopeval);
options = optimoptions(options, 'OutputFcn', @stopeval);
[w_opt, dr_opt, exitflag, output, lambda, grad, hessian] = fmincon(fun, weight, [], [], Aeq, beq, lb, ub, @constraint, options);

dr_opt2 = DR(w_opt) ;
tot = sum(w_opt) ;
lbd_max = max(lambda.upper) ;
lbd_max2 = max(lbd) ;