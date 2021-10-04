// MUST REVERT 6.3, 6.5, 6.6, 6.8a, 6.10 TO IVREG2 WHEN AVAILABLE
// SHOULD ALSO RUN 6.4a, 6.7, 6.9 WITH NEW OUTPUT FORMAT

sjlog using ch6.0,replace
use griliches, clear
summarize lw s expr tenure rns smsa iq med kww age mrt, sep(0)
sjlog close, replace

sjlog using ch6.1,replace
ivreg lw s expr tenure rns smsa _I* (iq=med kww age mrt), first
sjlog close, replace

sjlog using ch6.2, replace
overid
sjlog close, replace

sjlog using ch6.3,replace
ivreg2 lw s expr tenure rns smsa _I* (iq=med kww age mrt), gmm
sjlog close, replace

sjlog using ch6.4, replace
use phillips, clear
summarize cinf unem if cinf < .
sjlog close, replace

sjlog using ch6.4a, replace
ivreg2 cinf (unem = l(2/3).unem), bw(3) gmm robust
sjlog close, replace

use griliches, clear
sjlog using ch6.5, replace
ivreg2 lw s expr tenure rns smsa _I* (iq=med kww age mrt), /// 
gmm orthog(s)
sjlog close, replace

sjlog using ch6.6, replace
ivreg2 lw s expr tenure rns smsa _I* (iq=med kww age mrt), ///
gmm orthog(age mrt)
sjlog close, replace

sjlog using ch6.7, replace
ivreg2 lw s expr tenure rns smsa _I* (iq=med kww), gmm
sjlog close, replace

sjlog using ch6.8, replace
ivhettest, all
ivhettest, fitsq all
sjlog close, replace

sjlog using ch6.8a, replace
ivreg2 lw s expr tenure rns smsa _I* (iq = age mrt), ffirst redundant(mrt)
sjlog close, replace

sjlog using ch6.9, replace
quietly ivreg2 lw s expr tenure rns smsa _I* (iq=med kww), small
estimates store iv
quietly regress lw s expr tenure rns smsa _I* iq
hausman iv ., constant sigmamore
sjlog close, replace

sjlog using ch6.10, replace
ivreg2 lw s expr tenure rns smsa _I* iq (=med kww), orthog(iq) small
sjlog close, replace

sjlog using ch6.11, replace
quietly ivreg lw s expr tenure rns smsa _I* (iq=med kww)
ivendog
sjlog close, replace
