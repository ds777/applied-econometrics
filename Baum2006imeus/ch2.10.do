set scheme sj

sjlog using ch2.10, replace
local states CT MA ME NH RI VT
use NEstates, clear
foreach s of local states {
	generate double dpipc`s' = dpi`s'/pop`s'
	label var dpipc`s' "dpipc"
	}
sjlog close, replace

sjlog using ch2.10a, replace
egen avgdpipc = rowmean(dpipc*)
label var avgdpipc "NE avg"
sjlog close, replace

sjlog using ch2.10b, replace
foreach s of local states {
	tsline dpipc`s' avgdpipc, nodraw ti("`s'") ///
	lpattern(solid dash) legend(size(vsmall)) name(`s',replace)
	}
graph combine `states', saving(mergegph, replace) ///
   ti("Disposable personal income per capita, New England states")
sjlog close, replace

graph export fig2_2.eps, replace
