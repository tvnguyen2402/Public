
********************************************************
*** Final Project 									 *** 
*** Tai Nguyen - May  2021 						 	 *** 
*** Econ 0355: Empirical Methods in Macroeconomics 	 *** 
********************************************************

clear
cap log close               
set more off

global rawdata	"/Users/tvnguyen/Desktop/Research2021/HHConsumption/RAWDATA"
global mainpath "/Users/tvnguyen/Desktop/Research2021/HHConsumption"

capture mkdir 		"$mainpath/DATAIN"
global datain 		"$mainpath/DATAIN"

capture mkdir 		"$mainpath/DATAOUT"
global dataout 		"$mainpath/DATAOUT"

capture mkdir 		"$mainpath/OUTPUT"
global output 		"$mainpath/OUTPUT"


**********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 1990 - 1993 *
**********************************************************************************
	
forvalues k=90(1)93{
	forvalues j=1(1)4 {
		use $rawdata/fmli`k'`j'.dta, clear
		*destring inc_rank, gen(inc_rank1)
		*destring fam_size, gen(fam_size1)
	
		xtile income_quintile = inc_rank, nq(5) 

		global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli`k'`j'.dta, replace
	}
}

**********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 1994 - 1995 *
**********************************************************************************
	
forvalues k=94(1)95{
	forvalues j=1(1)4 {
		use $rawdata/fmli`k'`j'.dta, clear
		destring inc_rank, gen(inc_rank1)
		destring inc_hrs1, gen(inc_hrs1_)
		destring fam_size, gen(fam_size1)
	
		xtile income_quintile = inc_rank1, nq(5) 

		global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size1
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1_)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli`k'`j'.dta, replace
	}
}

**********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 1996 - 1999 *
**********************************************************************************
	
forvalues k=96(1)99{
	forvalues j=1(1)4 {
		use $rawdata/fmli`k'`j'.dta, clear
		
		xtile income_quintile = inc_rank, nq(5) 

		global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli`k'`j'.dta, replace
	}
}

***********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 2000 - 2003  *
***********************************************************************************

forvalues k=0(1)3 {
	forvalues j=1(1)4 {
		use $rawdata/fmli0`k'`j'.dta, clear
		*destring inc_rank, gen(inc_rank1)
		*destring fam_size, gen(fam_size1)
	
		xtile income_quintile = inc_rank, nq(5) 

		global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli0`k'`j'.dta, replace
	}
}

***********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 2004 - 2007  *
***********************************************************************************

forvalues k=4(1)7 {
	forvalues j=1(1)4 {
		use $rawdata/fmli0`k'`j'.dta, clear
		*destring inc_rank, gen(inc_rank1)
		*destring fam_size, gen(fam_size1)
	
		xtile income_quintile = inc_rnkm, nq(5) 

		global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli0`k'`j'.dta, replace
	}
}

********************************************************************************
*Aggregating Micro Data into Pseudo Panels based on Income Rank for 1984 - 1989*
********************************************************************************

forvalues k=84(1)89{
	forvalues j=1(1)4{
		use $rawdata/fmli`k'`j'.dta, clear
	*destring inc_rank, gen(inc_rank1)
	*destring fam_size, gen(fam_size1)
	
	xtile income_quintile = inc_rank, nq(5) 

	rename (zfoodtot zalcbevs zutilsps zhouseop zgasmoto zpubtran zentrmnt zpercare ztobacco zmiscels) (foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq)

	global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

		sum $nondurables
		
		tokenize $nondurables 
		
		forvalues i=1/10 {
			bysort income_quintile: replace ``i'' = ``i''/fam_size
			bysort income_quintile: egen ``i''_avg = mean(``i'')
		}

		bysort income_quintile: egen work_hrs = mean(inc_hrs1)

		bysort income_quintile: gen id=_n
		keep if id ==1

		*Total Expenditures on Non-durables*
		gen tot_consumption = foodcq_avg + alcbevcq_avg + utilcq_avg + housopcq_avg + gasmocq_avg + pubtracq_avg + entertcq_avg + perscacq_avg + tobacccq_avg + misccq_avg

		global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

		keep income_quintile $nondurables_avg tot_consumption work_hrs
*save the file*

		save $dataout/fmli`k'`j'.dta, replace
	}
}


*************
* Add Years *
*************

***************
* 2000 - 2007 *
***************

