% Fibrillar array discrete contact mechanics - spherical probe test 
% Public code for Bettscheider et al. (2020)
% Single test with specified preload
% Jamie Booth 6-23-2020


function [u_pdata,u_fibdata,u_BLdata,f_data,F_data,Nadata] = SphericalProbe_ForceDispPreload(u_p,du_p,R_,h_,P_,N,x_,y_,emax,v,c_fib,c_BL,fc_)

att_yn = false(N,1);
f_= zeros(N,1);
fib= transpose(1:N);

z_fibtip = (1./(emax*(1-v^2)))*2*h_*ones(N,1);

count = 0; % Increment count
F_ = 0; % Initial load

u_pdata = [];
u_fibdata = [];
u_BLdata = [];
f_data = [];
F_data = [];
Nadata = [];

c_ = c_fib + c_BL;

% Approach

while F_ > -P_ 
    
    count = count + 1;
    
    u_pdata(count) = u_p;
    
    u_ = u_p*ones(N,1) + (1./(emax*(1-v^2)))*(x_.^2./(2*R_)+y_.^2./(2*R_));
    
    z_surf = (1./(emax*(1-v^2)))*2*h_*ones(N,1) + u_;
    att_yn(z_fibtip >= z_surf) = 1;
    
    att_ind = 1; % Forces following while loop to run at least once
    
    while isempty(att_ind) == 0 % Runs reduction of c and recalculation of f_fmax until all fibrils are not critical
        
        
        fibred = fib(att_yn==1);
        
        u_red = u_(fibred);

        c_red = c_(fibred,fibred);
        k_red = eye(length(fibred))/c_red;

        f_red = k_red*u_red;
        
        f_ = zeros(N,1);
        f_(fibred) = f_red;
        f_data(:,count) = f_;
    
        u_fibdata(:,count) = c_fib*f_;
        u_BLdata(:,count) = c_BL*f_;
        
        z_fibtip = (1./(emax*(1-v^2)))*2*h_*ones(N,1) + u_fibdata(:,count) + u_BLdata(:,count);
        
        att_ind = setdiff(fib(z_fibtip >= z_surf),fib(att_yn));
        att_yn(att_ind) = 1;
    
    end

    F_ = sum(f_);
    F_data = [F_data F_];
    Nadata = [Nadata sum(att_yn)];
    
    u_p = u_p - du_p;

    
end


% Retraction

while sum(att_yn) > 0 
    
    count = count + 1;
    
    u_pdata(count) = u_p;
    
    u_ = u_p*ones(N,1)  + (1./(emax*(1-v^2)))*(x_.^2./(2*R_)+y_.^2./(2*R_));
    
    det_ind = 1; % Forces following while loop to run at least once
    
    while isempty(det_ind) == 0 % Runs reduction of c and recalculation of f_fmax until all fibrils are not critical
        
        
        fibred = fib(att_yn==1);
        fc_red = fc_(fibred);
        
        u_red = u_(fibred);

        c_red = c_(fibred,fibred);
        k_red = eye(length(fibred))/c_red;

        f_red = k_red*u_red;
        det_ind = fibred(f_red > fc_red);

        att_yn(det_ind) = 0;      
        
    
    end
    
    f_ = zeros(N,1);
    f_(fibred) = f_red;
    f_data(:,count) = f_;
    
    F_ = sum(f_);
    F_data = [F_data F_];
    Nadata = [Nadata sum(att_yn)];
    
    u_fibdata(:,count) = c_fib*f_;
    u_BLdata(:,count) = c_BL*f_;

    u_p = u_p + du_p;
    
end
