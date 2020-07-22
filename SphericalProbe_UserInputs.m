% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Obtain user inputs through command window
% Jamie Booth 6-23-2020

function [c,h,hex_yn,d,E,v,R,Fmaxexp] = SphericalProbe_UserInputs

c = input('Enter fibril radius, c: ');
while c <= 0
    c = input('Value must be positive. Enter fibril radius, c: ');
end  
h = input('Enter fibril height, h: ');
while h <= 0
    h = input('Value must be positive. Enter fibril height, h: ');
end
hex_yn = input('Enter array packing (0 - square, 1 - hexagonal): ');
while hex_yn ~= 0 && hex_yn ~= 1
    hex_yn = input('Invalid input. Enter array packing (0 - square, 1 - hexagonal): ');
end
d = input('Enter fibril spacing, d: ');
while d <= 0
    d = input('Value must be positive. Enter fibril spacing, d: ');
end
E = input('Enter Young''s modulus, E: ');
while E <= 0
    E = input('Value must be positive. Enter Young''s modulus, E: ');
end
v = input('Enter Poisson ratio, v: ');
while v < 0 || v > 0.5
    v = input('Value should be in range 0 < v < 0.5. Enter Poisson ratio, v: ');
end
R = input('Enter probe radius, R: ');
while R <= 0
    R = input('Value should be positive. Enter probe radius, R: ');
end 
Fmaxexp = input('Enter measured maximum pull-off force, F_max: ');
while Fmaxexp <= 0
    Fmaxexp = input('Value should be positive. Enter measured maximum pull-off force, F_max: ');
end