forvalues j=0(1)7{
	forvalues i=1(1)4{
		use $dataout/fmli0`j'`i'.dta 
		gen year = 200`j' 
		gen quarter = `i'
		save $dataout/fmli0`j'`i'.dta, replace
	}
}

***************
* 1984 - 1999 *
***************

forvalues j=84(1)99{
	forvalues i=1(1)4{
		use $dataout/fmli`j'`i'.dta
		gen year = 19`j'
		gen quarter = `i'	
		save $dataout/fmli`j'`i'.dta, replace
	}
	
}

********************************
* Appending data sets together *
********************************

clear *
cd $dataout
! ls fmli*.dta > filelist.txt

file open myfile using filelist.txt, read
file read myfile file

file read myfile line
use `line'

file read myfile line
while r(eof)==0 { 
	append using `line'
	file read myfile line
}

file close myfile
save $dataout/master_file.dta, replace

*append 2000q1*
use $dataout/master_file.dta, clear

append using $dataout/fmli001.dta

save $dataout/master_file.dta, replace

************************************************************
* Create date and drop household does not have income rank *
************************************************************

use $dataout/master_file.dta, clear

gen yq = yq(year, quarter)
format yq %tq

drop if income_quintile ==.

sort income_quintile yq
order income_quintile yq

save $dataout/master_file.dta, replace

*****************************
* Import Tax Policy Shocks	*
*****************************

import delimited $rawdata/policyshocks.csv, clear

gen yq = quarterly(date, "YQ")

format yq %tq

save $dataout/policyshocks.dta, replace

*****************************************
* Import Federal Spending Policy Shocks	*
*****************************************

import delimited $rawdata/policyshocks2.csv, clear

gen yq = quarterly(date, "YQ")

format yq %tq
tsset yq

gen romershock = romer2010_exo*100
gen romershock1 = L.romershock

gen fdlrfed1 = log(spf_rfed1/spf_rfed0)

* FORECAST ERRORS;

gen spfrfedshock1 = log(rfed/L.rfed) - L.fdlrfed1
gen spfshock 	  = spfrfedshock1*100
gen spfshock1 	  = L.spfshock

gen dlrfed1 = log(rfed/L1.rfed)
gen dlrfed4 = log(rfed/L4.rfed)

save $dataout/policyshocks.dta, replace


********************************************************
* Merge Household Consumer Spending with Policy Shocks *
********************************************************

use $dataout/master_file.dta, clear
merge m:1 yq using $dataout/policyshocks.dta
drop if year < 1990

*adjusting for seasonality - consumption*

*ssc inst egenmore 
xtset income_quintile yq

egen tot_consumption_ma = filter(tot_consumption), coef(0.5 1 1 1 0.5) lags(-2/2) normalise 
bysort income_quintile yq: gen season_fctr = tot_consumption/tot_consumption_ma
gen adj_tot_consumption = tot_consumption/season_fctr

*generate a real consumer spending series*
gen rtot_consumption = adj_tot_consumption*100/210.48967 

*take the log for seasonally adjusted variables*

gen ln_tot_consumption = log(rtot_consumption)

*tin(1991q,2007q1)*

egen work_hrs_ma = filter(work_hrs), coef(0.5 1 1 1 0.5) lags(-2/2) normalise 
bysort income_quintile yq: gen season_fctr1 = work_hrs/work_hrs_ma
gen adj_work_hrs = work_hrs/season_fctr1

gen ln_work_hrs = log(adj_work_hrs)
gen ln_rgdp = log(rpgdp)
gen ln_rfed  = log(rpfed)

*------------------------------------------------------------------------------

*adjusting for seasonality - food*
xtset income_quintile yq

egen food_avg_ma = filter(foodcq_avg), coef(0.5 1 1 1 0.5) lags(-2/2) normalise 
bysort income_quintile yq: gen season_fctr_food = foodcq_avg/food_avg_ma
gen adj_food = foodcq_avg/season_fctr_food

*generate a real consumer spending series*
gen rfood = adj_food*100/210.48967 

*take the log for seasonally adjusted variables*

gen ln_food = log(adj_food)


*---------------------------------------------------
forvalues i=1/5{
	preserve 
	keep if income_quintile == `i'
	save $dataout/`i'_quintile.dta, replace
	restore
}

*---------------------------------------------------

