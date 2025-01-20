# Regionsspezifischer Datensatz für Rüdersdorf b Berlin (r120640428428)

Die meisten der Rohdatensätze können für eine beliebige Region in Deutschland
verwendet werden. Einige sind jedoch nur für eine Teilregion verfügbar oder
spezifisch für die Region **r120640428428** :

## Daten für die Energiesystemmodellierung

### Strombedarf

#### Gesamtstrombedarf (2045), normiert

| Name                     | Raw-Datensatz | Dataset                   | Kommentar |
|--------------------------|---------------|---------------------------|-----------|
| *electricity-demand_hh*  | demandregio   | demand_electricity_region |           |
| *electricity-demand_cts* | demandregio   | demand_electricity_region |           |
| *electricity-demand_ind* | demandregio   | demand_electricity_region |           |
| *electricity-demand_mob* |               |                           |           |
 

*[Platzhalter für weiterführende Erklärungen und Annahmen]*



#### Stromlastprofile, normiert

| Name                             | Raw-Datensatz | Dataset                   | Kommentar |
|----------------------------------|---------------|---------------------------|-----------|
| *electricity-demand_hh_profile*  | demandregio   | demand_electricity_region |           |
| *electricity-demand_cts_profile* | demandregio   | demand_electricity_region |           |
| *electricity-demand_ind_profile* | demandregio   | demand_electricity_region |           |
| *electricity-demand_mob_profile* |               |                           |           |

*[Platzhalter für weiterführende Erklärungen und Annahmen]*

------------------------------------------------------------------------------------------------------------------------
### Wärmebedarf Niedrigtemperaturwärme

#### Gesamtwärmebedarf Niedrigtemperaturwärme zentral (2045) in MWh

| Name                          | Raw-Datensatz      | Dataset             | Kommentar                                                               |
|-------------------------------|--------------------|---------------------|-------------------------------------------------------------------------|
| *heat_low_central-demand_hh*  | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` |
| *heat_low_central-demand_cts* | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` |
| *heat_low_central-demand_ind* | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` | 

BMWK lfs

*[Platzhalter für weiterführende Erklärungen]*

#### Gesamtwärmebedarf Niedrigtemperaturwärme dezentral (2045) in MWh

| Name                            | Raw-Datensatz      | Dataset             | Kommentar                                                               |
|---------------------------------|--------------------|---------------------|-------------------------------------------------------------------------|
| *heat_low_decentral-demand_hh*  | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` |
| *heat_low_decentral-demand_cts* | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` |
| *heat_low_decentral-demand_ind* | wfbb_heat_atlas_bb | demand_heat_region2 | Manueller Checkout von `features/#3_add_dataset_heat_atlas_brandenburg` |

BMWK lfs

*[Platzhalter für weiterführende Erklärungen]*

#### Wärmelastprofile Niedrigtemperaturwärme zentral und dezentral, normiert

| Name                                  | Raw-Datensatz | Dataset            | Kommentar |
|---------------------------------------|---------------|--------------------|-----------|
| *heat_low_central-demand_hh_profile*  | demandregio   | demand_heat_region |           |
| *heat_low_central-demand_cts_profile* | demandregio   | demand_heat_region |           |
| *heat_low_central-demand_ind_profile* | demandregio   | demand_heat_region |           |

*[Platzhalter für weiterführende Erklärungen]*

--------------------------------------------------------------------------------------------------------------------
### Wärmebedarf Prozesswärme (150-500°C)
Annahmen:
- Temperaturniveau: 150-500′C (med)
- Anwendungsgebiet: Prozessdampf- und Warmwasser für Industrieprozesse [Quelle:Langfristszenarien]

#### Gesamtwärmebedarf Prozesswärme (2045) in MWh

| Name                          | Raw-Datensatz | Dataset                                                       | Kommentar       |
|-------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_med-demand_ind*         |               |                                                               |                 |

*[Platzhalter für weiterführende Erklärungen]*

#### Wärmelastprofile Prozesswwärme, normiert

| Name                          | Raw-Datensatz | Dataset                                                       | Kommentar       |
|-------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_med-demand_ind_profile* |               |                                                               |                 | 

--------------------------------------------------------------------------------------------------------------------
### Wärmebedarf Industrieöfen (>500°C)
Annahmen:
- Temperaturniveau: >-500′C (high)
- Anwendungsgebiet: Industrieöfen und Hochtemperaturverfahren für Industrieprozesse [Quelle:Langfristszenarien]

#### Gesamtwärmebedarf Prozesswärme (2045) in MWh

| Name                   | Raw-Datensatz | Dataset                                                       | Kommentar       |
|------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_high-demand_ind* |               |                                                               |                 |

