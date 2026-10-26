********************************************************************************
$ontext
Optimierungsmodell im Rahmen des Forschungsprojekts Quartier Opt.
Oktober 2026.
Written by Tim Rauschmeier, Jonas Egerer, and Johannes Spies.
This work is licensed under the MIT License (MIT).
For more information on this license, visit http://opensource.org/licenses/mit-license.php.
Whenever you use this code, please refer to https://www.zukunftbau.de/projekte/forschungsfoerderung/1008187-2335.
$offtext
********************************************************************************

***--------------------------------------------------------------------------***
***                                        MODEL                             ***
***--------------------------------------------------------------------------***
$onImplicitAssign

$Setglobal  Date                00000000

* Choose quarter
$Setglobal  MFH                "*" 
$Setglobal  WERDERAU           "" 
$Setglobal  BRUCK              "*"
$Setglobal  HERZOBASE          "*" 

* Choose scenario for model run: Benchmark, Inflex
$Setglobal  Scenario            Benchmark

* Choose building standard for MFH: KfW55, GEG2020, WSchV77
* Choose building or whole quarter for WERDERAU: Werderau, WerderauL6, WerderauL8, WerderauL357, WerderauL101224, WerderauL161810, WerderauL222426, WerderauP1214, WerderauP1618, WerderauP2022
* Choose building or whole quarter for BRUCK: BRUCK, BRUCKRG, BRUCKTG01, BRUCKTG02, BRUCKTG03, BRUCKTG04
$Setglobal  Building            Werderau

* Choose building orientation for MFH: NordSued, OstWest
$Setglobal  Orientation   NordSued     

* Check with "*" if include charges
$Setglobal  Charges             "*"

* Choose HP scenario: Volllast, Teillast
$setglobal Heatpump             Teillast



***--------------------------------------------------------------------------***
***                             GENERAL OPTIONS                              ***
***--------------------------------------------------------------------------***

option  optcr = 0.000000001
        limrow = 0,
        limcol = 0,
        solprint = on,
        sysout = on,
        QCP = Gurobi,
        LP = Gurobi
;

***--------------------------------------------------------------------------***
***                            LOAD DATA AND SETUP                           ***
***--------------------------------------------------------------------------***

$include 02_Sets_Parameters.gms

%MFH%$call csv2gdx data/data_generation_pv_%Orientation%.txt id=dataload_pv Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%MFH%$gdxin input.gdx
%MFH%$load dataload_pv
%MFH%$gdxin

%WERDERAU%$call csv2gdx data/data_generation_pv_%Building%.txt id=dataload_pv Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%WERDERAU%$gdxin input.gdx
%WERDERAU%$load dataload_pv
%WERDERAU%$gdxin

%BRUCK%$call csv2gdx data/data_generation_pv_%Building%.txt id=dataload_pv Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%BRUCK%$gdxin input.gdx
%BRUCK%$load dataload_pv
%BRUCK%$gdxin

%HERZOBASE%$call csv2gdx data/data_generation_pv_Herzobase1Geb.txt id=dataload_pv Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%HERZOBASE%$gdxin input.gdx
%HERZOBASE%$load dataload_pv
%HERZOBASE%$gdxin

%MFH%$call csv2gdx data/data_demand_elec.txt  id=dataload_d_elec Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%MFH%$gdxin input.gdx
%MFH%$load dataload_d_elec
%MFH%$gdxin

%WERDERAU%$call csv2gdx data/data_demand_elec_%Building%.txt  id=dataload_d_elec Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%WERDERAU%$gdxin input.gdx
%WERDERAU%$load dataload_d_elec
%WERDERAU%$gdxin

%BRUCK%$call csv2gdx data/data_demand_elec_%Building%.txt  id=dataload_d_elec Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%BRUCK%$gdxin input.gdx
%BRUCK%$load dataload_d_elec
%BRUCK%$gdxin

%HERZOBASE%$call csv2gdx data/data_demand_elec_Herzobase1Geb.txt  id=dataload_d_elec Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%HERZOBASE%$gdxin input.gdx
%HERZOBASE%$load dataload_d_elec
%HERZOBASE%$gdxin

