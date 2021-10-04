sjlog using ch2.6, replace
use census2b, clear
list state if region==""
tabulate region
assert r(N) == 50
sjlog close, replace
