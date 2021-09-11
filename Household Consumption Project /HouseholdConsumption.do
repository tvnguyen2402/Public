
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

***********************************************************************************
* Aggregating Micro Data into Pseudo Panels based on Income Rank for 2000 - 2007  *
***********************************************************************************

forvalues k=0(1)3{
forvalues j=1(1)4{
	use $rawdata/fmli0`k'`j'.dta, clear
	*destring inc_rank, gen(inc_rank1)
	*destring fam_size, gen(fam_size1)
	
xtile income_quintile = inc_rank, nq(5) 

global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

sum $nondurables

foreach i of global nondurables{
	gen `i'_avg = `i'/fam_size
}

global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

foreach i of global nondurables_avg {
	bysort income_quintile: egen `i'_ir= mean(`i')
}

bysort income_quintile: egen work_hrs = mean(inc_hrs1)

bysort income_quintile: gen id=_n
keep if id ==1

*Total Expenditures on Non-durables*
gen tot_consumption = foodcq_avg_ir + alcbevcq_avg_ir + utilcq_avg_ir + housopcq_avg_ir + gasmocq_avg_ir + pubtracq_avg_ir + entertcq_avg_ir + perscacq_avg_ir + tobacccq_avg_ir + misccq_avg_ir

global nondurables_avg_ir foodcq_avg_ir alcbevcq_avg_ir utilcq_avg_ir housopcq_avg_ir gasmocq_avg_ir pubtracq_avg_ir entertcq_avg_ir perscacq_avg_ir tobacccq_avg_ir misccq_avg_ir 

keep income_quintile $nondurables_avg_ir tot_consumption work_hrs
*save the file*

save $dataout/fmli0`k'`j'.dta, replace
}
}




*Aggregating Micro Data into Pseudo Panels based on Income Rank for 1990 - 1999*
forvalues k=90(1)93{
forvalues j=1(1)4{
	use fmli`k'`j', clear
	*destring inc_rank, gen(inc_rank1)
	*destring fam_size, gen(fam_size1)
	
xtile income_quintile = inc_rank, nq(5) 

global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

sum $nondurables

foreach i of global nondurables{
	gen `i'_avg = `i'/fam_size
}

global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

foreach i of global nondurables_avg {
	bysort income_quintile: egen `i'_ir= mean(`i')
}

*destring inc_hrs1, gen(inc_hrs)
bysort income_quintile: egen work_hrs = mean(inc_hrs1)

bysort income_quintile: gen id=_n
keep if id ==1

*Total Expenditures on Non-durables*
gen tot_consumption = foodcq_avg_ir + alcbevcq_avg_ir + utilcq_avg_ir + housopcq_avg_ir + gasmocq_avg_ir + pubtracq_avg_ir + entertcq_avg_ir + perscacq_avg_ir + tobacccq_avg_ir + misccq_avg_ir

global nondurables_avg_ir foodcq_avg_ir alcbevcq_avg_ir utilcq_avg_ir housopcq_avg_ir gasmocq_avg_ir pubtracq_avg_ir entertcq_avg_ir perscacq_avg_ir tobacccq_avg_ir misccq_avg_ir 

keep income_quintile $nondurables_avg_ir tot_consumption work_hrs
*save the file*

*cd "$CLEAN"
save, replace
}
}


*_____________________________________________________________________________________________*
*Aggregating Micro Data into Pseudo Panels based on Income Rank for 1984 - 1989*
forvalues k=4(1)9{
forvalues j=1(1)4{
	use fmli8`k'`j', clear
	*destring inc_rank, gen(inc_rank1)
	*destring fam_size, gen(fam_size1)
	
xtile income_quintile = inc_rank, nq(5) 

rename (zfoodtot zalcbevs zutilsps zhouseop zgasmoto zpubtran zentrmnt zpercare ztobacco zmiscels) (foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq)

global nondurables foodcq alcbevcq utilcq housopcq gasmocq pubtracq entertcq perscacq tobacccq misccq 

sum $nondurables

foreach i of global nondurables{
	gen `i'_avg = `i'/fam_size
}

global nondurables_avg foodcq_avg alcbevcq_avg utilcq_avg housopcq_avg gasmocq_avg pubtracq_avg entertcq_avg perscacq_avg tobacccq_avg misccq_avg 

foreach i of global nondurables_avg {
	bysort income_quintile: egen `i'_ir= mean(`i')
}

bysort income_quintile: egen work_hrs = mean(inc_hrs1)

bysort income_quintile: gen id=_n
keep if id ==1

*Total Expenditures on Non-durables*
gen tot_consumption = foodcq_avg_ir + alcbevcq_avg_ir + utilcq_avg_ir + housopcq_avg_ir + gasmocq_avg_ir + pubtracq_avg_ir + entertcq_avg_ir + perscacq_avg_ir + tobacccq_avg_ir + misccq_avg_ir

global nondurables_avg_ir foodcq_avg_ir alcbevcq_avg_ir utilcq_avg_ir housopcq_avg_ir gasmocq_avg_ir pubtracq_avg_ir entertcq_avg_ir perscacq_avg_ir tobacccq_avg_ir misccq_avg_ir 

keep income_quintile $nondurables_avg_ir tot_consumption work_hrs
*save the file*

*cd "$CLEAN"
save, replace
}
}

