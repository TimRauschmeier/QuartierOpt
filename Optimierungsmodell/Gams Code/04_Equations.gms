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

equations
objective           Optimizing function
cap_gen(g)          Conversion asset capacity
cap_sto(s)          Storage capacity

%MFH%con_PV_q_elec(g_pv,t)    PV electricity generation


max_S1_E(s_bat,t)         Storage charging capacity
max_S2_E(s_bat,t)        Storage discharging capacity
max_S3_E(s_bat,t)     Storage level
max_S4_E(s_bat)

max_S1_H(s_heat,t)          Storage level max
max_S3_H(s_heat,t)     Storage level
max_S4_H(s_heat)

con_heat(g_wp,t)
con_1_heat(t)
con_pump(t)
con_booster(t)
con_pump_KNW(t)


$ifthen '%Heatpump%' == Teillast
cap_wp_tl(g_wp)   Teillast WP Kapazität
$endif



$ifthen '%Scenario%' == Inflex
con_1_inflex(t)
con_2_inflex(t)
con_3_inflex(t)
$endif


$ifthen '%Scenario%' == Benchmark
con_1_benchmark (t)
con_2_benchmark(t)
$endif
;

*** ------------------ ***
*** Objective function ***
*** ------------------ ***

$ifthen '%Scenario%' == Inflex
objective.. cost =e= 
    + sum((u,t), P_elNetIn(t)  * f_elInRes(t,u) ) / Hour
    - sum(t,     P_elNetOut(t) * f_elOutRes(t)  ) / Hour
        + sum(g, c_gen(g) * C_i_gen(g) )
        + sum(s, c_sto(s) * C_i_sto(s) )
;
$endIf

$ifthen '%Scenario%' == Benchmark
objective.. cost =e= 
    + sum((u,t), P_elNetIn(t)  * f_elInRes(t,u) ) / Hour
    - sum(t,     P_elNetOut(t) * f_elOutRes(t)  ) / Hour
        + sum(g, c_gen(g) * C_i_gen(g) )
        + sum(s, c_sto(s) * C_i_sto(s) )
;
$endif

*** ------------------ ***
*** Model constraints  ***
*** ------------------ ***

cap_gen(g)..            c_gen(g)    =l= I_max(g);
cap_sto(s)..            c_sto(s)    =l= SC_max(s) ;

%MFH%con_PV_q_elec(g_pv,t).. q_elec(g_pv,t) =l= c_gen(g_pv) * Ava(g_pv,t);

con_heat(g_wp,t)..      q_heat(g_wp,t) =l= c_gen(g_wp) ;

con_1_heat(t)..         (1 - heatnet_lossratio) * sum(s_heat, s_out(s_heat,t) ) + f_elBooster(t) =e= sum(u, dataload_d_heat(t,u) + dataload_d_heat_tww(t,u) ) ;

con_pump(t)..           f_elPump(t) =e= pump_ratio * sum(s_heat, s_out(s_heat,t));

con_pump_KNW(t)..       f_elPump_KNW(t) =e= pump_ratio_KNW * sum(s_heat, s_out(s_heat,t));

con_booster(t)..        f_elBooster(t) =e= booster_ratio * sum(u, dataload_d_heat_tww(t,u));

max_S1_E(s_bat,t)..    s_l(s_bat,t)   =l=  c_sto(s_bat) ;

max_S2_E(s_bat,t)..    s_out(s_bat,t) =l=  c_sto(s_bat) ;

max_S3_E(s_bat,t)$(ord(t)>=1).. s_l(s_bat,t) =E= s_l(s_bat,t-1) * (1 - Loss(s_bat))  + s_in(s_bat,t) * Eff(s_bat) / Hour - s_out(s_bat,t) / Hour ;

max_S4_E(s_bat)..      s_l(s_bat,'t00001') =E= s_l(s_bat,'t35040') * (1 - Loss(s_bat)) + s_in(s_bat,'t00001') * Eff(s_bat) / Hour - s_out(s_bat,'t00001') / Hour  ;


max_S1_H(s_heat,t)..   s_l(s_heat,t)   =l=  c_sto(s_heat) ;

max_S3_H(s_heat,t)$(ord(t)>=1).. s_l(s_heat,t) =E= s_l(s_heat,t-1) + sum(g_wp, q_heat(g_wp,t)  * WP_SHeat(g_wp,s_heat)) * Eff(s_heat) / Hour - s_out(s_heat,t) / Hour - Loss(s_heat) ;

max_S4_H(s_heat)..     s_l(s_heat,'t00001') =E= s_l(s_heat,'t35040') + sum(g_wp, q_heat(g_wp,'t00001')  * WP_SHeat(g_wp,s_heat)) * Eff(s_heat) / Hour - s_out(s_heat,'t00001') / Hour - Loss(s_heat) ;

$ifthen '%Scenario%' == Inflex

f_elWPRes.fx(t) = 0 ;

con_1_inflex(t)..      sum(g_pv, q_elec(g_pv,t)) - sum(s_bat, s_in(s_bat,t) ) + sum(s_bat, s_out(s_bat,t)) =e= f_elOutRes(t) ;

con_2_inflex(t)..  
    sum(u, f_elInRes(t,u)) =e= sum(u, dataload_d_elec(t,u))
      + sum(g_wp, q_heat(g_wp,t) / COP(g_wp,t))
      + f_elPump(t)
      + f_elPump_KNW(t)
      + f_elBooster(t) ;

con_3_inflex(t)..  f_elInRes(t,'heat') + f_elWPRes(t) =e= sum(g_wp, q_heat(g_wp,t) / COP(g_wp,t)) ;

$endif


$ifthen '%Scenario%' == Benchmark
con_1_benchmark(t).. sum(g_pv, q_elec(g_pv,t) ) - sum(s_bat, s_in(s_bat,t) ) + sum(s_bat, s_out(s_bat,t) )  - sum(u, dataload_d_elec(t,u)) + sum(u, f_elInRes(t,u)) - f_elOutRes(t) - sum(g_wp, q_heat(g_wp,t) / COP(g_wp,t) ) - f_elPump(t) - f_elPump_KNW(t) - f_elBooster(t) =e= 0;

con_2_benchmark(t).. f_elInRes(t,'heat') + f_elWPRes(t) =e= sum(g_wp, q_heat(g_wp,t) / COP(g_wp,t)) ;
$endif

$ifthen '%Heatpump%' == Teillast
cap_wp_tl(g_wp)..    c_gen(g_wp) =e= Cap_tl(g_wp) * sum(g_wp_2, c_gen(g_wp_2)) ;
$endif



