* Clean you environment
clear all
macro drop _all
set more off
cls
version 15

* Install modules
*ssc install YYY

* About the dataset: https://rdrr.io/cran/wooldridge/man/jtrain.html

* Describe and summarize dataset
use "../data/JTRAIN.dta", clear
*use "http://fmwww.bc.edu/ec-p/data/wooldridge/jtrain.dta", clear

describe
summarize

* Drop missing observations
drop if lscrap == .
*drop if tothrs  == .

describe fcode year lscrap tothrs d88 d89 grant grant_1
list fcode year lscrap tothrs d88 d89 grant grant_1 in 1/9
summarize fcode year lscrap tothrs d88 d89 grant grant_1

* Set panel data
xtset fcode year
xtdescribe
xtsum fcode year lscrap tothrs d88 d89 grant grant_1

* Pooled OLS estimator
reg lscrap tothrs d88 d89 grant grant_1

* Between estimator
xtreg lscrap tothrs d88 d89 grant grant_1, be

* First differences estimator
sort fcode year
gen dlscrap = d.lscrap
gen dtothrs = d.tothrs
gen dgrant  = d.grant

reg dlscrap dtothrs dgrant

* Fixed effects within estimator
xtreg lscrap tothrs d88 d89 grant grant_1, fe

* Predict and summarize individual effects a_i
predict ai, u
list fcode year lscrap ai in 1/9
summarize ai

* Dummy variables as fixed effects
sort fcode
reg lscrap tothrs d88 d89 grant grant_1 i.fcode
* i.fcode creates one dummy variable for each fcode

* R-squared for fixed effects estimator and dummy variables regression
xtreg lscrap tothrs d88 d89 grant grant_1, fe
  display e(mss)
  display e(rss)
  scalar rsquared0=e(mss)/(e(mss)+e(rss))
  display rsquared0

reg lscrap tothrs d88 d89 grant grant_1 i.fcode
  display e(mss)
  display e(rss)
  scalar rsquared=e(mss)/(e(mss)+e(rss))
  display rsquared

* Random effects estimator
xtreg lscrap tothrs d88 d89 grant grant_1, re

* The random effects parameter theta
xtreg lscrap tothrs d88 d89 grant grant_1, re theta

* Calculate the random effects parameter theta
scalar theta=1-sqrt(e(sigma_e)^2/(e(sigma_e)^2+3*e(sigma_u)^2))
display theta

* Hausman test for fixed versus random effects
* H0: FE coefficients are not significantly different from the RE coefficients

xtreg lscrap tothrs d88 d89 grant grant_1, fe
estimates store fixed

xtreg lscrap tothrs d88 d89 grant grant_1, re
estimates store random

hausman fixed random
* If the Hausman test statistic is significant, use FE estimator because it is consistent
* If the Hausman test statistic is insignificant, use RE estimator because it is efficient
