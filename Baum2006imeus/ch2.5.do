sjlog using ch2.5, replace
use census2b, clear
                                             // check pop
list if pop < 300000 | pop > 3e7
assert pop <. & pop > 300000 & pop <= 3e7
                                             // check medage
list if medage <= 20 | medage >= 50
assert  medage > 20  & medage < 50
                                             // check drate
list if drate < 10  | drate >= 104+145
assert  drate < 10  & drate < 104+145
sjlog close, replace

/*
local err 0
capture noisily assert pop < . & pop > 300000 & pop <= 3e7 
local err `err' + _rc
list if pop <= 300000 | pop > 3e7
sjlog close, replace

*sjlog using ch2.5a, replace
capture noisily assert medage > 20 & medage < 50 
local err `err' + _rc
list if medage <= 20 | medage >= 50 
*sjlog close, replace

*sjlog using ch2.5b, replace
capture noisily assert drate > 10 & drate < 104+145
local err `err' + _rc
list if drate <= 10 | drate >= 104+145
*sjlog close, replace

*sjlog using ch2.5c, replace
assert `err' == 0
*sjlog close, replace
*/
