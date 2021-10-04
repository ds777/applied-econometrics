sjlog using ch2.11,replace
use reshapeState, clear
list
sjlog close, replace

sjlog using ch2.11a, replace
reshape long pop, i(state) j(year)
sjlog close, replace

sjlog using ch2.11b, replace
list
sjlog close, replace

*sjlog using ch2.12, replace
*use reshapeStateL, clear
*describe
*sjlog close, replace
                                                                                
sjlog using ch2.12a, replace
reshape wide pop, i(state) j(year)
sjlog close, replace
                                                                                
sjlog using ch2.12b, replace
list
sjlog close, replace
