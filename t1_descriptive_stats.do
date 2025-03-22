*** do 021-Table01v241116
 ** 11/16/2024
 ** t1_descriptivestats.ipynb
 ** Table 1: Descriptive Statistics
  * Use # non-white students = tefnw ftfefnw

local log "021-Table01v241116"
// local dsold "hdef19902019"
// local dsold "hsi_white_enrollment_final3"
local dsold "d_whiteflight_balanced"
local tag "021-Table01v241116"
local num "021"

capture log close
clear all
set matsize 800
set scheme plotplain
set mem 400000k
set linesize 100
set more off
use "`dsold'", clear
log using "`log'", t replace

*** Generate a var for the number of years relative to the year of the event (e.g. + or - 2 years)
 ** Charlie has already deleted private schools (control = 2) from the data
 ** So, only public schools (control = 1) remain in the data

    gen switchers = (hispserveyeardiff<.)
    foreach var of varlist cpopwh cpopbl cpophi cpopas cpopam populationwh populationbl populationhi populationas populationam {
        qui gen k`var' = `var' / 1000
    }
    rename kpopulationwh kpopwh 
    rename kpopulationbl kpopbl 
    rename kpopulationhi kpophi 
    rename kpopulationas kpopas 
    rename kpopulationam kpopam

    label var kcpopwh "county 18-24 white"
    label var kcpopbl "county 18-24 black"
    label var kcpophi "county 18-24 Latinx"
    label var kcpopas "county 18-24 Asian"
    label var kcpopam "county 18-24 Am. In."
    label var kpopwh "state 18-24 white"
    label var kpopbl "state 18-24 black"
    label var kpophi "state 18-24 Latinx"
    label var kpopas "state 18-24 Asian"
    label var kpopam "state 18-24 Am. In."
    label var hispserveyear "first year HSI"
    label var pcttefhispt "% undergrad Latinx"

    quietly gen region6 = 3 if fips==1   
    quietly replace region6 = 6 if fips==2   
    quietly replace region6 = 5 if fips==4   
    quietly replace region6 = 3 if fips==5   
    quietly replace region6 = 6 if fips==6   
    quietly replace region6 = 6 if fips==8   
    quietly replace region6 = 1 if fips==9   
    quietly replace region6 = 2 if fips==10   
    quietly replace region6 = 2 if fips==11   
    quietly replace region6 = 3 if fips==12   
    quietly replace region6 = 3 if fips==13   
    quietly replace region6 = 6 if fips==15   
    quietly replace region6 = 6 if fips==16   
    quietly replace region6 = 4 if fips==17   
    quietly replace region6 = 4 if fips==18   
    quietly replace region6 = 4 if fips==19   
    quietly replace region6 = 4 if fips==20   
    quietly replace region6 = 3 if fips==21   
    quietly replace region6 = 3 if fips==22   
    quietly replace region6 = 1 if fips==23   
    quietly replace region6 = 2 if fips==24   
    quietly replace region6 = 1 if fips==25   
    quietly replace region6 = 4 if fips==26   
    quietly replace region6 = 4 if fips==27   
    quietly replace region6 = 3 if fips==28   
    quietly replace region6 = 4 if fips==29   
    quietly replace region6 = 6 if fips==30   
    quietly replace region6 = 4 if fips==31   
    quietly replace region6 = 6 if fips==32   
    quietly replace region6 = 1 if fips==33   
    quietly replace region6 = 2 if fips==34   
    quietly replace region6 = 5 if fips==35   
    quietly replace region6 = 2 if fips==36   
    quietly replace region6 = 3 if fips==37   
    quietly replace region6 = 4 if fips==38   
    quietly replace region6 = 4 if fips==39   
    quietly replace region6 = 5 if fips==40   
    quietly replace region6 = 6 if fips==41   
    quietly replace region6 = 2 if fips==42   
    quietly replace region6 = 1 if fips==44   
    quietly replace region6 = 3 if fips==45   
    quietly replace region6 = 4 if fips==46   
    quietly replace region6 = 3 if fips==47   
    quietly replace region6 = 5 if fips==48   
    quietly replace region6 = 6 if fips==49   
    quietly replace region6 = 1 if fips==50   
    quietly replace region6 = 3 if fips==51   
    quietly replace region6 = 6 if fips==53   
    quietly replace region6 = 3 if fips==54   
    quietly replace region6 = 4 if fips==55   
    quietly replace region6 = 6 if fips==56   

    qui xi i.region6, noomit
    qui label var _Iregion6_1 "Northeast"
    qui label var _Iregion6_2 "Mid-Atlantic"
    qui label var _Iregion6_3 "South"
    qui label var _Iregion6_4 "Midwest"
    qui label var _Iregion6_5 "Southwest"
    qui label var _Iregion6_6 "West"

    qui lab var teftotlt "undergrads"
    qui lab var admitpct "Admissions rate (%)"
    qui lab var ftfefwhitt "Fulltime frosh enrol"

