sjlog using ch8.6, replace
use 4klem_wide_defl, clear
tsset
summarize *d year, sep(5)
sjlog close, replace

sjlog using ch8.7, replace
forvalues i=32/35 {
	local eqn "`eqn' (pi`i'd L.pi`i'd pk`i'd pl`i'd pe`i'd pm`i'd) "
}
sureg `eqn', corr
sjlog close, replace

sjlog using ch8.7a, replace
test ([pi32d]pe32d = [pi33d]pe33d) ([pi32d]pe32d = [pi34d]pe34d) ///
     ([pi32d]pe32d = [pi35d]pe35d)
sjlog close, replace

sjlog using ch8.8, replace
constraint define 1 [pi32d]pe32d = [pi33d]pe33d
constraint define 2 [pi32d]pe32d = [pi34d]pe34d
constraint define 3 [pi32d]pe32d = [pi35d]pe35d
sureg `eqn', notable c(1 2 3) 
sjlog close, replace
