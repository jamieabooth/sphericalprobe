% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Main code to extract fibril strength measurement
% Jamie Booth 6-23-2020

clear all;

% User inputs
[c,h,hex_yn,d,E,v,R,Fmaxexp] = SphericalProbe_UserInputs;
disp('Running...')

% Dimensionless parameters
h_ = h/(2*c);
d_ = d/c;
R_ = R/c;

% Standard simulation parameters
u_p = 0; % Starting prescribed dimensionless displacement
du_p = 0.01; % Prescribed dimensionless displacement increment

% Use adaptive step size in emax based on bisection method
i = 1;
e = Inf;
emax = 0;
Fmax = 0;
demax = 0.01;

while e > 0.005
    
    i = i + 1;
    emax = [emax emax(i-1)+demax];

    % Schargott solution provides lower bound on critical contact radius
    % Use 10% larger radius as starting point for array size
    a_crit = (2*max(emax(i))*h_*R_)^0.5;
    arraysizeerr = 1;

    % Process...
    % 1. Test array to full contact
    % 2. Identify pull-off force
    % 3. Test array using pull-off force as preload
    % 4. Keep increasing preload until saturation is observed
    % 4. Check if saturation required use of full array, and thus if larger array is needed, loop
    
    while arraysizeerr == 1

        a_crit = 1.1*a_crit; % 10% increase in array size if full contact is made prior to attaining saturation
        
        switch hex_yn
            case 0 % Square
                [x_,y_,N] = SphericalProbe_SquareArray(a_crit,d_);
            case 1 % Hex
                [x_,y_,N] = SphericalProbe_HexArray(a_crit,d_); 
        end

        [c_fib,c_BL] = SphericalProbe_Compliance(x_,y_,h_,v);
        fc_ = ones(N,1); % Uniform fibril strength

        [~,~,~,~,F_data,~] = SphericalProbe_ForceDispAllFibrils(u_p,du_p,R_,h_,N,x_,y_,emax(i),v,c_fib,c_BL,fc_);
        F_max1 = max(F_data);

        P_ = F_max1;
        preloaderr = 1;

        while preloaderr == 1

            P_ = 1.05*P_; % 5% increase in preload if saturation not observed
            [~,~,~,~,F_data,Nadata] = SphericalProbe_ForceDispPreload(u_p,du_p,R_,h_,P_,N,x_,y_,emax(i),v,c_fib,c_BL,fc_);
            F_max2 = max(F_data);

            conv = abs(F_max2 - F_max1)/F_max2;
            if conv > 0.01
                preloaderr = 1;
            else
                preloaderr = 0;
            end

            arraysizeerr = max(Nadata)/N;

        end

    end
    
    Fmax = [Fmax F_max2.*pi.*c.^2.*E.*emax(i)];
    e = abs((Fmaxexp-Fmax(i))/Fmaxexp);
    demax = (Fmaxexp-Fmax(i))*(emax(i)-emax(i-1))/(Fmax(i)-Fmax(i-1));
    
end

emaxexp = emax(i)
fmaxexp = pi*c^2*E*emaxexp
switch hex_yn
    case 0 % Square
        Weffexp = (1/d^2)*fmaxexp^2*h/(2*pi*c^2*E)
    case 1 % Hex
        Weffexp = (2/(sqrt(3)*d^2))*fmaxexp^2*h/(2*pi*c^2*E)
end
