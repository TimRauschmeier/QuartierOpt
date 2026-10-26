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

Scalar
Hour              Number of t per hour          / 4 /
Battery_kwh       kwh storage per capacity      / 2 /

%MFH%WP_DEG            degradation step WP TL     / 0.05 /
%WERDERAU%WP_DEG            degradation step WP TL     / 0.05 /
%BRUCK%WP_DEG            degradation step WP TL     / 0.05 /
%HERZOBASE%WP_DEG            degradation step WP TL     / 0.109 /
;

Sets

%WERDERAU%u       Unit                    / W_01, Heat /
%BRUCK%u         Unit                    / W_01, Heat /
%HERZOBASE%u         Unit                    / W_01, Heat /
%MFH%u            Unit                    / W_01, W_02, W_03, W_04, W_05, W_06, W_07, W_08, W_09, W_10, W_11, W_12, Heat /

t                Hours                   / t00001 * t35040 /

mon              Monate         / Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec /

tJan(t)          Januar         / t00001 * t02976 /
tFeb(t)          Februar        / t02977 * t05664 /
tMar(t)          März           / t05665 * t08640 /
tApr(t)          April          / t08641 * t11520 /
tMay(t)          Mai            / t11521 * t14496 /
tJun(t)          Juni           / t14497 * t17376 /
tJul(t)          Juli           / t17377 * t20352 /
tAug(t)          August         / t20353 * t23328 /
tSep(t)          September      / t23329 * t26208 /
tOct(t)          Oktober        / t26209 * t29184 /
tNov(t)          November       / t29185 * t32064 /
tDec(t)          Dezember       / t32065 * t35040 /  

tMon(mon,t)      Mapping

$ifthen '%Heatpump%' == Volllast
%MFH%g           Generators              / g_PV_N, g_PV_E, g_PV_S, g_PV_W, g_PV_01, wp_01 /
%WERDERAU%g        Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01 /
%BRUCK%g        Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01 /
%HERZOBASE%g     Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01 /
g_wp(g)          Heat pumps              / wp_01/
$endif

$ifthen '%Heatpump%' == Teillast
%MFH%g           Generators              / g_PV_N, g_PV_E, g_PV_S, g_PV_W, g_PV_01, wp_01, wp_02, wp_03, wp_04, wp_05, wp_06, wp_07 /
%WERDERAU%g        Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01, wp_02, wp_03, wp_04, wp_05, wp_06, wp_07 /
%BRUCK%g        Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01, wp_02, wp_03, wp_04, wp_05, wp_06, wp_07 /
%HERZOBASE%g        Generators              / g_PV_00, g_PV_01, g_PV_02, wp_01, wp_02, wp_03, wp_04, wp_05, wp_06, wp_07 /
g_wp(g)          Heat pumps              / wp_01, wp_02, wp_03, wp_04, wp_05, wp_06, wp_07 /
$endif

%MFH%g_pv(g)      PV                     / g_PV_N, g_PV_E, g_PV_S, g_PV_W, g_PV_01 /
%WERDERAU%g_pv(g)   PV                     / g_PV_00, g_PV_01, g_PV_02 /
%BRUCK%g_pv(g)   PV                     / g_PV_00, g_PV_01, g_PV_02 /
%HERZOBASE%g_pv(g)   PV                     / g_PV_00, g_PV_01, g_PV_02 /


s                Storage                 / s_bat_01 , s_heat_01/
s_bat(s)         Battery Storage         / s_bat_01 /
s_heat(s)        Heat Storage            / s_heat_01/
;

Alias (g_wp, g_wp_2, gg);

Parameters
dataload_pv(t,g_pv)
dataload_cop(t,g_wp)
dataload_d_elec(t,u)
dataload_d_heat(t,u)
dataload_d_heat_tww(t,u)

D_elec_b(u,t)   Demand for household electricity per building and time

D_heat_b(u,t)   Demand for household heating per building and time

D_tww_b(u,t)    Demand for household drinking & warm water per building and time

