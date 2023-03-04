function [x,y] = nomotoSim(angle)
    %% load current full input signal
    s = load("signal.mat");
    currentSignal = s.newArray;
    newArray = [currentSignal angle];

    %% Nomoto model with symbolic math toolbox
    % define system transfer function
    k = -0.1724;
    t1 = 2.0875;
    t2 = 0.3179;
    t3 = 0.183;
    gain = 60;

    % create symbolic parameters
    syms s t
    tSize = length(newArray);
    f = newArray;
    F = 0;

    % z transform of input to laplace (z to laplace transformation) (prev:tustin approximation)
    z = exp(s);
    for i = 1:tSize
        F = F + f(i)/z^(i-1);
    end

    % convolute input with system
    sys = vpa((gain*k*t3*s+gain*k)/(t1*t2*s^3+(t1+t2)*s^2+s));
    Output = F*sys;
    out = ilaplace(Output);
    yawMat = zeros(tSize);

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

%     %% Nomoto model with control systems toolbox
%     g = gain*tf([k*t3 k], [t1*t2 t1+t2 1 0]);
%     Ts = 1;
%     t = 0:Ts:length(newArray)-1;
%     out = lsim(g,newArray,t);
%     longchange = cos(out)*Ts;
%     latchange = sin(out)*Ts;
%     y = zeros(1,length(longchange));
%     x = zeros(1,length(latchange));
%     for i = 2:length(out)
%         y(i) = y(i-1) + longchange(i-1);
%         x(i) = x(i-1) + latchange(i-1);
%     end

    %% output current coordinates and run time
    x = -xout(length(xout));
    y = yout(length(yout));
    save("theoretical.mat","xout","yout");
    save("signal.mat","newArray");
end