infile YEAR  QY      PY      QK      PK      QL      PL      QE      PE      QM using berndtWood1, clear
sort YEAR 
save bw1,replace
infile YEAR    PM       QV       PV       Z1      Z2      Z3       Z4      Z5 using berndtWood2, clear
sort YEAR 
save bw2,replace
infile YEAR   Z6       Z7      Z8      Z9     Z10 using berndtWood3, clear
sort YEAR
save bw3,replace
use bw1
merge YEAR using bw2 bw3
drop _merge*
label var  QY  "Quantity of Gross Output"
label var  PY  "Price Index of Gross Output"
label var  QK  "Quantity of Capital Services"
label var  PK  "Rental Price Index for Capital Services"
label var  QL  "Quantity of Labor Input"
label var  PL  "Price Index for Labor Input"
label var  QE  "Quantity of Aggregate Energy Input"
label var  PE  "Price Index for Aggregate Energy Input"
label var  QM  "Quantity of Non-Energy Intermediate Materials"
label var  PM  "Price Index for Non-Energy Intermediate Materials"
label var  QV  "Quantity of Value-Added Output"
label var  PV  "Price Index of Value-Added Output"
label var  Z1  "US Population"
label var  Z2  "US Population of Working Age"
label var  Z3  "Effective Rate of Sales and Excise Taxation"
label var  Z4  "Effective Rate of Property Taxation"
label var  Z5  "Government Purchases of Durable Goods"
label var  Z6  "Government Purchases of Non-Durable Goods and Services"
label var  Z7  "Government Purchases of Labor Services"
label var  Z8  "Real Exports of Durable Goods"
label var  Z9  "Real Exports of Non-Durable Goods and Services"
label var  Z10 "US Tangible Capital Stock at the End of the Previous Year"
label data "from Berndt, Ernst R. and David O. Wood [1975],Rev. of Ec. & Stat."
format YEAR %ty
tsset YEAR
desc
summ
save berndtWood,replace

