% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Generate hexagonal array
% Jamie Booth 6-23-2020

function [x_,y_,N] = SphericalProbe_HexArray(a_crit,d_)

nD = ceil(a_crit/d_);

A = @(T) [cos(T) sin(T); -sin(T) cos(T)]; 

N = 3*nD*(nD-1)+1;
x_ = zeros(N,1);
y_ = zeros(N,1);
rot = [0 pi/3 2*pi/3 pi 4*pi/3 5*pi/3];

ii = 1;

for ex = 2:nD % Builds matrix of fibril positions
    
    for ey = 2:ex

        x_unrot = (ex-1)*sqrt(3)*d_/2;
        y_unrot = (ey-1)*d_-0.5*(ex-1)*d_;

        for i = 1:length(rot)
            
            ii = ii + 1;
            xy_ = A(rot(i))*[x_unrot; y_unrot];
            x_(ii) = xy_(1);
            y_(ii) = xy_(2);

        end

    end
    
end

% Ensure a minimum of one fibril
if N == 0
    
    x_ = 0;
    y_ = 0;
    N = 1;
    
else
end