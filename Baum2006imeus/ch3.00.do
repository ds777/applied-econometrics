set scheme sj
use hprice2a, clear
drop if price>=50000
set seed 20050909
sample 100, count
* replace rooms = round(rooms)
* label var rooms "Number of rooms"
label var stratio "Student--teacher ratio"
scatter price stratio, msize(vsmall) title(Average single-family house price) ///
|| lfit price stratio, legend(off) 
graph export fig3_0.eps, replace