twoway (line ln_tot_consumption yq if income_quintile == 1 & tin(1990q4,2007q4) , legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line ln_tot_consumption yq if income_quintile == 2 & tin(1990q4,2007q4), legend(label(2 "Second Quintile")) lwidth(medthick)) (line ln_tot_consumption yq if income_quintile == 3 & tin(1990q4,2007q4), legend(label(3 "Third Quintile")) lwidth(medthick)) (line ln_tot_consumption yq if income_quintile == 4 & tin(1990q4,2007q4), legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line ln_tot_consumption yq if income_quintile == 5 & tin(1990q4,2007q4), legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Household Consumption, margin(0 2.5 2.5 0)) title(Households Consumption - Seasonally Adjusted) subtitle(Data from the Consumer Expenditure Surveys) name(consumption_ma, replace)

twoway (line ln_work_hrs yq if income_quintile == 1, legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line ln_work_hrs yq if income_quintile == 2, legend(label(2 "Second Quintile")) lwidth(medthick)) (line ln_work_hrs yq if income_quintile == 3, legend(label(3 "Third Quintile")) lwidth(medthick)) (line ln_work_hrs yq if income_quintile == 4, legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line ln_work_hrs yq if income_quintile == 5, legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Work Hours, margin(0 2.5 2.5 0)) title(Households Work Hours - Seasonally Adjusted) subtitle(Data from the Consumer Expenditure Surveys) name(workhours_ma, replace)

*****************************************************************************************
** First-Stage: test if the federal spending shock series predict real actual spending **
*****************************************************************************************

/*reg D.lrdef L(1/4).lrdef L(1/4).lrgdp L(1/4).tb3 L(1/4).amtbr pdvmily L(1/4).pdvmily*/

reg D.ln_rfed L(1/4).ln_rfed L(1/4).ln_rgdp spfshock1 L(1/4).spfshock1

*Marginal F-test on current and four lags of news variable to see if strong instrument 
test spfshock1=L.spfshock1=L2.spfshock1=L3.spfshock1=L4.spfshock1=0


**********************************************************
** Effects of Government Spending Shocks on Consumption **
**********************************************************

