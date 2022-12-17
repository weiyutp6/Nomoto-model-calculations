function [x,y] = nomoto_cal(out)
    longchange = cos(out)*0.02;
    latchange = sin(out)*0.02;
    y = zeros(1,length(longchange));
    x = zeros(1,length(latchange));
    for i = 2:length(out)
        y(i) = y(i-1) + longchange(i-1);
        x(i) = x(i-1) + latchange(i-1);
    end
end