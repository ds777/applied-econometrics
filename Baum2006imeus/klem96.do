infix year 5-8 ind 9-20 v3 21-34 v4 35-48 v5 49-62 v6 63-78 using 35klem96.dat, clear
bys ind: g chunk = int((_n-1)/39) +1
tab chunk
reshape wide v*, i(year ind) j(chunk)
rename v31 q
rename v41 po
rename v51 pi
drop v61
rename v32 vk
rename v42 pk
rename v52 vl
rename v62 pl
rename v33 ve
rename v43 pe
rename v53 vm
rename v63 pm
g vt = q*pi - vk - vl - ve - vm
g qk = vk/po
g ql = vl/po
g qe = ve/po
g qm = vm/po
label data "35KLEM: Jorgensen industry sector data"
label var q "quantity of output"
label var po "price of output that producers receive"
label var pi "price of output that consumers pay"
label var vk "value of capital services"
label var pk "price of capital services"
label var vl "value of labor inputs"
label var pl "price of labor inputs"
label var ve "value of energy inputs"
label var pe "price of energy inputs"
label var vm "value of material inputs"
label var pm "price of material inputs"
label var vt "value of taxes paid"
label var qk "capital services, output price deflator"
label var ql "labor inputs, output price deflator"
label var qe "energy inputs, output price deflator"
label var qm "energy inputs, output price deflator"
note: "Accessed from http://post.economics.harvard.edu/faculty/jorgenson/data/35klem.html"
format year %ty
tsset ind year
desc
summ
save 35klem,replace




