# Regionsspezifischer Datensatz für Rüdersdorf b Berlin (r120640428428)

Die meisten der Rohdatensätze können für eine beliebige Region in Deutschland
verwendet werden. Einige sind jedoch nur für eine Teilregion verfügbar oder
spezifisch für die Region **r120640428428** :

## Daten für die Energiesystemmodellierung

### Strombedarf

#### Gesamtstrombedarf (2045), normiert

| Name                     | Raw-Datensatz | Dataset                                                       | Kommentar       |
|--------------------------|---------------|---------------------------------------------------------------|-----------------|
| *electricity-demand_hh*  |               |                                                               |                 |
| *electricity-demand_cts* |               |                                                               |                 |
| *electricity-demand_ind* |               |                                                               |                 |    
| *electricity-demand_mob* |               |                                                               |                 |
 

*[Platzhalter für weiterführende Erklärungen und Annahmen]*



#### Stromlastprofile, normiert

| Name                             | Raw-Datensatz | Dataset                                                       | Kommentar           |
|----------------------------------|---------------|---------------------------------------------------------------|---------------------|
| *electricity-demand_hh_profile*  |               |                                                               | not region-specific |
| *electricity-demand_cts_profile* |               |                                                               | not region-specific                    |
| *electricity-demand_ind_profile* |               |                                                               | not region-specific                    |    
| *electricity-demand_mob_profile* |               |                                                               | not region-specific                    |   

*[Platzhalter für weiterführende Erklärungen und Annahmen]*

------------------------------------------------------------------------------------------------------------------------
### Wärmebedarf Niedrigtemperaturwärme

#### Gesamtwärmebedarf Niedrigtemperaturwärme zentral (2045) in GWh

| Name                         | Raw-Datensatz | Dataset                                                       | Kommentar       |
|------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_low_central-demand_hh* |               |                                                               |                 |
| *heat_low_central-demand_cts* |               |                                                               |                 |
| *heat_low_central-demand_ind*     |               |                                                               |                 |    

 

*[Platzhalter für weiterführende Erklärungen]*

#### Gesamtwärmebedarf Niedrigtemperaturwärme dezentral (2045) in GWh

| Name                         | Raw-Datensatz | Dataset                                                       | Kommentar       |
|------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_low_central-demand_hh* |               |                                                               |                 |
| *heat_low_central-demand_cts* |               |                                                               |                 |
| *heat_low_central-demand_ind*     |               |                                                               |                 |    

 

*[Platzhalter für weiterführende Erklärungen]*

#### Wärmelastprofile Niedrigtemperaturwärme zentral, normiert

| Name                                  | Raw-Datensatz | Dataset                                                       | Kommentar       |
|---------------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_low_central-demand_hh_profile*  |               |                                                               |                 |
| *heat_low_central-demand_cts_profile* |               |                                                               |                 |
| *heat_low_central-demand_ind_profile* |               |                                                               |                 | 

*[Platzhalter für weiterführende Erklärungen]*

#### Wärmelastprofile Niedrigtemperaturwärme dezentral, normiert

| Name                                    | Raw-Datensatz | Dataset                                                       | Kommentar       |
|-----------------------------------------|---------------|---------------------------------------------------------------|-----------------|
| *heat_low_decentral-demand_hh_profile*  |               |                                                               |                 |
| *heat_low_decentral-demand_cts_profile* |               |                                                               |                 |
| *heat_low_decentral-demand_ind_profile* |               |                                                               |                 | 

*[Platzhalter für weiterführende Erklärungen]*

--------------------------------------------------------------------------------------------------------------------
### Wärmebedarf Prozesswärme (150-500°C)
Annahmen:
- Temperaturniveau: 150-500′C (med)
- Anwendungsgebiet: Prozessdampf- und Warmwasser für Industrieprozesse [Quelle:Langfristszenarien]

#### Gesamtwärmebedarf Prozesswärme (2045) in GWh

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

#### Gesamtwärmebedarf Prozesswärme (2045) in GWh

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


#### Ausbaupotentiale EE-Technologie in GW

