/***********************************************************************************************************/
/* This program uses EPI's ACS-CPS ORG combined data to: 1) Identify and describe the number of people who would be directly 
/* affected by a minimum wage increase; 2) Estimate the number of people indirectly affected by an increase; 
/* 3) Calculate the wage bill increase; and 4) model these calculations with a multi-year, phased increase in the MW. 
/* This program accounts for existing state and local minimum wage increases scheduled under current law.
/*
/* D. Cooper - 3/11/19*/
/* Stops giving "natural" wage growth to workers getting MW-induced raises
/* caps maximum raise as nominal change in minimum, to prevent large increases for workers with subminimum wage values
/*
/*This version assumes "natural" nominal wage growth between data year and first increase at average annual
/* growth rate of bottom 20% from ORG over 2012-2017. Future years at CBO's projected rate of inflation in the CPI +0.5%
/* This version is for state-level analysis in VA - 15 by 2024; 70pct tipped MW;
/* NOTE: ;
/************************************************************************************************************/
quit;
libname external 'E:\userfiles\dcooper\Minimum Wage\new spillover\data';
libname acs 'e:\fdata1\dcooper\ACS\new_epi_extract\'; 
options obs=max ; *symbolgen;

/* These variables must be changed depending on proposal being analyzed*/
%let year_data = 2017; *The year of most recent data;

%let wagegrowth1=1.030927; *Assuming 2.48% growth from 2015-2016 - Jan-Oct growth;
%let monthstoincrease1 = 36; *given that we usually use full-year data from the previous year, I tend to make this how many months into the current year before the first increase;
%let year_proposal1 = 2020; *the first year the proposal will be implemented;
%let month_pre_proposal1 = 7; *the month of the first proposed increase.   DC(10/3/11): Typically the increases occur on jan 1,so applying the previous month's rate requires bridging years, 
which the program is not designed to do. So we you can set this to Jan as if it were a Feb increase if needed.;
%let newrate1 = 10.00; *the new minimum wage in the first increase;
%let tiprate1 = 2.13;

/*multi-year proposals only */

%let wagegrowth2=1.03; *CBO's projections for CPI;
%let monthstoincrease2 = 6; *the number of months between the first and second increase;
%let year_proposal2 = 2021; *the second year of the proposed phased increase;
%let month_pre_proposal2 = 7; *the month of the second proposed phased increase;
%let newrate2 = 11.00; *the new minimum wage in the second increase;
%let tiprate2 = 2.13;

%let wagegrowth3=1.03; *CBO's projections for CPI %;
%let monthstoincrease3 = 6; *the number of months between the second and third increase;
%let year_proposal3 = 2022; *the third year of the proposed phased increase;
%let month_pre_proposal3 = 7; *the month of the third proposed phased increase;
%let newrate3 = 12.00; *the new miniumum wage in the third increase;
%let tiprate3 = 2.13;

%let wagegrowth4=1.03; *CBO's projections for CPI;
%let monthstoincrease4 = 6; 
%let year_proposal4 = 2023; 
%let month_pre_proposal4 = 7; 
%let newrate4 = 13.00; *the new miniumum wage in the fourth increase;
%let tiprate4 = 2.13;

%let wagegrowth5=1.029; *CBO's projections for CPI;
%let monthstoincrease5 = 12; 
%let year_proposal5 = 2024; 
%let month_pre_proposal5 = 7; 
%let newrate5 = 14.00; *the new miniumum wage in the fifth increase;
%let tiprate5 = 2.13;

%let wagegrowth6=1.029; *CBO's projections for CPI;
%let monthstoincrease6 = 12;
%let year_proposal6 = 2024; 
%let month_pre_proposal6 = 7; 
%let newrate6 = 15.00; *the new miniumum wage in the sixth increase;
%let tiprate6 = 2.13;
/*
%let wagegrowth7=1.029; *CBO's projections for CPI plus 0.5%;
%let monthstoincrease7 = 12; 
%let year_proposal7 = 2025; 
%let month_pre_proposal7 = 7; 
%let newrate7 = 15.00; *the new miniumum wage in the seventh increase;
%let tiprate7 = 15.00;

%let wagegrowth8=1.029; *CBO's projections for CPI plus 0.5%;
%let monthstoincrease8 = 12; 
%let year_proposal8 = 2024; 
%let month_pre_proposal8 = 7; 
%let newrate8 = 15.00; *the new miniumum wage in the eighth increase;
%let tiprate8 = 12.20;

%let wagegrowth9=1.00; *CBO's projections for CPI plus 0.5%;
%let monthstoincrease9 = 1; 
%let year_proposal9 = 2025; 
%let month_pre_proposal9 = 1; 
%let newrate9 = 15.00; *the new miniumum wage in the ninth increase;
%let tiprate9 = 12.20;
*/
%let growthdum = 1; *Dummy to indicate the inclusion of wagegrowth bottom 20%;
%let onlyresidents=0; *Turns on resident-only analysis for state-level simulations;

*USING Produced by Demographics Research Group of the Weldon Cooper Center for Public Service, June 2019, http://demographics.coopercenter.org;
%let popgrowthw = 1.007556; *projected annual labor force growth rate for non-Hispanic whites 2014-2024 per BLS;
%let popgrowthb = 1.007556; *projected annual labor force growth rate for Blacks 2014-2024 per BLS;
%let popgrowthh = 1.007556; *projected annual labor force growth rate for Hispanics 2014-2024 per BLS;
%let popgrowtha = 1.007556; *projected annual labor force growth rate for Asians 2014-2024 per BLS;
%let popgrowtho = 1.007556; *projected annual labor force growth rate for other race/ethnicities 2014-2024 per BLS;

%let numsteps=6; *Change to indicate number of total iterations;

%let lowercutoff=0.8; *lower bound for inclusion in affected sample;
	
/*state level calculations only */

%let targetstate = 51; *STATE FIPS CODE of state of proposed minimum wage increase. Disable for national calculations;

*%let conds=(worker=1 and state=&targetstate);*use for single state-level analysis.  STILL NEED TO CHANGE CONDS LINE FOR KIDS METRICS;
%let conds=(worker=1); *use for national-level analysis;
*%let conds=(worker=1 and state=&targetstate and cbsa=35620 and cencity=1); *for city-level analyses. Use ACS instead.;

*%let kconds=(state=&targetstate and cbsa=35620 and cencity=1); *for city-level;
*%let kconds=(state=&targetstate);
%let kconds=(pop=1);

%let outfile = 'R:\new_R_drive_structure\EARN\Minimum Wage\2015_2017\VA\VA_15_2025_allyears_noTMW_noAG.xlsx'; *File where SAS will output the data;

%let yr=%substr(&year_data,3,2); *two digit year - no need to modify;
run;

%macro alertme(); *plays sound that program is complete;
 DATA _NULL_;* this produces a
   series of tones and serves as a
   signal that SAS has reached
   this point in a program;
      Do i = 200 to  2500 by 250
   ;
           call sound(i,100);
      end;
   run;
%mend alertme;

%macro cut(st);
proc univariate data=wage_mins(where=(worker=1)) noprint;
var hrwage2 indirect_cutoff&st;
weight perwt2;
output out=cut&st mean=mwage cutoff pctlpre=cut pctlpts=5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95;
run;

%if &st=0 %then %do;
	data cutout;
	set cut&st;
	%end;
%else %do;
	data cutout;
	set cutout cut&st;
	%end;

data freqset(keep=perwt2 wb);
set wage_mins(where=(worker=1));

if 0<hrwage2<5.8 then wb='0)0-5.80      ';
else if 5.8<=hrwage2<6.25 then wb='01)5.8-6.25    ';
else if 6.25<=hrwage2<6.75 then wb='02)6.25-6.75    ';
else if 6.75<=hrwage2<7.25 then wb='03)6.75-7.25    ';
else if 7.25<=hrwage2<7.75 then wb='04)7.25-7.75    ';
else if 7.75<=hrwage2<8.25 then wb='05)7.75-8.25    ';
else if 8.25<=hrwage2<8.75 then wb='06)8.25-8.75    ';
else if 8.75<=hrwage2<9.25 then wb='07)8.75-9.25    ';
else if 9.25<=hrwage2<9.75 then wb='08)9.25-9.75    ';
else if 9.75<=hrwage2<10.25 then wb='09)9.75-10.25    ';
else if 10.25<=hrwage2<10.75 then wb='10)10.25-10.75';
else if 10.75<=hrwage2<11.25 then wb='11)10.25-11.25';
else if 11.25<=hrwage2<11.75 then wb='12)11.25-11.75';
else if 11.75<=hrwage2<12.25 then wb='13)11.75-12.25';
else if 12.25<=hrwage2<12.75 then wb='14)12.25-12.75';
else if 12.75<=hrwage2<13.25 then wb='15)12.75-13.25';
else if 13.25<=hrwage2<13.75 then wb='16)13.25-13.75';
else if 13.75<=hrwage2<14.25 then wb='17)13.75-14.25';
else if 14.25<=hrwage2<14.75 then wb='18)14.25-14.75';
else if 14.75<=hrwage2<15.25 then wb='19)14.75-15.25';
else if 15.25<=hrwage2<15.75 then wb='20)15.25-15.75';
else if 15.75<=hrwage2<16.25 then wb='21)15.75-16.25';
else if 16.25<=hrwage2<16.75 then wb='22)16.25-16.75';
else if 16.75<=hrwage2<17.25 then wb='23)16.75-17.25';
else if 17.25<=hrwage2<17.75 then wb='24)17.25-17.75';
else if 17.75<=hrwage2<18.25 then wb='25)17.75-18.25';
else if 18.25<=hrwage2<18.75 then wb='26)18.25-18.75';
else if 18.75<=hrwage2<19.25 then wb='27)18.75-19.25';
else if 19.25<=hrwage2<19.75 then wb='28)19.25-19.75';
else if 19.75<=hrwage2<20.25 then wb='29)19.75-20.25';
else if 20.25<=hrwage2 then wb='30)20.25+     ';
else wb='n/a';

