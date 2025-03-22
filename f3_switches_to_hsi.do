*** do 012-Figure03v241205
 ** Figure 3: Switches to HSI Status
 ** grc1leg2 // combine plots with only 1 legend
 
local log "012-Figure03v241205"
local dsold "d_whiteflight_balanced"
local tag "012-Figure03; 12/05/24/sc"
local numtag "012"

capture log close
clear all
set matsize 800
set mem 400000k
set scheme plotplain
set linesize 100
set more off
use "`dsold'", clear
log using "`log'", t replace

    gen switchers = (hispserveyeardiff<.)
    label var hispserveyear "first year HSI"

    qui count if hispserveyear==year
    local N1 = r(N)
    di `N1'

    qui histogram hispserveyear if hispserveyear==year, discrete freq barwidth(.9) color(emidblue) fcolor(edkblue) ///
        xtitle("") xlabel(1990(5)2020) ///
        ytitle("Number of Schools") ylabel(0 4 8 12,grid) yscale(range(0 13)) /// 
        text(11 1990 "Total Switchers to HSI = `N1'", place(e) size(small)) ///
        title("Figure 3. Switches to HSI Status, 4-Year Public Universities", size(medium) pos(12) margin(small) justification(center))

    qui graph export `numtag'-f3_switchestohsi-v241205.wmf, replace
    qui graph export `numtag'-f3_switchestohsi-v241205.pdf, replace

log close

