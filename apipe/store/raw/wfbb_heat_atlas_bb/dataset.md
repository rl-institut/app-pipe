# Wärmekataster Brandenburg (Bestands- und Potenzialanalyse)

Bestands- und Potenzialanalyse zur kommunalen Wärmeplanung im Auftrag des Ministeriums für Wirtschaft, Arbeit und Energie des Landes Brandenburg mit Unterstützung der Energieagentur Brandenburg durch con|energy consult GmbH.

Diese Analyse des Wärmesektors basiert auf modellierten Daten, die von den tatsächlichen Verbrauchswerten abweichen können. Das Modell nutzt verfügbare Informationen zur Gebäudegeometrie und Nutzung, um den Wärmebedarf und den Endenergieverbrauch mithilfe von Gebäudetypen, statistischer Zuordnung des Sanierungszustands und des Heizungssystems abzuschätzen.

Stand: 27.02.2023

© Wirtschaftsförderung Land Brandenburg GmbH | Energieagentur des Landes Brandenburg

---

### Datenabruf aus Wärmekataster Brandenburg

Datenauszug aus Energieportal-Brandenburg (26.9.2023):
https://energieportal-brandenburg.de/cms/inhalte/tools/werkzeugkasten-kommunale-waermeplanung/waermekataster-bestands-und-potenzialanalyse

Datei: `2023-09-26_waermekataster_bestand_potenzial_analyse_download.csv`

Gewählte Kategorien:

* **Aggregationsebene**:
  * Städte, Gemeinden
* **Jahr**:
  * 2022
* **Sanierungszustand**:
  * Neubau,
  * Vollsaniert
  * Teilsaniert
  * Unsaniert
* **Gebäudetyp**:
  * Industrie
  * Nichtwohngebäude
  * Wohngebäude
* **Energieträger**:
  * Wärmenetze
  * Feste Biomasse
  * Gas
  * Kohle
  * Öl
  * Strom
* **Baualtersklasse**: -
* **Nutzungsart**:
  * Gewerbe
  * Öffentliche Hand
  * Sonstiges
  * Wohnen
* **Heizungstechnik**:
  * Gasetagenheizung
  * Gaskessel
  * Nachtspeicher
  * Ölkessel
  * Pelletkessel
  * Sonstiges
  * Wärmenetz
  * Wärmepumpe (Strom)
* **Wärmekategorie**:
  * Kälte
  * Prozesskälte
  * Prozesswärme
  * Raumwärme
* **Potenziale Wärmeerzeugung**:
  * Abwärme
  * Abwasser
  * Biomasse
  * Flussthermie
  * Seethermie

---

### Beschreibung

Details zu Hintergrund und Methodik: [Abschlussdokumentation zu Wärmekataster BB](https://energieportal-brandenburg.de/cms/fileadmin/medien/dokumente/waermeplanung/20230828_dokumentation_waermekataster_kurz.pdf)

Je Stadt/Gemeinde sind *Wärmebedarfe* (kWh), *CO2-Emissionen* (t CO2-Äq.) und *Endenergieverbräuche* (kWh) für das Jahr 2022 enthalten. Diese sind jeweils nach den ausgewählten Kategorien aufgeteilt (siehe oben).

Außerdem sind jeweils die *theoretischen Potenzialmengen* (kWh) für *Wärmeerzeugung* durch *Abwärme*, *Abwasser*, *Biomasse*, *Flussthermie* und *Seethermie* enthalten.

### Informationen zur Gebäude-Kategorisierung

* **Gebäudetypen:**
  * *Industrie*
    * Produktionsgebäude
    * Fabrik
  * *Nicht Wohngebäude*
    * Krankenhaus
    * Bürogebäude
    * Gericht
    * Einkaufszentrum
  * *Wohngebäude*
    * Einfamilienhaus
    * Reihenhaus
    * Mehrfamilienhaus
    * Hochhaus
* **Sanierungszustand:**
  * Da keine gebäudescharfe Ermittlung des Sanierungszustands möglich war, erfolgte die Zuordnung anhand statistischer Verteilung
  * Der Sanierungszustand wurde basierend auf ihrem Anteil gem. [UBA Studie](https://www.umweltbundesamt.de/sites/default/files/medien/1410/publikationen/2019-06-03-barrierefrei-broschuere_wohnenundsanieren.pdf) zugewiesen.
    * Die Anzahl der Neubauten aus der Gebäudefortschreibung des Zensus wurde für die Verteilung der Neubauten auf regionaler Ebene genutzt
  * Je nach Sanierungszustand erhielt ein Gebäude einen spez. Wärmebedarf gem. [IWU Gebäudetypologie](https://www.iwu.de/fileadmin/publikationen/gebaeudebestand/episcope/2015_IWU_LogaEtAl_Deutsche-Wohngeb%C3%A4udetypologie.pdf)
  * Die Nicht-Wohngebäude bekamen den Zustand unsaniert