proc freq data=freqset noprint;
tables wb/out=freq&st;
weight perwt2;
run;

data freq&st(rename=(COUNT=Count&st PERCENT=Percent&st));
set freq&st;
percent=percent/100;

%if &st=0 %then %do;
	data freqout;
	set freq&st;
	%end;
%else %do;
	data freqout;
	merge freqout freq&st;
	by wb;
	%end;

proc delete data=freqset;
proc delete data=cut&st;
proc delete data=freq&st;
RUN;
%mend;

/*******************************************************************/
/*****************************YEAR 1********************************/
/*******************************************************************/

/*Minimum Wage Datset Construction*/

* First get the current and future min wage data from external file;

data min_current (drop=year month rename=(stmin=stmin&year_data tipmin=tipmin&year_data)) ;
	set external.stmins_current_ACS (where=(year=&year_data and month=7) keep=pwstate year month stmin tipmin); *setting baseline MW comparison month to July;
	attrib pwstate length=3;
	run;

%macro loadmins();
%do a=1 %to &numsteps;
* Set the future min wage to be the current state min the month before the proposal
	takes effect. This captures states that raise their mins between now and then;
data min_future&a (where=(year=&&year_proposal&a and month=&&month_pre_proposal&a)) ;
	set external.stmins_current_ACS (keep=pwstate year month stmin tipmin);
	attrib pwstate length=3;
run;
%end;
%mend;
%loadmins; run;
/*Set the future min wage to be the current state min the month before the proposal
	takes effect. This captures states that raise their mins between now and then;*/
%macro sortmins();
%do b=1 %to &numsteps;
	proc sort data=min_future&b; by pwstate year;run;
%end;
%mend;
%sortmins;run;
%macro minlist();
%do e=1 %to &numsteps;
	min_future&e (drop=year rename=(stmin=stmin&&year_proposal&e tipmin=tipmin&&year_proposal&e)) 
%end;
%mend;

data mins;
*This dataset has for each state the future scheduled min wage;
	merge %minlist;
	by pwstate; *month pwpuma;
run;

%macro deletemins();
%do c=1 %to &numsteps;
	proc delete data=min_future&c;
%end;
%mend;
%deletemins;run;

/* Estimate wage and job growth over period of proposed MW increase */
/* Find average wage growth of past three years by state
  and total population growth using estimate of annual growth;
*/

data growth (keep = statefips avggrowth totalpopgrowthw totalpopgrowthb totalpopgrowthh totalpopgrowtha totalpopgrowtho year1growth);
	set external.growthACS (keep=growthavg2012 growthavg2013 growthavg2014 growthavg2015 growthavg2016 growthavg2017 state statefips);
	if _n_ = 1 then delete; *Delete first row of total US data;
	attrib state statefips length=3;
	avggrowth = (growthavg2013 + growthavg2014 + growthavg2015 + growthavg2016 + growthavg2017)/5; *state-specific average growth of the bottom 20pct of wage-earners from ORG;
	year1growth = ((&monthstoincrease1/12)*(&wagegrowth1-1))+1; 
    totalpopgrowthw = ((&monthstoincrease1/12)*(&popgrowthw-1))+1;
	totalpopgrowthb = ((&monthstoincrease1/12)*(&popgrowthb-1))+1;
	totalpopgrowthh = ((&monthstoincrease1/12)*(&popgrowthh-1))+1;
	totalpopgrowtha = ((&monthstoincrease1/12)*(&popgrowtha-1))+1;
	totalpopgrowtho = ((&monthstoincrease1/12)*(&popgrowtho-1))+1;
run;

/*CALCULATE DIRECTLY AND INDIRECTLY AFFECTED*/
* Next find directly affected workers
  Those who are earning above the current min but less than proposed min;

* Input most recent data;
data acsdata;
set acs.acs_state (keep=age classwkrd educd empstatd ftotinc hasyouth_fam  hhincome hispan hrwage2 
						inctot incwage ind marst nchild occ parent_fam perwt2 puma pwpuma pwstate poverty race raced 
						serial sex statefips uhrswork adj_wkswork1 year); *vetstatd bpl citizen pernum wkswork2 related hasyouth_sfam parent_sfam famsize famunit ind1990 met2013 metro;
	*statefips=state;*the 2014 data are still coded to the old state format, as are the stmin and wage growth data sets so have to set 2015+ data to 2014 coding;
if pwstate>0;

*perwt2=perwt2/5;

if ftotinc>=9999999 then ftotinc=.;
if hhincome>=9999999 then hhincome=.;
if inctot>=9999999 then inctot=.;
if incwage>=9999999 then incwage=.;

poverty=round(poverty);
run;

proc format;    *state abbreviations;
value statef 
      23=me 33=nh 50=vt 25=ma 44=ri 9=ct 36=ny 34=nj 42=pa 
      39=oh 18=in 17=il 26=mi 55=wi 27=mn 19=ia 29=mo 38=nd 46=sd 31=ne 20=ks 
      10=de 24=md 11=dc 51=va 54=wv 37=nc 45=sc 13=ga 12=fl 21=ky 47=tn 1=al 28=ms 5=ar 22=la 40=ok 48=tx 
      30=mt 16=id 56=wy 8=co 35=nm 4=az 49=ut 32=nv 53=wa 41=or 6=ca 2=ak 15=hi;
run;

proc sort data=mins;
	by pwstate; 
run;
proc sort data=min_current;
	by pwstate; 
run;

data all_mins; *merge ACS data with database of minimum wages during data year;
 merge mins min_current;
 by pwstate;
 run;
proc delete data=mins;run;
proc delete data=min_current;run;
proc sort data=acsdata;
by statefips;
run;
proc sort data=growth;
by statefips;
run;
*Combine wagegrowth data with ACS_currentmin data;
data acs_growth;
  merge acsdata growth;
  by statefips;
run;
proc delete data=acsdata;run; 
proc delete data=growth;
run;
proc sort data=acs_growth;
by pwstate;
run;
proc sort data=all_mins;
by pwstate;
run;

* Combine future min wage data with ACS_currentmin_growth data;
data wage_mins(drop=hispan race);
attrib pop adult child _race woc poc length=3;
 merge acs_growth all_mins;
 by pwstate; *month pwpuma;

pop=1;
raise=.;
draise=.;
iraise=.;
worker=0;

if age>=18 then do;
	adult=1;
	child=0;
	end;
else do;
	adult=0;
	child=1;
end;

* Create demographic categories;
if 16<=age<20 then agec1='0Under 20';
  else agec1='20 +    ';

if 16<=age<=18 then agec3='0Under 18';
	else agec3='18+     ';    

if age<25 then agec2='16 to 24';
else if 25<=age<40 then agec2='25 to 39';
else if 40<=age<55 then agec2='40 to 54';
else if age>=55 then agec2='55+     ';

if sex=1 then sexc='Male                ';
  else sexc='Female              ';

if 1<=hispan<=4 then do;
	rc='3Hispanic   ';
	_race=3;
	poc=1;
	perwt2=perwt2*totalpopgrowthh;
end;
else do;
	if race=1 then do;
		rc='1White      ';
		_race=1;
		poc=0;
		perwt2=perwt2*totalpopgrowthw;
	end;
	else if race=2 then do;
		rc='2Black      ';
		_race=2;
		poc=1;
		perwt2=perwt2*totalpopgrowthb;
	end;
	/*else if race=3 then do;
		rc='6American Indian  
		poc=1;';
		perwt2=perwt2*totalpopgrowthi;
	end;*/
	else if (race=4 or race=5 or race=6) then do;
		/*if raced=630 then rc='4.1N. Hawaii';
		else if (680<=raced<=699) then rc='4.2Pac Islnd';
		else rc='4.3Asian    ';*/
		rc='4Asian/oth';
		poc=1;
		_race=4;
		perwt2=perwt2*totalpopgrowtha;
	end;
  	else do;
		rc='4Asian/oth';
		_race=5;
		poc=1;
		perwt2=perwt2*totalpopgrowtho;
	end;
