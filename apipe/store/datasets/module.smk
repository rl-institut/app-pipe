"""
Dataset registry for datasets module which is loaded by main snakemake file.
All datasets in the datasets category must be added to this file.

Template:
---------
module <DATASET_NAME>:
    snakefile: "<DATASET_NAME>/create.smk"
    config: config["store"]["datasets"]["<DATASET_NAME>"]
use rule * from <DATASET_NAME> as datasets_<DATASET_NAME>_*

"""

module bkg_vg250_districts_region:
    snakefile: "bkg_vg250_districts_region/create.smk"
    config: config["store"]["datasets"]["bkg_vg250_districts_region"]
use rule * from bkg_vg250_districts_region as datasets_bkg_vg250_districts_region_*

module bkg_vg250_muns_region:
    snakefile: "bkg_vg250_muns_region/create.smk"
    config: config["store"]["datasets"]["bkg_vg250_muns_region"]
use rule * from bkg_vg250_muns_region as datasets_bkg_vg250_muns_region_*

module bkg_vg250_state:
    snakefile: "bkg_vg250_state/create.smk"
    config: config["store"]["datasets"]["bkg_vg250_state"]
use rule * from bkg_vg250_state as datasets_bkg_vg250_state_*

module bkg_vg250_federal_states:
    snakefile: "bkg_vg250_federal_states/create.smk"
    config: config["store"]["datasets"]["bkg_vg250_federal_states"]
use rule * from bkg_vg250_federal_states as datasets_bkg_vg250_federal_states_*

module bkg_vg250_region:
    snakefile: "bkg_vg250_region/create.smk"
    config: config["store"]["datasets"]["bkg_vg250_region"]
use rule * from bkg_vg250_region as datasets_bkg_vg250_region_*

module bnetza_mastr_wind_region:
    snakefile: "bnetza_mastr_wind_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_wind_region"]
use rule * from bnetza_mastr_wind_region as datasets_bnetza_mastr_wind_region_*

module bnetza_mastr_pv_ground_region:
    snakefile: "bnetza_mastr_pv_ground_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_pv_ground_region"]
use rule * from bnetza_mastr_pv_ground_region as datasets_bnetza_mastr_pv_ground_region_*

module bnetza_mastr_pv_roof_region:
    snakefile: "bnetza_mastr_pv_roof_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_pv_roof_region"]
use rule * from bnetza_mastr_pv_roof_region as datasets_bnetza_mastr_pv_roof_region_*

module bnetza_mastr_biomass_region:
    snakefile: "bnetza_mastr_biomass_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_biomass_region"]
use rule * from bnetza_mastr_biomass_region as datasets_bnetza_mastr_biomass_region_*

module bnetza_mastr_hydro_region:
    snakefile: "bnetza_mastr_hydro_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_hydro_region"]
use rule * from bnetza_mastr_hydro_region as datasets_bnetza_mastr_hydro_region_*

module bnetza_mastr_combustion_region:
    snakefile: "bnetza_mastr_combustion_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_combustion_region"]
use rule * from bnetza_mastr_combustion_region as datasets_bnetza_mastr_combustion_region_*

module bnetza_mastr_gsgk_region:
    snakefile: "bnetza_mastr_gsgk_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_gsgk_region"]
use rule * from bnetza_mastr_gsgk_region as datasets_bnetza_mastr_gsgk_region_*

module bnetza_mastr_storage_region:
    snakefile: "bnetza_mastr_storage_region/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_storage_region"]
use rule * from bnetza_mastr_storage_region as datasets_bnetza_mastr_storage_region_*

module bnetza_mastr_captions:
    snakefile: "bnetza_mastr_captions/create.smk"
    config: config["store"]["datasets"]["bnetza_mastr_captions"]
use rule * from bnetza_mastr_captions as datasets_bnetza_mastr_captions_*

module population_region:
    snakefile: "population_region/create.smk"
    config: config["store"]["datasets"]["population_region"]
use rule * from population_region as datasets_population_region_*

module employment_region:
    snakefile: "employment_region/create.smk"
    config: config["store"]["datasets"]["employment_region"]
use rule * from employment_region as datasets_employment_region_*

module demand_electricity_region:
    snakefile: "demand_electricity_region/create.smk"
    config: config["store"]["datasets"]["demand_electricity_region"]
use rule * from demand_electricity_region as datasets_demand_electricity_region_*

