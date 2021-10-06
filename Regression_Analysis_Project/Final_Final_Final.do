
********************************************************
*** Final Project 									 *** 
*** Tai Nguyen -- December 2020 					 *** 
*** ECON 211 -- Professor Byker 					 *** 
********************************************************

clear
cap log close
set more off


cap log close
                   
set more off

global DATA "/Users/tvnguyen/Desktop/Regression Analysis/DATA"
global OUTPUT "/Users/tvnguyen/Desktop/Regression Analysis/OUTPUT"

cd "$DATA"
import excel data_updated.xlsx, sheet("Stata_data") case(lower) firstrow

encode date, gen(date1)
tsset date1

gen yq = yq(year, quarter) 
format yq %tq 

*******************************************************************
*Fitting a thrid degree polynomial to log of real personal income *
*******************************************************************

gen l_rpinc = log(rpinc)
gen t = _n
gen t2 = t^2
gen t3 = t^3

reg l_rpinc t t2 t3, r
predict fitted_l_rpinc


*******************************************************************
*Creating lags, first difference, difference over h time horizons *
*******************************************************************

*Generating time horizons for gdp*
forvalues i=1(1)20 {
	gen gdp_f`i'=F`i'.gdp
}

*Generating the first lag for GDP*
gen gdp_l1=L1.gdp

*Generating the first difference for gdp*
gen d_gdp= gdp - gdp_l1

*Generating the cummulative change for gdp over h time horizons*
forvalues i=1(1)20 {
	gen d`i'_gdp= gdp_f`i' - gdp_l1
}

*Scaled by fitted third degree polynomial of log real personal income*
gen d_gdp_scaled = d_gdp/fitted_l_rpinc

forvalues i=1(1)20 {
	gen d`i'_gdp_scaled= d`i'_gdp/fitted_l_rpinc
}

*Generating lags*
forvalues i=1(1)20 {
	gen l`i'_gdp_scaled= L`i'.gdp/fitted_l_rpinc
}

************************************************
*Repeat the same steps for government purchases*
************************************************

gen fgexpnd_l1=L1.fgexpnd
gen d_fgexpnd = fgexpnd - fgexpnd_l1

forvalues i=1(1)20 {
	gen fgexpnd_f`i'=F`i'.fgexpnd
}

forvalues i=1(1)20 {
	gen d`i'_fgexpnd= fgexpnd_f`i' - fgexpnd_l1
}

gen d_fgexpnd_scaled= d1_fgexpnd/fitted_l_rpinc

forvalues i=1(1)20{
	gen d`i'_fgexpnd_scaled= d`i'_fgexpnd/fitted_l_rpinc
}

forvalues i=1(1)20 {
	gen l`i'_fgexpnd_scaled= L`i'.fgexpnd/fitted_l_rpinc
}
****************************
* Lags of Control Variables*
****************************

*fed funds rate*
gen fedfunds_l1 = L1.fedfunds
gen d1_fedfunds_l1 = fedfunds - fedfunds_l1 

*Romer&Romer 2004 Monetary Shocks*
gen rr_monetary_l1= L1.rr_monetary

*Romer&Romer 2010 Tax Policy Shocks*
gen rr_endo_l1 =L1.rr_endo
gen rr_exo_l1=L1.rr_exo 

*lagged unemployment rate*
gen unrate_l1=L1.unrate


**********************************************************************
*Jorda Local Projections - OLS regressions with all control variables*
**********************************************************************
cd "$OUTPUT"

local controls "d1_fedfunds_l1 rr_monetary rr_monetary_l1 rr_exo rr_exo_l1 rr_endo rr_endo_l1 unrate_l1"

local lags "l1_gdp_scaled l2_gdp_scaled l3_gdp_scaled l4_gdp_scaled l1_fgexpnd_scaled l2_fgexpnd_scaled l3_fgexpnd_scaled l4_fgexpnd_scaled"

*current period*
reg d_gdp_scaled d_fgexpnd_scaled `controls' `lags', robust

outreg2 using control_final_essay, excel replace ctitle(h=0) keep(d_fgexpnd_scaled)

*time horizon h into the future*
forvalues i=1(1)20 {
reg d`i'_gdp_scaled `gdp_lags' d`i'_fgexpnd_scaled `controls', robust

outreg2 using control_final_essay, excel append ctitle(h=`i') keep(d`i'_fgexpnd_scaled)
}

************************************************************
*Jorda Local Projections - Instrumental Variable Regressions*
************************************************************

*generating 4 time horizons h for the expected defense spending time series*
forvalues i=1(1)4 {
	gen ramey_defense_ratio_l`i' = L`i'.ramey_defense_ratio
}


local controls "ramey_defense_ratio_l1 ramey_defense_ratio_l2 ramey_defense_ratio_l3 ramey_defense_ratio_l4 d1_fedfunds_l1 rr_monetary rr_monetary_l1 rr_exo rr_exo_l1 rr_endo rr_endo_l1 unrate_l1"

local lags "l1_gdp_scaled l2_gdp_scaled l3_gdp_scaled l4_gdp_scaled l1_fgexpnd_scaled l2_fgexpnd_scaled l3_fgexpnd_scaled l4_fgexpnd_scaled"

*First stage regression to test predicting power*

*current period*
reg d_fgexpnd_scaled ramey_defense_ratio `controls' `lags', robust
predict instrumented 

*time horizon h*
forvalues i=1(1)20 {
	reg d`i'_fgexpnd_scaled ramey_defense_ratio `controls' `lags', robust
	predict instrumented`i'
}

*------------------
* second stage*

cd "$OUTPUT"

local controls "ramey_defense_ratio_l1 ramey_defense_ratio_l2 ramey_defense_ratio_l3 ramey_defense_ratio_l4 d1_fedfunds_l1 rr_monetary rr_monetary_l1 rr_exo rr_exo_l1 rr_endo rr_endo_l1 unrate_l1"

local lags "l1_gdp_scaled l2_gdp_scaled l3_gdp_scaled l4_gdp_scaled  l1_fgexpnd_scaled l2_fgexpnd_scaled l3_fgexpnd_scaled l4_fgexpnd_scaled"

*Instrumenting the cumulative changes in government purchases with 3 lags of Ramey (2011) expected defense spending*
ivreg d_gdp_scaled (d_fgexpnd_scaled = ramey_defense_ratio `controls' `lags') `controls' `lags', robust

outreg2 using IV_final_essay, excel replace ctitle(h=0) keep(d_fgexpnd_scaled)

forvalues i=1(1)20 {
	ivreg d`i'_gdp_scaled (d`i'_fgexpnd_scaled = ramey_defense_ratio `controls' `lags') `controls' `lags', robust
	
	outreg2 using IV_final_essay, excel append ctitle(h=`i') keep(d`i'_fgexpnd_scaled)
}