end;

if (poc=1) then do;
	if sex ne 1 then do;
		woc=1;
		pocc='2Women of color';
	end;
	else do; 
		woc=0;
		pocc='1Men of color';
	end;
end;
else pocc='3Not person of color';

/*
if (12<=vetstatd<=20) then vetc='Veteran   ';
else if vetstatd=11 then vetc='Not veteran ';
else vetc=.;
*/
/*Immigration
borncode="n/a";

if 0<bpl<150 then borncd="U.S. born";
	else if bpl>=150 then do;
		if citizen=1 then borncd="U.S. born";
		else if citizen ne 1 then borncd="Foreign born ";
	end;

if bpl<100 then pbirth="U.S. State     ";
	else if 100<=bpl<150 then pbirth="U.S. territory";
	else if bpl>=150 then pbirth="Outside U.S.";
	else pbirth="N/A";

if citizen=2 then citc='Naturalized     ';
	else if citizen=3 then citc='Not US citizen';
	else citc='Born citizen';
*/
run;
proc delete data=acs_growth;
run;
proc delete data=all_mins;
run;

data wage_mins;
set wage_mins;
*hard coding in substate minimum wages;
if pwstate=4 then do;*Arizona;
	if pwpuma in (400) then do; *Flagstaff - uses all of Coconino county;
	stmin2017=10.50;
	stmin2019=12.00;
	stmin2020=13.00;
	stmin2021=15.00;
	stmin2022=15.50;
	stmin2023=15.90;
	stmin2024=16.30;

	tipmin2017=9.00;
	tipmin2019=10.00;
	tipmin2020=11.00;
	tipmin2021=12.00;
	tipmin2022=13.00;
	tipmin2023=13.90;
	tipmin2024=14.80;
	end;
end;
if pwstate=17 then do;*Illinois;
	if pwpuma in (3400) then do; *Cook County & Chicago - uses Cook County minimum;
	stmin2017=10.00;
	stmin2019=12.00;
	stmin2020=13.00;
	stmin2021=13.30;
	stmin2022=13.65;
	stmin2023=14.00;
	stmin2024=14.35;

	tipmin2017=4.95;
	tipmin2019=5.20;
	tipmin2020=5.35;
	tipmin2021=5.50;
	tipmin2022=5.65;
	tipmin2023=5.80;
	tipmin2024=5.95;
	end;
end;
if pwstate=23 then do; *Maine;
	if pwpuma in (790) then do; *Portland and surrounding areas (SE Maine);
	stmin2017=10.68; *Might want to use $9.00 here for State minimum;
	stmin2019=11.17;
	stmin2020=12.00;
	stmin2021=12.30;
	stmin2022=12.60;
	stmin2023=12.90;
	stmin2024=13.20;

	tipmin2017=5.00;*equals state tip minimum already;
	tipmin2019=5.50;
	tipmin2020=6.00;
	tipmin2021=6.15;
	tipmin2022=6.30;
	tipmin2023=6.45;
	tipmin2024=6.60;
	end;
end;
if pwstate=24 then do; *Maryland;
	if pwpuma in (1000) then do;*Montgomery county;
	stmin2017=10.75;
	stmin2019=13.00;
	stmin2020=14.00;
	stmin2021=15.00;
	stmin2022=15.38;
	stmin2023=15.76;
	stmin2024=16.14;

	tipmin2017=4.00;
	tipmin2019=4.00;
	tipmin2020=4.00;
	tipmin2021=4.00;
	tipmin2022=4.00;
	tipmin2023=4.00;
	tipmin2024=4.00;
	end;
	else if pwpuma=1100 then do;*Prince Georges County;
	stmin2017=10.75;
	stmin2019=11.50;
	stmin2020=11.50;
	stmin2021=11.50;
	stmin2022=11.50;
	stmin2023=11.50;
	stmin2024=11.50;

	tipmin2017=3.63;
	tipmin2019=3.63;
	tipmin2020=3.63;
	tipmin2021=3.63;
	tipmin2022=3.63;
	tipmin2023=3.63;
	tipmin2024=3.63;
	end;
end;
if pwstate=27 then do; *Minnesota;
	if pwpuma in (1400) then do;*Minneapolis;
	stmin2017=9.50;
	stmin2019=12.25;
	stmin2020=13.25;
	stmin2021=14.25;
	stmin2022=15.00;
	stmin2023=15.37;
	stmin2024=15.73;

	tipmin2017=9.50;
	tipmin2019=12.25;
	tipmin2020=13.25;
	tipmin2021=14.25;
	tipmin2022=15.00;
	tipmin2023=15.37;
	tipmin2024=15.73;
	end;
	else if pwpuma in (1300) then do;*St.Paul;
	stmin2017=9.50;
	stmin2019=9.86;
	stmin2020=12.50;
	stmin2021=12.50;
	stmin2022=15.00;
	stmin2023=15.37;
	stmin2024=15.73;

	tipmin2017=9.50;
	tipmin2019=9.86;
	tipmin2020=12.50;
	tipmin2021=12.50;
	tipmin2022=15.00;
	tipmin2023=15.37;
	tipmin2024=15.73;
	end;
end;
if pwstate=35 then do; *New Mexico;
	if pwpuma in (790) then do;*ABQ - uses all of Bernalillo County;
	stmin2017=8.70;
	stmin2019=9.05;
	stmin2020=9.25;
	stmin2021=9.50;
	stmin2022=9.75;
	stmin2023=10.00;
	stmin2024=10.25;

	tipmin2017=2.13;
	tipmin2019=2.13;
	tipmin2020=2.13;
	tipmin2021=2.13;
	tipmin2022=2.13;
	tipmin2023=2.13;
	tipmin2024=2.13;
	end;
	else if pwpuma in (500) then do;*Santa Fe - uses all of Santa Fe County;
	stmin2017=11.09;
	stmin2019=11.40;
	stmin2020=11.68;
	stmin2021=11.95;
	stmin2022=12.25;
	stmin2023=12.56;
	stmin2024=12.87;

	tipmin2017=3.33;
	tipmin2019=3.50;
	tipmin2020=3.59;
	tipmin2021=3.68;
	tipmin2022=3.77;
	tipmin2023=3.86;
	tipmin2024=3.96;
	end;
	else if pwpuma in (1000) then do; *Las Cruces - uses all of Dona Ana county;
	stmin2017=9.20;
	stmin2019=10.10;
	stmin2020=10.35;
	stmin2021=10.60;
	stmin2022=10.85;
	stmin2023=11.10;
	stmin2024=11.35;

	tipmin2017=3.68;
	tipmin2019=4.04;
	tipmin2020=4.14;
	tipmin2021=4.24;
	tipmin2022=4.34;
	tipmin2023=4.44;
	tipmin2024=4.54;
	end;
end;
if pwstate=36 then do; *New York;
	if pwpuma in (3700,3800,3900,4000,4100) then do; *NYC;
	stmin2017=11.00;
	stmin2019=15.00;
	stmin2020=15.00;
	stmin2021=15.00;
	stmin2022=15.00;
	stmin2023=15.00;
	stmin2024=15.00;

	tipmin2017=7.50;
	tipmin2019=10.00;
	tipmin2020=10.00;
	tipmin2021=10.00;
	tipmin2022=10.00;
	tipmin2023=10.00;
	tipmin2024=10.00;
	end;
	else if pwpuma in (3100,3200,3300) then do;*Nassau, Suffolk, Westchester Counties;
	stmin2017=10.00;
	stmin2019=12.00;
	stmin2020=13.00;
	stmin2021=14.00;
	stmin2022=15.00;
	stmin2023=15.00;
	stmin2024=15.00;

	tipmin2017=7.50;
	tipmin2019=8.00;
	tipmin2020=8.65;
	tipmin2021=9.35;
	tipmin2022=10.00;
	tipmin2023=10.00;
	tipmin2024=10.00;
	end;
