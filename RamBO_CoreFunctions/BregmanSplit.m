function x = BregmanSplit(A,y,lam,D,v,tol,MaxIts)

    % BregmanSplit function: Solves a constrained optimization problem using
    % the Split Bregman method with Total Variation (TV) regularization.
    %
    % Inputs:
    %   A    - Forward operator (Jacobian)
    %   y    - Observed data vector
    %   lam  - Regularization parameter
    %   D    - Difference operator
    %   v    - Set to zero when using for generate blocky models
    %
    % Output:
    %   x    - Recovered solution 

nx = size(A,2);

mu = 2*lam;
b = zeros(nx,1);
d = zeros(nx,1);

bigA = [A; sqrt(mu)*D];
for kk=1:MaxIts

    rhs = [y;sqrt(mu)*(d-b)];
    x = bigA\rhs;
    s = soft_thresh(v+D*x+b,lam/mu);
    d = s-v;
    b = b+D*x-s;
    if kk>1 && norm(xOld-x)/norm(x)<tol || kk>MaxIts
        break
    end
    xOld = x;
end