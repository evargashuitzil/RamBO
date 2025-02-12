function S_lambda = soft_thresh(x,lambda)
    S_lambda = sign(x) .*  max(abs(x) - lambda,0);
end