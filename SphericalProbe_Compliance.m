% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Formulate compliance matrix
% Jamie Booth 6-23-2020

function [c_fib,c_BL] = SphericalProbe_Compliance(x_,y_,h_,v)

N = length(x_);

c_fib = zeros(N);
c_BL = zeros(N);
r_ = zeros(N);

for i = 1:N % Builds unreduced compliance matrix
    
    for j = 1:N
        
     r_(i,j) = ((x_(i)-x_(j))^2+(y_(i)-y_(j))^2)^0.5;   
        
        if i==j
            
            c_fib(i,j) = 2*h_/(1-v^2);
            c_BL(i,j) = 16/(3*pi);
            
        else
            
            c_fib(i,j) = 0;
            c_BL(i,j) = 1/r_(i,j);
            
        end
        
    end
    
end