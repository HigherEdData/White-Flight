*** do 011-Figure01
 ** Same as old Figure 1, 3/18/2022
 ** grc1leg2 // combine plots with only 1 legend

local dsold "hdef19902019"
local log "011-Figure01"
local tag "011-Figure01; 3/18/22/sc"
local numtag "011"

capture log close
clear all
set matsize 800
set mem 400000k
set scheme plotplain
set linesize 100
set more off
use `dsold', clear
log using "`log'", t replace

*** Create separate unitid for Benjamin Franklin Institute for when it goes from Public to Private
 ** Correct IPEDS reporting error to note it is private in 2016 & 2017

    replace unitid = unitid+1000000 if unitid==165884 & year>2007
    replace control = 2 if unitid==1165884
    
 ** Replace Boricuo college Latinx enrollment as missing for years 1993 & 1994
  * when reporting error reduced % Latinx from 95% to 0%

    replace tefhispt = . if unitid==189413 & year<1995 & year>1992

    keep if ftfeftotlt>100 & ftfeftotlt<. & control==1
    
 *** Plot exposure index for public schools

    gen wxlatin = tefwhitt * (tefhispt / teftotlt)
    gen wxwhite = tefwhitt * (tefwhitt / teftotlt)
    gen hxwhite = tefhispt * (tefwhitt / teftotlt)
    gen hxlatin = tefhispt * (tefhispt / teftotlt)
    gen mnpctlatin= (tefhispt / teftotlt) * 100

    collapse (sum) wxlatin wxwhite hxlatin hxwhite tefwhitt tefhispt teftotlt (mean) mnpctlatin, by(year)

    gen pctlatin = (tefhispt / teftotlt) * 100
    gen pctwhite = (tefwhitt / teftotlt) * 100
    gen mnwxlatin = wxlatin / tefwhitt * 100 
    gen mnwxwhite = wxwhite / tefwhitt * 100 
    gen mnhxlatin = hxlatin / tefhispt * 100 
    gen mnhxwhite = hxwhite / tefhispt * 100 
/*
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latinx at school of average white student"
    lab var mnhxlatin "% Latinx at school of average Latinx students"
    lab var mnhxwhite "% white at school of average Latinx students"
    lab var mnpctlatin "School Mean % Latinx students"
    lab var pctlatin "Weighted mean % Latinx students"
    lab var pctwhite "Weighted mean % white students"
*/
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latine at school of average white student"
    lab var mnhxlatin "% Latine at school of average Latine students"
    lab var mnhxwhite "% white at school of average Latine students"
    lab var mnpctlatin "School Mean % Latine students"
    lab var pctlatin "Weighted mean % Latine students"
    lab var pctwhite "Weighted mean % white students"

    sum mnwxwhite mnwxlatin mnhxlatin mnhxwhite pctlatin mnpctlatin 
    list year mnwxwhite mnhxwhite mnhxlatin mnwxlatin, clean noobs

    twoway (connected mnwxwhite year, msym(dh) msiz(*.9) mcol(gs10) clcol(gs10) clpat(dash)) ///
           (connected mnhxwhite year, msym(o) msiz(*.7) mcol(gs10) clcol(gs10) clpat(dash)) /// 
           (connected mnhxlatin year, msym(X) msiz(*.9) mcol(black) clcol(black) clpat(dash)) ///
           (connected mnwxlatin year, msym(oh) msiz(*.9) mcol(black) clcol(black) clpat(dash)) /// 
        , xtitle(" ") xlabel(1990(5)2020, nogrid) legend(pos(6) size(small) rows(4) region(margin(zero))) ///
          title(public) ///
          text(81 1990.35 "84.4", size(small) col(gs10)) text(67.0 2017.5 "62.5", size(small) col(gs10)) ///
          text(63.9 1990.35 "60.4", size(small) col(gs10)) text(40.6 2017.5 "36.6", size(small) col(gs10)) ///
          text(22.4 1990.35 "18.9", size(small) col(black)) text(29.4 2017.5 "33.9", size(small) col(black)) ///
          text(6.9 1990.35 "3.4", size(small) col(black)) text(15.8 2017.5 "12.3", size(small) col(black)) ///
          ytitle(% Students) ylabel(0(20)85, nogrid) ///
          xsize(8) ysize(11) name(pub220318, replace) scale(1.2)

    twoway (connected mnhxwhite year, msym(o) msiz(*.7) mcol(gs10) clcol(gs10) clpat(dash)) /// 
           (connected mnhxlatin year, msym(X) msiz(*.9) mcol(black) clcol(black) clpat(dash)) ///
        , xtitle(" ") xlabel(1990(5)2020, nogrid) legend(pos(6) size(small) rows(4) region(margin(zero))) ///
          text(63.9 1990.35 "60.4", size(small) col(gs10)) text(40.6 2017.5 "36.6", size(small) col(gs10)) ///
          text(22.4 1990.35 "18.9", size(small) col(black)) text(29.4 2017.5 "33.9", size(small) col(black)) ///
          ytitle(% Students) ylabel(10(10)65, nogrid) yline(20 30 40 50 60, lcol(gs13)) ///
          title("Figure 1. Latine Isolation and Exposure Indices for 4-Year Public Institutions", ///
          position(12) size(small) justification(center)) ///
          xsize(10) ysize(10) name(pub241022, replace) scale(0.9)

    graph export `numtag'-f1_exposure241022.wmf, replace
    graph export `numtag'-f1_exposure241022.pdf, replace

