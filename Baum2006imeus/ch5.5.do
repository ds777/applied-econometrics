sjlog using ch5.5a, replace
use nlsw88, clear
keep if !missing(wage + race + union)
generate lwage = log(wage)
summarize wage race union tenure, sep(0)
sjlog close, replace
*summarize wage race union occupation collgrad tenure, sep(0)

sjlog using ch5.5, replace
anova lwage race union
sjlog close, replace

sjlog using ch5.6, replace
tabulate race, generate(R)
regress lwage R1 R2 union
test R1 R2  //         joint test for the effect of race
sjlog close, replace

sjlog using ch5.7, replace
anova lwage race union race*union 
sjlog close, replace

sjlog using ch5.7a, replace
anova, regress
sjlog close, replace

sjlog using ch5.7b, replace
generate R1u = R1*union
generate R2u = R2*union
regress lwage R1 R2 union R1u R2u
test R1u R2u    //    joint test for the interaction effect of race*union
sjlog close, replace

/*  NOT USED -- REMOVED
*sjlog using ch5.8, replace
tabulate occupation, generate(O)
forvalues i = 1/`r(r)' {
	quietly generate R1O`i' = R1*O`i'
	quietly generate R2O`i' = R2*O`i'
}
*sjlog close, replace

*sjlog using ch5.8aa, replace
regress lwage R1 R2 union R1u R2u O* R1O* R2O* collgrad
*sjlog close, replace

*sjlog using ch5.8a, replace
//  joint test for the main effect of occupation
//  omitting dropped terms
test O1 O2 O3 O4 O5 O6 O7 O8  O11 O12 O13
// joint test for the interaction effect of race*occupation
//  omitting dropped terms
test R1O1 R1O2 R1O3 R1O4 R1O5 R1O6 R1O7 R1O8      R1O10 R1O11       R1O13 ///
     R2O1      R2O3           R2O6      R2O8  
test R1 R2     // joint test for the main effect of race
test R1u R2u   // joint test for the interaction effect of race*union
*sjlog close, replace

* anova lwage race union race*union occupation race*occupation collgrad

*/

sjlog using ch5.9, replace
regress lwage R1 R2 union tenure
test R1 R2  // joint test for the effect of race
sjlog close, replace

sjlog using ch5.10, replace
quietly generate uTen = union*tenure
regress lwage R1 R2 union tenure uTen
sjlog close, replace

sjlog using ch5.11, replace
quietly generate R1ten = R1*tenure
quietly generate R2ten = R2*tenure
regress lwage R1 R2 union tenure R1ten R2ten
test R1ten R2ten
sjlog close, replace

sjlog using ch5.12, replace
regress lwage R1 R2 union tenure uTen R1ten R2ten 
test uTen R1ten R2ten
sjlog close, replace

sjlog using ch5.13, replace
regress lwage union tenure uTen
sjlog close, replace

sjlog using ch5.13a, replace
regress lwage tenure if !union
predict double unw if e(sample), res
regress lwage tenure if union
predict double nunw if e(sample), res
sjlog close, replace

sjlog using ch5.14, replace
generate double allres = nunw
replace allres = unw if unw<.
sdtest allres, by(union)
sjlog close, replace

sjlog using ch5.14a, replace
regress lwage  union tenure uTen, robust
sjlog close, replace