P_elNetOut(t)    Price of selling electricity to public grid      
P_elNetIn(t)     Price of buying electricity to public grid               
     
I_max(g)         Maximum total input for each producer
Ava(g,t)         Hourly availability for each producer
COP(g_wp,t)      COP for heat pumps according to building and temperature
Eff(s)

SC_max(s)        Maximum capacity for loading and unloading storage
WP_SHeat(g_wp,s_heat) 

C_i_gen(g)      Investment costs for generators
C_i_sto(s)      Investment costs for storage systems
Loss(s)
pump_ratio      Ratio of electricity demand to transported heat 
pump_ratio_KNW  Ratio of electricity demand to transported heat
heatnet_lossratio   Heat losses network
booster_ratio   reheating ratio

P_elecIn        

COP_max(t)     
COP_min(t)     
Cap_tl(g_wp)   Capacity share
deg(g_wp)      Degradation weight
dCOP(t)        
deg_sum(g_wp)  
COP_tl(g_wp,t) 

;
I_max(g_pv) = 0 ;

$ifthen '%Orientation%' == OstWest
%MFH%I_max('g_PV_E')  =    39.5 ;
%MFH%I_max('g_PV_W')  =    39.5 ;
$endif

$ifthen '%Orientation%' == NordSued
%MFH%I_max('g_PV_S')  =    39.5 ;
%MFH%I_max('g_PV_N')  =    39.5 ;
$endif

I_max(g_wp)    = 800000 ;

%MFH%Ava(g_pv,t)  = dataload_pv(t,g_pv) ;

$ifthen '%Heatpump%' == Volllast
COP(g_wp,t)  = dataload_cop(t,g_wp) ;
$endif

$ifthen '%Heatpump%' == Teillast
%WERDERAU%COP_max(t)  = dataload_cop(t,'wp_01') * 1.21 ;
%MFH%COP_max(t)  = dataload_cop(t,'wp_01') * 1.21 ;

%BRUCK%COP_max(t)  = dataload_cop(t,'wp_01') ;
%HERZOBASE%COP_max(t)  = dataload_cop(t,'wp_01') ;
$endif

SC_max('s_bat_01') = 1000 ;
SC_max('s_heat_01') = 1000 ;

WP_SHeat(g_wp,'s_heat_01') = 1 ;

Loss(s_bat) = 0.00001 ;

%MFH%Loss(s_heat) = 0.0997 ;
%WERDERAU%Loss(s_heat) = 0.0997 ;
%BRUCK%Loss(s_heat) = 0.0997 ;
%HERZOBASE%Loss(s_heat) = 0.0204 ;

%MFH%pump_ratio = 0.0022 ;
%WERDERAU%pump_ratio = 0.0006 ;
%BRUCK%pump_ratio = 0.0045 ;
%HERZOBASE%pump_ratio = 0.0022 ;

%MFH%pump_ratio_KNW = 0 ;
%WERDERAU%pump_ratio_KNW = 0 ;
%BRUCK%pump_ratio_KNW = 0.0067 ;
%HERZOBASE%pump_ratio_KNW = 0 ;

heatnet_lossratio = 0.0025 ;


%MFH%booster_ratio = 0.04 ;
%WERDERAU%booster_ratio = 0.105 ;

%BRUCK%booster_ratio = 0.2 ;
%HERZOBASE%booster_ratio = 0.2 ;

Eff(s_bat)  = 0.90 ;
Eff(s_heat) = 1 ;

P_elecIn = 0.001;
  
C_i_gen(g_pv) = 105.11 ;

$ifthen '%Heatpump%' == Volllast
%MFH%C_i_gen(g_wp) = 96.29 ;
%WERDERAU%C_i_gen(g_wp) = 96.29 ;
%BRUCK%C_i_gen(g_wp) = 96.29 ;
%HERZOBASE%C_i_gen(g_wp) = 120.36 ;
$endif

$ifthen '%Heatpump%' == Teillast
%MFH%C_i_gen(g_wp) = 96.29 ;
%WERDERAU%C_i_gen(g_wp) = 96.29 ;
%BRUCK%C_i_gen(g_wp) = 96.29 ;
%HERZOBASE%C_i_gen(g_wp) = 120.36 ;
$endif

