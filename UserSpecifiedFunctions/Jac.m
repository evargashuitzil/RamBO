function J = Jac(m,h,f,nd,dx)
J  = ones(nd,length(m));
m1 = zeros(size(m));
for i = 1:length(m)
    m1(i) = dx;
    J(:,i) = (callMT(m+m1,h,f) - callMT(m-m1,h,f))./(2*dx);
    m1(i) = 0;
end
end

