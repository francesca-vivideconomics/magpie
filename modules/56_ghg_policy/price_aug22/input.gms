*** |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

* Set-switch for countries affected by regional ghg policy
* Default: all iso countries selected
sets
  policy_countries56(iso) countries to be affected by tier 1 ghg policy / ALA,AUS,AUT,BEL,BGR,CAN,CHN,CYP,EST,ESP,GBR,
                               FRA,FRO,GGY,HUN,GIB,GRC,HRV,IMN,
                               IRL,JEY,LTU,MLT,NLD,POL,PRT,ROU,
                               AND,ISL,LIE,MCO,SJM,SMR,VAT,ALB,
                               BIH,MKD,MNE,SRB,TUR,GRL,HKG,TWN,
                               CZE,DEU,DNK,ITA,LUX,LVA,SVK,SVN,
                               SWE,SWZ,JPN,KOR,FIN,NOR,USA,NZL,
                               PRK,SPM /


  policy_countries_t2_56(iso) countries to be affected by tier 2 ghg policy / AUS,BRA,CHN,KOR,USA,VNM /
;

scalars
  s56_limit_ch4_n2o_price upper limit for CH4 and N2O GHG prices (USD05MER per tC) / 4000 /
  s56_cprice_red_factor reduction factor for CO2 price (-) / 1 /
  s56_minimum_cprice Minium C price for future time steps (USD per tC) / 0 /
  s56_ghgprice_devstate_scaling Switch for scaling GHG price with development state (1=on 0=off) / 0 /
  s56_c_price_induced_aff Switch for C price driven afforestation (1=on 0=off) / 1 /
  s56_c_price_exp_aff c price expectation for afforestation (years) / 50 /
  s56_buffer_aff share of carbon credits for afforestation projects pooled in a buffer (1) / 0.2 /
  s56_counter counter for C price interpolation (1) / 0 /
  s56_timesteps number of time steps for C price interpolation (1) / 0 /
  s56_offset helper for C price interpolation (1) / 0 /
;

* FV added tiers to carbon pricing
* $setglobal c56_pollutant_prices  R21M42-SSP2-NPi
* $setglobal c56_pollutant_prices_noselect  R21M42-SSP2-NPi

$setglobal c56_pollutant_prices_tier1  fps_developed
$setglobal c56_pollutant_prices_tier2  fps_developing
$setglobal c56_pollutant_prices_tier3  fps_developing
$setglobal c56_emis_policy  redd+natveg_nosoil
$setglobal c56_cprice_aff  forestry_vegc
$setglobal c56_mute_ghgprices_until  y2025

$setglobal c56_carbon_stock_pricing  actualNoAcEst
*   options:  actual, actualNoAcEst

table f56_pollutant_prices(t_all,i,pollutants,ghgscen56) GHG certificate prices for N2O-N CH4 CO2-C (USD05MER per t)
$ondelim
$include "./modules/56_ghg_policy/input/f56_pollutant_prices.cs3"
$offdelim
;

$if "%c56_pollutant_prices%" == "coupling" table f56_pollutant_prices_coupling(t_all,i,pollutants) Regional ghg certificate prices for N2O-N CH4 CO2-C (USD05MER per t)
$if "%c56_pollutant_prices%" == "coupling" $ondelim
$if "%c56_pollutant_prices%" == "coupling" $include "./modules/56_ghg_policy/input/f56_pollutant_prices_coupling.cs3"
$if "%c56_pollutant_prices%" == "coupling" $offdelim
$if "%c56_pollutant_prices%" == "coupling" ;

$if "%c56_pollutant_prices%" == "emulator" table f56_pollutant_prices_emulator(t_all,i,pollutants) Global ghg certificate prices for N2O-N CH4 CO2-C (USD05MER per t)
$if "%c56_pollutant_prices%" == "emulator" $ondelim
$if "%c56_pollutant_prices%" == "emulator" $include "./modules/56_ghg_policy/input/f56_pollutant_prices_emulator.cs3"
$if "%c56_pollutant_prices%" == "emulator" $offdelim
$if "%c56_pollutant_prices%" == "emulator" ;

* f56_emis_policy contains scenarios determining for each gas and source whether it is priced or not

table f56_emis_policy(scen56,pollutants_all,emis_source) GHG emission policy scenarios (1)
$ondelim
$include "./modules/56_ghg_policy/input/f56_emis_policy.csv"
$offdelim
;
