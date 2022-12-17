function in = localResetFcn(in)
    in = setVariable(in,'mapMatrix', 50*ones(10,10));
    mapReset();
    clf
end