| Name                                                       | Raw-Datensatz | Dataset | Kommentar |
|------------------------------------------------------------|---------------|---------|-----------|
| _electricity-wind-capacity_potential_                      |               |         |           | 
| _electricity-pv_ground-capacity_potential_                 |               |         |           | 
| _electricity-pv_agri_vertical-capacity_potential_          |               |         |           | 
| _electricity-pv_agri_horizontal-capacity_potential_        |               |         |           |
| _electricity-pv_rooftop-capacity_potential_                |               |         |           | 
| _heat_low_decentral-solarthermal_plant-capacity_potential_ |               |         |           |

----------------------------------------------------------------------------------------------------------------------
### Wärmepumpen 

#### Ausbaupotentiale für Wärmepumpen in GW

| Name                                                | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------------|---------------|---------|-----------|
| _electricity-heatpump_central-capacity_potential_   |               |         |           | 
| _electricity-heatpump_decentral-capacity_potential_ |               |         |           | 
| _electricity-heatpump_heat_med-capacity_potential_  |               |         |           | 

#### COP-Zeitreihen für Wärmepumpen, normiert

| Name                                     | Raw-Datensatz | Dataset               | Kommentar                                                                 |
|------------------------------------------|---------------|-----------------------|---------------------------------------------------------------------------|
| _electricity-heatpump_central-profile_   |               | `datasets/heatpump_cop` | Zeitreihe wird auch für electricity-heatpump_decentral-profile angenommen | 
| _electricity-heatpump_decentral-profile_ |               | `datasets/heatpump_cop` |                                                                           | 
| _electricity-heatpump_heat_med-profile_  |               |                       | Hochtemperaturwärmepumpe                                                  |

----------------------------------------------------------------------------------------------------------------------
## Kraft-Wärme-Kopplung

#### Ausbaupotentiale für KWK in GW

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


#### feste Kapazitäten für KWK in GW

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

#### Ausbaupotentiale für Brennkessel in GW

| Name                                               | Raw-Datensatz | Dataset | Kommentar |
|----------------------------------------------------|---------------|---------|-----------|
| _biomass_solid-boiler_heat_med-capacity_potential_ |               |         |           | 
| _biomass_solid-boiler_heat_high-capacity_potential_          |               |         |           | 
| _electricity-boiler_heat_med-capacity_potential_             |               |         |           | 
| _electricity-boiler_heat_high-capacity_potential_            |               |         |           | 
| _h2-boiler_heat_med-capacit_potentialy_                      |               |         |           | 
| _h2-boiler_heat_high-capacity_potential_                     |               |         |           | 


#### feste Kapazitäten für Brennkessel in GW

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

#### Ausbaupotentiale für Speicher in GW

| Name                                              | Raw-Datensatz | Dataset | Kommentar |
|---------------------------------------------------|---------------|---------|-----------|
| _electricity-battery_storage-capacity_potential_ |               |         |           | 
| _heat_low_central-storage-capacity_potential_          |               |         |           | 
| _heat_low_decentral-storage-capacity_potential_            |               |         |           |

#### feste Kapazitäten für Speicher in GW

| Name                                    | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------|---------------|---------|-----------|
| _electricity-battery_storage-capacity_ |               |         |           | 
| _heat_low_central-storage-capacity_ |               |         |           | 
| _heat_low_decentral-storage-capacity_  |               |         |           |

----------------------------------------------------------------------------------------------------------------------
## Elektrolyseur

#### Ausbaupotentiale für Elektrolyseur  in GW

| Name                                          | Raw-Datensatz | Dataset | Kommentar |
|-----------------------------------------------|---------------|---------|-----------|
| _electricity-electrolyzer-capacity_potential_ |               |         |           | 


#### feste Kapazitäten für Elektrolyseur in GW

| Name                                | Raw-Datensatz | Dataset | Kommentar |
|-------------------------------------|---------------|---------|-----------|
| _electricity-electrolyzer-capacity_ |               |         |           |

----------------------------------------------------------------------------------------------------------------------
## Export

#### feste Kapazitäten für Export in GW

| Name                          | Raw-Datensatz | Dataset | Kommentar |
|-------------------------------|---------------|---------|-----------|
| _h2-export-capacity_          |               |         |           |
| _electricity-export-capacity_ |               |         |           |