function y  = laprnd(n, mu, b)
u = rand(n,1)-0.5;
y = mu - b * sign(u).* log(1-2*abs(u));