*** New restrictions // 11/17/2024

    // drop if lnftfefwhitt==. | lnftfefhispt==. // old
    drop if lnftfefwhitt==.
    drop if year==1990 & hispserve==1
    // gen missingpanel=. // already defined 24/11/17
    sort unitid year
    // bysort unitid: egen maxyear=max(year) // already defined 24/11/17 
    // bysort unitid: egen minyear=min(year) // already defined 24/11/17
    bysort unitid (year): replace missingpanel=1 if year[_n-1]!=year-1 | lnftfefwhitt==. | lnftfeftotlt==.
    replace missingpanel=. if year==1990 & lnftfefwhitt!=. & lnftfeftotlt!=.
    // bysort unitid: egen missingpanelall=min(missingpanel) // already defined 24/11/17
    replace missingpanelall=1 if maxyear!=2019 | minyear !=1990
    // bysort unitid: egen alwaystreated=min(hispserve) // already defined 24/11/17
    // bysort unitid: egen evertreated=max(hispserve) // already defined 24/11/17
    drop if alwaystreated==1
    drop if missingpanelall==1
    xtset unitid year

*** Show counts for switchers and non-switchers

  * Switcher schools
    qui count if hispserveyear==year
    local N1 = r(N)

  * Switcher schools/years
    qui count if hispserveyear!=.
    local N2 = r(N)

  * Non-switcher schools
    qui count if minyear==year & hispserveyear==.
    local N3 = r(N)

  * Non-switcher schools/years
    qui count if hispserveyear==.
    local N4 = r(N)

    foreach num of numlist 1 2 3 4 {
        di
        if `num'==1 {
            dis "===> `N1' switcher schools" 
        }
        if `num'==2 {
            display "===> `N2' switcher schools/years"
        }
        if `num'==3 {
            dis "===> `N3' non-switcher schools"
        }
        if `num'==4 {
            display "===> `N4' non-switcher schools/years"
        }
    }

*** Create Table 1

    local tab1var "teftotlt hispserveyear"
    local tab1var "`tab1var' _Iregion6_1 _Iregion6_2 _Iregion6_3 _Iregion6_4 _Iregion6_5 _Iregion6_6"
    local tab1var "`tab1var' admitpct pcttefhispt ftfefwhitt"
    local tab1var "`tab1var' kcpopwh kcpopbl kcpophi kcpopas kcpopam"
    local tab1var "`tab1var' kpopwh kpopbl kpophi kpopas kpopam"
    nmlab `tab1var'

    di "------------------------------------------------------------"
    di _col(27) "HSI switchers" _col(47) "Non-switchers"
    di _col(26) "--------------" _col(46) "--------------"
    di _col(2) "Variables" _col(26) "Mean" _col(37) %8.2f "Std" ///
           _col(46) %8.2f "Mean" _col(57) %8.2f "Std"
    di "------------------------------------------------------------"

    local i = 1
    foreach nam in `tab1var' {

        qui sum `nam' if switchers==1
        local mn1 = r(mean)
        local sd1 = r(sd)

        qui sum `nam' if switchers==0
        local mn2 = r(mean)
        local sd2 = r(sd)

        di _col(2) "`: var label `nam''" _col(22) %8.2f `mn1' _col(32) %8.2f `sd1' ///
           _col(42) %8.2f `mn2' _col(52) %8.2f `sd2'
        local i = `i' + 1
    }
    di "------------------------------------------------------------"
    di _col(1) "Number of schools" _col(31) "`N1'" _col(50) "`N3'"
    di _col(1) "Number of school/years" _col(30) "`N2'" _col(48) "`N4'"
    di "------------------------------------------------------------"

*** Switchers

    sum `tab1var' if switchers==1

*** Non-switchers

    sum `tab1var' if switchers==0

log close
