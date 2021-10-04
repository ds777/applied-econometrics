set scheme sj

sjlog using ch5.17, replace
use nlsw88, clear
generate lwage = log(wage)
generate Ten2 = tenure<=2
generate Ten7 = !Ten2 & tenure<=7
generate Ten12 = !Ten2 & !Ten7 & tenure<=12
generate Ten25 = !Ten2 & !Ten7 & !Ten12 & tenure<.
sjlog close, replace

sjlog using ch5.17a, replace
generate tTen2 = tenure*Ten2
generate tTen7 = tenure*Ten7
generate tTen12 = tenure*Ten12
generate tTen25 = tenure*Ten25
regress lwage Ten* tTen*, nocons hascons
predict double lwagehat
label var lwagehat "Predicted log(wage)"
sort tenure
sjlog close, replace

scalar ten199=_b[Ten2]+1.99*_b[tTen2]
scalar ten201= _b[Ten7]+2.01*_b[tTen7]
di ten199 " " ten201
scalar ten699=_b[Ten7]+6.99*_b[tTen7]
scalar ten701= _b[Ten12]+7.01*_b[tTen12]
di ten699 " " ten701

sjlog using ch5.17b, replace
twoway (line lwagehat tenure if tenure<=2) ///
(line lwagehat tenure if tenure>2 & tenure<=7) ///
(line lwagehat tenure if tenure>7 & tenure<=12) ///
(line lwagehat tenure if tenure>12 & tenure<.), legend(off)
sjlog close, replace
graph export fig5_3.eps, replace

sjlog using ch5.18, replace
mkspline sTen2 2 sTen7 7 sTen12 12 sTen25 = tenure
regress lwage sTen*
predict double lwageSpline
label var lwageSpline "Predicted log(wage), splined"
twoway line lwageSpline tenure
sjlog close, replace
graph export fig5_4.eps, replace