%MFH%$call csv2gdx data/data_demand_heating_%Building%_%Orientation%.txt id=dataload_d_heat Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%MFH%$gdxin input.gdx
%MFH%$load dataload_d_heat
%MFH%$gdxin

%WERDERAU%$call csv2gdx data/data_demand_heating_%Building%.txt id=dataload_d_heat Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%WERDERAU%$gdxin input.gdx
%WERDERAU%$load dataload_d_heat
%WERDERAU%$gdxin

%BRUCK%$call csv2gdx data/data_demand_heating_%Building%.txt id=dataload_d_heat Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%BRUCK%$gdxin input.gdx
%BRUCK%$load dataload_d_heat
%BRUCK%$gdxin

%HERZOBASE%$call csv2gdx data/data_demand_heating_Herzobase1Geb.txt id=dataload_d_heat Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%HERZOBASE%$gdxin input.gdx
%HERZOBASE%$load dataload_d_heat
%HERZOBASE%$gdxin

%MFH%$call csv2gdx data/data_demand_heating_tww.txt id=dataload_d_heat_tww Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%MFH%$gdxin input.gdx
%MFH%$load dataload_d_heat_tww
%MFH%$gdxin

%WERDERAU%$call csv2gdx data/data_demand_heating_tww_%Building%.txt id=dataload_d_heat_tww Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%WERDERAU%$gdxin input.gdx
%WERDERAU%$load dataload_d_heat_tww
%WERDERAU%$gdxin

%BRUCK%$call csv2gdx data/data_demand_heating_tww_%Building%.txt id=dataload_d_heat_tww Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%BRUCK%$gdxin input.gdx
%BRUCK%$load dataload_d_heat_tww
%BRUCK%$gdxin

%HERZOBASE%$call csv2gdx data/data_demand_heating_tww_Herzobase1Geb.txt id=dataload_d_heat_tww Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%HERZOBASE%$gdxin input.gdx
%HERZOBASE%$load dataload_d_heat_tww
%HERZOBASE%$gdxin

%MFH%$call csv2gdx data/data_heatpump_%Building%.txt id=dataload_cop Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%MFH%$gdxin input.gdx
%MFH%$load dataload_cop
%MFH%$gdxin

%WERDERAU%$call csv2gdx data/data_heatpump_%Building%.txt id=dataload_cop Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%WERDERAU%$gdxin input.gdx
%WERDERAU%$load dataload_cop
%WERDERAU%$gdxin

%BRUCK%$call csv2gdx data/data_heatpump_Bruck.txt id=dataload_cop Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%BRUCK%$gdxin input.gdx
%BRUCK%$load dataload_cop
%BRUCK%$gdxin

%HERZOBASE%$call csv2gdx data/data_heatpump_Herzobase.txt id=dataload_cop Index=1 Value=2..lastCol UseHeader=Y StoreZero=Y FieldSep=Comma Output=input.gdx
%HERZOBASE%$gdxin input.gdx
%HERZOBASE%$load dataload_cop
%HERZOBASE%$gdxin

dataload_d_elec(t,u)  = 4 * dataload_d_elec(t,u)  ;

$include 03_Variables.gms
$include 04_Equations.gms


***--------------------------------------------------------------------------***
***                          SOLVE DISPATCH MODEL                            ***
***--------------------------------------------------------------------------***

Model LocModDecentral / all / ;


%BRUCK%q_elec.fx(g_pv,t) = dataload_pv(t,g_pv) ;
%HERZOBASE%q_elec.fx(g_pv,t) = dataload_pv(t,g_pv) ;
%WERDERAU%q_elec.fx(g_pv,t) = dataload_pv(t,g_pv) ;

%BRUCK%c_gen.fx(g_pv) = 0;
%HERZOBASE%c_gen.fx(g_pv) = 0;
%WERDERAU%c_gen.fx(g_pv) = 0;

%MFH%c_gen.fx(g_pv) = I_max(g_pv) ;

SOLVE LocModDecentral USING LP MINIMIZING cost   ;

$include 05_Results.gms

***--------------------------------------------------------------------------***
***                           END MODEL SECTION                              ***
***--------------------------------------------------------------------------***
