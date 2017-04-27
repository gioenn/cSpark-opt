function [cores, deadlines, err] = xsparksolveb(i, r, maxcore, deadline, alpha)

options = optimoptions('fmincon', 'MaxFunctionEvaluations', 150000, 'MaxIterations', 100000);

x0(1:length(i)) = 1;
lb(1:length(i)) = 0;

d = deadline * alpha;

constraints = genconfun(i, r, d, maxcore);

[cores, ~, ~, output] = fmincon(@objfun,x0,[],[],[],[], lb, [], constraints, options);

disp(output);

deadlines = i./(r.*cores);

err = 100*(d - sum(deadlines))/d;


function g = genconfun(i, r, d, maxcore)

function [ c, ceq ] = confun(x)
    c = 1-prod(x <= maxcore);
    ceq = sum(i./(r.*x))-d;
end
    g = @confun;
end

function f = objfun(x)
    f = sum(x);
end

end