set scheme s2mono
*---------------------------------------------------
use $dataout/1_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create first_cons_fed, step(20) bs rep(500) set(first_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename first_consumption_fed, replace

*---------------------------------------------------
/*use $dataout/1_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_food, exog(t t2) lags(1/4) 
varirf create first_cons_fed, step(20) bs rep(500) set(first_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_food ln_rfed) std
irf graph oirf, impulse(spfshock1) response(ln_food) level(68) byopts(rescale) 
graph rename first_food_fed, replace*/

*---------------------------------------------------
use $dataout/2_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create second_cons_fed, step(20) bs rep(500) set(second_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename second_consumption_fed, replace

*---------------------------------------------------
use $dataout/3_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create third_cons_fed, step(20) bs rep(500) set(third_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename third_consumption_fed, replace

*---------------------------------------------------
use $dataout/4_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create fourth_cons_fed, step(20) bs rep(500) set(fourth_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename fourth_consumption_fed, replace

*---------------------------------------------------
use $dataout/5_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create fifth_cons_fed, step(20) bs rep(500) set(fifth_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68)
graph rename fifth_consumption_fed, replace

**********************************************************
** Effects of Government Spending Shocks on Work Hours **
**********************************************************

*---------------------------------------------------
use $dataout/1_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_work_hrs, lags(1/4) 
varirf create first_hrs_fed, step(20) bs rep(500) set(first_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_work_hrs) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename first_consumption_fed, replace

*---------------------------------------------------
use $dataout/2_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create second_cons_fed, step(20) bs rep(500) set(second_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename second_consumption_fed, replace

*---------------------------------------------------
use $dataout/3_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create third_cons_fed, step(20) bs rep(500) set(third_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename third_consumption_fed, replace

*---------------------------------------------------
use $dataout/4_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create fourth_cons_fed, step(20) bs rep(500) set(fourth_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68) byopts(rescale) 
graph rename fourth_consumption_fed, replace

*---------------------------------------------------
use $dataout/5_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var spfshock1 ln_rfed ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4) 
varirf create fifth_cons_fed, step(20) bs rep(500) set(fifth_cons_fed, replace)
varirf table oirf, impulse(spfshock1) response(ln_tot_consumption) std
irf graph oirf, impulse(spfshock1) response(ln_tot_consumption) level(68)
graph rename fifth_consumption_fed, replace

*******************************************************************************
** Effects of Government Tax Policy Shocks on Household Consumer Expenditure **
*******************************************************************************

*---------------------------------------------------
use $dataout/1_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var romershock1 amtbr ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4)  
varirf create first_cons, step(20) bs rep(500) set(first_cons, replace)
varirf table oirf, impulse(romershock1) response(ln_tot_consumption) std
irf graph oirf, impulse(romershock1) response(ln_tot_consumption) level(68)
graph rename first_consumption, replace


*---------------------------------------------------
use $dataout/2_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var romershock1 amtbr ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4)  
varirf create second_cons, step(20) bs rep(500) set(second_cons, replace)
varirf table oirf, impulse(romershock1) response(ln_tot_consumption) std
irf graph oirf, impulse(romershock1) response(ln_tot_consumption) level(68)
graph rename second_consumption_romer, replace

*----------------------------------------------------
use $dataout/3_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

var romershock1 amtbr ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4)  
varirf create third_cons, step(20) bs rep(500) set(third_cons, replace)
varirf table oirf, impulse(romershock1) response(ln_tot_consumption) std
irf graph oirf, impulse(romershock1) response(ln_tot_consumption) level(68)
graph rename third_consumption_romer, replace

*------------------------------------------------------
use $dataout/4_quintile.dta , clear

gen t = _n
gen t2 = t^2 

keep if tin(1991q1,2007q4)

var romershock1 amtbr ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4)  
varirf create fourth_cons, step(20) bs rep(500) set(fourth_cons, replace)
varirf table oirf, impulse(romershock1) response(ln_tot_consumption) std
irf graph oirf, impulse(romershock1) response(ln_tot_consumption) level(68)
graph rename fourth_consumption_romer, replace

*---------------------------------------------------
use $dataout/5_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_tot_consumption, exog(t t2) lags(1/4)  
varirf create fifth_cons, step(20) bs rep(500) set(fifth_cons, replace)
varirf table oirf, impulse(romershock1) response(ln_tot_consumption) std
irf graph oirf, impulse(romershock1) response(ln_tot_consumption) level(68)
graph rename fifth_consumption_romer

**********************************************************
** Effects of Tax Polic Shocks on Work Hours            **
**********************************************************

*-------------------------------------------------------------------------------*
use $dataout/1_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_work_hrs, exog(t t2) lags(1/4)  
varirf create first_hrs, step(20) bs rep(500) set(first_hrs, replace)
varirf table oirf, impulse(romershock1) response(ln_work_hrs) std
irf graph oirf, impulse(romershock1) response(ln_work_hrs) level(68)
graph rename first_hrs_romer, replace

*-------------------------------------------------------------------------------*

use $dataout/2_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_work_hrs, exog(t t2) lags(1/4)  
varirf create second_hrs, step(20) bs rep(500) set(second_hrs, replace)
varirf table oirf, impulse(romershock1) response(ln_work_hrs) std
irf graph oirf, impulse(romershock1) response(ln_work_hrs) level(68)
graph rename second_hrs_romer, replace

*-------------------------------------------------------------------------------*

use $dataout/3_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_work_hrs, exog(t t2) lags(1/4)  
varirf create third_hrs, step(20) bs rep(500) set(third_hrs, replace)
varirf table oirf, impulse(romershock1) response(ln_work_hrs) std
irf graph oirf, impulse(romershock1) response(ln_work_hrs) level(68)
graph rename third_hrs_romer, replace

*-------------------------------------------------------------------------------*

use $dataout/4_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_work_hrs, exog(t t2) lags(1/4)  
varirf create fourth_hrs, step(20) bs rep(500) set(fourth_hrs, replace)
varirf table oirf, impulse(romershock1) response(ln_work_hrs) std
irf graph oirf, impulse(romershock1) response(ln_work_hrs) level(68)
graph rename fourth_hrs_romer, replace

*-------------------------------------------------------------------------------*

use $dataout/5_quintile.dta , clear

gen t = _n
gen t2 = t^2

keep if tin(1991q1,2007q4)

tsset yq

var romershock1 amtbr ln_rgdp ln_work_hrs, exog(t t2) lags(1/4)  
varirf create fifth_hrs, step(20) bs rep(500) set(fifth_hrs, replace)
varirf table oirf, impulse(romershock1) response(ln_work_hrs) std
irf graph oirf, impulse(romershock1) response(ln_work_hrs) level(68)
graph rename fifth_hrs_romer, replace
