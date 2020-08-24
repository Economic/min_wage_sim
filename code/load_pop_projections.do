*Loads assumed growth rates for each race/ethnicity and saves in data folder
*that will be appended to dataset

clear

import delimited using `1'.csv

label variable growthann "Annual growth rate"

save ${data}popgrowth, replace
