********************************************************
*** Final Project 									 *** 
*** Tai Nguyen -- August 2021 						 *** 
*** PREDOC Summer Course in Social Science Analytics *** 
********************************************************

clear
cap log close
set more off

global rawdata	"/Users/tvnguyen/Desktop/Predoc_Summercourse/RAWDATA/FinalProject"
global mainpath "/Users/tvnguyen/Desktop/Predoc_Summercourse/"

/*I already have DATAIN, DATAOUT, and OUPUT on my computer. You might need to create those folders*/

global datain "$mainpath/DATAIN"
capture mkdir "$datain/FinalProject"

global dataout "$mainpath/DATAOUT"
capture mkdir  "$dataout/FinalProject"

global output "$mainpath/OUTPUT"
capture mkdir "$output/FinalProject"


global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

*************************************
*** Graphs for Motivation Section ***			
*************************************

set scheme s2mono

/*-----------------------------------------------------------------------------*/

** Household Monthly Consumption by Income Tercile **

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	gen yrmonth = ym(year, month) 
	format yrmonth %tm 
	
	bysort hhinc3 year month: egen inc_mpur = sum(DOLLARS)
	bysort hhinc3 year month: gen id1 = _n
	bysort hhinc3 year month: egen number = max(id1)

	bysort hhinc3 year month: gen ave_mpur = inc_mpur/number
	drop if id1 != 1

	*** Adjust for Seasonality 	***

	*ssc inst egenmore 

	xtset hhinc3 yrmonth

	egen ave_mpur_ma = filter(ave_mpur), coef(0.5 1 1 1 1 1 1 1 1 1 1 1 0.5) lags(-6/6) normalise 
	bysort hhinc3 month: gen season_fctr = ave_mpur/ave_mpur_ma
	gen adj_ave_mpur = ave_mpur/season_fctr
	
	save $dataout/FinalProject/``i''hvfinc.dta, replace
	********************************

	** Figure 3 a,b,c **
	
	tw (scatter ave_mpur yrmonth if hhinc3 == 3, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) 																				  ///
	(fpfit ave_mpur yrmonth if hhinc3 == 3 , lcolor(green%80))					///
	(scatter ave_mpur yrmonth if hhinc3 == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) 																								///
	(fpfit ave_mpur yrmonth if hhinc3 == 2, lcolor(blue%80)) 									    ///
	(scatter ave_mpur yrmonth if hhinc3 == 1, msize(small) mcolor(red%30) msymbol(R)) 			///
	(fpfit ave_mpur yrmonth if hhinc3 == 1, lcolor(red%80)),										///
	ti("Household Monthly Average Expenditures by Income Tercile", size(medium)) 					///
	subtitle("2004 - 2012", size(medium)) legend( pos(5) ring(0) size(small) col(1) order(1 "Top Third" 3 "Middle Third " 5 "Bottom Third")) 												                          ///
	xti("Month Year") yti("U.S Dollars $", margin(medium)) note("Source: IRI Academic Data",pos(7)) ///
	name(exp_by_inc_``i'', replace)
	
	
	tw (scatter adj_ave_mpur yrmonth if hhinc3 == 3, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) 																				  ///
	(scatter adj_ave_mpur yrmonth if hhinc3 == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) 																								///
	(scatter adj_ave_mpur yrmonth if hhinc3 == 1, msize(small) mcolor(red%30) msymbol(R)), 			///
	ti("Household Monthly Average Expenditures by Income Tercile", size(medium)) 					///
	subtitle("2004 - 2012 Seasonality Adjusted", size(medium)) legend( pos(5) ring(0) size(small) col(1) order(1 "Top Third" 2 "Middle Third" 3 "Bottom Third")) 												                          ///
	xti("Month Year") yti("U.S Dollars $", margin(medium)) note("Source: IRI Academic Data",pos(7)) ///
	name(adj_exp_by_inc_``i'', replace)
	
	grc1leg exp_by_inc_``i'' adj_exp_by_inc_``i'' , ycom name(commbined_``i'', replace)
	gr di, xsize(10)
	
}

