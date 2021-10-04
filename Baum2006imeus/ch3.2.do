use hprice2a, clear
sjlog using ch3.2,replace

quietly regress lprice lnox ldist rooms stratio
test lnox ldist
sjlog close, replace
