sjlog using appA.05, replace
clear
infix using 09289-infix
sjlog close, replace  

sjlog using appA.06, replace
clear
infile using 09289-0001-Data
sjlog close, replace

sjlog using appA.07, replace
describe
sjlog close, replace  