end;
if pwstate=41 then do; *Oregon;
	if pwpuma in (1325,1326,1327) then do; *Portland urban growth area;
	stmin2017=11.25; *Might want to use state min of $9.75;
	stmin2019=12.50;
	stmin2020=13.25;
	stmin2021=14.00;
	stmin2022=14.75;
	stmin2023=15.10;
	stmin2024=15.45;

	tipmin2017=11.25;
	tipmin2019=12.50;
	tipmin2020=13.25;
	tipmin2021=14.00;
	tipmin2022=14.75;
	tipmin2023=15.10;
	tipmin2024=15.45;
	end;
	else if pwpuma in (100,200,300,800,1000) then do; *Rural counties;
	stmin2017=10.00;
	stmin2019=11.00;
	stmin2020=11.50;
	stmin2021=12.00;
	stmin2022=12.50;
	stmin2023=12.85;
	stmin2024=13.20;

	tipmin2017=10.00;
	tipmin2019=11.00;
	tipmin2020=11.50;
	tipmin2021=12.00;
	tipmin2022=12.50;
	tipmin2023=12.85;
	tipmin2024=13.20;
	end;
end;
if pwstate=53 then do; *Washingon;
	if pwpuma in (11600) then do; *Seattle - include SeaTac and all of King County;
	stmin2017=15.00; *Consider using state minimum of $11;
	stmin2019=16.00;
	stmin2020=16.37;
	stmin2021=16.78;
	stmin2022=17.21;
	stmin2023=17.63;
	stmin2024=18.06;

	tipmin2017=15.00;
	tipmin2019=16.00;
	tipmin2020=16.37;
	tipmin2021=16.78;
	tipmin2022=17.21;
	tipmin2023=17.63;
	tipmin2024=18.06;
	end;
	if pwpuma in (11500) then do; *Takoma - uses all of Pierce County;
	stmin2017=11.15;
	stmin2019=12.35;
	stmin2020=13.50;
	stmin2021=13.84;
	stmin2022=14.19;
	stmin2023=14.54;
	stmin2024=14.89;

	tipmin2017=11.15;
	tipmin2019=12.35;
	tipmin2020=13.50;
	tipmin2021=13.84;
	tipmin2022=14.19;
	tipmin2023=14.54;
	tipmin2024=14.89;
	end;
end;
run;

/* Ben did this in extract creation already - vars hasyouth_fam;
proc sort data=wage_mins0;
by serial famunit subfam; *year;
run;

proc sql;*nchild in ACS is kids of any age. Need to restrict to kids<18 - cps is only for reference family; 
      create table wage_mins as
      select *,max(child) as hasyouth
      from wage_mins0
      group by serial, famunit, subfam
	  order by serial, famunit, subfam, pernum; *need to add year if combining multiple acs years;
run;
*/

data wage_mins(drop=educd marst ind occ classwkrd empstatd poverty month pwpuma);
set wage_mins;
attrib tipped alone parent soleprovider length=3;

if (pwstate=&targetstate); ****LIMITS TO TARGET STATE for place-of-work;

pumac=put(puma,6.);

if (nchild>=1 and hasyouth_fam=1) then do;
	alone=0;
	parent=1;
  if(sex=1) then workpar='Work dad';
   else workpar='Work mom';
  if (1<=marst<=2) then childc='1Married parent    ';
   else do;
		childc="2Single parent     ";
		if(sex=1) then singpar='Single dad';
		 else singpar='single mom';
	end;
end;
else do;
  parent=0;
  if (1<=marst<=2) then do;
	childc="3Married, no kids  ";
	alone=0;
  end;
   else do;
	childc="4Unmarried, no kids";
	alone=1;
   end;
end;

 /*Education*/ 
if (2<=educd<62) then edc="1LT high school ";
	 else if (62<=educd<=64) then edc="2High School    ";
	 else if (65<=educd<=71) then edc="3Some col, no AA";
	 else if (81<=educd<=83) then edc="4AA degree      ";
	 else if (101<=educd) then edc="5Bachelor's+    ";
	 else edc=.;

 /*Household and family income*/
if (hhincome<25000) then hhinc='01Less than $25,000  ';
  else if (25000<=hhincome<50000) then hhinc='02$25,000 - $49,999  ';
  else if (50000<=hhincome<75000) then hhinc='03$50,000 - $74,999  ';
  else if (75000<=hhincome<100000) then hhinc='04$75,000 - $99,999  ';
  else if (100000<=hhincome<150000) then hhinc='05$100,000 - $149,999';
  else if (150000<=hhincome) then hhinc='06$150,000 or more   ';

if (ftotinc<25000) then faminc2='01Less than $25,000  ';
  else if (25000<=ftotinc<50000) then faminc2='02$25,000 - $49,999  ';
  else if (50000<=ftotinc<75000) then faminc2='03$50,000 - $74,999  ';
  else if (75000<=ftotinc<100000) then faminc2='04$75,000 - $99,999  ';
  else if (100000<=ftotinc<150000) then faminc2='05$100,000 - $149,999'  ;
  else if (150000<=ftotinc) then faminc2='06$150,000 or more   ';

if 0<poverty<=100 then povstat2='0In Poverty      ';
 else if 100<poverty<=200 then povstat2='101-200% poverty';
 else if 200<poverty<=400 then povstat2='201-400% poverty';
 else if 400<poverty then povstat2='400%+ poverty   ';
 else povstat2='Missing pov stat';

  /*Worker-only demographics*/
if(age>=16 and hrwage2>0 and 22<=classwkrd<=28 and 10<=empstatd<=12) then do; *begin worker block;
	worker=1;

	/*Sector*/
	if classwkrd=22 then sectc='For profit';
	 else if classwkrd=23 then sectc='Non-profit';
	 else if (24<=classwkrd<=28) then sectc='Government';
	 *else if classwkrd=25 then sectc='Federal government    ';
	 *else if (27<=classwkrd<=28) then sectc='State & local government    ';
	 else if sectc='Selfemp   ';

	 /*Work hours*/
	if (1<=uhrswork<20) then hourc="1Part time (< 20)";
	 else if (20<=uhrswork<35) then hourc="2Mid time (20-34)";
	 else if (uhrswork>=35) then hourc="3Full time (35+) ";

	/*Industry and occupation */ 

	if (170<=ind<=490) then do;
		indc="01Agro,fish,forest,mine ";
		MWexempt=1;
		end;
 	  else if ind=770 then indc="02Construction          ";
 	  else if (1070<=ind<=3990) then indc="04Manufacturing         ";    
 	  else if (4070<=ind<=4590) then indc="05Wholesale trade       ";
 	  else if (4670<=ind<=5790) then indc="06Retail trade          ";
 	  else if ((6070<=ind<=6390)|(570<=ind<=690)) then indc="07Transpo,warehouse,util";
 	  else if (6470<=ind<=6780) then indc="08Information           ";
 	  else if (6870<=ind<=7190) then indc="09Finance,insur,real est";
 	  else if (7270<=ind<=7570) then indc="10Prof,science,mgmt svcs";
 	  else if (7580<=ind<=7790) then indc="11Admin,support,waste   ";
 	  else if (7860<=ind<=7890) then indc="12Educational services  ";
 	  else if (7970<=ind<=8470) then indc="13Healthcare,social asst";
 	  else if (8560<=ind<=8590) then indc="14Arts,ent,rec services ";
 	  else if (8660<=ind<=8670) then indc="15Accommodation         ";
 	  else if (8680<=ind<=8690) then indc="16Restaurants           ";
 	  else if (8770<=ind<=9290) then indc="17Other services        ";
	  else if (9370<=ind<=9590) then indc="18Public administration ";
	  else if (9670<=ind<=9870) then indc="19Active Duty Military  ";
 	    else indc="20Missing/other         ";

		/*Detailed industries*/
	/*if (1070<=ind<=2390) then indcd="04.1Nondurable manufacturing   ";
 	  else if (2470<=ind<=3990) then indcd="04.2Durable manufacturing    ";*/
 	  /*else if ind=4970 then indcd="06.1Grocery stores      ";
 	  else if ind=7580 then indcd="11.1Employment services ";
 	  else if ind=7690 then indcd="11.2Building services   ";
 	  else if (7970<=ind<=8180) then indcd="13.1Ambulatory care     ";
	  else if (8270<=ind<=8470) then indcd="13.2Resid,soc,chld care ";
 	  else if ind=8190 then indcd="13.3Hospitals           ";
 	  *else if (8880<=ind<=9090) then indcd="17.1Personal services            ";
 	  *else if ind=9160 then indcd="17.2Religious organizations            ";
 	  *else if ind=9170 then indcd="17.3Civic,social,advocacy,giving                  ";
 	   else indcd=indc;*/

	if ((10<=occ<1000) or (occ=4465)) then occ_c='01Mgmt,biz,financial        ';
		else if (1005<=occ<2000) then occ_c='02Comp,engineering,sci      ';
		else if (2000<=occ<3000) then occ_c='03Ed,law,comm svc,arts,media';
		else if (3000<=occ<3600) then occ_c='04Healthcare and technical  ';
		else if (3600<=occ<4700) or (occ=9050) or (occ=9415) then occ_c='05Service occs              ';
		else if (4700<=occ<6000) then occ_c='06Sales,office & admin supp ';
		else if (6000<=occ<7700) then occ_c='07Extract,construct,maintain';
		else if (7700<=occ<9800) then occ_c='08Product,transport,mat move';
		else if (9800<=occ<9920) then occ_c='09Military                  ';
		else occ_c='10Missing/other             ';

		/*Detailed occupations*//*
	if (2000<=occ<2100) then occ_cd='03.1Community&social svcs   ';
		else if (2100<=occ<2200) then occ_cd='03.2Legal                   ';
		else if (2200<=occ<2600) then occ_cd='03.3Education               ';
		else if (2600<=occ<3000) then occ_cd='03.4Arts and media          ';
		else if (3600<=occ<3700) then occ_cd='05.1Healthcare support      ';
		else if (3700<=occ<4000) then occ_cd='05.2Protective services     ';
		else if (4000<=occ<4200) then occ_cd='05.3Food prep and serving   ';
		else if (4200<=occ<4300) then occ_cd='05.4Bldg & grounds mainten  ';
		else if (4300<=occ<4700) or occ=9050 or occ=9415 then occ_cd='05.5Personal care and svcs  ';
		else if (4700<=occ<5000) then occ_cd='06.1Sales and related       ';
		else if (5000<=occ<6000) then occ_cd='06.2Office & admin support  ';
		else occ_cd=occ_c;*/

	if (inctot>0 and ftotinc>0) then do;
	  if (ftotinc > inctot) then do;
			percent_inc = inctot/ftotinc;
			soleprovider = 0;
			end;
	     else do;
			percent_inc = 1;
			soleprovider = 1;
			end;
	end;

 /*Identify tipped workers*/
 if occ in (4040,4060,4110,4400,4500,4510,4520) then do;
	tipped=1; *removed massage therapists;
	tipc='1Tipped    ';
	end;
  else if (occ in (4120,4130) and ind in (8580,8590,8660,8670,8680,8690,8970,8980,8990,9090)) then do;
	tipped=1; 
	tipc='1Tipped    ';
	end;
  *added waiters, nonrestaurant, and dining room and cafeteria attendants and bartender helpers for select industries;
  else do;
	tipped=0;
	tipc='2Not tipped';
	end;

