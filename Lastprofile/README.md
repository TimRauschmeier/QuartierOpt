# Lastprofile
Für die simulationsgestützte Untersuchung der Quartiersenergiesysteme werden zeitlich hochaufgelöste Last- und Erzeugungsprofile für Heizwärme, Trinkwarmwasser, Haushaltsstrom und Photovoltaikerträge verwendet.
## Stromlastprofile
Die Haushaltsstromprofile werden mit dem agentenbasierten Tool LoadProfileGenerator (LPG) Version 10.9.0 erzeugt. Hierbei werden unterschiedliche Haushaltstypen und Nutzerverhalten abgebildet. Die Einzelprofile werden entsprechend der Bewohnerstruktur der jeweiligen Quartiere zu quartiersspezifischen Lastprofilen aggregiert. Verwendet werden dafür bereits vorhandene Konfigurationen („Presets“) bestimmter Haushalte, diese werden modifiziert indem der Urlaub entfernt wird. 10 Haushalte des gleichen Presets werden nacheinander simuliert, durch die unterschiedliche Seeds werden die Interaktionen der Bewohner mit den Geräten im jeweiligen Haushalt zufällig ausgewählt, dadurch soll eine exakt zeitgleiche Überlagerung von Aktivitäten und damit verbundenen Lastspitzen vermieden werden (z.B. „Kochen“). Zur Bildung der verwendeten Profile wird der Mittelwert der aggregierten 10 Profile verwendet.
### Verwendete Presets aus dem LPG:

CHR25	Single woman under 30 years with work  
CHR27	Family both at work, 2 children  
CHR30	Single, Retired Man  
CHR34	Couple under 30 years, one at work, one at home  
CHR45	Family with 1 child, 1 at work, 1 at home  
CHR57	Family with 2 Children, Man at work  
CHS04	Retired Couple, no work  

### Zusammensetzung der Quartiere:
|Quartier |	Wohneinheiten |	Bewohner |	Presets  |
|------------- |------------- | ------------- | ------------- |
|Gen. MFH	| 12 |	30 |	6x CHR34, 6x CHR45  |
|Herzogenaurach-HerzoBase	| 8 |	27 |	1x CHR34, 3x CHR45, 4x CHR57  |
|Nürnberg-Werderau |	96 |	175 |	15x CHR27, 47x CHR30, 34x CHS04  
|Erlangen-Bruck |	308 |	924 |	102x CHR27, 102x CHR34, 104x CHR45  |


### Dateiname:
Kombination aus dem zugehörigen Gebäude/Quartier und Intensivität des Verbrauchs.

„energy_intensive“	Intensiver Verbrauch  
„rnd“	Zufällig/mittlerer Verbrauch  
„energy_saving“	Sparsamer Verbrauch  


### Dateiformat (LPG – „*.csv“):
Die erste Zeile (Header, zum Beispiel „Time; SumStrom_in_kWh“) dient als Überschrift/Identifikation der folgenden Werte. Zeitintervall 15 Minuten, Trennzeichen Semikolon, Datum Uhrzeit und Summenwerte in kWh.

#### Beispiel – „MFH_rnd.csv“:
Time;SumStrom_in_kWh  
2021-01-01 00:00:00;0.47991992623178314  
2021-01-01 00:15:00;0.5153161212956499  
2021-01-01 00:30:00;0.4684410253129074  
2021-01-01 00:45:00;0.42229508608932353  

### Dateiformat (TRNSYS – „*.txt“):
Die erste Zeile (Header, zum Beispiel „SumStrom_in_kWh“) dient als Überschrift/Identifikation der folgenden Werte. Beim Einlesen der Werte in der TRNSYS Simulation mit dem Data-Reader-Type 9 wird diese übersprungen („Header Lines to Skip  1“).
Es folgen die kWh-Werte im 15-Minutenintervall mit Punkt als Dezimaltrennzeichen.

#### Beispiel – „MFH_rnd.txt“:
SumStrom_in_kWh  
0.47991992623178314  
0.5153161212956499  
0.4684410253129074  
0.42229508608932353  


## PV-Erzeugung
Die Photovoltaikertragsprofile werden in TRNSYS auf Basis von Dachfläche, Ausrichtung, Dachneigung und standortspezifischen Wetterdaten generiert. Die Berechnung erfolgt für jedes Gebäude separat, um die tatsächlichen Erzeugungspotenziale der Quartiere realitätsnah abzubilden.

### Dateiname:
Kombination aus dem zugehörigen Gebäude/Quartier und Ausrichtung der PV-Anlage (Dachseite).

