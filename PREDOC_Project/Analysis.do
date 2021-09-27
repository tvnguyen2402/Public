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

global dataout "$mainpath/DATAOUT"

global output "$mainpath/OUTPUT"


global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent sugarsub peanbutr mustketc margbutr mayo hotdog 

***************************************************************
*First Analysis***Income and Weath Effects between 2008 - 2012*
***************************************************************	

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent hotdog 

use $dataout/FinalProject/coldcerhvf.dta, clear

bysort PANID year month: egen hhmpur = sum(DOLLARS)
gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
bysort PANID year month: gen id1 = _n 
drop if id1 != 1

gen yrmonth = ym(year, month) 
format yrmonth %tm 

gen log_hhmpur = log(hhmpur)
gen log_hv = log(hv_)

*******************************

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep"

cap encode city, gen(city1)
cap encode statename, gen (state1)

local fixed_effects "i.state1##i.year i.month "

cd $output/FinalProject
reg log_hhmpur top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_basic, replace 

*---*
tokenize $files

forvalues i=2/8{
	use $dataout/FinalProject/``i''hvf.dta, clear

	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1

	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)
	

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep"

cap encode city, gen(city1)
cap encode statename, gen (state1)

local fixed_effects "i.state1##i.year i.month "

reg log_hhmpur top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_basic, append 
}

***********************************************************************
*First Analysis***Income and Weath Effects between 2008 - 2012 - Trips*
***********************************************************************

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent hotdog 

use $dataout/FinalProject/filtered_panel_trips_coldcer.dta, clear

bysort PANID year month: egen hhmtrips = sum(hh_trips)
bysort PANID year month: egen hhmpur   = sum(hh_wpur)
bysort PANID year month: gen id1 = _n
drop if id1 !=1
drop id1

gen yrmonth = ym(year, month) 
format yrmonth %tm 

gen recession = (yrmonth >=ym(2007, 12) & yrmonth < ym(2009,7))
gen share_pur = hhmpur*100/hhmtrips
gen log_hhmpur = log(hhmpur)
gen log_hhmtrips = log(hhmtrips)
gen log_hv = log(hv_)
gen log_share = log(share_pur*100)

*******************************

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep"

cap encode city, gen(city1)
cap encode statename, gen (state1)

local fixed_effects "i.state1##i.year i.yrmonth"

cd $output/FinalProject

reg  top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_trips_hv, replace

reg log_share top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_trips, replace

*---*
tokenize $files

forvalues i=2/8{
	use $dataout/FinalProject/filtered_panel_trips_``i''.dta, clear

	bysort PANID year month: egen hhmtrips = sum(hh_trips)
	bysort PANID year month: egen hhmpur   = sum(hh_wpur)
	bysort PANID year month: gen id1 = _n
	drop if id1 !=1
	drop id1

	gen yrmonth = ym(year, month) 
	format yrmonth %tm 

	bysort PANID yrmonth: gen time_trend = _n
	gen time_trend_sq = time_trend^2

	gen recession = (yrmonth >=ym(2007, 1) & yrmonth < ym(2009,7))
	
	gen share_pur = hhmpur*100/hhmtrips
	gen log_hhmpur = log(hhmpur)
	gen log_hhmtrips = log(hhmtrips)
	gen log_hv = log(hv_)
	gen log_share = log(share_pur*)

	local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep"

	cap encode statename, gen (state1)

	local fixed_effects "i.state1##i.year i.month"

	reg log_hhmtrips top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_trips_hv, append 

	reg log_share top_third bottom_third log_hv `controls' `fixed_effects', r
outreg2 using first_trips, append 
}


*****************************************************************************
*Second Analysis***Effects of Work Status on Consumption between 2008 - 2012*
*****************************************************************************

********************************************************
*** Non Parametric Time Trend -- Time-fixed Effects  ***
********************************************************

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w renter other_resid married widowed div_sep"

global files coldcer yogurt fzpizza saltsnck soup fzdinent hotdog 