indirect_cutoff0 = stmin&year_data*1.15;
end; *end worker block;
run;

 *%cut(0); run;*initial wage distribution before first increase;

data wage_mins; *simulate life up to first increase;
set wage_mins;
if worker=1 then do;

 if (&growthdum=1) then do; 
	*hrwage2 = hrwage2*(((&monthstoincrease1/12)*(&wagegrowth1-1))+1);
	hrwage2 = hrwage2*(((&monthstoincrease1/12)*(avggrowth-1))+1); *This would use the state-specific avg of bottom 20pct from 2012-2017;
 end;
 /****Capture changes in state mins between data year and first year of simulation****/
 if (stmin&year_proposal1>stmin&year_data) then do; *in state where the minimum wage changed;
   if (tipped=0) then do;
  	 if (hrwage2<(stmin&year_proposal1*1.15)) then do;
	 	 if (hrwage2<stmin&year_data) then hrwage2=((hrwage2/stmin&year_data)*stmin&year_proposal1);
		 else if (stmin&year_data<=hrwage2<(stmin&year_proposal1*1.15)) then do;
			 if (hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2)))<stmin&year_proposal1 then hrwage2=stmin&year_proposal1;
			 else hrwage2=(hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2))); *if (hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2)))>=stmin&year_proposal1 then ;
		 end;
	 end;
   end; *end nontipped;
  else if (tipped=1) then do;
	if (tipmin&year_proposal1>tipmin&year_data) then do; *reg min changes, so does tipped min;
		if (2<hrwage2<tipmin&year_data) then hrwage2=((hrwage2/tipmin&year_data)*tipmin&year_proposal1);
		else if (tipmin&year_data<=hrwage2<stmin&year_data) then hrwage2=hrwage2+(tipmin&year_proposal1-tipmin&year_data);
		else if (stmin&year_data<=hrwage2<stmin&year_proposal1) then do;
			if (hrwage2+(tipmin&year_proposal1-tipmin&year_data))>stmin&year_proposal1 then hrwage2=hrwage2+(tipmin&year_proposal1-tipmin&year_data);
			else hrwage2=stmin&year_proposal1;
		end;
		else hrwage2=hrwage2;
	end; *end tip min changes;
	else do; *reg min changes, no change in tipped min;
		if hrwage2<stmin&year_data then hrwage2=((hrwage2/stmin&year_data)*stmin&year_proposal1);
		else if (stmin&year_data<=hrwage2<(stmin&year_proposal1)) then do;
			if (hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2)))<stmin&year_proposal1 then hrwage2=stmin&year_proposal1;
			else hrwage2=(hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2))); *if (hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2)))>=stmin&year_proposal1 then ;
		end;
		else hrwage2=hrwage2;
	end; *end no change tipped min;
  end; *end tipped;
 end; *end capture changes in state mins before first step;
end; *end worker block;
run;

data wage_mins; *now assess impact of first proposed increase;
set wage_mins;
attrib direct indirect affected directparent indirectparent length=3;
if worker=1 then do;

 wagecf=hrwage2; *establish initial counterfactual wage;

 raise=.;
 draise=.;
 iraise=.;

 indirect_cutoff1 = &newrate1*1.15; *Per Arins Frictions paper; 
 *indirect_cutoff1 = &newrate1 + (&newrate1 - stmin&year_proposal); * this cutoff changes with size of increase; 

if tipped in (0,1) then do;
	 * identify directly affected workers;
	 if (stmin&year_proposal1 < &newrate1) then do;* for workers in states with min below new rate;
	   if (((&lowercutoff*stmin&year_proposal1)) <=hrwage2< &newrate1) then do; 
		 direct=1; *if between old min and new direct=1;
	 		* Calc raise: first check if state min is now larger than wage;
			raise = max((&newrate1 - hrwage2),(.25*(indirect_cutoff1 - hrwage2)));
			if raise>(&newrate1 - stmin&year_proposal1) then raise = (&newrate1 - stmin&year_proposal1); *make sure no raises are larger than MW increase;
			draise=raise;
			end; *end direct check;
	   else direct=0;
	   end;
	 else direct=0;

	*Identify indirectly affected workers;
	if (stmin&year_proposal1 < &newrate1) then do;* for workers in states with min below new rate;
	  if (&newrate1 <= hrwage2 < indirect_cutoff1) then do;
	    indirect=1;
		raise = .25*(indirect_cutoff1 - hrwage2); *assumption is that indirectly affected workers will see their wages rise by 1/4 distance to the cutoff.;
		iraise=raise;
		end;
	  else indirect=0;
	  end;
	else indirect=0;
end;*tipped=0 block;
else if tipped=2 then do;
	 * identify directly affected workers;
	 if (tipmin&year_proposal1 < &tiprate1) then do;* for workers in states with tipmin below new rate;
	   if ((&lowercutoff*tipmin&year_proposal1) <=hrwage2< &newrate1) then do; 
		 direct=1; *if between old min and new direct=1;
	 		* Calc raise: first check if state min is now larger than wage;
			raise = &tiprate1-tipmin&year_proposal1;
			draise=raise;
			end;
	   else direct=0;
	   end;
	 else direct=0;

	*Identify indirectly affected workers;
	if (tipmin&year_proposal1 < &tiprate1) then do;* for workers in states with tipmin below new rate;
	  if (&newrate1 <= hrwage2) then do;
	    indirect=1;
		raise = (&tiprate1-tipmin&year_proposal1)*.5; 
		iraise=raise;
		end;
	  else indirect=0;
	  end;
	else indirect=0;
end;*tipped=1 block;

*EXCLUDE AG WORKERS*;
if MWexempt=1 then do;
	direct=0;
	indirect=0;
	end;

if (direct=1 and hrwage2>0) then p_incd = hrwage2*uhrswork*52; *adj_wkswork1;
if (indirect=1 and hrwage2>0) then p_inci=hrwage2*uhrswork*52; *adj_wkswork1;
if ((direct=1 or indirect=1) and hrwage2>0) then p_inca=hrwage2*uhrswork*52; *adj_wkswork1;

if (direct=1 and parent=1) then directparent=1;
if (indirect=1 and parent=1) then indirectparent=1;

if direct=1 or indirect=1 then affected=1;
else affected=0;

wagecfa=wagecf*affected;
wagecfd=wagecf*direct;
wagecfi=wagecf*indirect;
wagea=hrwage2*affected;
waged=hrwage2*direct;
wagei=hrwage2*indirect;

wagebill = raise*uhrswork*52;*adj_wkswork1; * stimulus effect of increase.  NOTE: ACS uses Predicted weeks worked, not 52 as in CPS;
dwagebill = draise*uhrswork*52;*adj_wkswork1; *just for directly affected;
iwagebill = iraise*uhrswork*52;*adj_wkswork1; *just for indirectly affected;

