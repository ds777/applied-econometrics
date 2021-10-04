set more off
* altered version of womenwk
* g lw = log(wage)
* g work = (wage < .)
* g lwf = lw
* replace lwf = 0 if lwf==.

sjlog using ch7.1, replace
use womenwk, clear
summarize work age married children education
sjlog close, replace

sjlog using ch7.1a, replace
probit work age married children education, nolog 
sjlog close, replace

sjlog using ch7.1b, replace
mfx compute
sjlog close, replace

sjlog using ch7.1c, replace
margeff, dummies(married) count
sjlog close, replace

sjlog using ch7.2, replace
logit work age married children education, nolog
sjlog close, replace

sjlog using ch7.2a, replace
mfx compute
sjlog close, replace

sjlog using ch7.2b, replace
mfx compute, at(children=0)
sjlog close, replace
* save womenwk, replace

* dia: change in Inc/Asset ratio, 1982-1983
sjlog using ch7.3, replace
use panel84extract, clear
summarize rating83c ia83 dia
tabulate rating83c
sjlog close, replace

* oprobit rating83c ia83 dia, nolog
sjlog using ch7.3a, replace
ologit rating83c ia83 dia, nolog
sjlog close, replace

sjlog using ch7.3b, replace
predict spBA_B_C spBAA spAA_A spAAA
summarize spAAA, mean
list sp* rating83c if spAAA==r(max)
summarize spBA_B_C, mean
list sp* rating83c if spBA_B_C==r(max)
sjlog close, replace

sjlog using ch7.3c, replace
use laborsub, clear
summarize whrs kl6 k618 wa we
sjlog close, replace

sjlog using ch7.3d, replace
regress whrs kl6 k618 wa we if whrs>0
sjlog close, replace

sjlog using ch7.3e, replace
truncreg whrs kl6 k618 wa we, ll(0) nolog
sjlog close, replace

sjlog using ch7.4, replace
use womenwk, clear
regress lwf age married children education
sjlog close, replace

sjlog using ch7.4a, replace
tobit lwf age married children education, ll(0)
sjlog close, replace

sjlog using ch7.4b, replace
mfx compute, predict(pr(0,.))
sjlog close, replace

sjlog using ch7.4c, replace
mfx compute, predict(e(0,.))
sjlog close, replace

* note sign switch on children from tobit
* twostep: note children now insignif in wage eqn
sjlog using ch7.5, replace
heckman lw education age children, ///
select(age married children education) nolog
sjlog close, replace

sjlog using ch7.5a, replace
heckman lw education age children, ///
select(age married children education) twostep
sjlog close, replace

* NOT USED
sjlog using ch7.6, replace
* better example--also of incid. truncation?
use school, clear
* biprobit private vote years logptax loginc, partial difficult
heckprob private years logptax, select(vote = years loginc logptax) ///
robust nolog
sjlog close, replace

set more on
