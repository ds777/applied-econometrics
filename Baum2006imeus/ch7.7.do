sjlog using ch7.7, replace
use hmda, clear
replace fanfred=. if deny
rename s6 loanamt
rename vr vacancy
rename mi med_income
rename s50 appr_value
rename s17 appl_income
replace appl_income = appl_income/1000
rename s46 debt_inc_r
summarize approve fanfred loanamt vacancy med_income appr_value ///
black appl_income debt_inc_r, sep(0)
sjlog close, replace

sjlog using ch7.7a, replace
heckprob fanfred loanamt vacancy med_income appr_value, ///
 sel(approve= black appl_income debt_inc_r) nolog
sjlog close, replace