annwagecf=wagecf*uhrswork*52; *adj_wkswork1;
annwagecfa=annwagecf*affected;
annwagecfd=annwagecf*direct;
annwagecfi=annwagecf*indirect;

if wagebill>0 then annraise=wagebill;
else annraise=0;

if (direct) then do;
  directpct = direct*percent_inc;
  totalpct=directpct;
end;
if (indirect) then do;
  indirectpct = indirect*percent_inc;
  totalpct=indirectpct;
end;
end; *workers loop;

statec=put(statefips,statef.);
run;

*%cut(1);run;

data wage_mins;
set wage_mins;
if annraise<=0 then annraise=.;
if wagebill<=0 then wagebill=.; 
if annwagecf<=0 then annwagecf=.;
if annwagecfa<=0 then annwagecfa=.;
if annwagecfd<=0 then annwagecfd=.;
if annwagecfi<=0 then annwagecfi=.;
if wagea<=0 then wagea=.;
if waged<=0 then waged=.;
if wagei<=0 then wagei=.;

if wagea>0 then do;
dwagea=(wagea+raise)-wagecfa;
danninc=dwagea*uhrswork*52; *adj_wkswork1;
end;
if waged>0 then do;
dwaged=(waged+draise)-wagecfd;
dannincd=dwaged*uhrswork*52; *adj_wkswork1;
end;
if wagei>0 then do;
dwagei=(wagei+iraise)-wagecfi;
danninci=dwagei*uhrswork*52; *adj_wkswork1;
end;
run;


%macro calcfirst(yr);
/*Calculate total figures for directly and indirectly affected, wage bill, stimulus*/
* Find total number of people directly + ind affected;

proc means data=wage_mins(where=&conds) noprint; 
var pop direct indirect annwagecf dwagebill iwagebill wagebill danninc annwagecfa annwagecfd annwagecfi dannincd danninci dwagea dwaged dwagei;
weight perwt2;
*by state;
output out=a (drop=_type_ mpop sdwagea sdwaged sdwagei) sum=pop direct indirect annwagecf dwagebill iwagebill wagebill danninc annwagecfa annwagecfd annwagecfi dannincd danninci sdwagea sdwaged sdwagei
								mean=mpop mdirect mindirect mannwagecf mDraise mIraise mraise mdanninc mannwagecfa mannwagecfd mannwagecfi mdannincd mdanninci mdwagea mdwaged mdwagei;
run;

data a;
set a;
year=&yr;
total=direct+indirect;
sharecat=total/pop;
run;
*Create a dataset to combine other datasets to,
 standardize category variable name to be <categ>;
data combined;
set a;
run;
%mend;

%calcfirst(&year_proposal1);run;

*This macro inputs a category name and creates statistics for
the resulting categories, then adds them to dataset <combined>
pop is the total number in categ, direct is the number directly affected;
%macro combine(type);
  proc means data=wage_mins(where=&conds) noprint;
  var pop direct indirect annwagecf dwagebill iwagebill wagebill danninc annwagecfa annwagecfd annwagecfi dannincd danninci dwagea dwaged dwagei;
  weight perwt2;
  class &type;
  *by state;
  output out=temp (drop=_type_ mpop sdwagea sdwaged sdwagei) sum=pop direct indirect annwagecf dwagebill iwagebill wagebill danninc annwagecfa annwagecfd annwagecfi dannincd danninci sdwagea sdwaged sdwagei
									 mean=mpop mdirect mindirect mannwagecf mDraise mIraise mraise mdanninc mannwagecfa mannwagecfd mannwagecfi mdannincd mdanninci mdwagea mdwaged mdwagei;

  data temp;
  set temp;
  if _n_=1 then delete; *remove first obs which has total number;
  rename &type = categ; *rename type variable to match combined; 
  	total=direct+indirect;
	sharecat=total/pop;

  data combined;
  set combined temp;
%mend combine;
run;

*Run the combine macro on the following categories: age, race, parent, family income;

	%combine(sexc);
		%combine(agec3);
		%combine(agec1);
		%combine(agec2);
		%combine(rc);
		%combine(pocc);
		%combine(childc);
		*%combine(hhinc);
		%combine(hourc);
		%combine(edc);
		%combine(indc);
		*%combine(occ_c);
		%combine(sectc);
		%combine(faminc2);
		%combine(povstat2);
		%combine(tipc);
		%combine(statec);
		/*%combine(workpar);
		*%combine(singpar);
		*%combine(vetc);*/
run;

%macro kids();
/* PARENTS AFFECTED BY INCREASE */

*Create a variable thats 1 if any parent is min wage worker;
proc sql;
      create table orgkids as
      select *,max(directparent) as parentsdirect
      from wage_mins(where=(&kconds))
      group by serial; *could also group by famunit, rather than just HH;

proc sql;
      create table orgkids2 as
      select *,max(indirectparent) as parentsindirect
      from orgkids
      group by serial;*could also group by famunit, rather than just HH;

/*
proc sort data=orgkids2;
by state;
run;
*/
*count children with directly affected parent;*had to separate out into three separate means bc we were double counting children with both directly and indirectly affected parents;
proc means data=orgkids2 noprint; *(where=(age<18));
var child;
weight perwt2;
*by state;
output out=children (drop=_type_) sum=pop;
run;
proc means data=orgkids2 (where=(parentsdirect=1 and parentsindirect ne 1)) noprint;
var child;
weight perwt2;
*by state;
output out=children2 (drop=_type_ _freq_) sum=direct;
run;
proc means data=orgkids2 (where=(parentsindirect=1 and parentsdirect ne 1)) noprint;
var child;
weight perwt2;
*by state;
output out=children3 (drop=_freq_ _type_) sum=indirect;
run;
/*
proc sort data=children;
by state;
run;
proc sort data=children2;
by state;
run;
proc sort data=children3;
by state;
run;
*/
data children;
merge children children2 children3;
categ = 'children';
*by state;
run;
/*
proc sort data=combined;
by state;
run;
*/
data combined;
set combined children;
*by state;
run;
%mend;

*%kids;run;

%macro famincsole(i);
/*Calculating percentage of family income contributed by mw worker*/

proc means data=wage_mins(where=(&conds & (direct=1 | indirect=1) & alone=0)) noprint; *all affected;
var percent_inc soleprovider;
weight perwt2;
*by state;
output out=affectpercentall (drop=_type_) mean= ampercent_inc amsole;
run;

proc means data=wage_mins(where=(&conds & (direct=1 | indirect=1) & (directparent=1 | indirectparent=1) & alone=0)) noprint; *all affected parents;
var percent_inc soleprovider;
weight perwt2;
*by state;
output out=affectpercentrents (drop=_type_) mean= pmpercent_inc pmsole;
run;

data affectedincome&i;
set affectpercentall affectpercentrents;
*by state;
run;
%mend;

*%famincsole(1);run;

/*state breakdown*/
/*
proc means data=wage_mins(where=(&conds)) noprint;
  var pop direct indirect wagebill;
  weight perwt2;
  class state;
  output out=states (drop=_type_) sum=pop direct indirect wagebill mean=mpop mdirect mindirect mwagebill;
*/
/* EXPORT THE DATA */
data year1;
format categ _FREQ_ pop direct mdirect indirect mindirect total sharecat dwagebill mDraise annwagecfd mannwagecfd dannincd mdannincd mdwaged 
		iwagebill mIraise annwagecfi mannwagecfi danninci mdanninci mdwagei wagebill mraise annwagecfa mannwagecfa danninc mdanninc mdwagea annwagecf mannwagecf ;
set combined;
run;

PROC EXPORT DATA= year1
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="Year1"; 
RUN;
/*
PROC EXPORT DATA= affectedincome1
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="Income year1"; 
RUN;



PROC EXPORT DATA= states
			OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="states year1"; 
RUN;
*/

/******************Macro start for subsequent steps*********************/