C_i_sto(s_bat) = 16.05 ;

C_i_sto(s_heat) = 27.64 ;

P_elNetOut(t) = 0.055 ;


$ifthen '%Scenario%' == Inflex
P_elNetOut(t) = 0.08 ;
$endIf

P_elNetIn(t)  = 0.30 ;

$ifthen '%Heatpump%' == Teillast
COP_min(t) = COP_max(t) - 1 ;

%MFH%Cap_tl('wp_01') = 0.4 ;
%MFH%Cap_tl('wp_02') = 0.1 ;
%MFH%Cap_tl('wp_03') = 0.1 ;
%MFH%Cap_tl('wp_04') = 0.1 ;
%MFH%Cap_tl('wp_05') = 0.1 ;
%MFH%Cap_tl('wp_06') = 0.1 ;
%MFH%Cap_tl('wp_07') = 0.1 ;

%WERDERAU%Cap_tl('wp_01') = 0.4 ;
%WERDERAU%Cap_tl('wp_02') = 0.1 ;
%WERDERAU%Cap_tl('wp_03') = 0.1 ;
%WERDERAU%Cap_tl('wp_04') = 0.1 ;
%WERDERAU%Cap_tl('wp_05') = 0.1 ;
%WERDERAU%Cap_tl('wp_06') = 0.1 ;
%WERDERAU%Cap_tl('wp_07') = 0.1 ;

%BRUCK%Cap_tl('wp_01') = 0.4 ;
%BRUCK%Cap_tl('wp_02') = 0.1 ;
%BRUCK%Cap_tl('wp_03') = 0.1 ;
%BRUCK%Cap_tl('wp_04') = 0.1 ;
%BRUCK%Cap_tl('wp_05') = 0.1 ;
%BRUCK%Cap_tl('wp_06') = 0.1 ;
%BRUCK%Cap_tl('wp_07') = 0.1 ;

%HERZOBASE%Cap_tl('wp_01') = 0.2 ;
%HERZOBASE%Cap_tl('wp_02') = 0.1333 ;
%HERZOBASE%Cap_tl('wp_03') = 0.1333 ;
%HERZOBASE%Cap_tl('wp_04') = 0.1333 ;
%HERZOBASE%Cap_tl('wp_05') = 0.1333 ;
%HERZOBASE%Cap_tl('wp_06') = 0.1333 ;
%HERZOBASE%Cap_tl('wp_07') = 0.1335 ;


deg('wp_01')  = 0 * WP_DEG ;
deg('wp_02')  = 2 * WP_DEG ;
deg('wp_03')  = 3 * WP_DEG ;
deg('wp_04')  = 4 * WP_DEG ;
deg('wp_05')  = 5 * WP_DEG ;
deg('wp_06')  = 6 * WP_DEG ;
deg('wp_07')  = 7 * WP_DEG ;


COP(g_wp,t) = COP_max(t) * ( 1 - deg(g_wp) ) ;

COP_tl(g_wp,t) = sum(gg$(ord(gg) <= ord(g_wp)), ( Cap_tl(gg) * COP(gg,t) ) ) / sum(gg$(ord(gg) <= ord(g_wp)), Cap_tl(gg) ) ;

$endIf

tMon('Jan',t) = yes$(tJan(t));
tMon('Feb',t) = yes$(tFeb(t));
tMon('Mar',t) = yes$(tMar(t));
tMon('Apr',t) = yes$(tApr(t));
tMon('May',t) = yes$(tMay(t));
tMon('Jun',t) = yes$(tJun(t));
tMon('Jul',t) = yes$(tJul(t));
tMon('Aug',t) = yes$(tAug(t));
tMon('Sep',t) = yes$(tSep(t));
tMon('Oct',t) = yes$(tOct(t));
tMon('Nov',t) = yes$(tNov(t));
tMon('Dec',t) = yes$(tDec(t));