*** Create separate unitid for Benjamin Franklin Institute for when it goes from Public to Private
 ** Correct IPEDS reporting error to note it is private in 2016 & 2017

    use `dsold', clear

    replace unitid=unitid+1000000 if unitid==165884 & year>2007
    replace control=2 if unitid==1165884
    
  * Replace Boricuo college Latinx enrollment as missing for years 1993 & 1994
  * when reporting error reduced % Latinx from 95% to 0%

    replace tefhispt=. if unitid==189413 & year<1995 & year>1992
    keep if ftfeftotlt>100 & ftfeftotlt<. & control==2 

*** Plot exposure index for private schools

    gen wxlatin = tefwhitt * (tefhispt / teftotlt)
    gen wxwhite = tefwhitt * (tefwhitt / teftotlt)
    gen hxwhite = tefhispt * (tefwhitt / teftotlt)
    gen hxlatin = tefhispt * (tefhispt / teftotlt)
    gen mnpctlatin= (tefhispt / teftotlt) * 100

    collapse (sum) wxlatin wxwhite hxlatin hxwhite tefwhitt tefhispt teftotlt (mean) mnpctlatin, by(year)
    
    gen pctlatin = (tefhispt / teftotlt) * 100
    gen pctwhite = (tefwhitt / teftotlt) * 100
    gen mnwxlatin = wxlatin / tefwhitt * 100 
    gen mnwxwhite = wxwhite / tefwhitt * 100 
    gen mnhxlatin = hxlatin / tefhispt * 100 
    gen mnhxwhite = hxwhite / tefhispt * 100 
/*
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latinx at school of average white student"
    lab var mnhxlatin "% Latinx at school of average Latinx students"
    lab var mnhxwhite "% white at school of average Latinx students"
    lab var mnpctlatin "School Mean % Latinx students"
    lab var pctlatin "Weighted mean % Latinx students"
    lab var pctwhite "Weighted mean % white students"
*/
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latine at school of average white student"
    lab var mnhxlatin "% Latine at school of average Latine students"
    lab var mnhxwhite "% white at school of average Latine students"
    lab var mnpctlatin "School Mean % Latine students"
    lab var pctlatin "Weighted mean % Latine students"
    lab var pctwhite "Weighted mean % white students"

    sum mnwxwhite mnwxlatin mnhxlatin mnhxwhite pctlatin mnpctlatin 
    list year mnwxwhite mnhxwhite mnhxlatin mnwxlatin, clean noobs

    twoway (connected mnwxwhite year, msym(dh) msiz(*.9) mcol(gs10) clcol(gs10) clpat(dash)) ///
           (connected mnhxwhite year, msym(o) msiz(*.7) mcol(gs10) clcol(gs10) clpat(dash)) /// 
           (connected mnhxlatin year, msym(X) msiz(*.9) mcol(black) clcol(black) clpat(dash)) ///
           (connected mnwxlatin year, msym(oh) msiz(*.9) mcol(black) clcol(black) clpat(dash)) /// 
        , xtitle(" ") xlabel(1990(5)2020, nogrid) legend(pos(6) size(small) rows(4) region(margin(zero))) ///
          title(private) ///
          text(81 1990.35 "84.5", size(small) col(gs10)) text(67.3 2017.5 "62.8", size(small) col(gs10)) ///
          text(69.5 1990.35 "66.0", size(small) col(gs10)) text(51.9 2017.5 "48.4", size(small) col(gs10)) ///
          text(16.7 1990.35 "13.7", size(small) col(black)) text(22.1 2017.5 "19.1", size(small) col(black)) ///
          text(6.1 1990.35 "3.1", size(small) col(black)) text(13.2 2017.5 "10.2", size(small) col(black)) ///
          ytitle(% Students) ylabel(0(20)85, nogrid) ///
          xsize(8) ysize(11) name(pri, replace) scale(1.2)

*** Combine public and private schools

    grc1leg pub220318 pri, /// 
        title("Figure 1: Latine and White Student Exposure Indices for Four-Year Institutions", ///
        position(12) size(medium) justification(center)) ///
        col(2) xsize(5.5) ysize(3.5) iscale(*1) imargin(small) graphregion(margin(l=5 r=5)) 
    graph display
    graph export `numtag'-f1_exposure220318.wmf, replace
    graph export `numtag'-f1_exposure220318.pdf, replace

*** Plot exposure index for all schools

    use `dsold', clear

 ** Create separate unitid for Benjamin Franklin Institute for when it goes from Public to Private
 **Correct IPEDS reporting error to note it is private in 2016 & 2017

    replace unitid=unitid+1000000 if unitid==165884 & year>2007
    replace control=2 if unitid==1165884
    
  * Replace Boricuo college Latinx enrollment as missing for years 1993 & 1994
  * when reporting error reduced % Latinx from 95% to 0%

    replace tefhispt=. if unitid==189413 & year<1995 & year>1992
    keep if ftfeftotlt>100 & ftfeftotlt<. & control==1

    gen wxlatin = tefwhitt * (tefhispt / teftotlt)
    gen wxwhite = tefwhitt * (tefwhitt / teftotlt)
    gen hxwhite = tefhispt * (tefwhitt / teftotlt)
    gen hxlatin = tefhispt * (tefhispt / teftotlt)
    gen mnpctlatin= (tefhispt / teftotlt) * 100

    collapse (sum) wxlatin wxwhite hxlatin hxwhite tefwhitt tefhispt teftotlt (mean) mnpctlatin, by(year)

    gen pctlatin = (tefhispt / teftotlt) * 100
    gen pctwhite = (tefwhitt / teftotlt) * 100
    gen mnwxlatin = wxlatin / tefwhitt * 100 
    gen mnwxwhite = wxwhite / tefwhitt * 100 
    gen mnhxlatin = hxlatin / tefhispt * 100 
    gen mnhxwhite = hxwhite / tefhispt * 100 
