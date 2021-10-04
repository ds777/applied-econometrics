sjlog using ch8.9a, replace
use traffic, clear
xtsum fatal beertax spircons unrate perincK state year
sjlog close, replace

sjlog using ch8.9, replace
xtreg fatal beertax spircons unrate perincK, fe
sjlog close, replace

sjlog using ch8.10, replace
quietly tabulate year, generate(yr)
local j 0
forvalues i=82/87 {
	local ++j
	rename yr`j' yr`i'
	quietly replace yr`i' = yr`i' - yr7
	}
drop yr7
xtreg fatal beertax spircons unrate perincK yr*, fe
test yr82 yr83 yr84 yr85 yr86 yr87 
sjlog close, replace

sjlog using ch8.11, replace
xtreg fatal beertax spircons unrate perincK, be
sjlog close, replace

sjlog using ch8.12, replace
xtreg fatal beertax spircons unrate perincK, re
sjlog close, replace

sjlog using ch8.13, replace
quietly xtreg fatal beertax spircons unrate perincK, fe
estimates store fix
quietly xtreg fatal beertax spircons unrate perincK, re
estimates store ran
hausman fix ran
sjlog close, replace

/*
xtabond2 fatal L.fatal spircons year, ///
gmm(beertax spircons unrate perincK) iv(year) ///
twostep robust noleveleq 
*/
sjlog using ch8.14, replace
use traffic, clear
tsset
xtabond2 fatal L.fatal spircons year, ///
gmmstyle(beertax spircons unrate perincK) ///
ivstyle(year) twostep robust noleveleq 
sjlog close, replace

/*
xtabond2 fatal L.fatal spircons year, ///
gmm(beertax spircons unrate perincK) iv(year) ///
twostep robust 
*/
sjlog using ch8.15, replace
xtabond2 fatal L.fatal spircons year, ///
gmmstyle(beertax spircons unrate perincK) ///
ivstyle(year) twostep robust 
sjlog close, replace
