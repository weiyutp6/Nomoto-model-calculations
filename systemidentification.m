load('derivative.mat','deriv');
load('input.mat','in');
data = iddata(deriv',in',0.01);
sys = tfest(data,2,1);
b0 = sys.Numerator(1);
b1 = sys.Numerator(2);
a1 = sys.Denominator(2);
a2 = sys.Denominator(3);
syms t1 t2 k
eqn1 = k/t1/t2 == b1;
eqn2 = 1/t1+1/t2 == a1;
eqn3 = 1/t1/t2 == a2;
eqns = [eqn1 eqn2 eqn3];
s = solve(eqns,[t1 t2 k]);
t1 = vpa(s.t1(1));
t2 = vpa(s.t2(1));
t3 = b0/b1;
k = vpa(s.k(1));
nomoto_coefficients = [t1;t2;t3;k]
save('nomoto_coef.mat','nomoto_coefficients')