/*
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latinx at school of average white student"
    lab var mnhxlatin "% Latinx at school of average Latinx students"
    lab var mnhxwhite "% white at school of average Latinx students"
    lab var mnpctlatin "School Mean % Latinx students"
    lab var pctlatin "Weighted mean % Latinx students"
    lab var pctwhite "Weighted mean % white students"
*/
    lab var mnwxwhite "% white at school of average white student"
    lab var mnwxlatin "% Latine at school of average white student"
    lab var mnhxlatin "% Latine at school of average Latine students"
    lab var mnhxwhite "% white at school of average Latine students"
    lab var mnpctlatin "School Mean % Latine students"
    lab var pctlatin "Weighted mean % Latine students"
    lab var pctwhite "Weighted mean % white students"

    sum mnwxwhite mnwxlatin mnhxlatin mnhxwhite pctlatin mnpctlatin 
    list year mnwxwhite mnhxwhite mnhxlatin mnwxlatin, clean noobs

    twoway (connected mnwxwhite year, msym(dh) msiz(*.7) mcol(yellow) clcol(yellow) clpat(dash) clwidth(medthin)) ///
           (connected mnhxwhite year, msym(o) msiz(*.7) mcol(yellow) clcol(yellow) clpat(dash) clwidth(medthin)) /// 
           (connected mnhxlatin year, msym(X) msiz(*.9) mcol(red) clcol(red) clpat(dash) clwidth(medthin)) ///
           (connected mnwxlatin year, msym(oh) msiz(*.7) mcol(red) clcol(red) clpat(dash) clwidth(medthin))  /// 
        , xtitle(" ") xlabel(1990(5)2020) legend(pos(6) size(small) rows(4) region(margin(zero))) ///
          title("Average Latinx and White Student Exposure to Each Other" " " "At US Public Universities" " ", size(small)) ///
          text(81 1990.35 "84.4", size(vsmall) col(black)) text(67.0 2017.5 "62.5", size(vsmall) col(black)) ///
          text(63.9 1990.35 "60.4", size(vsmall) col(black)) text(40.6 2017.5 "36.6", size(vsmall) col(black)) ///
          text(22.4 1990.35 "18.9", size(vsmall) col(black)) text(29.4 2017.5 "33.9", size(vsmall) col(black)) ///
          text(6.9 1990.35 "3.4", size(vsmall) col(black)) text(15.8 2017.5 "12.3", size(vsmall) col(black)) ///
          ytitle(% Students) ylabel(0(20)85,) ///
            xsize(8) ysize(11) scale(1.2) scheme(dubois)

    graph export `numtag'-alt_f1_exposure_public_dubois.pdf, replace

log close
