sjlog using ch3.19, replace
use hprice2a, clear
generate rooms2 = rooms^2
quietly regress lprice rooms   			// Fit model 1
estimates store model1     			// Store estimates as model1
quietly regress lprice rooms rooms2 ldist  	// Fit model 2
estimates store model2                 		// Store estimates as model2
quietly regress lprice ldist stratio lnox  	// Fit model 3
estimates store model3                 		// Store estimates as model3
quietly regress lprice lnox ldist rooms stratio // Fit model 4
estimates store model4                       	// Store estimates as model4
estimates table model1 model2 model3 model4, stat(r2_a rmse) ///
 b(%7.3g) se(%6.3g) p(%4.3f)
sjlog close, replace

sjlog using ch3.19a, replace
estimates table model4 model1 model3 model2, stat(r2_a rmse ll) ///
 b(%7.3g) star title("Models of median housing price")
sjlog close, replace

which estout
sjlog using ch3.19b, replace
estout model1 model2 model3 model4 using ch3.19b_est.tex, ///
style(tex) replace title("Models of median housing price")  ///
prehead(\\begin{table}[htbp]\\caption{{\sc @title}}\\centering\\medskip ///
\begin{tabular}{l*{@M}{r}}) ///
posthead("\hline") prefoot("\hline") ///
varlabels(rooms2 "rooms$^2$" _cons "constant") legend ///
stats(N F r2_a rmse, fmt(%6.0f %6.0f %8.3f %6.3f) ///
labels("N" "F" "$\bar{R}^2$" "RMS error")) /// 
cells(b(fmt(%8.3f)) se(par fmt(%6.3f))) ///
postfoot(\hline\end{tabular}\end{table}) notype
sjlog close, replace

/*
sjlog using ch3.20, replace
label define crlev 0 "v.low" 1 "low" 2 "medium" 3 "high" 4 "v.high"
egen crimelevel = cut(crime), group(5)
label values crimelevel crlev
tabstat price, stat(n mean p50) by(crimelevel) nototal save
return list
sjlog close, replace
*/

sjlog using ch3.21, replace
label define crlev 0 "v.low" 1 "low" 2 "medium" 3 "high" 4 "v.high"
egen crimelevel = cut(crime), group(5)
label values crimelevel crlev
statsmat price, stat(n mean p50) by(crimelevel) ///
 matrix(price_crime) format(%9.4g) ///
 ti("Housing price by quintile of crime")
sjlog close, replace


/*
outtable using ch3_21, mat(popg) format(%9.4g) ///
 caption("Population growth by region") replace
sjlog close, replace


sjlog using ch3.22, replace
mat accum V = popgrowth lexp gnppc safewater, noconstant dev
mat C = corr(V)
mat list C
outtable using ch3_22, mat(C) format(%7.3f) ///
  caption("Correlations (N=`r(N)')") nobox replace
sjlog close, replace
*/

sjlog using ch3.23, replace
makematrix pc, from(r(rho) r(N)) label cols(price) ///
title("Correlations with median housing price") listwise: ///
corr crime nox dist 
sjlog close, replace
