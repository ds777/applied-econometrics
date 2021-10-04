clear
set obs 1000
set seed 20050910
gen double c = invnorm(uniform())
gen double x1 = invnorm(uniform()) + c
gen double x2 = invnorm(uniform()) + c
gen double e = invnorm(uniform()) 
gen cat = int((_n-1)/200)
tab cat, gen(d)
gen double y = 3 + x1 + 2*x2 + e
reg y x* d*, nocons
qui {
test d1 = d2
test d1 = d3, accum
test d1 = d4, accum
}
test d1 = d5, accum
reg y x* d1-d4
test d1 d2 d3 d4
