%   Copyright 2010 The MathWorks, Inc.
function y = kalmanfilter(z,point) 
%z=column vector size 2x1
%point = index of diff tracker
dt=1;
% Initialize state transition matrix
A=[ 1 0 dt 0 0 0;...     % [x  ]            
       0 1 0 dt 0 0;...     % [y  ]
       0 0 1 0 dt 0;...     % [Vx]
       0 0 0 1 0 dt;...     % [Vy]
       0 0 0 0 1 0 ;...     % [Ax]
       0 0 0 0 0 1 ];       % [Ay]
H = [ 1 0 0 0 0 0; 0 1 0 0 0 0 ];    % Initialize measurement matrix
Q = eye(6);
R = 100 * eye(2);
persistent kal;%x_est p_est                % Initial state conditions
if ((isempty(kal))||(size(kal,2)<point))
    kal(point).x_est = zeros(6, 1);             % x_est=[x,y,Vx,Vy,Ax,Ay]'
    kal(point).p_est = zeros(6, 6);
end
% Predicted state and covariance
x_prd = A * kal(point).x_est;
p_prd = A * kal(point).p_est * A' + Q;
% Estimation
S = H * p_prd' * H' + R;
B = H * p_prd';
klm_gain = (S \ B)';
% Estimated state and covariance
kal(point).x_est = x_prd + klm_gain * (z - H * x_prd);
kal(point).p_est = p_prd - klm_gain * H * p_prd;
% Compute the estimated measurements
y = H * kal(point).x_est;
end                % of the function