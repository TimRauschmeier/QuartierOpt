# Technisch-ökonomisches Optimierungsmodell

Das Modell ist in GAMS (General Algebraic Modeling System) implementiert und dient zur kostenoptimalen Dimensionierung und Betriebsführung lokaler Energiesysteme. 

Das Optimierungsmodell minimiert dabei die jährlichen Gesamtkosten des betrachteten lokalen Energiesystems. 
Die Optimierung bestimmt sowohl wirtschaftlich optimalen Anlagenkapazitäten als auch deren zeitlich aufgelösten Betrieb.
Die Modellierung erfolgt mit einer zeitlichen Auflösung von 15 Minuten über ein vollständiges Jahr mit insgesamt 35.040 Zeitschritten.

Allgemeine Hinweise zur Nutzung von GAMS befindet sich am Ende des README

## Aufbau des Modells

### GAMS-Dateien

Das Modell ist modular in mehrere GAMS-Dateien aufgeteilt. Diese befinden sich im Ordner "Gams Code".
- 01_Setup steuert den vollständigen Modelllauf.
- 02_Sets_Parameters enthält die grundlegenden Mengen, Parameter und techno-ökonomischen Modellannahmen.
- 03_Variables enthält die Entscheidungsvariablen des Optimierungsmodells.
- 04_Equations enthält die Zielfunktion und die Nebenbedingungen des Modells.
- 05_Results bereitet die Ergebnisse nach erfolgreicher Optimierung auf.

Der zu untersuchende Anwendungsfall wird in der Hauptdatei über globale Schalter ausgewählt.
Im Modell sind folgende Anwendungsfälle vorgesehen:
- MFH – generisches Mehrfamilienhaus    
- WERDERAU – Nürnberg-Werderau
- BRUCK – Erlangen-Bruck
- HERZOBASE – Herzogenaurach-Herzo Base

Abhängig vom Anwendungsfall können weitere Eigenschaften festgelegt werden.

### Eingangsdaten

Die Eingangsdaten befinden sich im Ordner "data". Sie basieren auf den im Rahmen des Forschungsprojekts erzeugten Last- und Erzeugungsprofilen. Die zugrunde liegenden Profile sind im Ordner "Lastprofile" abgelegt.
Für die Verwendung im Optimierungsmodell wurden die Daten entsprechend der benötigten Modellstruktur formatiert, den jeweiligen Anwendungsfällen zugeordnet und in einem für GAMS einlesbaren Format gespeichert.

Der jeweilige Dateiname beschreibt zunächst die Art der enthaltenen Zeitreihe. Unterschieden werden:
- Photovoltaik-Erzeugungsprofile (data_generation_pv)
- Haushaltsstrombedarfsprofile (data_demand_elec)
- Heizwärmebedarfsprofile (data_demand_heating)
- Trinkwarmwasserbedarfsprofile (data_demand_heating_tww)
- COP-Zeitreihen der Wärmepumpen (data_heatpump).
  
Abhängig vom Anwendungsfall wird die Bezeichnung des betrachteten Quartiers oder Gebäudes beziehungsweise Gebäudetyps an den Dateinamen angehängt.

### Zentrale Modellparameter

Ein wesentlicher Teil der Modellannahmen kann in 02_Sets_Parameters_Simple.gms angepasst werden.
Hierzu gehören insbesondere:
- Strombezugspreis aus dem öffentlichen Netz
- Vergütung für Stromeinspeisung
- Investitionskosten der Erzeugungstechnologien
- Investitionskosten der Speicher
- maximale installierbare Leistung einer Technologie
- maximale Speichergröße
- Verluste
- Wirkungsgrade 


### Zielfunktion und Nebenbedingungen
Die Zielfunktion der Optimierung minimiert die jährlichen Gesamtkosten des betrachteten Energiesystems.

Das Modell enthält unter anderem folgende technische und energetische Nebenbedingungen:
- Strombilanz
- Wärmebilanz
- Energiebilanz Strom-/Wärmespeicher
- Anlagenkapazitäten

### Optimierung und Solver
Das Modell wird als lineares Optimierungsproblem (LP) gelöst.
Als Solver wurde Gurobi verwendet.

## Hinweise zur Nutzung von GAMS

GAMS kann über die offizielle Webseite heruntergeladen und installiert werden.  
Download: https://www.gams.com/download/

Für die Ausführung größerer Optimierungsmodelle ist eine entsprechende GAMS-Lizenz erforderlich. Die kostenlose Demoversion unterliegt Einschränkungen hinsichtlich der Modellgröße.  
Darüber hinaus muss ein geeigneter Optimierungssolver verfügbar sein. 
 
Nach der Installation kann das Optimierungsmodell über die Entwicklungsumgebung GAMS Studio geöffnet und ausgeführt werden.  
Hier können die GAMS-Dateien geöffnet, bearbeitet, und die Optimierung gestartet werden.
