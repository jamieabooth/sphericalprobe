% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Main code to extract fibril strength measurement
% Jamie Booth 9-7-2020

clear all;

% User inputs
[c,h,hex_yn,d,E,v,R,Fmaxexp] = SphericalProbe_UserInputs;
disp('Running...')

% Dimensionless parameters
h_ = h/(2*c); % Fibril height
d_ = d/c; % Fibril spacing
R_ = R/c; % Probe radius

% Initialize variables
u_p = 0; % Starting prescribed dimensionless displacement
du_p = 0.01; % Starting prescribed dimensionless displacement increment
i = 1; % Initialize loop counter
e = Inf; % Initialize error
emax = 0; % Initialize 
Fmax = 0; % Initialize detachment force
demax = 0.01; % Starting strain increment

while e > 0.005
    
    % Increment fibril strain to detachent
    i = i + 1;
    emax = [emax emax(i-1)+demax];

    % Schargott solution provides lower bound on contact radius
    % Use as starting point for array size
    a_crit = (2*max(emax(i))*h_*R_)^0.5;
    arraysizeerr = 1; % Error indicating full contact prior to saturation of pull-off force

    % Process...
    % 1. Test array to full contact
    % 2. Identify pull-off force
    % 3. Test array using pull-off force as preload
    % 4. Keep increasing preload until saturation is observed
    % 4. Check if saturation required use of full array, and thus if larger array is needed, loop
    
    while arraysizeerr == 1

        a_crit = 1.1*a_crit; % 10% increase in array size if full contact is made prior to attaining saturation
        
        % Generate array positions
        switch hex_yn
            case 0 % Square
                [x_,y_,N] = SphericalProbe_SquareArray(a_crit,d_);
            case 1 % Hex
                [x_,y_,N] = SphericalProbe_HexArray(a_crit,d_); 
        end
        
        % Generate compliance matrix
        [c_fib,c_BL] = SphericalProbe_Compliance(x_,y_,h_,v);
        % Prescribe uniform fibril strength
        fc_ = ones(N,1);
        % Perform model adhesion test with preload to full contact and output pull-off force
        F_max1 = SphericalProbe_ForceDispAllFibrils(u_p,du_p,R_,h_,N,x_,y_,emax(i),v,c_fib,c_BL,fc_);
        
        % Use pull-off force as starting point for preload
        P_ = F_max1;
        preloaderr = 1; % Error indicating saturation of pull-off force with preload not observed
        
        while preloaderr == 1

            P_ = 1.05*P_; % 5% increase in preload if saturation not observed
            
            % Perform model adhesion test with preload to specified force and output pull-off force
            [F_max2,Namax] = SphericalProbe_ForceDispPreload(u_p,du_p,R_,h_,P_,N,x_,y_,emax(i),v,c_fib,c_BL,fc_);
            
            % Test for saturation of pull-off force
            conv = abs(F_max2 - F_max1)/F_max2;
            if conv > 0.01
                preloaderr = 1;
            else
                preloaderr = 0;
            end
            
            % Test for full contact of array
            arraysizeerr = Namax/N;

        end

    end
    
    % Model saturation pull-off force
    Fmax = [Fmax F_max2.*pi.*c.^2.*E.*emax(i)];
    % Error between experimental and model saturation pull-off force
    e = abs((Fmaxexp-Fmax(i))/Fmaxexp);
    % Increment fibril strain to detachment using adaptive step size based on secant method
    demax = (Fmaxexp-Fmax(i))*(emax(i)-emax(i-1))/(Fmax(i)-Fmax(i-1));
    % Cap strain increment to avoid excessive computational cost
    demax = sign(demax)*min([abs(demax) 0.25]);
    
end

% Output fibril strength parameters
emaxexp = emax(i)
fmaxexp = pi*c^2*E*emaxexp
switch hex_yn
    case 0 % Square
        Weffexp = (1/d^2)*fmaxexp^2*h/(2*pi*c^2*E)
    case 1 % Hex
        Weffexp = (2/(sqrt(3)*d^2))*fmaxexp^2*h/(2*pi*c^2*E)
end
