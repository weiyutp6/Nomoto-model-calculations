b0 = -0.4545;
b1 = -2.664;
a1 = 3.706;
a2 = 1.545;
syms t1 t2 k
t3 = b0/b1
eqn1 = k/t1/t2 == b1;
eqn2 = 1/t1+1/t2 == a1;
eqn3 = 1/t1/t2 == a2;
eqns = [eqn1 eqn2 eqn3];
s = solve(eqns,[t1 t2 k]);
t1 = vpa(s.t1)
t2 = vpa(s.t2)
k = vpa(s.k)