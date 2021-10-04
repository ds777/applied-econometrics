sjlog using appA.5, replace
clear
infix using compustat2
sjlog close, replace  

sjlog using appA.6, replace
clear
infile using compustat3
describe
sjlog close, replace  