use $dataout/FinalProject/coldcerhvf.dta, clear
	
	gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1

	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)
	
	cap encode statename, gen (state1)
	local fixed_effects "i.state1##i.year i.month"
	
	cd $output/FinalProject
	
	reg log_hhmpur log_hv less_ft_w  less_ft_m home_stu_w home_stu_m no_hh_w no_hh_m unemp_w unemp_m `controls' `fixed_effects', r
	est store coldcer
	outreg2 using second_basic, replace

	reg log_hhmpur log_hv less_ft_w##more_four less_ft_m##more_four home_stu_w##more_four home_stu_m##more_four unemp_w##more_four unemp_m##more_four no_hh_w##more_four no_hh_m##more_four `controls' `fixed_effects', r
	outreg2 using second_famsize, replace
	
	/*-------------------*/

tokenize $files

forvalues i=2/7{
	use $dataout/FinalProject/``i''hvf.dta, clear
	drop if missing(familysize)
	gen more_four = familysize >3
	
	gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1
	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)
	
	cap encode statename, gen (state1)
	local fixed_effects "i.state1##i.year i.month "
	
	reg log_hhmpur log_hv less_ft_w  less_ft_m home_stu_w home_stu_m no_hh_w no_hh_m unemp_w unemp_m `controls' `fixed_effects', r
	est store ``i''
	outreg2 using second_basic, append

	reg log_hhmpur log_hv less_ft_w##more_four less_ft_m##more_four home_stu_w##more_four home_stu_m##more_four unemp_w##more_four unemp_m##more_four no_hh_w##more_four no_hh_m##more_four `controls' `fixed_effects', r
	outreg2 using second_famsize, append
}

set scheme s2mono

/*----------------------------------------------------------------------------*/

/*Part-time*/
coefplot (coldcer, label(coldcer)) (yogurt, label(yogurt)) (fzpizza, label(fzpizza)) (saltsnck, label(saltsnck)) (soup, label(soup)) (spagsauc, label(spagsauc)) (fzdinent, label(fzdinent)) (hotdog, label(hotdog)), keep(less_ft_w) sort drop(_cons) xline(0, lpattern(dash)) legend(pos(3) row(1) size(small)) name(parttime_w, replace) title("Effects of Part-time Work on Consumption of Household") subtitle(Female Head  2004 - 2012) xti("Estimated Coeficients") note("Source: IRI Academic Data",pos(7))

coefplot (coldcer, label(coldcer)) (yogurt, label(yogurt)) (fzpizza, label(fzpizza)) (saltsnck, label(saltsnck)) (soup, label(soup)) (spagsauc, label(spagsauc)) (fzdinent, label(fzdinent)) (hotdog, label(hotdog)), keep(less_ft_m) sort drop(_cons) xline(0, lpattern(dash)) legend(pos(3) row(1) size(small)) name(parttime_m, replace) title("Effects of Part-time Work on Consumption of Household") subtitle(Male Head 2004 - 2012) xti("Estimated Coeficients") note("Source: IRI Academic Data",pos(7))

grc1leg parttime_w parttime_m , ycom name(commbined_pt, replace)
	gr di, xsize(10)
	
coefplot (coldcer, label(coldcer)) (yogurt, label(yogurt)) (fzpizza, label(fzpizza)) (saltsnck, label(saltsnck)) (soup, label(soup)) (spagsauc, label(spagsauc)) (fzdinent, label(fzdinent)) (hotdog, label(hotdog)), keep(home_stu_w) sort drop(_cons) xline(0, lpattern(dash)) legend(pos(3) row(1) size(small)) name(hm_w, replace) title("Effects of Being a Homemaker on Consumption of Household") subtitle(Female Head  2004 - 2012) xti("Estimated Coeficients") note("Source: IRI Academic Data",pos(7))

coefplot (coldcer, label(coldcer)) (yogurt, label(yogurt)) (fzpizza, label(fzpizza)) (saltsnck, label(saltsnck)) (soup, label(soup)) (spagsauc, label(spagsauc)) (fzdinent, label(fzdinent)) (hotdog, label(hotdog)), keep(home_stu_m) sort drop(_cons) xline(0, lpattern(dash)) legend(pos(3) row(1) size(small)) name(hm_m, replace) title("Effects of Being a Homemaker on Consumption of Household") subtitle(Male Head 2004 - 2012) xti("Estimated Coeficients") note("Source: IRI Academic Data",pos(7))

grc1leg hm_w hm_m , ycom name(commbined_hm, replace)
	gr di, xsize(10)

*****************************************************************************
*Third Analysis*** Cyclicality of Consumption between 2008 - 2012.          *
*****************************************************************************