%macro iterateMW();
%do n=2 %to &numsteps;
	%let m=%eval(&n-1);

	proc delete data=combined;
	*proc delete data=year1;
	*proc delete data=bystate1;
	proc delete data=a;
	proc delete data=temp;
	*proc delete data=orgkids;
	*proc delete data=orgkids2;
	*proc delete data=children;
	*proc delete data=affectpercentall;
	*proc delete data=affectpercentrents;
	*proc delete data=directout;
	*proc delete data=indirectout;
	*proc delete data=states;
	run;

	/* Re-estimate wage and job growth over period since previous step-increase in MW */

	* Input most recent data;
	data wage_mins (drop=raise draise iraise dwagebill iwagebill direct indirect affected wagebill directpct indirectpct totalpct percent_inc 
		soleprovider wagea waged wagei wagecfd wagecfi wagecfa dwagea dwagei dwaged danninc annwagecf annwagecfd annwagecfi annwagecfa dannincd danninci);
	 set wage_mins;

	 if(raise>0) then do;
		hrwage2 = (hrwage2 + raise); /*((0.5*((&&monthstoincrease&n/12)*(&&wagegrowth&n-1)))+1); *apply the raise - only raise, no additional wage growth;*/
		wagecf = wagecf*(((&&monthstoincrease&n/12)*(&&wagegrowth&n-1))+1);
		end;
	 else do;
		hrwage2=hrwage2*(((&&monthstoincrease&n/12)*(&&wagegrowth&n-1))+1);
		wagecf=wagecf*(((&&monthstoincrease&n/12)*(&&wagegrowth&n-1))+1);
	 end;

	 if directparent=1 then directparent=0;
	 if indirectparent=1 then indirectparent=0;
	 if direct=1 then direct=0;
	 if indirect=1 then indirect=0;
	 if affected=1 then affected=0;

	if _race=1 then do;
		perwt2=perwt2*(((&&monthstoincrease&n/12)*(&popgrowthw-1))+1);
		end;
	  else if _race=2 then do;
		perwt2=perwt2*(((&&monthstoincrease&n/12)*(&popgrowthb-1))+1);
		end;
	  else if _race=3 then do;
		perwt2=perwt2*(((&&monthstoincrease&n/12)*(&popgrowthh-1))+1);
		end;
	  else if _race=4 then do;
		perwt2=perwt2*(((&&monthstoincrease&n/12)*(&popgrowtha-1))+1);
		end;
	  else do;
		perwt2=perwt2*(((&&monthstoincrease&n/12)*(&popgrowtho-1))+1);
		end;
	run;

	data wage_mins;
	set wage_mins;

  /***account for scheduled increases between each proposal year***/
	if(stmin&&year_proposal&n>stmin&&year_proposal&m) then do; 
	 if (tipped=0) then do;
		if (hrwage2<(stmin&&year_proposal&n*1.15)) then do;*MW-affected wage;
			if (hrwage2<stmin&&year_proposal&m) then hrwage2=((hrwage2/stmin&&year_proposal&m)*stmin&&year_proposal&n);
		  	else if (stmin&&year_proposal&m<=hrwage2<(stmin&&year_proposal&n*1.15)) then do;
				if (hrwage2+(0.25*((stmin&&year_proposal&n*1.15)-hrwage2)))<stmin&&year_proposal&n then hrwage2=stmin&&year_proposal&n;
			  	else hrwage2=(hrwage2+(0.25*((stmin&&year_proposal&n*1.15)-hrwage2))); *if (hrwage2+(0.25*((stmin&&year_proposal&n*1.15)-hrwage2)))>=stmin&&year_proposal&n then;
		  	end;
	 	end;
	 	if (wagecf<(stmin&&year_proposal&n*1.15)) then do; *counterfactual wage;
			if (wagecf<stmin&&year_proposal&m) then wagecf=((wagecf/stmin&&year_proposal&m)*stmin&&year_proposal&n);
			else if (stmin&&year_proposal&m<=wagecf<(stmin&&year_proposal&n*1.15)) then do;
				if (wagecf+(0.25*((stmin&&year_proposal&n*1.15)-wagecf)))<stmin&&year_proposal&n then wagecf=stmin&&year_proposal&n;
				else wagecf=(wagecf+(0.25*((stmin&&year_proposal&n*1.15)-wagecf))); * if (wagecf+(0.25*((stmin&&year_proposal&n*1.15)-wagecf)))>=stmin&&year_proposal&n then;
			end;
	 	end;
	 end; *end non-tipped;
	 else if (tipped=1) then do; 
	 	if (tipmin&&year_proposal&n>tipmin&&year_proposal&m) then do; *reg min changes, so does tipped min;
			if (hrwage2<tipmin&&year_proposal&m) then wage=((hrwage2/tipmin&&year_proposal&m)*tipmin&&year_proposal&n);
			 else if (tipmin&&year_proposal&m<=hrwage2<stmin&&year_proposal&m) then hrwage2=hrwage2+(tipmin&&year_proposal&n-tipmin&&year_proposal&m);
			 else if (stmin&&year_proposal&m<=hrwage2<stmin&&year_proposal&n) then do;
				if (hrwage2+(tipmin&&year_proposal&n-tipmin&&year_proposal&m))>stmin&&year_proposal&n then hrwage2=hrwage2+(tipmin&&year_proposal&n-tipmin&&year_proposal&m);
				else hrwage2=stmin&&year_proposal&n;
			 end;
			 else hrwage2=hrwage2;

			if (wagecf<tipmin&&year_proposal&m) then wagecf=((wagecf/tipmin&&year_proposal&m)*tipmin&&year_proposal&n);
			else if (tipmin&&year_proposal&m<=wagecf<stmin&&year_proposal&m) then wagecf=wagecf+(tipmin&&year_proposal&n-tipmin&&year_proposal&m);
			else if (stmin&&year_proposal&m<=wagecf<stmin&&year_proposal&n) then do;
				if (wagecf+(tipmin&&year_proposal&n-tipmin&&year_proposal&m))>stmin&&year_proposal&n then wagecf=wagecf+(tipmin&&year_proposal&n-tipmin&&year_proposal&m);
				else wagecf=stmin&&year_proposal&n;
			end;
			else wagecf=wagecf;
	 	end; *end tip min change;
	 	else do; *reg min changes, no change in tipped min;
			if hrwage2<stmin&&year_proposal&m then hrwage2=((hrwage2/stmin&&year_proposal&m)*stmin&&year_proposal&n);
			else if (stmin&&year_proposal&m<=hrwage2<(stmin&&year_proposal&n)) then do;
				if (hrwage2+(0.25*((stmin&&year_proposal&n*1.15)-hrwage2)))<stmin&&year_proposal&n then hrwage2=stmin&&year_proposal&n;
				else hrwage2=(hrwage2+(0.25*((stmin&&year_proposal&n*1.15)-hrwage2))); *if (hrwage2+(0.25*((stmin&year_proposal1*1.15)-hrwage2)))>=stmin&year_proposal1 then ;
			end;
			else hrwage2=hrwage2;

			if wagecf<stmin&&year_proposal&m then wagecf=((wagecf/stmin&&year_proposal&m)*stmin&&year_proposal&n);
			else if (stmin&&year_proposal&m<=wagecf<(stmin&&year_proposal&n)) then do;
				if (wagecf+(0.25*((stmin&&year_proposal&n*1.15)-wagecf)))<stmin&&year_proposal&n then wagecf=stmin&&year_proposal&n;
				else wagecf=(wagecf+(0.25*((stmin&&year_proposal&n*1.15)-wagecf))); *if (wage+(0.25*((stmin&year_proposal1*1.15)-wage)))>=stmin&year_proposal1 then ;
			end;
			else wagecf=wagecf;
		end; *end no change in tipped min;
	 end; *end tipped;
	end;*end change in state min between steps;
	else do;
		hrwage2=hrwage2;
		wagecf=wagecf;
	end;
	run;
	

	data wage_mins;
	set wage_mins;

	raise=.;
	draise=.; *new;
	iraise=.; *new;

	*worker=0;

	if (inctot>0 and ftotinc>0) then do;
	  if (ftotinc > inctot) then do;
			percent_inc = inctot/ftotinc;
			soleprovider = 0;
			end;
	     else do;
			percent_inc = 1;
			soleprovider = 1;
			end;
	end;

	*if(age>=16 and hrwage2>0 and 1<=pemlr<=2) then do;
	if (worker=1) then do;

	  indirect_cutoff&n = &&newrate&n*1.15; /*Per Dube frictions paper;*/
	 *indirect_cutoff&n = &&newrate&n + (&&newrate&n - &&newrate&m);

	 if tipped in (0,1) then do;
		 * identify directly affected workers;
		 if (stmin&&year_proposal&n < &&newrate&n) then do;* for workers in states with min below new rate;
		   if (((&lowercutoff*stmin&&year_proposal&n)) <=hrwage2< &&newrate&n) then do; 
			 direct=1; *if between old min and new direct=1;
		 		* Calc raise: first check if state min is now larger than wage;
				raise = max((&&newrate&n - hrwage2),(.25*(indirect_cutoff&n - hrwage2)));
				if raise>(&&newrate&n - stmin&&year_proposal&n) then raise = (&&newrate&n - stmin&&year_proposal&n); *make sure no raises are larger than MW increase;
				if (hrwage2+raise)<wagecf then raise=(wagecf-hrwage2)+0.01; *prevent higher wage in counterfactual, adds 1 cent to keep them in affected sample for wage calcs;
				draise=raise;
				end;
		   else direct=0;
		   end;
		 else direct=0;

		*Identify indirectly affected workers;
		if (stmin&&year_proposal&n < &&newrate&n) then do;* for workers in states with min below new rate;
		  if (&&newrate&n <= hrwage2 < indirect_cutoff&n) then do;
		    indirect=1;
			raise = .25*(indirect_cutoff&n - hrwage2); *assumption is that indirectly affected workers will see their wages rise by 1/4 distance to the cutoff.;
			if (hrwage2+raise)<wagecf then raise=(wagecf-hrwage2)+0.01; *prevent higher wage in counterfactual, adds 1 cent to keep them in affected sample for wage calcs;
			iraise=raise;
			end;
		  else indirect=0;
		  end;
		else indirect=0;
	end;*tipped=0 block;
	else if tipped=2 then do;
		 * identify directly affected workers;
		 if (tipmin&&year_proposal&n < &&tiprate&n) then do;* for workers in states with tipmin below new rate;
		   if ((&lowercutoff*tipmin&&year_proposal&n) <=hrwage2< &&newrate&n) then do; 
			 direct=1; *if between old min and new direct=1;
		 		* Calc raise: first check if state min is now larger than wage;
				raise = min(&&tiprate&n-tipmin&&year_proposal&n, &&tiprate&n-&&tiprate&m);
				if (hrwage2+raise)<wagecf then raise=(wagecf-hrwage2)+0.01; *prevent higher wage in counterfactual, adds 1 cent to keep them in affected sample for wage calcs;
				draise=raise;
				end;
		   else direct=0;
		   end;
		 else direct=0;

		*Identify indirectly affected workers;
		if (tipmin&&year_proposal&n < &&tiprate&n) then do;* for workers in states with tipmin below new rate;
		  if (&&newrate&n <= hrwage2) then do;
		    indirect=1;
			raise = (min(&&tiprate&n-tipmin&&year_proposal&n, &&tiprate&n-&&tiprate&m))*.5; 
			if (hrwage2+raise)<wagecf then raise=(wagecf-hrwage2)+0.01; *prevent higher wage in counterfactual, adds 1 cent to keep them in affected sample for wage calcs;
			iraise=raise;
			end;
		  else indirect=0;
		  end;
		else indirect=0;
	end;*tipped=1 block;