*[Platzhalter für weiterführende Erklärungen]*

#### Wärmelastprofile Niedrigtemperaturwärme dezentral, normiert

| Name                           | Raw-Datensatz | Dataset                                                       | Kommentar       |
|--------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_high-demand_ind_profile* |               |                                                               |                 | 

--------------------------------------------------------------------------------------------------------------------
### EE-Technologien

#### Einpeisezeitreihen EE-Technologien, normiert

| Name                                            | Raw-Datensatz | Dataset | Kommentar |
|-------------------------------------------------|---------------|---------|-----------|
| _electricity-wind-profile_                      |               |         |           | 
| _electricity-pv_ground-profile_                 |               |         |           | 
| _electricity-pv_agri_vertical-profile_          |               |         |           | 
| _electricity-pv_agri_horizontal-profile_        |               |         |           |
| _electricity-pv_rooftop-profile_                |               |         |           | 
| _heat_low_decentral-solarthermal_plant-profile_ |               |         |           |


#### Ausbaupotentiale EE-Technologie in MW

| Name                                                       | Raw-Datensatz          | Dataset                         | Kommentar                                                      |
|------------------------------------------------------------|------------------------|---------------------------------|----------------------------------------------------------------|
| _electricity-wind-capacity_potential_                      |                        |                                 | Keine Windpotenzialflächen nach Regionalplan 2024 (1. Entwurf) |
| _electricity-pv_ground-capacity_potential_                 | oei_agri_pv            | potentialarea_pv_ground_region2 | Bezeichnung in Daten: *soil_quality_low*                       |
| _electricity-pv_agri_vertical-capacity_potential_          | oei_agri_pv            | potentialarea_pv_ground_region2 | Bezeichnung in Daten: *soil_quality_medium*                    |
| _electricity-pv_agri_horizontal-capacity_potential_        | oei_agri_pv            | potentialarea_pv_ground_region2 | Bezeichnung in Daten: *permanent_crops*                        |
| _electricity-pv_rooftop-capacity_potential_                | wfbb_pv_roof_potential | potentialarea_pv_roof_region2   |                                                                |
| _heat_low_decentral-solarthermal_plant-capacity_potential_ |                        |                                 |                                                                |

----------------------------------------------------------------------------------------------------------------------
### Wärmepumpen 

#### Ausbaupotentiale für Wärmepumpen in MW

| Name                                                | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------------|---------------|---------|-----------|
| _electricity-heatpump_central-capacity_potential_   |               |         |           | 
| _electricity-heatpump_decentral-capacity_potential_ |               |         |           | 
| _electricity-heatpump_heat_med-capacity_potential_  |               |         |           | 


#### Feste Kapazitäten für Wärmepumpen in MW


| Name                                               | Raw-Datensatz | Dataset | Kommentar |
|----------------------------------------------------|---------------|---------|-----------|
| _electricity-heatpump_central-capacity_   |               |         |           | 
| _electricity-heatpump_decentral-capacity_ |               |         |           | 
| _electricity-heatpump_heat_med-capacity_  |               |         |           | 

#### COP-Zeitreihen für Wärmepumpen, normiert

| Name                                     | Raw-Datensatz | Dataset               | Kommentar                                                                 |
|------------------------------------------|---------------|-----------------------|---------------------------------------------------------------------------|
| _electricity-heatpump_central-profile_   |               | `datasets/heatpump_cop` | Zeitreihe wird auch für electricity-heatpump_decentral-profile angenommen | 
| _electricity-heatpump_decentral-profile_ |               | `datasets/heatpump_cop` |                                                                           | 
| _electricity-heatpump_heat_med-profile_  |               |                       | Hochtemperaturwärmepumpe                                                  |

----------------------------------------------------------------------------------------------------------------------
## Kraft-Wärme-Kopplung

#### Ausbaupotentiale für KWK in MW

| Name                                                | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------------|---------------|---------|-----------|
| _biomass_solid-bpchp_heat_low_decentral-capacity_potential_   |               |         |           | 
| _biomass_solid-bpchp_heat_low_central-capacity_potential_ |               |         |           | 
| _biomass_solid-bpchp_heat_med-capacity_potential_  |               |         |           | 
| _biomass_gas-bpchp_heat_low_decentral-capacity_potential_  |               |         |           | 
| _biomass_gas-bpchp_heat_low_central-capacity_potential_  |               |         |           | 
| _biomass_gas-bpchp_heat_med-capacity_potential_  |               |         |           | 
| _biomass_solid-extchp_heat_med-capacity_potential_  |               |         |           | 
| _biomass_solid-extchp_heat_high-capacity_potential_  |               |         |           | 
| _biomass_gas-extchp_heat_med-capacity_potential_  |               |         |           | 
| _biomass_gas-extchp_heat_high-capacity_potential_  |               |         |           | 
| _h2-extchp_heat_high-capacity_potential_  |               |         |           | 
| _residual_waste-extchp_heat_high-capacity_potential_  |               |         |           | 
| _residual_waste-extchp_heat_low_central-capacity_potential_  |               |         |           | 


