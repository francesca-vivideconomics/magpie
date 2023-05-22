*** |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
*** |  authors, and contributors see CITATION.cff file. This file is part
*** |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
*** |  AGPL-3.0, you are granted additional permissions described in the
*** |  MAgPIE License Exception, version 1.0 (see LICENSE file).
*** |  Contact: magpie@pik-potsdam.de

$setglobal c22_protect_scenario  BH
$setglobal c22_protect_scenario_noselect  none

scalars
s22_restore_land  If land restoration is allowed (0=no 1=yes) / 1 /
s22_conservation_start    Land conservation start year        / 2025 /
s22_conservation_target   Land conservation target year       / 2035 /
;

* Set-switch for countries affected by regional land conservation policy
* Default: all iso countries selected
sets
  policy_countries22(iso) countries to be affected by land conservation policy
                        / ALA,AUS,AUT,BEL,BGR,CAN,CHN,CYP,EST,ESP,GBR,
                               FRA,FRO,GGY,HUN,GIB,GRC,HRV,IMN,
                               IRL,JEY,LTU,MLT,NLD,POL,PRT,ROU,
                               AND,ISL,LIE,MCO,SJM,SMR,VAT,ALB,
                               BIH,MKD,MNE,SRB,TUR,GRL,HKG,TWN,
                               CZE,DEU,DNK,ITA,LUX,LVA,SVK,SVN,
                               SWE,SWZ,JPN,KOR,FIN,NOR,USA,NZL,
                               PRK,SPM /
;

table f22_wdpa_baseline(t_all,j,land) Initial protected area as derived from WDPA until 2020 (mio. ha)
$ondelim
$include "./modules/22_land_conservation/input/wdpa_baseline.cs3"
$offdelim
;
* fix to 2020 values for years after 2020
m_fillmissingyears(f22_wdpa_baseline,"j,land");

table f22_consv_prio(j,consv_prio22,land) Conservation priority areas (mio. ha)
$ondelim
$include "./modules/22_land_conservation/input/consv_prio_areas.cs3"
$offdelim
;

