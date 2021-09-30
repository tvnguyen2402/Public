
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

**************************************************************************************
*Data Programming *** Append Data from Groceries Stores, Drug Stores, and Mass Stores*
**************************************************************************************

/*For years 2004 - 2007*/

local weeks4 "1270_1321" 
local weeks5 "1322_1373" 
local weeks6 "1374_1426"
local weeks7 "1427_1478"

forvalues k=4(1)7 {
	tokenize $files
	forvalues i=1/13 {
		/*Import household panel data*/
		import delimited $rawdata/y`k'/``i''_PANEL_DR_`weeks`k''.dat, delimiter(whitespace, collapse)case(preserve) colrange(:11) clear
		drop v8

		save $datain/FinalProject/``i''_PANEL_DR_`weeks`k''.dta, replace

/*----------------------------------------------------------------------------*/
		import delimited $rawdata/y`k'/``i''_PANEL_GR_`weeks`k''.dat, delimiter(whitespace, collapse) case(preserve) colrange(:11) clear
		drop v8

		save $datain/FinalProject/``i''_PANEL_GR_`weeks`k''.dta, replace

		append using $datain/FinalProject/``i''_PANEL_DR_`weeks`k''.dta

		save $datain/FinalProject/appended_``i''_PANEL_`weeks`k''.dta, replace
	}
}

/*----------------------------------------------------------------------------*/
/*For years 2008 - 2012*/

local weeks8 "1479_1530" 
local weeks9 "1531_1582" 
local weeks10 "1583_1634"
local weeks11 "1635_1686"
local weeks12 "1687_1739"

forvalues k=8(1)12 {
tokenize $files
forvalues i=1/13 {
/*Import household panel data*/
import delimited $rawdata/y`k'/``i''_PANEL_DK_`weeks`k''.dat, case(preserve) colrange(:11) clear

save $datain/FinalProject/``i''_PANEL_DK_`weeks`k''.dta, replace

/*----------------------------------------------------------------------------*/

import delimited $rawdata/y`k'/``i''_PANEL_GK_`weeks`k''.dat, case(preserve) colrange(:11) clear


save $datain/FinalProject/``i''_PANEL_GK_`weeks`k''.dta, replace

append using $datain/FinalProject/``i''_PANEL_DK_`weeks`k''.dta

save $datain/FinalProject/appended_``i''_PANEL_`weeks`k''.dta, replace
}
}


*************************************
** Import the demographics files   **
*************************************

forvalues k=4(1)7{
	import delimited $rawdata/Demo/demo`k'.csv, clear
	rename panelistid PANID
	rename year YEAR
save $datain/FinalProject/DEMOS_`k'.dta, replace
}

