set more off
clear all

global base /home/dcooper/projects/min_wage/
global code ${base}code/
global data ${base}data/
global output ${base}output/

append_extracts, begin(2017m1) end(2017m12) sample(org)
