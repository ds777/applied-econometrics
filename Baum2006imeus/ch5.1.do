sjlog using ch5.1,replace
use NEdata, clear
mean dpipc, over(state)
sjlog close, replace

* list state pop dpi dpipc if year==2000, sep(6)
* tabstat dpipc, by(state)


sjlog using ch5.2,replace
anova dpipc state
sjlog close, replace

sjlog using ch5.2a,replace
anova, regress
sjlog close, replace

sjlog using ch5.3,replace
tabulate state, generate(NE)
regress dpipc NE2-NE6
sjlog close, replace

sjlog using ch5.4,replace
regress dpipc NE*, nocons
sjlog close, replace

sjlog using ch5.4a, replace
forvalues i=1/5 {
  generate NE_`i' = NE`i'-NE6
  }
regress dpipc NE_*
sjlog close, replace

sjlog using ch5.4b, replace
lincom -(NE_1+NE_2+NE_3+NE_4+NE_5)
sjlog close, replace