#### feste Kapazitäten für KWK in MW

| Name                                                | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------------|---------------|---------|-----------|
| _biomass_solid-bpchp_heat_low_decentral-capacity_   |               |         |           | 
| _biomass_solid-bpchp_heat_low_central-capacity_ |               |         |           | 
| _biomass_solid-bpchp_heat_med-capacity_  |               |         |           | 
| _biomass_gas-bpchp_heat_low_decentral-capacity_  |               |         |           | 
| _biomass_gas-bpchp_heat_low_central-capacity_  |               |         |           | 
| _biomass_gas-bpchp_heat_med-capacity_  |               |         |           | 
| _biomass_solid-extchp_heat_med-capacity_  |               |         |           | 
| _biomass_solid-extchp_heat_high-capacity_  |               |         |           | 
| _biomass_gas-extchp_heat_med-capacity_  |               |         |           | 
| _biomass_gas-extchp_heat_high-capacity_  |               |         |           | 
| _h2-extchp_heat_high-capacity_  |               |         |           | 
| _residual_waste-extchp_heat_high-capacity_  |               |         |           | 
| _residual_waste-extchp_heat_low_central-capacity_  |               |         |           | 

----------------------------------------------------------------------------------------------------------------------
## Brennkessel

#### Ausbaupotentiale für Brennkessel in MW

| Name                                               | Raw-Datensatz | Dataset | Kommentar |
|----------------------------------------------------|---------------|---------|-----------|
| _biomass_solid-boiler_heat_med-capacity_potential_ |               |         |           | 
| _biomass_solid-boiler_heat_high-capacity_potential_          |               |         |           | 
| _electricity-boiler_heat_med-capacity_potential_             |               |         |           | 
| _electricity-boiler_heat_high-capacity_potential_            |               |         |           | 
| _h2-boiler_heat_med-capacit_potentialy_                      |               |         |           | 
| _h2-boiler_heat_high-capacity_potential_                     |               |         |           | 


#### feste Kapazitäten für Brennkessel in MW

| Name                                          | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------|---------------|---------|-----------|
| _biomass_solid-boiler_heat_med-capacity_      |               |         |           | 
| _biomass_solid-boiler_heat_high-capacity_     |               |         |           | 
| _electricity-boiler_heat_med-capacity_        |               |         |           | 
| _electricity-boiler_heat_high-capacity_       |               |         |           | 
| _h2-boiler_heat_med-capacity_ |               |         |           | 
| _h2-boiler_heat_high-capacity_         |               |         |           | 

----------------------------------------------------------------------------------------------------------------------
## Speicher

#### Ausbaupotentiale für Speicher in MW

| Name                                                   | Raw-Datensatz | Dataset | Kommentar |
|--------------------------------------------------------|---------------|---------|-----------|
| _electricity-large_battery_storage-capacity_potential_ |               |         |           |
| _heat_low_central-storage-capacity_potential_          |               |         |           | 


#### feste Kapazitäten für Speicher in MWh

| Name                                   | Raw-Datensatz | Dataset | Kommentar |
|----------------------------------------|---------------|---------|-----------|
| _electricity-small_battery_storage-capacity_ |               |         |           |
| _heat_low_decentral-storage-capacity_  |               |         |           |

----------------------------------------------------------------------------------------------------------------------
## Elektrolyseur

#### Ausbaupotentiale für Elektrolyseur  in MW

| Name                                          | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------|---------------|---------|-----------|
| _electricity-electrolyzer-capacity_potential_ |               |         |           | 


#### feste Kapazitäten für Elektrolyseur in MW


| Name                                | Raw-Datensatz | Dataset | Kommentar |
|-------------------------------------|---------------|---------|-----------|
| _electricity-electrolyzer-capacity_ |               |         |           |

----------------------------------------------------------------------------------------------------------------------
## Export

#### feste Kapazitäten für Export in MW

| Name                          | Raw-Datensatz | Dataset | Kommentar |
|-------------------------------|---------------|---------|-----------|
| _h2-export-capacity_          |               |         |           |
| _electricity-export-capacity_ |               |         |           |