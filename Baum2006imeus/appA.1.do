sjlog using appA.1, replace
clear
infile str2 state members prop potential using appA_1
list
sjlog close, replace

sjlog using appA.2, replace
clear
infile str2 state members prop potential str20 state_name key using appA_2
list
sjlog close, replace

sjlog using appA.3, replace
clear
type appA_3.raw
infile str2 state members prop potential str20 state_name key using appA_3
list
sjlog close, replace

sjlog using appA.4, replace
clear
insheet using appA_4
list
sjlog close, replace

