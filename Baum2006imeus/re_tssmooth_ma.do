log using tssmooth_test,replace
use ukrates, clear

egen double frs=filter(rs), l(1/4) c(0.4(0.1)0.1)
tssmooth ma double sm1=rs, weights(0.1(0.1)0.4 <0>)
g double discrep1 = frs-sm1
egen double frs2 = filter(rs), l(-2/2) c(1 4 6 4 1) n
tssmooth ma double sm2=rs, weights(1 4 <6> 4 1)
g double discrep2 = frs2-sm2
su
l rs frs sm1 frs2 sm2,sep(0)
log close