*EXCLUDE AG WORKERS*;
if MWexempt=1 then do;
	direct=0;
	indirect=0;
	end;

	if (direct=1 and hrwage2>0) then p_incd = hrwage2*uhrswork*52; *adj_wkswork1;
	if (indirect=1 and hrwage2>0) then p_inci=hrwage2*uhrswork*52; *adj_wkswork1;

	if (direct=1 and parent=1) then directparent=1; *ownchld>0;
	if (indirect=1 and parent=1) then indirectparent=1; *ownchld>0;

	if direct=1 or indirect=1 then affected=1;
	else affected=0;


		wagecfa=wagecf*affected;
		wagecfd=wagecf*direct;
		wagecfi=wagecf*indirect;
		wagea=hrwage2*affected;
		waged=hrwage2*direct;
		wagei=hrwage2*indirect;

		wagebill = raise*uhrswork*52; *adj_wkswork1; * stimulus effect of increase.  DC (10/3/11): Should this be 50 weeks or 52??;
		dwagebill = draise*uhrswork*52;*adj_wkswork1; *just for directly affected;
		iwagebill = iraise*uhrswork*52;*adj_wkswork1; *just for indirectly affected;

		annwagecf=wagecf*uhrswork*52; *adj_wkswork1;
		annwagecfa=annwagecf*affected;
		annwagecfd=annwagecf*direct;
		annwagecfi=annwagecf*indirect;

		if wagebill>0 then annraise=wagebill;
		else annraise=0;


	if (direct) then do;
	  directpct = direct*percent_inc;
	  totalpct=directpct;
	end;
	if (indirect) then do;
	  indirectpct = indirect*percent_inc;
	  totalpct=indirectpct;
	end;

	end; *workers loop;
	run;
%if &n=&numsteps %then %do;
	*%cut(&n);run;
%end;
	data wage_mins;
	set wage_mins;

		if annraise<=0 then annraise=.; 
		if wagebill<=0 then wagebill=.; 
		if dwagebill<=0 then dwagebill=.;
		if iwagebill<=0 then iwagebill=.;
		if annwagecf<=0 then annwagecf=.;
		if annwagecfa<=0 then annwagecfa=.;
		if annwagecfd<=0 then annwagecfd=.;
		if annwagecfi<=0 then annwagecfi=.;
		if wagea<=0 then wagea=.;
		if waged<=0 then waged=.;
		if wagei<=0 then wagei=.;

		dwagea=(wagea+raise)-wagecfa;
		danninc=dwagea*uhrswork*52; *adj_wkswork1;
		dwaged=(waged+draise)-wagecfd;
		dannincd=dwaged*uhrswork*52; *adj_wkswork1;
		dwagei=(wagei+iraise)-wagecfi;
		danninci=dwagei*uhrswork*52; *adj_wkswork1;

		if dwagea<=0 then dwagea=.;*new;*changed to 0 from .;
		if dwaged<=0 then dwaged=.;*new;*changed to 0 from .;
		if dwagei<=0 then dwagei=.;*new;*changed to 0 from .;
		if danninc<=0 then danninc=.;*new;*changed to 0 from .;
		if dannincd<=0 then dannincd=.;*new;*changed to 0 from .;
		if danninci<=0 then danninci=.;*new;*changed to 0 from .;

	run;

	%calcfirst(&&year_proposal&n);run; *establish initial total statistics and combined dataset;

	*Run the combine macro on the various demographic categories: age, race, parent, family income,etc;
	%combine(sexc);
		%combine(agec3);
		%combine(agec1);
		%combine(agec2);
		%combine(rc);
		%combine(pocc);
		%combine(childc);
		*%combine(hhinc);
		%combine(hourc);
		%combine(edc);
		%combine(indc);
		*%combine(occ_c);
		%combine(sectc);
		%combine(faminc2);
		%combine(povstat2);
		%combine(tipc);
		%combine(statec);
		/*%combine(workpar);
		*%combine(singpar);
		*%combine(vetc);*/
	run;
	
	data year&n;
	format categ _FREQ_ pop direct mdirect indirect mindirect total sharecat dwagebill mDraise annwagecfd mannwagecfd dannincd mdannincd mdwaged 
		iwagebill miraise annwagecfi mannwagecfi danninci mdanninci mdwagei wagebill mraise annwagecfa mannwagecfa danninc mdanninc mdwagea annwagecf mannwagecf;
	set combined;
	run;

	PROC EXPORT DATA= year&n
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="Year&n"; 
	RUN;

%if &n=&numsteps %then %do;
	%famincsole(&n);run; *Calculating percentage of family income contributed by mw worker;

	PROC EXPORT DATA= affectedincome&n
	            OUTFILE= &outfile
	            DBMS=XLSX REPLACE;
	     SHEET="Income year&n"; 
	RUN;
%end;

%end;
%mend;

%iterateMW; run;

%let conds=(worker=1 and statefips=&targetstate);

	proc delete data=a;run;
	proc delete data=combined;run;

	%calcfirst(&&year_proposal&numsteps);run;
	%combine(sexc);
		%combine(agec3);
		%combine(agec1);
		%combine(agec2);
		%combine(rc);
		%combine(pocc);
		%combine(childc);
		*%combine(hhinc);
		%combine(hourc);
		%combine(edc);
		%combine(indc);
		*%combine(occ_c);
		%combine(sectc);
		%combine(faminc2);
		%combine(povstat2);
		%combine(tipc);
		%combine(statec);
		/*%combine(workpar);
		*%combine(singpar);
		*%combine(vetc);*/
run;
data residents;
	format categ _FREQ_ pop direct mdirect indirect mindirect total sharecat dwagebill mDraise annwagecfd mannwagecfd dannincd mdannincd mdwaged 
		iwagebill miraise annwagecfi mannwagecfi danninci mdanninci mdwagei wagebill mraise annwagecfa mannwagecfa danninc mdanninc mdwagea annwagecf mannwagecf;
	set combined;
	run;

	PROC EXPORT DATA= residents
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="Residents_only"; 
	RUN;

	/*
data acs.wage_minsBH(compress=yes);
set wage_mins (drop=stmin2017 stmin2019 stmin2020 stmin2021 stmin2022 stmin2023 stmin2024 tipmin2017 tipmin2019
	tipmin2020 tipmin2021 tipmin2022 tipmin2023 tipmin2024);
run;

PROC EXPORT DATA= cutout
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="cuts"; 
RUN;

PROC EXPORT DATA= freqout
            OUTFILE= &outfile
            DBMS=XLSX REPLACE;
     SHEET="freq_table"; 
RUN;
*/


