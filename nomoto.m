k = -0.1724;
t1 = 2.0875;
t2 = 0.3179;
t3 = 0.183;
gain = 10;
g = gain*tf([k*t3 k], [t1*t2 t1+t2 1 0]);
t = 0:0.01:20;
rotation90 = [0 -1;1 0];
leftturn = pi/12;
rightturn = -pi/12;
timing = 3.3;
transtime = 4;
%t1 = 0:0.01:timing-transtime;
%btw = timing-transtime+0.01:0.01:timing+transtime;
%t2 = timing+transtime+0.01:0.01:20;
%in = [rightturn*ones(size(t1)) pi/12/transtime*(btw-timing) leftturn*ones(size(t2))];
t1 = 0:0.01:timing;
t2 = timing+0.01:0.01:20;
in = [rightturn*ones(size(t1)) leftturn*ones(size(t2))];
%in = pi/12*ones(size(t));
out = lsim(g,in,t);
deriv = zeros(size(t));
for i = 2:length(t)
    deriv(i)=(out(i)-out(i-1))/0.01;
end
save('input.mat', 'in');
save('output.mat', 'out');
save('derivative.mat', 'deriv');
% plot(t,deriv)
longchange = cos(out)*0.05;
latchange = sin(out)*0.05;
y = zeros(1,length(longchange));
x = zeros(1,length(latchange));
for i = 2:length(out)
    y(i) = y(i-1) + longchange(i-1);
    x(i) = x(i-1) + latchange(i-1);
end
advance = find(out == min(abs(out+pi/2))-pi/2);
if isempty(advance)
    advance = find(out == -min(abs(out+pi/2))-pi/2);
end
tactical_rad = find(out == min(abs(out+pi))-pi);
if isempty(tactical_rad)
    tactical_rad = find(out == -min(abs(out+pi))-pi);
end
%plot(x(1:tactical_rad),y(1:tactical_rad))
%plot(0:0.01:(tactical_rad-1)/100, in(1:tactical_rad))
% plot(0:0.01:(tactical_rad-1)/100, out(1:tactical_rad))
% title('u turn counterclockwise yaw');
% xlabel('time(s)');
% ylabel('yaw(rad)');
% input = in(1:tactical_rad);
% yaw = out(1:tactical_rad);
% coords = [x(1:tactical_rad); y(1:tactical_rad)];
% save('Uturnin_counterclockwise.mat', 'input');
% save('Uturnyaw_counterclockwise.mat', 'yaw');
% save('Uturncoords_counterclockwise.mat','coords');
% circle = find(out == min(abs(out-2*pi))+2*pi)
% stopping = find(x == min(x));
% tacticalout = out(1:stopping);
% save('Uturnyaw.mat','tacticalout')
% plot(0:0.01:((stopping-1)/100),tacticalout')
% plot(x(1:tactical_rad),y(1:tactical_rad))
% plot(t,out)

% save u turn output as .mat
% coords = [x(1:stopping); y(1:stopping)];
% save('Uturncoords.mat','coords')

% plot u turn
% plot(x(1:stopping),y(1:stopping))
% title('U turn coords')
% xlabel('x(m)')
% ylabel('y(m)')
% plot(0:0.01:(stopping/100-0.01), out(1:stopping))
% title('U turn yaw')
% xlabel('time(s)')
% ylabel('yaw(rad)')
% plot(0:0.01:(stopping/100-0.01), in(1:stopping))
% title('U turn input on 15 degree rudder turn')
% xlabel('time(s)')
% ylabel('rudder angle(rad)')

% plot each type of turn
% plot(-y(1:advance),-x(1:advance))
% title('turn from left to up')
% xlabel('x(m)')
% ylabel('y(m)')

% figure;
% subplot(1,2,1);
% plot(x(1:advance),-y(1:advance))
% plot(0:0.01:(advance-1)/100, -x(1:advance))
% subplot(1,2,2);
% plot(t,in)
% plot(0:0.01:(advance-1)/100, y(1:advance))
% plot(x(1:tactical_rad),y(1:tactical_rad),'-s','MarkerIndices',[advance tactical_rad], 'MarkerFaceColor','red','MarkerSize',15)
% plot(t,out)

% save each type of turn as .mat
% turn180coords = [-x(1:tactical_rad);y(1:tactical_rad)];
% turn90coords = [-x(1:advance);y(1:advance)];
% save('turnUpToRight90.mat','turn90coords');
% save('turnUpToRight180.mat', 'turn180coords');
% turn90coords = rotation90*turn90coords;
% turn180coords = rotation90*turn180coords;
% save('turnRightToDown90.mat', 'turn90coords');
% save('turnRightToDown180.mat', 'turn180coords');
% turn90coords = rotation90*turn90coords;
% turn180coords = rotation90*turn180coords;
% save('turnDownToLeft90.mat', 'turn90coords');
% save('turnDownToLeft180.mat', 'turn180coords');
% turn90coords = rotation90*turn90coords;
% turn180coords = rotation90*turn180coords;
% save('turnLeftToUp90.mat', 'turn90coords');
% save('turnLeftToUp180.mat', 'turn180coords');