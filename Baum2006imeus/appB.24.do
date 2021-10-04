mata: mata clear
capt program drop averageper

sjlog using appB.24, replace
* define the Mata averageper function
mata:
        void averageper(string scalar vname, real scalar per, string scalar touse)
        {
// define objects used in function        
        string scalar vnew 
        real scalar divisor 
        real scalar resindex
        real matrix v1
        real matrix v3
// construct the new variable name from original name and per
        vnew = vname + "A" + strofreal(per)
// access the Stata variable, honoring any if or in conditions
        v1=st_data(.,vname,touse)
// verify that per is appropriate
        if (per<=0 | per > rows(v1)) {
        	_error("per must be > 0 and < nobs.")
        	}
// verify that nobs is a multiple of per
        if (mod(rows(v1),per) ~= 0) {
        	_error("nobs must be a multiple of per.")
        	}
// reshape the column vector into nobs/per rows and per columns
// postmultiply by a per-element row vector with values 1/per 
        divisor = 1/per
        v3 = colshape(v1',per) * J(per,1,divisor)
// add the new variable to the current Stata data set
        resindex = st_addvar("float",vnew)
// store the calculated values in the new Stata variable
        st_store((1,rows(v3)),resindex,v3)
        }
end
sjlog close, replace

sjlog using appB.24a, replace
// save the compiled averageper function 
mata: mata mosave averageper(), replace
sjlog close, replace

sjlog using appB.25, replace
* define the Stata averageper wrapper command
*! averageper 1.0.0  05aug2005 CFBaum
program averageper, rclass
	version 9
	syntax varlist(max=1 numeric) [if] [in], per(integer)
// honor if and in conditions if provided
	marksample touse
// pass the variable name, per, and touse to the Mata function 
	mata: averageper("`varlist'",`per',"`touse'")
end
sjlog close, replace
sjlog using appB.26, replace
use urates, clear
tsset
describe tenn
averageper tenn, per(3)  // calculate quarterly averages
averageper tenn, per(12) // calculate annual averages
summarize tenn*
sjlog close, replace

sjlog using appB.27, replace
tsmktim quarter, start(1978q1) // create quarterly calendar var
tsmktim year, start(1978)      // create annual calendar var
list t tenn quarter tennA3 year tennA12 in 1/12, sep(3)
sjlog close, replace

/*
tsset t
drop quarter
sjlog using appB.28, replace
averageper missouri if tin(1989m4,1994m6), per(3)
tsmktim quarter, start(1989q2)
l quarter missouriA3 if missouriA3<.
*/

use urates, clear
sjlog using appB.28, replace
foreach v of varlist tenn-arkansas {
	averageper `v', per(3)
}
summarize illinois*
sjlog close, replace
