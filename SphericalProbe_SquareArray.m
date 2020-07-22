% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Generate square array
% Jamie Booth 6-23-2020

function [x_,y_,N] = SphericalProbe_SquareArray(a_crit,d_)

nx = ceil(2*a_crit/d_);
ny = ceil(2*a_crit/d_);
x_ = zeros(nx*ny,1); y_ = zeros(nx*ny,1);

for ex = 1:nx % Builds matrix of fibril positions
    
    for ey = 1:ny
        
        i = ny*(ex-1)+ey;
        x_(i) = (ex-1)*d_;
        y_(i) = (ey-1)*d_;
        
    end
    
end

% Zero center of array
x_ = x_ - (max(x_)-min(x_))/2;
y_ = y_ - (max(y_)-min(y_))/2;

% Crop to circle
r_ = (x_.^2+y_.^2).^0.5;
x_ = x_(r_ < a_crit);
y_ = y_(r_ < a_crit);

N = length(x_);

% Ensure a minimum of one fibril
if N == 0
    
    x_ = 0;
    y_ = 0;
    N = 1;
    
else
end
    