********************************************
***  Polynonimal time-trends			 ***
********************************************

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep log_hv"

global files coldcer yogurt fzpizza saltsnck soup fzdinent hotdog 

use $dataout/FinalProject/coldcerhvf.dta, clear
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1
	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)

	bysort PANID (year month): gen time_trend = _n
	gen time_trend_sq = time_trend^2
	gen time_trend_cb = time_trend^3

	cap encode statename, gen (state1)

	local fixed_effects "i.state1"
	cd $output/FinalProject

	reg log_hhmpur less_ft_w##i.recession i.less_ft_m##i.recession i.home_stu_w##i.recession i.home_stu_m##i.recession unemp_w##i.recession unemp_m##i.recession no_hh_w##i.recession no_hh_m##i.recession time_trend time_trend_sq time_trend_cb `controls' `fixed_effects', r

	outreg2 using cyclicality_1, replace

*----*

tokenize $files

forvalues i=2/8{
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	gen recession = (Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1
	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)

	bysort PANID (year month): gen time_trend = _n
	gen time_trend_sq = time_trend^2
	gen time_trend_cb = time_trend^3

	cap encode statename, gen (state1)

	local fixed_effects "i.state1"
	cd $output/FinalProject

	reg log_hhmpur less_ft_w##i.recession i.less_ft_m##i.recession i.home_stu_w##i.recession i.home_stu_m##i.recession unemp_w##i.recession unemp_m##i.recession no_hh_w##i.recession no_hh_m##i.recession time_trend time_trend_sq time_trend_cb `controls' `fixed_effects', r
	
	outreg2 using cyclicality_1, append
}

********************************************
***  Polynonimal linear time-trends		 ***
********************************************

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w more_four renter other_resid married widowed div_sep log_hv"

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent hotdog 

use $dataout/FinalProject/coldcerhvf.dta, clear

	drop if missing(familysize)
	gen more_four = familysize >3
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	gen recession 		= 	(Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	gen pre_recession 	=	(Calendarweekendingon<mdy(12,1,2007))
	gen post_recession	= 	(Calendarweekendingon>mdy(7,1,2009))
	
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1
	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)

	bysort PANID (year month): gen time_trend = _n

	cap encode statename, gen (state1)

	local fixed_effects "i.state1"
	cd $output/FinalProject

	reg log_hhmpur log_hv less_ft_w less_ft_m home_stu_w home_stu_m unemp_w unemp_m no_hh_w no_hh_m c.time_trend##pre_recession c.time_trend##post_recession `controls' `fixed_effects', r

	outreg2 using cyclicality_2, replace

*----*

local controls "i.combinedpretaxincomeofhh less_54_m less_54_w more_55_m more_55_w hsgrad_m hsgrad_w some_coll_m some_coll_w collgrad_m collgrad_w postgrad_m postgrad_w mana_admin_m sales_m cler_m crafts_m oper_m laborer_m serv_priv_m other_prof_m mana_admin_w sales_w cler_w crafts_w oper_w laborer_w serv_priv_w other_prof_w log_hv"

global files coldcer yogurt fzpizza saltsnck soup spagsauc fzdinent hotdog 


tokenize $files

forvalues i=2/8{
	use $dataout/FinalProject/``i''hvf.dta, clear
	
	bysort PANID year month: egen hhmpur = sum(DOLLARS)
	gen recession 		= 	(Calendarweekendingon>=mdy(12,1,2007) & Calendarweekendingon<mdy(7,1,2009))
	gen pre_recession 	=	(Calendarweekendingon<mdy(12,1,2007))
	gen post_recession	= 	(Calendarweekendingon>mdy(7,1,2009))
	
	bysort PANID year month: gen id1 = _n 
	drop if id1 != 1
	
	gen log_hhmpur = log(hhmpur)
	gen log_hv = log(hv_)

	bysort PANID (year month): gen time_trend = _n

	cap encode statename, gen (state1)

	local fixed_effects "i.state1"
	cd $output/FinalProject
	reg log_hhmpur log_hv less_ft_w less_ft_m home_stu_w home_stu_m unemp_w unemp_m no_hh_w no_hh_m c.time_trend##pre_recession c.time_trend##post_recession `controls' `fixed_effects', r
		
	outreg2 using cyclicality_2, append
}