module heatpump_cop:
    snakefile: "heatpump_cop/create.smk"
    config: config["store"]["datasets"]["heatpump_cop"]
use rule * from heatpump_cop as datasets_heatpump_cop_*

module demand_heat_region:
    snakefile: "demand_heat_region/create.smk"
    config: config["store"]["datasets"]["demand_heat_region"]
use rule * from demand_heat_region as datasets_demand_heat_region_*

module renewable_feedin:
    snakefile: "renewable_feedin/create.smk"
    config: config["store"]["datasets"]["renewable_feedin"]
use rule * from renewable_feedin as datasets_renewable_feedin_*

module potentialarea_wind_region:
    snakefile: "potentialarea_wind_region/create.smk"
    config: config["store"]["datasets"]["potentialarea_wind_region"]
use rule * from potentialarea_wind_region as datasets_potentialarea_wind_region_*

module potentialarea_pv_ground:
    snakefile: "potentialarea_pv_ground/create.smk"
    config: config["store"]["datasets"]["potentialarea_pv_ground"]
use rule * from potentialarea_pv_ground as datasets_potentialarea_pv_ground_*

module potentialarea_pv_ground_region:
    snakefile: "potentialarea_pv_ground_region/create.smk"
    config: config["store"]["datasets"]["potentialarea_pv_ground_region"]
use rule * from potentialarea_pv_ground_region as datasets_potentialarea_pv_ground_region_*

module potentialarea_pv_ground_region2:
    snakefile: "potentialarea_pv_ground_region2/create.smk"
    config: config["store"]["datasets"]["potentialarea_pv_ground_region2"]
use rule * from potentialarea_pv_ground_region2 as datasets_potentialarea_pv_ground_region2_*

module potentialarea_pv_roof_region:
    snakefile: "potentialarea_pv_roof_region/create.smk"
    config: config["store"]["datasets"]["potentialarea_pv_roof_region"]
use rule * from potentialarea_pv_roof_region as datasets_potentialarea_pv_roof_region_*

module potentialarea_pv_roof_region2:
    snakefile: "potentialarea_pv_roof_region2/create.smk"
    config: config["store"]["datasets"]["potentialarea_pv_roof_region2"]
use rule * from potentialarea_pv_roof_region2 as datasets_potentialarea_pv_roof_region2_*

module rli_pv_wfr_region:
    snakefile: "rli_pv_wfr_region/create.smk"
    config: config["store"]["datasets"]["rli_pv_wfr_region"]
use rule * from rli_pv_wfr_region as datasets_rli_pv_wfr_region_ *

module technology_data:
    snakefile: "technology_data/create.smk"
    config: config["store"]["datasets"]["technology_data"]
use rule * from technology_data as datasets_technology_data_ *

module osm_buildings:
    snakefile: "osm_buildings/create.smk"
    config: config["store"]["datasets"]["osm_buildings"]
use rule * from osm_buildings as datasets_osm_buildings_ *

module rpg_ols_regional_plan:
    snakefile: "rpg_ols_regional_plan/create.smk"
    config: config["store"]["datasets"]["rpg_ols_regional_plan"]
use rule * from rpg_ols_regional_plan as datasets_rpg_ols_regional_plan_ *

module bfn_protected_areas_region:
    snakefile: "bfn_protected_areas_region/create.smk"
    config: config["store"]["datasets"]["bfn_protected_areas_region"]
use rule * from bfn_protected_areas_region as datasets_bfn_protected_areas_region_ *

module mwae_bb_energy_strategy_region:
    snakefile: "mwae_bb_energy_strategy_region/create.smk"
    config: config["store"]["datasets"]["mwae_bb_energy_strategy_region"]
use rule * from mwae_bb_energy_strategy_region as datasets_mwae_bb_energy_strategy_region_ *

module app_captions:
    snakefile: "app_captions/create.smk"
    config: config["store"]["datasets"]["app_captions"]
use rule * from app_captions as datasets_app_captions_ *

module app_settings:
    snakefile: "app_settings/create.smk"
    config: config["store"]["datasets"]["app_settings"]
use rule * from app_settings as datasets_app_settings_*

module demand_heat_region2:
    snakefile: "demand_heat_region2/create.smk"
    config: config["store"]["datasets"]["demand_heat_region2"]
use rule * from demand_heat_region2 as datasets_demand_heat_region2_*