### Dateiformat („*.csv“):
Zwei Zeilen Header („Time; PV-Erzeugung“), Zeitintervall 15 Minuten, Trennzeichen Semikolon, Datum Uhrzeit und Leistungswerte in kW.
#### Beispiel „MFH_Profil_PV_Erzeugung_12FH_Sued.csv“:
Time;PV-Erzeugung  12FH          
;kW  
01.01.2021 00:00;0  
01.01.2021 00:15;0  
01.01.2021 00:30;0  


### Dateiformat (TRNSYS – „*.txt“):
Kombination aus bis zu 2 Dachseiten je nach Konfiguration/Ausrichtung der Dachflächen (z.B. Nord-Süd oder Ost-West). 2 Zeilen Header und Erzeugungswerte in kW mit Trennzeichen Tabulator.

#### Beispiel „MFH_Profil_PV_Erzeugung_12FH_NordSued.txt“
Nord PV-Erzeugung  12FH  Sued PV-Erzeugung  12FH  
kW  kW  
0  0  
0  0  
0  0  

## Trinkwarmwasser
Die Trinkwarmwasserprofile werden auf Grundlage der VDI 4645 in Abhängigkeit der Bewohneranzahl erstellt. Dabei werden typische tages- und jahreszeitliche Verbrauchsmuster berücksichtigt, um den zeitlichen Verlauf des Warmwasserbedarfs möglichst realistisch abzubilden. Ausgehend von einem Verbrauch von 25 Liter pro Tag und Bewohner bei Quelltemperatur 10 °C und Trinkwarmwassertemperatur 60 °C wird in Energiemenge Trinkwarmwasser in kWh umgerechnet und für die Profile verwendet. Die Trinkwarmwasserprofile sind im 60 Minuten Zeitintervall.
### Dateiformat („*.csv“):
Die erste Zeile (Header, zum Beispiel „Time;Qtww…“) dient als Überschrift/Identifikation der folgenden Werte. Zeitintervall 60 Minuten, Trennzeichen Semikolon, Datum Uhrzeit und Summenwerte in kWh.
#### Beispiel „MFH_Lastprofil_TWW_Bedarf_12FH.csv“:
Time;Qtww 12FH                       
;kW  
01.01. 00:00;1,14  
01.01. 01:00;1,07  
01.01. 02:00;0,68  

### Dateiformat (TRNSYS – „*.txt“):
Ersten zwei Zeilen Header (Quartier, Einheit), als Überschrift/Identifikation der folgenden Werte. Beim Einlesen der Werte in der TRNSYS Simulation mit dem Data-Reader-Type 9 wird diese übersprungen („Header Lines to Skip  2“).
Es folgen die kW-Werte im 60-Minutenintervall mit Punkt als Dezimaltrennzeichen die Werte werden von TRNSYS interpoliert den Simulationszeitschritt.

#### Beispiel „MFH_Lastprofil_TWW_Bedarf_12FH.txt“:
Qtww 12FH                       
kW  
1.14  
1.07  
0.68  

## Heizlast
Die Heizwärmeprofile werden mittels dynamisch-thermischer Gebäudesimulationen in TRNSYS erstellt. Grundlage sind die Gebäudeeigenschaften und standortspezifische Wetterdaten. Berücksichtigt werden unter anderem Gebäudestandard, Gebäudegeometrie, Wärmeübergabesysteme sowie interne Wärmegewinne. Raum-Solltemperatur 20 °C mit Nachtabsenkung zwischen 23.00 Uhr und 6.00 Uhr auf 16 °C.

### Dateiformat („*.csv“):
Zwei Zeilen Header („Time; QH_GES…“), Zeitintervall 15 Minuten, Trennzeichen Semikolon, Datum Uhrzeit und Leistungswerte in kW.
#### Beispiel „MFH_Lastprofil_Waermebedarf_GEG2020_12FH_O-W.csv“:
Time;QH_GES 12FH                     
;kW                     
01.01.2021 00:00;0  
01.01.2021 00:15;0  
01.01.2021 00:30;0  

### Dateiformat (TRNSYS – „*.txt“):
Ersten zwei Zeilen Header (Quartier, Einheit), als Überschrift/Identifikation der folgenden Werte. Beim Einlesen der Werte in der TRNSYS Simulation mit dem Data-Reader-Type 9 wird diese übersprungen („Header Lines to Skip  2“).
Es folgen die kW-Werte im 15-Minutenintervall mit Punkt als Dezimaltrennzeichen.

#### Beispiel „MFH_Lastprofil_Waermebedarf_GEG2020_12FH_O-W.txt“:
QH_GES 12FH                     
kW                     
0  
0  
0  


# Referenzen
Pflugradt et al., (2022). LoadProfileGenerator: An Agent-Based Behavior Simulation for Generating Residential Load Profiles. Journal of Open Source Software, 7(71), 3574, https://doi.org/10.21105/joss.03574
