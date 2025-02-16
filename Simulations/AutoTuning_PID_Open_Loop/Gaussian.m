function y = Gaussian ( window, mu, sigma) 
% y = exp (-((window - mu).^2)/(2*sigma^2)).* (1/(sigma * sqrt(2* pi)))  ;
y = exp (-((window - mu).^2)/(2*sigma^2)) ;
end
