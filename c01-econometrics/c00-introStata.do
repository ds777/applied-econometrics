/*----------- Initial set up -----------*/
*cd
log using "../results/c00-introStata.txt", text replace

clear all
macro drop _all
set more off

/*=============================================>>>>>
= PROGRAM: Introduction to stata =
===============================================>>>>>*

Outline:
	Importing data
	Exploring data
	Editing data
	Exporting regression output
	Creating log files

Data files:
	wage1.dta

Code source:
	This program is based on the code of Ani Katchova.

*=============================================<<<<<*/

/*=============================================>>>>>
= Define key parameters =
===============================================>>>>>*/
global programName c00-introStata


/*=============================================>>>>>
= Import data =
===============================================>>>>>*/
use "../data/wage1", clear

/*=============================================>>>>>
= Explore data =
===============================================>>>>>*/

/*----------- Describe data -----------*/
describe
describe wage educ exper

/*----------- List data -----------*/
list wage educ exper in 1/10

/*----------- Summary statistics -----------*/
summarize
summarize wage educ exper
summarize wage, detail

/*----------- Summary stastistics by group -----------*/
tabulate female
summarize wage if female==1
bysort female: summarize wage

/*=============================================>>>>>
= Edit data =
===============================================>>>>>*/

/*----------- Keep and drop variables -----------*/
keep wage educ exper tenure female south west
drop tenure
drop if wage<2

/*----------- Label variables -----------*/
label variable wage "hourly wage in dollars"
describe wage

/*----------- Generate new variables -----------*/
gen logwage = log(wage)
gen educsq = educ^2
gen southwest = south+west

/*=============================================>>>>>
= Estimate regression models =
===============================================>>>>>*/

/*----------- Install outreg2 package -----------*/
*ssc install outreg2

/*----------- Estimate a simple regression model -----------*/
reg wage educ

/*----------- Export results in table -----------*/
outreg2 using "../results/${programName}-regtable.xls", excel dec(4) ctitle(Model) label replace

/*----------- Estimate a multiple regression model -----------*/
reg wage educ exper

/*----------- Export results in table, append -----------*/
outreg2 using "../results/${programName}-regtable.xls", excel dec(4) ctitle(Model) label append

log close