*-----------------------------
*Add Years*
*2000 - 2007*
cd "$DATA"
forvalues j=0(1)7{
	forvalues i=1(1)4{
		use fmli0`j'`i'
		gen year = 200`j' 
		gen quarter = `i'
		save, replace
	}
}

*1984 - 1999*
cd "$DATA"
forvalues j=84(1)99{
	forvalues i=1(1)4{
		use fmli`j'`i'
		gen year = 19`j'
		gen quarter = `i'	
		save, replace
	}
	
}
*-----------------------------
*Appeding data sets together

cd "$DATA"
! ls *.dta >filelist.txt

file open myfile3 using "filelist.txt", read
file read myfile3 file

file read myfile3 line
use `line'
save master_data, replace

file read myfile3 line
while r(eof)==0 { 
	append using `line'
	file read myfile3 line
}

file close myfile3
save master_data, replace

*append 2000q1*
use master_data
append using "fmli001.dta"

save master_data, replace

*--------------------------------
drop if income_quintile ==.

sort income_quintile year quarter

save master_data, replace
*-------------------------------

clear
cd "$DATA"
import delimited main2.csv

gen date2 = quarterly(date, "YQ")

format date2 %tq

xtset income_quintile date2

drop if income_quintile == .

save household_data, replace

*------------------------------
clear
cd "$DATA"
import delimited policyshocks.csv

gen date2 = quarterly(date, "YQ")

format date2 %tq

*adjusting for seasonality*

*Moving average*

ssc inst egenmore 
xtset income_quintile date2

egen tot_consumption_ma = filter(tot_consumption), coef(1 1 1 1) lags(0/3) normalise 
gen rtot_consumption_ma = tot_consumption*100/210.48967 

cd "$DATA"
save policyshocks_data, replace
*-----------------------------
use household_data.dta, clear
merge 1:1 income_quintile date2 using "policyshocks_data.dta"

egen work_hrs_ma = filter(work_hrs), coef(1 1 1 1) lags(0/3) normalise
*-------------------------------

*take the log for ma variables*

gen ln_tot_consumption_ma = log(rtot_consumption_ma)

*tin(1991q,2007q1)*

gen ln_work_hrs_ma = log(work_hrs_ma)
gen ln_rgdp = log(rgdp)

*---------------------------------------------------

twoway (line rtot_consumption date2 if income_quintile == 1 & year > 1989, legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line rtot_consumption date2 if income_quintile == 2 & year > 1989, legend(label(2 "Second Quintile")) lwidth(medthick)) (line rtot_consumption date2 if income_quintile == 3 & year > 1989, legend(label(3 "Third Quintile")) lwidth(medthick)) (line rtot_consumption date2 if income_quintile == 4 & year > 1989, legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line rtot_consumption date2 if income_quintile == 5 & year > 1989, legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Work Hours, margin(0 2.5 2.5 0)) title(Households Consumption) subtitle(Data from the Consumer Expenditure Surveys) name(consumption, replace)

twoway (line work_hrs date2 if income_quintile == 1, legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line work_hrs date2 if income_quintile == 2, legend(label(2 "Second Quintile")) lwidth(medthick)) (line work_hrs date2 if income_quintile == 3, legend(label(3 "Third Quintile")) lwidth(medthick)) (line work_hrs date2 if income_quintile == 4, legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line work_hrs date2 if income_quintile == 5, legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Household Consumption, margin(0 2.5 2.5 0)) title(Households Work Hours) subtitle(Data from the Consumer Expenditure Surveys) name(workhours, replace)


twoway (line tot_consumption_ma date2 if income_quintile == 1 & tin(1990q4,2007q4) , legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line tot_consumption_ma date2 if income_quintile == 2 & tin(1990q4,2007q4), legend(label(2 "Second Quintile")) lwidth(medthick)) (line tot_consumption_ma date2 if income_quintile == 3 & tin(1990q4,2007q4), legend(label(3 "Third Quintile")) lwidth(medthick)) (line tot_consumption_ma date2 if income_quintile == 4 & tin(1990q4,2007q4), legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line tot_consumption_ma date2 if income_quintile == 5 & tin(1990q4,2007q4), legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Household Consumption, margin(0 2.5 2.5 0)) title(Households Consumption - Four-Quarter Moving Average) subtitle(Data from the Consumer Expenditure Surveys) name(consumption_ma, replace)

