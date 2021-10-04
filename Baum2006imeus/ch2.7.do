sjlog using ch2.7, replace
use census2b, clear
duplicates list state
assert r(sum) == 0
sjlog close, replace
