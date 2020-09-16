% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Single test specified to contact all fibrils in array
% Jamie Booth 6-23-2020

function F_max = SphericalProbe_ForceDispAllFibrils(u_p,du_p,R_,h_,N,x_,y_,emax,v,c_fib,c_BL,fc_)

% Initialize arrays
att_yn = false(N,1);
fib= 1:N';
F_max = [];
Namax = [];

% Constant system properties
z_fibtip = (1./(emax*(1-v^2)))*2*h_*ones(N,1);
c_ = c_fib + c_BL;

% Increment count
count = 1; 

% Approach
while sum(att_yn) < N 
    
    % Increment displacment
    u_p = u_p - du_p;
    count = count + 1;
    
    % Determine relative position of surface and fibril tips
    u_ = u_p*ones(N,1) + (1./(emax*(1-v^2)))*(x_.^2./(2*R_)+y_.^2./(2*R_));
    z_surf = (1./(emax*(1-v^2)))*2*h_*ones(N,1) + u_;
    % Log attachment of fibrils
    att_yn(z_fibtip >= z_surf) = 1;
    
    % Repeat until no further attachment occurs
    att_ind = 1; % Force loop to run at least once
    while isempty(att_ind) == 0
        
        % Calculate fibril forces
        fibred = fib(att_yn==1);
        f_red = c_(fibred,fibred)\u_(fibred);
        f_ = zeros(N,1);
        f_(fibred) = f_red;
        % Calculate deformation
        u_fib = c_fib*f_;
        u_BL = c_BL*f_;
        % Determine relative position of surface and fibril tips
        z_fibtip = (1./(emax*(1-v^2)))*2*h_*ones(N,1) + u_fib + u_BL;
        % Log attachment of fibrils
        att_ind = setdiff(fib(z_fibtip >= z_surf),fib(att_yn));
        att_yn(att_ind) = 1;
    
    end
    
    F_ = sum(f_);
    Na = sum(att_yn);
    
    F_max = max([F_max F_]);
    Namax = max([Namax Na]);

end

% Retraction
while sum(att_yn) > 0 
    
    % Increment displacement
    u_p = u_p + du_p;
    count = count + 1;
    
    % Determine fibril forces until no further detachements occur 
    u_ = u_p*ones(N,1) + (1./(emax*(1-v^2)))*(x_.^2./(2*R_)+y_.^2./(2*R_));
    det_ind = 1; % Force loop to run at least once
    while isempty(det_ind) == 0
        
        fibred = fib(att_yn==1);
        f_red = c_(fibred,fibred)\u_(fibred);
        det_ind = fibred(f_red > fc_(fibred));
        att_yn(det_ind) = 0;      
    
    end
    
    f_ = zeros(N,1);
    f_(fibred) = f_red;
    F_ = sum(f_);
    Na = sum(att_yn);
    
    F_max = max([F_max F_]);
    Namax = max([Namax Na]);

end
