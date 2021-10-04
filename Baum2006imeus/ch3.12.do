use berndtWood, clear
foreach v of varlist QV QK QL QE QM {
     g double l`v' = log(`v')
     }
sjlog using ch3.12, replace
reg lQV lQL lQE lQM
test lQL  + lQE + lQM = 1
lincom lQL + lQE + lQM
sjlog close, replace

sjlog using ch3.13, replace
test lQL = lQM
test lQL = 1.4 * lQM
sjlog close, replace

gen lQVL = lQV - lQL
gen lQEL = lQE - lQL
gen lQML = lQM - lQL
reg lQVL lQEL lQML
lincom 1 - lQEL - lQML

sjlog using ch3.14, replace
constraint def 1 lQL  + lQE + lQM = 1
cnsreg lQV lQL lQE lQM, constraint(1)
sjlog close, replace

reg lQV lQL lQE lQM
sjlog using ch3.15, replace
test lQL = 1.2 * lQM
test lQE = 0.2, accum
test lQL  + lQE + lQM = 1, accum
sjlog close, replace

sjlog using ch3.16, replace
testnl _b[lQE]*_b[lQL] = 0.2
testnl _b[lQL]*_b[lQM] = 0.25
nlcom _b[lQE]*_b[lQL] - 0.2
nlcom _b[lQL]*_b[lQM] - 0.25
testnl (_b[lQE]*_b[lQL] = 0.2) (_b[lQL]*_b[lQM] = 0.25)
sjlog close, replace