twoway (line work_hrs_ma date2 if income_quintile == 1, legend(label(1 "Lowest Quintile")) lwidth(medthick)) (line work_hrs_ma date2 if income_quintile == 2, legend(label(2 "Second Quintile")) lwidth(medthick)) (line work_hrs_ma date2 if income_quintile == 3, legend(label(3 "Third Quintile")) lwidth(medthick)) (line work_hrs_ma date2 if income_quintile == 4, legend(label(4 "Fourth Quintile")) lwidth(medthick)) (line work_hrs_ma date2 if income_quintile == 5, legend(label(5 "Top Quintile")) lwidth(medthick)), xtitle(Time,  margin(0 10 2.5 0)) ytitle(Work Hours, margin(0 2.5 2.5 0)) title(Households Work Hours - Four-Quarter Moving Average) subtitle(Data from the Consumer Expenditure Surveys) name(workhours_ma, replace)


cd "$DATA"
save first_quintile, replace
save second_quintile, replace
save third_quintile, replace
save fourth_quintile, replace
save fifth_quintile, replace

*---------------------------------------------------

cd "$DATA"
use second_quintile, clear
keep if income_quintile == 1

var rr2010_exo mtr ln_rgdp ln_work_hrs_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create first_hrs, step(20) bs rep(500) set(first_hrs, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_rgdp ln_work_hrs_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_work_hrs_ma) level(68)
graph rename first_hrs

*_____________________________________________________________________________________________*
keep if tin(1991q1,2007q4)

var rr2010_exo mtr ln_rgdp ln_tot_consumption_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create first_cons, step(20) bs rep(500) set(first_cons, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mln_tot_consumption_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) level(68)
graph rename first_consumption

*------
clear
cd "$DATA"
use second_quintile, clear
keep if income_quintile == 2

var rr2010_exo mtr ln_rgdp ln_work_hrs_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create second_hrs, step(20) bs rep(500) set(second_hrs, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_work_hrs_ma) std 

irf graph oirf, impulse(rr2010_exo) response(ln_work_hrs_ma) level(68)
graph rename second_hrs

*_____________________________________________________________________________________________*
keep if tin(1991q1,2007q4)

var rr2010_exo mtr ln_rgdp ln_tot_consumption_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create second_cons, step(20) bs rep(500) set(second_cons, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_tot_consumption_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_rgdp ln_tot_consumption_ma) level(68)
graph rename second_consumption

*------
clear
cd "$DATA"
use third_quintile, clear
keep if income_quintile == 3

var rr2010_exo mtr ln_rgdp ln_work_hrs_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create third_hrs, step(20) bs rep(500) set(third_hrs, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_work_hrs_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_work_hrs_ma) level(68)
graph rename third_hrs

*_____________________________________________________________________________________________*
keep if tin(1991q1,2007q4)

var rr2010_exo mtr ln_rgdp ln_tot_consumption_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create third_cons, step(20) bs rep(500) set(third_cons, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_tot_consumption_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) level(68)
graph rename third_consumption

*------
clear
cd "$DATA"
use fourth_quintile, clear
keep if income_quintile == 4

var rr2010_exo mtr ln_rgdp ln_work_hrs_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create fourth_hrs, step(20) bs rep(500) set(fourth_hrs, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(mtr ln_work_hrs_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_work_hrs_ma)
graph rename fourth_hrs

*_____________________________________________________________________________________________*
keep if tin(1991q1,2007q4)

var rr2010_exo mtr ln_rgdp ln_tot_consumption_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create fourth_cons, step(20) bs rep(500) set(fourth_cons, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) level(68) 
irf graph cirf, impulse(rr2010_exo) response(mtr ln_tot_consumption_ma) level(68) 

graph rename fourth_consumption1

*------
clear
cd "$DATA"
use fifth_quintile, clear
keep if income_quintile == 5

var rr2010_exo mtr ln_rgdp ln_work_hrs_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create fifth_hrs, step(20) bs rep(500) set(fifth_hrs, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(ln_work_hrs_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_work_hrs_ma) level(68)
graph rename fifth_hrs

*_____________________________________________________________________________________________*
keep if tin(1991q1,2007q4)

var rr2010_exo mtr ln_rgdp ln_tot_consumption_ma, lags(1/4) 

*Calculate impulse response functions (IRFs) 
*NOTE: This next line takes a while to run 
varirf create fifth_cons, step(20) bs rep(500) set(fifth_cons, replace)

*Create a table of the IRF when there is a shock to the news defense shock 
varirf table oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) std

irf graph oirf, impulse(rr2010_exo) response(ln_tot_consumption_ma) level(68)
graph rename fifth_consumption
