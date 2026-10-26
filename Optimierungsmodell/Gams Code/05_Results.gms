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

Parameters
    Result_Invest(*)
    Result_Elec(*)
    Result_Heat(*)
    Result_Flow_15min(t,*)
    Result_Costs(*)
    Result_WP_Heat_15min(t,*)
    Result_Elec_Mon(mon,*)
    Result_Heat_Mon(mon,*)
;


*** ---------------------------
*** Ergebnisse zu Investitionen
*** ---------------------------

Result_Invest(g) = c_gen.l(g);
Result_Invest(s) = c_sto.l(s);
Result_Invest('WP_total') = sum(g_wp, c_gen.l(g_wp));


*** ----------------------------
*** Ergebnisse zu Energieflüssen
*** ----------------------------


Result_Elec('D_elec') = sum((u,t), dataload_d_elec(t,u)) / Hour / 1e3;

Result_Elec(g_pv) = sum(t, q_elec.l(g_pv,t)) / Hour / 1e3;
Result_Elec(g_wp) = sum(t, q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;

Result_Elec('I_net') = sum((u,t), f_elInRes.l(t,u)) / Hour / 1e3;
Result_Elec('O_net') = sum(t, f_elOutRes.l(t)) / Hour / 1e3;

Result_Elec('O_bat') = sum((s_bat,t), s_in.l(s_bat,t)) / Hour / 1e3;
Result_Elec('I_bat') = sum((s_bat,t), s_out.l(s_bat,t)) / Hour / 1e3;

Result_Elec('L_bat') = sum((s_bat,t), s_in.l(s_bat,t) * (1 - Eff(s_bat))) / Hour / 1e3;
Result_Elec('L_sto') = sum((s_bat,t), s_l.l(s_bat,t) * Loss(s_bat)) / 1e3;

Result_Elec('D_pump') = sum(t, f_elPump.l(t)) / Hour / 1e3;
Result_Elec('D_pump_KNW') = sum(t, f_elPump_KNW.l(t)) / Hour / 1e3;
Result_Elec('D_booster') = sum(t, f_elBooster.l(t)) / Hour / 1e3;

Result_Elec('D_WP_total') = sum((g_wp,t), q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;



Result_Elec_Mon(mon,'D_elec') = sum((u,t)$tMon(mon,t), dataload_d_elec(t,u)) / Hour / 1e3;

Result_Elec_Mon(mon,g_pv) = sum(t$tMon(mon,t), q_elec.l(g_pv,t)) / Hour / 1e3;
Result_Elec_Mon(mon,g_wp) = sum(t$tMon(mon,t), q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;

Result_Elec_Mon(mon,'I_net') = sum((u,t)$tMon(mon,t), f_elInRes.l(t,u)) / Hour / 1e3;
Result_Elec_Mon(mon,'O_net') = sum(t$tMon(mon,t), f_elOutRes.l(t)) / Hour / 1e3;

Result_Elec_Mon(mon,'O_bat') = sum((s_bat,t)$tMon(mon,t), s_in.l(s_bat,t)) / Hour / 1e3;
Result_Elec_Mon(mon,'I_bat') = sum((s_bat,t)$tMon(mon,t), s_out.l(s_bat,t)) / Hour / 1e3;

Result_Elec_Mon(mon,'L_bat') = sum((s_bat,t)$tMon(mon,t), s_in.l(s_bat,t) * (1 - Eff(s_bat))) / Hour / 1e3;
Result_Elec_Mon(mon,'L_sto') = sum((s_bat,t)$tMon(mon,t), s_l.l(s_bat,t) * Loss(s_bat)) / 1e3;

Result_Elec_Mon(mon,'D_pump') = sum(t$tMon(mon,t), f_elPump.l(t)) / Hour / 1e3;
Result_Elec_Mon(mon,'D_pump_KNW') = sum(t$tMon(mon,t), f_elPump_KNW.l(t)) / Hour / 1e3;
Result_Elec_Mon(mon,'D_booster') = sum(t$tMon(mon,t), f_elBooster.l(t)) / Hour / 1e3;

Result_Elec_Mon(mon,'D_WP_total') = sum((g_wp,t)$tMon(mon,t), q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;



Result_Heat('D_heat') = sum((u,t), dataload_d_heat(t,u) + dataload_d_heat_tww(t,u)) / Hour / 1e3;

Result_Heat('I_WP') = sum((g_wp,t), q_heat.l(g_wp,t)) / Hour / 1e3;
Result_Heat('O_WP') = sum((g_wp,t), q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;
Result_Heat('O_Heat') = sum((g_wp,t), q_heat.l(g_wp,t)) / Hour / 1e3;

Result_Heat('I_heat') = sum((s_heat,t), s_out.l(s_heat,t)) / Hour / 1e3;

Result_Heat('L_heat') = sum((s_heat,g_wp,t), q_heat.l(g_wp,t) * WP_SHeat(g_wp,s_heat) * (1 - Eff(s_heat))) / Hour / 1e3;

Result_Heat('L_sto') = sum((s_heat,t), Loss(s_heat)) / 1e3;
Result_Heat('L_net') = heatnet_lossratio * sum((s_heat,t), s_out.l(s_heat,t)) / Hour / 1e3;

Result_Heat('D_Gebaude') = sum((u,t), dataload_d_heat(t,u)) / Hour / 1e3;
Result_Heat('D_TWW') = sum((u,t), dataload_d_heat_tww(t,u)) / Hour / 1e3;

Result_Heat('L_puffer') = Result_Heat('L_heat') + Result_Heat('L_sto');

Result_Heat('AZ_WP') = 0;
if (Result_Heat('O_WP') > 0,
    Result_Heat('AZ_WP') = Result_Heat('I_WP') / Result_Heat('O_WP');
);



Result_Heat_Mon(mon,'D_heat') = sum((u,t)$tMon(mon,t), dataload_d_heat(t,u) + dataload_d_heat_tww(t,u)) / Hour / 1e3;

Result_Heat_Mon(mon,'I_WP') = sum((g_wp,t)$tMon(mon,t), q_heat.l(g_wp,t)) / Hour / 1e3;
Result_Heat_Mon(mon,'O_WP') = sum((g_wp,t)$tMon(mon,t), q_heat.l(g_wp,t) / COP(g_wp,t)) / Hour / 1e3;

Result_Heat_Mon(mon,'O_Heat') = sum((g_wp,t)$tMon(mon,t), q_heat.l(g_wp,t)) / Hour / 1e3;
Result_Heat_Mon(mon,'I_heat') = sum((s_heat,t)$tMon(mon,t), s_out.l(s_heat,t)) / Hour / 1e3;

Result_Heat_Mon(mon,'L_heat') = sum((s_heat,g_wp,t)$tMon(mon,t), q_heat.l(g_wp,t) * WP_SHeat(g_wp,s_heat) * (1 - Eff(s_heat))) / Hour / 1e3;

Result_Heat_Mon(mon,'L_sto') = sum((s_heat,t)$tMon(mon,t), Loss(s_heat)) / 1e3;
Result_Heat_Mon(mon,'L_net') = heatnet_lossratio * sum((s_heat,t)$tMon(mon,t), s_out.l(s_heat,t)) / Hour / 1e3;

Result_Heat_Mon(mon,'D_Gebaude') = sum((u,t)$tMon(mon,t), dataload_d_heat(t,u)) / Hour / 1e3;
Result_Heat_Mon(mon,'D_TWW') = sum((u,t)$tMon(mon,t), dataload_d_heat_tww(t,u)) / Hour / 1e3;

Result_Heat_Mon(mon,'L_puffer') = Result_Heat_Mon(mon,'L_heat') + Result_Heat_Mon(mon,'L_sto');

Result_Heat_Mon(mon,'E_WP_local') = sum(t$tMon(mon,t), f_elWPRes.l(t)) / Hour / 1e3;
Result_Heat_Mon(mon,'E_WP_net') = sum(t$tMon(mon,t), f_elInRes.l(t,'heat')) / Hour / 1e3;


*** ----------------------------------
*** Energieflüsse
*** ----------------------------------


Result_Flow_15min(t,'I_PV') = sum(g_pv, q_elec.l(g_pv,t));

Result_Flow_15min(t,'I_net') = sum(u, f_elInRes.l(t,u));
Result_Flow_15min(t,'O_net') = f_elOutRes.l(t);

Result_Flow_15min(t,'O_WP') = sum(g_wp, q_heat.l(g_wp,t) / COP(g_wp,t));

Result_Flow_15min(t,'O_bat') = sum(s_bat, s_in.l(s_bat,t));
Result_Flow_15min(t,'I_bat') = sum(s_bat, s_out.l(s_bat,t));

Result_Flow_15min(t,'D_elec') = sum(u, dataload_d_elec(t,u));

Result_Flow_15min(t,'D_pump') = f_elPump.l(t);
Result_Flow_15min(t,'D_pump_KNW') = f_elPump_KNW.l(t);
Result_Flow_15min(t,'D_booster') = f_elBooster.l(t);

Result_Flow_15min(t,'I_WP') = sum(g_wp, q_heat.l(g_wp,t));
Result_Flow_15min(t,'O_heat') = sum(g_wp, q_heat.l(g_wp,t));

Result_Flow_15min(t,'I_heat') = sum(s_heat, s_out.l(s_heat,t));

Result_Flow_15min(t,'D_heat') = sum(u, dataload_d_heat(t,u) + dataload_d_heat_tww(t,u));
Result_Flow_15min(t,'D_tww') = sum(u, dataload_d_heat_tww(t,u));
Result_Flow_15min(t,'D_heating') = sum(u, dataload_d_heat(t,u));

Result_Flow_15min(t,'S_bat') = sum(s_bat, s_l.l(s_bat,t));
Result_Flow_15min(t,'S_heat') = sum(s_heat, s_l.l(s_heat,t));


*** ----------------------------
*** Wärmepumpenerzeugung
*** ----------------------------

Result_WP_Heat_15min(t,g_wp) = q_heat.l(g_wp,t);
Result_WP_Heat_15min(t,'total') = sum(g_wp, q_heat.l(g_wp,t));


*** --------------------
*** Kosten
*** --------------------

Result_Costs('C_PV') = sum(g_pv, c_gen.l(g_pv) * C_i_gen(g_pv));

Result_Costs('C_ST') = sum(s, c_sto.l(s) * C_i_sto(s));

Result_Costs('C_ST_Bat') = sum(s_bat, c_sto.l(s_bat) * C_i_sto(s_bat));
Result_Costs('C_ST_Heat') = sum(s_heat, c_sto.l(s_heat) * C_i_sto(s_heat));

Result_Costs('C_WP') = sum(g_wp, c_gen.l(g_wp) * C_i_gen(g_wp));

Result_Costs('C_Elec') = sum((u,t), P_elNetIn(t) * f_elInRes.l(t,u)) / Hour;

Result_Costs('R_Elec') = - sum(t, P_elNetOut(t) * f_elOutRes.l(t)) / Hour;

Result_Costs('Gesamt') =
      Result_Costs('C_PV')
    + Result_Costs('C_WP')
    + Result_Costs('C_ST')
    + Result_Costs('C_Elec')
    + Result_Costs('R_Elec');


*** --------------------
*** Speicherverluste
*** --------------------

Result_Elec('L_storage_el_total') =
      Result_Elec('L_bat')
    + Result_Elec('L_sto');

Result_Heat('L_storage_heat_total') =
      Result_Heat('L_heat')
    + Result_Heat('L_sto')
    + Result_Heat('L_net');


*** --------------------
*** Ergebnisexport
*** --------------------

execute_unload 'Results_%Scenario%_%Orientation%_%Building%_%Heatpump%_%Date%.gdx',
    Result_Invest,
    Result_Elec,
    Result_Heat,
    Result_Flow_15min,
    Result_Costs,
    Result_WP_Heat_15min,
    Result_Elec_Mon,
    Result_Heat_Mon,