forvalues k=8(1)12{
	import delimited $rawdata/Demo/demo`k'.csv, clear
	rename panelistid PANID
	gen YEAR = `k'
save $datain/FinalProject/DEMOS_`k'.dta, replace
}

************************************************************
** Import the panel static file and merge with demo files **
************************************************************

/*to filter out households that did not remain the IRI datasets for a reasonable length and who did not have a consistent purchase record*/

import delimited $rawdata/static1_12.csv, case(upper) clear

save $datain/FinalProject/static1_12.dta, replace

forvalues k=4(1)12{
	use $datain/FinalProject/DEMOS_`k'.dta, replace
	merge m:1 PANID YEAR using $datain/FinalProject/static1_12.dta 
	drop if _m != 3
	drop _m
	keep if MAKE_STATIC == "yes"
	save $datain/FinalProject/DEMOS_`k'.dta, replace
}

*****************************************
** Import the week translation dataset **
*****************************************

import excel "$rawdata/IRI week translation.xls", first clear
rename IRIWeek WEEK

keep WEEK Calendarweekstartingon Calendarweekendingon

unab var : * 
tokenize `var' 

forvalues i=1/3 {
	drop if missing(``i'')
}

save "$datain/FinalProject/week.dta", replace

/*----------------------------------------------------------------------------*/
/*House Value Index*/

use $datain/FinalProject/maps/zillow_house_index.dta, clear

local months "jan feb mar apr may jun jul aug sep oct nov dec"

forvalues i=2004(1)2012{
	foreach j of local months {
		rename `j'`i' hv_`j'`i'
	}
}

reshape long hv_, i(zipcode) j(monyear) string

gen int monyear2 = date(monyear,"MY")
format monyear2 %td
gen year = year(monyear2)
gen month = month(monyear2)

sort zipcode year month
order zipcode year month hv_

keep zipcode year month monyear2 hv_ statename city metro countyname 

save $datain/FinalProject/hv_zip_reshaped.dta, replace

************************************************************
** Merge household panel dataset with demographics dataset**
************************************************************

***********************
*For years 2004 - 2007*
***********************
		
global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

local weeks4 	"1270_1321" 
local weeks5 	"1322_1373" 
local weeks6 	"1374_1426"
local weeks7 	"1427_1478"

forvalues k=4(1)7 {
	
	tokenize $files
	forvalues i=1/13 {
		
		use $datain/FinalProject/appended_``i''_PANEL_`weeks`k''.dta, clear
		merge m:1 PANID using $datain/FinalProject/DEMOS_`k'.dta

		drop if _m != 3
		drop _m

		/*Merge household panel dataset with week translation*/
		merge m:1 WEEK using "$datain/FinalProject/week.dta"
		drop if _m != 3
		drop _m

		gen start_year		= year(Calendarweekstartingon)
		gen start_month		= month(Calendarweekstartingon)

		gen year			= year(Calendarweekendingon)
		gen month			= month(Calendarweekendingon)

		save $dataout/FinalProject/merged_``i''_`weeks`k''.dta, replace
	}
}
		
******************************************************************
** Generate dummy variables and collapse data into monthly data **
******************************************************************
		
local weeks4 	"1270_1321" 
local weeks5 	"1322_1373" 
local weeks6 	"1374_1426"
local weeks7 	"1427_1478"

forvalues k=4(1)7 {
	
	tokenize $files
	forvalues i=1/13 {
		use $dataout/FinalProject/merged_``i''_`weeks`k''.dta, replace
		
		*family size *
		drop if missing(familysize)
		gen more_four = familysize >3
		
		*head of household income*
		drop if combinedpretaxincomeofhh == 0
		
		xtile hhinc3 = combinedpretaxincomeofhh, n(3)
		tab hhinc3
		
		gen top_third 		= hhinc3 == 3
		gen mid_third 		= hhinc3 == 2
		gen bottom_third 	= hhinc3 == 1
		
		*type of residential possesion*
		drop if typeofresidentialpossession == 0
		
		gen renter 			= typeofresidentialpossession == 1
		gen owner 			= typeofresidentialpossession == 2
		
		*marital status*
		drop if maritalstatus == 0
		
		gen married 		= maritalstatus == 2
		gen widowed 		= maritalstatus == 4
		gen div_sep 		= maritalstatus == 3 | maritalstatus == 5
		gen single			= maritalstatus == 1

		*age of hh*
		drop if agegroupappliedtomalehh == 0
		drop if agegroupappliedtofemalehh == 0
		
		gen less_34_m 		= agegroupappliedtomalehh <= 2
		gen less_34_w 		= agegroupappliedtofemalehh <= 2

		gen less_54_m 		= agegroupappliedtomalehh <= 4 & agegroupappliedtomalehh > 2
		gen less_54_w 		= agegroupappliedtofemalehh <= 4 & agegroupappliedtofemalehh > 2
		
		gen more_55_m 		= agegroupappliedtomalehh <= 6 & agegroupappliedtomalehh > 4
		gen more_55_w 		= agegroupappliedtofemalehh <= 6 & agegroupappliedtofemalehh > 4
		
		*education attainment*
		gen less_hs_m 		= educationlevelreachedbymalehh <= 3
		gen less_hs_w 		= educationlevelreachedbyfemalehh <= 3
		
		gen hsgrad_m 		= educationlevelreachedbymalehh == 4 
		gen hsgrad_w 		= educationlevelreachedbyfemalehh == 4
		
		gen some_coll_m 	= educationlevelreachedbymalehh > 4 & educationlevelreachedbymalehh <= 6
		gen some_coll_w 	= educationlevelreachedbyfemalehh > 4 & educationlevelreachedbyfemalehh <= 6
		
		gen collgrad_m 		= educationlevelreachedbymalehh == 7
		gen collgrad_w 		= educationlevelreachedbyfemalehh == 7
		
		gen postgrad_m 		= educationlevelreachedbymalehh == 7
		gen postgrad_w 		= educationlevelreachedbyfemalehh == 7

		*occupation*
		gen prof_tech_m 	= occupationcodeofmalehh == 1
		gen mana_admin_m 	= occupationcodeofmalehh == 2
		gen sales_m 		= occupationcodeofmalehh == 3
		gen cler_m 			= occupationcodeofmalehh == 4
		gen crafts_m 		= occupationcodeofmalehh == 5
		gen oper_m 			= occupationcodeofmalehh == 6
		gen laborer_m 		= occupationcodeofmalehh == 7
		gen serv_priv_m 	= occupationcodeofmalehh == 8 | occupationcodeofmalehh == 9
		gen other_prof_m 	= occupationcodeofmalehh == 0
		
		gen prof_tech_w 	= occupationcodeoffemalehh == 1
		gen mana_admin_w 	= occupationcodeoffemalehh == 2
		gen sales_w 		= occupationcodeoffemalehh == 3
		gen cler_w 			= occupationcodeoffemalehh == 4
		gen crafts_w 		= occupationcodeoffemalehh == 5
		gen oper_w 			= occupationcodeoffemalehh == 6
		gen laborer_w 		= occupationcodeoffemalehh == 7
		gen serv_priv_w		= occupationcodeoffemalehh == 8 | occupationcodeoffemalehh == 9
		gen other_prof_w 	= occupationcodeoffemalehh == 0
		
		*employment status*
		gen unemp_w 		= (femaleworkinghourcode == 1)  
		gen unemp_m 		= (maleworkinghourcode == 1)  
		

		*working hours status*
		*gen not_employed_w = (femaleworkinghourcode == 1)  
		gen fulltime_w 		= (femaleworkinghourcode == 3)	
		gen less_ft_w 		= (femaleworkinghourcode == 2)  
		gen home_stu_w 		= (femaleworkinghourcode == 4| femaleworkinghourcode == 5 | femaleworkinghourcode == 6)
		gen no_hh_w 		= (femaleworkinghourcode == 7)
		
		*gen not_employed_m = (maleworkinghourcode == 1)  
		gen fulltime_m 		= (maleworkinghourcode == 3)
		gen less_ft_m 		= (maleworkinghourcode == 2)  
		gen home_stu_m 		= (maleworkinghourcode == 4 | maleworkinghourcode == 5 | maleworkinghourcode == 6)
		gen no_hh_m 		= (maleworkinghourcode == 7)
		
		cd "$dataout/FinalProject"

		save $dataout/FinalProject/``i''_`k', replace
	}
}
****************************************************************************
***Data programming***Merge household panel dataset with Week Translation***
****************************************************************************
						***********************
						*For years 2008 - 2012*
						***********************

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

local weeks8 	"1479_1530" 
local weeks9 	"1531_1582" 
local weeks10 	"1583_1634"
local weeks11 	"1635_1686"
local weeks12 	"1687_1739"

forvalues k=8(1)12 {
	tokenize $files
	forvalues i=1/13 {
		
		use $datain/FinalProject/appended_``i''_PANEL_`weeks`k''.dta, clear
		merge m:1 PANID using $datain/FinalProject/DEMOS_`k'.dta

		drop if _m != 3
		drop _m

		/*Merge household panel dataset with week translation*/
		merge m:1 WEEK using "$datain/FinalProject/week.dta"
		drop if _m != 3
		drop _m

		gen start_year		= year(Calendarweekstartingon)
		gen start_month		= month(Calendarweekstartingon)

		gen year		= year(Calendarweekendingon)
		gen month		= month(Calendarweekendingon)

		save $dataout/FinalProject/merged_``i''_`weeks`k''.dta, replace
		
	}
}

******************************************************************
** Generate dummy variables and collapse data into monthly data **
******************************************************************

local weeks8 	"1479_1530" 
local weeks9 	"1531_1582" 
local weeks10 	"1583_1634"
local weeks11 	"1635_1686"
local weeks12 	"1687_1739"

forvalues k=8(1)12 {
	
	tokenize $files
	forvalues i=1/13 {
		
		use $dataout/FinalProject/merged_``i''_`weeks`k''.dta, clear
		
		*family size*
		drop if missing(familysize)
		gen more_four = familysize >3
	
		*head of household income*
		drop if combinedpretaxincomeofhh == 99
		
		xtile hhinc3 = combinedpretaxincomeofhh, n(3)
		tab hhinc3
		
		gen top_third 		= hhinc3 == 3
		gen mid_third 		= hhinc3 == 2
		gen bottom_third 	= hhinc3 == 1
		
		*type of residential possesion*		
		gen renter 			= typeofresidentialpossession == 1
		gen owner 			= typeofresidentialpossession == 2
		gen other_resid 	= typeofresidentialpossession == 3
		
		*marital status*
		drop if maritalstatus == 0
		
		gen married 		= maritalstatus == 1
		gen widowed 		= maritalstatus == 2
		gen div_sep 		= maritalstatus == 3
		gen single			= maritalstatus == 4

		*age of hh*
		drop if agegroupappliedtomalehh == 0
		drop if agegroupappliedtofemalehh == 0
		
		gen less_34_m 		= agegroupappliedtomalehh <= 2
		gen less_34_w 		= agegroupappliedtofemalehh <= 2

		gen less_54_m 		= agegroupappliedtomalehh <= 4 & agegroupappliedtomalehh > 2
		gen less_54_w 		= agegroupappliedtofemalehh <= 4 & agegroupappliedtofemalehh > 2
		
		gen more_55_m 		= agegroupappliedtomalehh <= 6 & agegroupappliedtomalehh > 4
		gen more_55_w 		= agegroupappliedtofemalehh <= 6 & agegroupappliedtofemalehh > 4
		
		*education attainment*
		gen less_hs_m 		= educationlevelreachedbymalehh <= 2 | educationlevelreachedbymalehh >= 8
		gen less_hs_w 		= educationlevelreachedbyfemalehh <= 2 | educationlevelreachedbyfemalehh >= 8
		
		gen hsgrad_m 		= educationlevelreachedbymalehh == 3 
		gen hsgrad_w 		= educationlevelreachedbyfemalehh == 3
		
		gen some_coll_m 	= educationlevelreachedbymalehh == 4
		gen some_coll_w 	= educationlevelreachedbyfemalehh == 4
		
		gen collgrad_m 		= educationlevelreachedbymalehh == 5
		gen collgrad_w 		= educationlevelreachedbyfemalehh == 5
		
		gen postgrad_m 		= educationlevelreachedbymalehh == 6
		gen postgrad_w 		= educationlevelreachedbyfemalehh == 6
		
		*occupation*
		gen prof_tech_m 	= occupationcodeofmalehh == 1
		gen mana_admin_m 	= occupationcodeofmalehh == 2
		gen sales_m 		= occupationcodeofmalehh == 4
		gen cler_m 			= occupationcodeofmalehh == 3
		gen crafts_m 		= occupationcodeofmalehh == 5
		gen oper_m 			= occupationcodeofmalehh == 6
		gen laborer_m 		= occupationcodeofmalehh == 7
		gen serv_priv_m 	= occupationcodeofmalehh == 8
		gen other_prof_m 	= occupationcodeofmalehh == 10
		
		gen prof_tech_w 	= occupationcodeoffemalehh == 1
		gen mana_admin_w 	= occupationcodeoffemalehh == 2
		gen sales_w 		= occupationcodeoffemalehh == 4
		gen cler_w 			= occupationcodeoffemalehh == 3
		gen crafts_w 		= occupationcodeoffemalehh == 5
		gen oper_w 			= occupationcodeoffemalehh == 6
		gen laborer_w 		= occupationcodeoffemalehh == 7
		gen serv_priv_w 	= occupationcodeoffemalehh == 8
		gen other_prof_w 	= occupationcodeoffemalehh == 10
		
		*employment status*
		gen unemp_w = occupationcodeoffemalehh == 99 | occupationcodeoffemalehh == 98
		gen unemp_m = occupationcodeofmalehh   == 99 | occupationcodeofmalehh == 98
		
		*working hours status*
		gen fulltime_w 	    = (femaleworkinghourcode == 2)  
		gen home_stu_w		= (femaleworkinghourcode == 3)
	    gen less_ft_w 		= (femaleworkinghourcode == 1)  
		gen other_w 		= (femaleworkinghourcode == 99)  
		
		gen no_hh_w 		= (femaleworkinghourcode == 4)

		gen fulltime_m 		= (maleworkinghourcode == 2)  
		gen home_stu_m 		= (maleworkinghourcode == 3)
	    gen less_ft_m 		= (maleworkinghourcode == 1)  
		gen other_m 		= (maleworkinghourcode == 99)
		
		gen no_hh_m 		= (maleworkinghourcode == 4)
		
		save $dataout/FinalProject/``i''_`k', replace
	}
}

***************************************************
** Appending data sets together by food category **
***************************************************

cd "$dataout/FinalProject"

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

cap mkdir $dataout/FinalProject/raw
tokenize $files
forvalues j=1/13 {
	clear *
	! ls ``j''_*.dta > ``j''.txt

	file open ``j''_file using ``j''.txt, read
	file read ``j''_file file

	file read ``j''_file line
	use `line'

	file read ``j''_file line
	while r(eof)==0 { 
		append using `line'
		file read ``j''_file line
	}
	
	append using ``j''_10

	file close ``j''_file
	save $dataout/FinalProject/raw/``j''.dta, replace
}
***************************************************
** Appending all raw data sets together 		 **
***************************************************
cd $dataout/FinalProject/raw

	clear *
	! ls *.dta > raw.txt

	file open raw_file using raw.txt, read
	file read raw_file file

	file read raw_file line
	use `line'

	file read raw_file line
	while r(eof)==0 { 
		append using `line'
		file read raw_file line
	}
	
	append using coldcer

	file close raw_file
	save $dataout/FinalProject/raw/raw.dta, replace

forvalues i=4/12{
	sum DOLLARS if YEAR == `i' 	
}

bysort PANID YEAR: gen id1 = _n
drop if id1 != 1

forvalues i=4/12{
	sum PANID if YEAR == `i' 	
}

************************************************************************
*Data Programming *** Merge Household Panel Data with House Value Index*
************************************************************************

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''.dta, clear
	merge m:1 zipcode year month using $datain/FinalProject/hv_zip_reshaped.dta
	drop if _m != 3
	drop _m 
	gen id = `i'
	save $dataout/FinalProject/``i''hv.dta, replace
}

****************************************************
*Data Programming *** Append All HH Panel Datasets *
****************************************************
cd "$dataout/FinalProject"

clear *
! ls *hv.dta > all.txt

file open all_file using all.txt, read
file read all_file file

file read all_file line
use `line'
	
file read all_file line
while r(eof)==0 { 
	append using `line'
	file read all_file line
}
append using coldcerhv.dta
	
file close all_file
save $dataout/FinalProject/all_file.dta, replace
	
****************************************************
*Data Programming *** Filter Households 		   *
****************************************************

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hv.dta, clear
	bysort PANID: egen start_period = min(Calendarweekstartingon)
	bysort PANID: egen end_period = max(Calendarweekendingon)
	bysort PANID: gen duration = end_period - start_period
	gen durm =duration/30
	drop if durm < 6

	bysort PANID year month: gen id1 = _n
	bysort PANID year month: egen freq_month = max(id1)
	bysort PANID: egen ave_fre_month = mean(freq_month)
	drop if ave_fre_month <1

	bysort PANID (WEEK MINUTE): gen id2 = _n
	xtset PANID id2
	gen gap = Calendarweekendingon - L.Calendarweekendingon
	gen gapm = gap/30
	bysort PANID: egen longest_gapm = max(gapm)
	drop if longest_gapm > 6

	drop id1 id2 
	save $dataout/FinalProject/``i''hvf.dta, replace
}

*************************************************************
*Data Programming *** Append All FILTERED HH Panel Datasets *
*************************************************************
cd "$dataout/FinalProject"

clear *
! ls *hvf.dta > allf.txt

file open allf_file using allf.txt, read
file read allf_file file

file read allf_file line
use `line'
	
file read allf_file line
while r(eof)==0 { 
	append using `line'
	file read allf_file line
}
append using coldcerhvf.dta
	
file close allf_file
save $dataout/FinalProject/allf_file.dta, replace

*************************************
*** Import trips files            ***			
*************************************

cap mkdir $datain/FinalProject/trips

forvalues k=4/12{
	import delimited $rawdata/trips`k'.csv, case(upper) clear
	gen YEAR_TRIPS = `k'
	save $datain/FinalProject/trips/trips`k'.dta, replace
}

***************************************
*** Append all trips files together ***			
***************************************

cd "$datain/FinalProject/trips/"

clear *
! ls *.dta > trips.txt

file open trips_file using trips.txt, read
file read trips_file file

file read trips_file line
use `line'
	
file read trips_file line
while r(eof)==0 { 
	append using `line'
	file read trips_file line
}

append using trips10.dta

file close trips_file
save $dataout/FinalProject/master_trips.dta, replace

***********************************************
*** Match Trips Files with Filtered HH data ***
***********************************************

/*Because there is no var MINUTE for  years before 2008, collapse data into household weekly average*/

use $dataout/FinalProject/master_trips.dta, clear
bysort PANID WEEK: egen hh_trips = sum(CENTS999)
bysort PANID WEEK: gen id = _n
drop if id !=1
drop id
save $dataout/FinalProject/master_trips_week.dta, replace

/*----------------------------------------------------------------------------*/
global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

tokenize $files

forvalues i= 1/13 {
	use $dataout/FinalProject/``i''hvf.dta, clear
	bysort PANID WEEK: egen hh_wpur = sum(DOLLARS)
	bysort PANID WEEK: gen id1 = _n
	drop if id1 !=1
	drop id1
	
	merge 1:1 PANID WEEK using $dataout/FinalProject/master_trips_week.dta
	drop if _m != 3
	drop _m 
	save $dataout/FinalProject/filtered_panel_trips_``i''.dta, replace
}






