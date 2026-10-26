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

variables
cost                    Objective function
;

positive variables

f_elInRes(t,u)          Flow of electricity from public grid
f_elOutRes(t)           Flow of electricity to public grid

f_elWPRes(t)            energy demand of the heat pump

f_elPump(t)             electricity demand circulation pump

f_elPump_KNW(t)         electricity demand KNW-pump

f_elBooster(t)          electricity demand TWW Nacherhitzung

q_elec(g,t)              Electricity generation

q_heat(g,t)

s_l(s,t)                 Storage level in t
s_in(s,t)                Storage input
s_out(s,t)               Storage withdrawal

c_gen(g)                 Capacity Generation
c_sto(s)                 Capacity Storage

;