*net install grc1leg,from( http://www.stata.com/users/vwiggins/) 

*grc1leg exp_by_inc_coldcer exp_by_inc_fzpizza exp_by_inc_fzdinent exp_by_inc_soup exp_by_inc_hotdog, ti("Household Average Monthly Expenditure by Income Tercile") ycom name(commbined_ready_to_serve, replace)

tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	gen yrmonth = ym(year, month) 
	format yrmonth %tm 
	
	gen work_hours_m = fulltime_m
	replace work_hours_m = 3 if home_stu_m == 1 
	replace work_hours_m = 2 if less_ft_m == 1 
	replace work_hours_m = 4 if no_hh_m == 1 
	
	bysort work_hours_m year month: egen inc_mpur = sum(DOLLARS)
	bysort work_hours_m year month: gen id1 = _n
	bysort work_hours_m year month: egen number = max(id1)

	bysort work_hours_m year month: gen ave_mpur = inc_mpur/number
	drop if id1 != 1
	
	
	*** Adjust for Seasonality 	***

	*ssc inst egenmore 

	xtset work_hours_m yrmonth

	egen ave_mpur_ma = filter(ave_mpur), coef(0.5 1 1 1 1 1 1 1 1 1 1 1 0.5) lags(-6/6) normalise 
	bysort work_hours_m month: gen season_fctr = ave_mpur/ave_mpur_ma
	gen adj_ave_mpur = ave_mpur/season_fctr
	
	save $dataout/FinalProject/``i''hvfhrs.dta, replace

	
	*** Figure 4 a,b **
	
	tw (scatter ave_mpur yrmonth if work_hours_m == 1, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) ///
	(fpfit ave_mpur yrmonth if work_hours_m == 1, lcolor(green%80)) ///
	(scatter ave_mpur yrmonth if work_hours_m == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) ///
	(fpfit ave_mpur yrmonth if work_hours_m == 2, lcolor(blue%80)) ///
	(scatter ave_mpur yrmonth if work_hours_m == 3, msize(small) mcolor(red%30) msymbol(R)) ///
	(fpfit ave_mpur yrmonth if work_hours_m == 3, lcolor(red%80)), ///
	ti("Household Monthly Average Expenditure by Work Status", size(large)) ///
	subtitle("Male Head 2004 - 2012", size(medium)) legend(pos(5) ring(0) size(small) col(1) order(1 "Full-time" 3 "Part-time" 5 "Homemaker")) ///
	xti("Month Year") yti("U.S Dollars $") note("Source: IRI Academic Data",pos(7)) ///
	name(exp_by_work_m``i'', replace)
	
	
	tw (scatter adj_ave_mpur yrmonth if work_hours_m == 1, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) 																				  ///
	(scatter adj_ave_mpur yrmonth if work_hours_m == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) 																								///
	(scatter adj_ave_mpur yrmonth if work_hours_m == 3, msize(small) mcolor(red%30) msymbol(R)), 			///
	ti("Household Monthly Average Expenditures by Work Status", size(medium)) 					///
	subtitle("2004 - 2012 Seasonality Adjusted", size(medium)) legend( pos(5) ring(0) size(small) col(1) order(1 "Full-time" 2 "Part-time" 3 "Homemaker")) 												                          ///
	xti("Month Year") yti("U.S Dollars $", margin(medium)) note("Source: IRI Academic Data",pos(7)) ///
	name(adj_exp_by_work_m``i'', replace)
	
	grc1leg exp_by_work_m``i'' adj_exp_by_work_m``i'' , ycom name(hrs_commbined_``i'', replace)
	gr di, xsize(10)
}
/*--------------------------------*/


tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	gen yrmonth = ym(year, month) 
	format yrmonth %tm 
	
	gen work_hours_w = fulltime_w
	replace work_hours_w = 3 if home_stu_w == 1 
	replace work_hours_w = 2 if less_ft_w == 1 
	replace work_hours_w = 4 if no_hh_w == 1 
	
	bysort work_hours_w year month: egen inc_mpur = sum(DOLLARS)
	bysort work_hours_w year month: gen id1 = _n
	bysort work_hours_w year month: egen number = max(id1)

	bysort work_hours_w year month: gen ave_mpur = inc_mpur/number
	drop if id1 != 1
	
	
	*** Adjust for Seasonality 	***

	*ssc inst egenmore 

	xtset work_hours_w yrmonth

	egen ave_mpur_ma = filter(ave_mpur), coef(0.5 1 1 1 1 1 1 1 1 1 1 1 0.5) lags(-6/6) normalise 
	bysort work_hours_w month: gen season_fctr = ave_mpur/ave_mpur_ma
	gen adj_ave_mpur = ave_mpur/season_fctr
	
	save $dataout/FinalProject/``i''hvfhrs_w.dta, replace

	*** Figure 5 a,b **
		
	tw (scatter ave_mpur yrmonth if work_hours_w == 1, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) ///
	(fpfit ave_mpur yrmonth if work_hours_w == 1, lcolor(green%80)) ///
	(scatter ave_mpur yrmonth if work_hours_w == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) ///
	(fpfit ave_mpur yrmonth if work_hours_w == 2, lcolor(blue%80)) ///
	(scatter ave_mpur yrmonth if work_hours_w == 3, msize(small) mcolor(red%30) msymbol(R)) ///
	(fpfit ave_mpur yrmonth if work_hours_w == 3, lcolor(red%80)), ///
	ti("Household Monthly Average Expenditure by Work Status", size(large)) ///
	subtitle("Female Head 2004 - 2012", size(medium)) legend(pos(5) ring(0) size(small) col(1) order(1 "Full-time" 3 "Part-time" 5 "Homemaker")) ///
	xti("Month Year") yti("U.S Dollars $") note("Source: IRI Academic Data",pos(7)) ///
	name(exp_by_work_w``i'', replace)
	
	tw (scatter adj_ave_mpur yrmonth if work_hours_w == 1, msize(small) mcolor(green%30) msymbol(R) xline(575, lcolor(red%50))) 																				  ///
	(scatter adj_ave_mpur yrmonth if work_hours_w == 2, msize(small) mcolor(blue%30) msymbol(R) xline(595, lcolor(red%50))) 																								///
	(scatter adj_ave_mpur yrmonth if work_hours_w == 3, msize(small) mcolor(red%30) msymbol(R)), 			///
	ti("Household Monthly Average Expenditures by Work Status", size(medium)) 					///
	subtitle("Female Head 2004 - 2012 Seasonality Adjusted", size(medium)) legend( pos(5) ring(0) size(small) col(1) order(1 "Full-time" 2 "Part-time" 3 "Homemaker")) 												                          ///
	xti("Month Year") yti("U.S Dollars $", margin(medium)) note("Source: IRI Academic Data",pos(7)) ///
	name(adj_exp_by_work_w``i'', replace)
	
	grc1leg exp_by_work_w``i'' adj_exp_by_work_w``i'' , ycom name(hrs_commbined_``i'', replace)
	gr di, xsize(10)
}

/*--------------------------------*/
tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	gen yrmonth = ym(year, month) 
	format yrmonth %tm 
	
	bysort year month: egen hhinc_mpur = sum(DOLLARS)
	bysort year month: gen id1 = _n
	bysort year month: egen number = max(id1)

	bysort year month: gen ave_exp_hh = hhinc_mpur/number
	drop if id1 != 1
	
	tsset yrmonth
	
	gen log_ave 		= log(ave_exp_hh)
	gen fd_log_ave		= log_ave - L.log_ave
	gen log_hv 		   	= log(hv_)
	gen fd_log_hv 		= log_hv - L.log_hv
	
	tw (scatter fd_log_ave fd_log_hv, msize(small) mcolor(green%30) msymbol(R)) (lfit fd_log_ave fd_log_hv, lcolor(red%50)), 		///
	ti("Household Monthly Average Expenditures and House Value", size(medium)) 					///
	subtitle("2004 - 2012", size(medium)) legend(pos(6) order(1 "Expenditure" 2 "House Value")) 		 ///
	xti("Change in Log House Value Index") yti("Change in Log Expenditure") note("Source: IRI Academic Data/ Zillow, Inc. ",pos(7)) ///			
	name(exp_hv_``i'', replace)
}

grc1leg exp_hv_coldcer exp_by_inc_fzpizza exp_by_inc_fzdinent exp_by_inc_soup exp_by_inc_hotdog, ti("Household Average Monthly Expenditure by Income Tercile") ycom name(commbined_ready_to_serve, replace)
