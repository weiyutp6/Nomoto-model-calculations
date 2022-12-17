%% Nomoto model with symbolic math toolbox
% define system transfer function
k = -0.1724;
t1 = 2.0875;
t2 = 0.3179;
t3 = 0.183;
gain = 10;

% create symbolic parameters
syms s
tSize = length(newArray);
n = 0:(tSize-1);
f = pi/12*ones(size(n));
F = 0;

% z transform of input to laplace (tustin approximation)
z = (1+s/2)/(1-s/2);
for i = 1:tSize
    F = F + f(i)/z^(i-1);
end

% convolute input with system
sys = vpa((gain*k*t3*s+gain*k)/(t1*t2*s^3+(t1+t2)*s^2+s));
Output = F*sys;
out = ilaplace(Output);
yawMat = zeros(tSize);
syms t

% inverse laplace
for i = 1:tSize
    yawMat(i) = subs(out,t,i-1);
end
yaw = yawMat;

% calculate coordinates from all yaw
longchange = cos(yaw)*1;
latchange = sin(yaw)*1;
yout = zeros(1,length(longchange));
xout = zeros(1,length(latchange));
for i = 2:length(yaw)
    yout(i) = yout(i-1) + longchange(i-1);
    xout(i) = xout(i-1) + latchange(i-1);
end