"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""
import pandas as pd
import geopandas as gpd
from apipe.store.utils import (
    get_abs_dataset_path,
    PATH_TO_REGION_MUNICIPALITIES_GPKG
)
from apipe.scripts.datasets.demand import demand_prognosis
DATASET_PATH = get_abs_dataset_path(
    "datasets", "demand_heat_region2", data_dir=True)

# TO DO:
# - modify rules for also include values of 2045 scenario (reduction factor)
# - add demand_heat_structure_cen.csv
# - (add demand_heat_structure_esys_cen.csv)
# - (add demand_heat_structure_esys_dec.csv)


rule heat_demand_hh_ct_ind:
    """
    Extracts heat demand values of the building types 'residential' (hh) / 'non-residential' (cts) / 'industry' (ind) for each municipality and saves them as seperate CSV files for each sector.
    2022 and 2045 scenario.
    """
    input:
        preprocessed_wfbb=get_abs_dataset_path(
            "preprocessed", "wfbb_heat_atlas_bb") / "data" / "wfbb_heat_atlas.csv",
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
        demand_future_TN=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "TN-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_TN_ind=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "TN-Strom_ind_demand_reformatted.csv",
        demand_future_T45=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "T45-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_T45_ind=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "T45-Strom_ind_demand_reformatted.csv",
    output:
        demand_res_heat_demand=DATASET_PATH / "demand_hh_heat_demand.csv",
        demand_nonres_heat_demand=DATASET_PATH / "demand_cts_heat_demand.csv",
        demand_ind_heat_demand=DATASET_PATH / "demand_ind_heat_demand.csv",
    params:
        sectors = ["hh", "cts", "ind"],
        build_type_column_selection = ["build_type_residential_heat_demand", "build_type_non_residential_heat_demand", "build_type_industry_heat_demand"]
    run:
        muns_data = gpd.read_file(input.region_muns)
        wfbb_data = pd.read_csv(input.preprocessed_wfbb, dtype=str)
        merged_data = pd.merge(muns_data, wfbb_data, on="ags", how="inner")
        for idx, column_name in enumerate(params.build_type_column_selection):
            extracted_data = merged_data[["id", column_name]].rename(columns={column_name: 2022, "id": "municipality_id"})
            extracted_data.set_index("municipality_id", inplace=True)
            extracted_data[2022] = extracted_data[2022].astype(float)
            extracted_data = extracted_data.join(
                demand_prognosis(
                    demand_future_T45=input.demand_future_T45_ind if params.sectors[idx] == "ind" else input.demand_future_T45,
                    demand_future_TN=input.demand_future_TN_ind if params.sectors[idx] == "ind" else input.demand_future_TN,
                    demand_region=extracted_data,
                    year_base=2022,
                    year_target=2045,
                    scale_by="total",
                    ).rename(columns={2022: 2045})
                )
            extracted_data = extracted_data.div(1e3)  # kWh to MWh
            output_file = DATASET_PATH / f"demand_{params.sectors[idx]}_heat_demand.csv"
            extracted_data.to_csv(output_file, index=True)


rule heat_demand_dec_cen:
    """
    Extracts and computes decentralized and centralized heat demand across 'hh', 'cts', and 'ind' sectors for each municipality, saving the data as separate CSV files for each sector.
    2022 and 2045 scenario.
    """
    input:
        preprocessed_wfbb=get_abs_dataset_path(
            "preprocessed", "wfbb_heat_atlas_bb") / "data" / "wfbb_heat_atlas.csv",
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
        demand_future_TN=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "TN-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_TN_ind=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "TN-Strom_ind_demand_reformatted.csv",
        demand_future_T45=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "T45-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_T45_ind=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "T45-Strom_ind_demand_reformatted.csv",
    output:
        demand_hh_heat_demand_dec=DATASET_PATH / "demand_hh_heat_demand_dec.csv",
        demand_cts_heat_demand_dec=DATASET_PATH / "demand_cts_heat_demand_dec.csv",
        demand_ind_heat_demand_dec=DATASET_PATH / "demand_ind_heat_demand_dec.csv",
        demand_hh_heat_demand_cen=DATASET_PATH / "demand_hh_heat_demand_cen.csv",
        demand_cts_heat_demand_cen=DATASET_PATH / "demand_cts_heat_demand_cen.csv",
        demand_ind_heat_demand_cen=DATASET_PATH / "demand_ind_heat_demand_cen.csv",
    params:
        sectors=["hh", "cts", "ind"],
        decentral_demand_columns=[
            "energy_carrier_solid_biomass_heat_demand",
            "energy_carrier_gas_heat_demand",
            "energy_carrier_coal_heat_demand",
            "energy_carrier_oil_heat_demand",
            "energy_carrier_electricity_heat_demand"
        ],
        central_demand_column="energy_carrier_heat_networks_heat_demand",
        build_type_column_selection=[
            "build_type_residential_heat_demand",
            "build_type_non_residential_heat_demand",
            "build_type_industry_heat_demand"
        ]
    run:
        muns_data = gpd.read_file(input.region_muns)
        wfbb_data = pd.read_csv(input.preprocessed_wfbb, dtype=str)

        wfbb_data[params['decentral_demand_columns']] = wfbb_data[params['decentral_demand_columns']].apply(pd.to_numeric, errors='coerce')
        wfbb_data[params['central_demand_column']] = wfbb_data[params['central_demand_column']].apply(pd.to_numeric, errors='coerce')

        merged_data = pd.merge(muns_data, wfbb_data, on='ags', how='inner').rename(columns={'id': 'municipality_id'})
        merged_data.set_index("municipality_id", inplace=True)
        for idx, sector in enumerate(params['sectors']):
            decentral_demand = merged_data[params['decentral_demand_columns']].sum(axis=1)
            central_demand = merged_data[params['central_demand_column']]
            build_type_demand = merged_data[params['build_type_column_selection'][idx]]

            decentral_demand_build_type = pd.to_numeric(build_type_demand, errors='coerce') * (decentral_demand / (decentral_demand + central_demand))
            central_demand_build_type = pd.to_numeric(build_type_demand, errors='coerce') * (central_demand / (decentral_demand + central_demand))

            output_file_dec = DATASET_PATH / f"demand_{sector}_heat_demand_dec.csv"
            output_data_dec = pd.DataFrame({2022: decentral_demand_build_type}, index=merged_data.index)
            output_data_dec = output_data_dec.join(
                demand_prognosis(
                    demand_future_T45=input.demand_future_T45_ind if sector == "ind" else input.demand_future_T45,
                    demand_future_TN=input.demand_future_TN_ind if sector == "ind" else input.demand_future_TN,
                    demand_region=output_data_dec,
                    year_base=2022,
                    year_target=2045,
                    scale_by="total",
                ).rename(columns={2022: 2045})
            )
            output_data_dec = output_data_dec.div(1e3)  # kWh to MWh
            output_data_dec.to_csv(output_file_dec, index=True)

            output_file_cen = DATASET_PATH / f"demand_{sector}_heat_demand_cen.csv"
            output_data_cen = pd.DataFrame({2022: central_demand_build_type}, index=merged_data.index)
            output_data_cen = output_data_cen.join(
                demand_prognosis(
                    demand_future_T45=input.demand_future_T45_ind if sector == "ind" else input.demand_future_T45,
                    demand_future_TN=input.demand_future_TN_ind if sector == "ind" else input.demand_future_TN,
                    demand_region=output_data_cen,
                    year_base=2022,
                    year_target=2045,
                    scale_by="total",
                ).rename(columns={2022: 2045})
            )
            output_data_cen = output_data_cen.div(1e3)  # kWh to MWh
            output_data_cen.to_csv(output_file_cen, index=True)


rule heat_demand_structure_dec:
    """
    Calculate the percentage shares of each energy carrier in total decentralized heat demand and export as a CSV file.
    """
    input:
        preprocessed_wfbb=get_abs_dataset_path("preprocessed", "wfbb_heat_atlas_bb") / "data" / "wfbb_heat_atlas.csv",
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG
    output:
        demand_rel_csv=DATASET_PATH / "demand_heat_structure_dec.csv"
    params:
        decentral_demand_columns=[
            "energy_carrier_solid_biomass_heat_demand",
            "energy_carrier_gas_heat_demand",
            "energy_carrier_coal_heat_demand",
            "energy_carrier_oil_heat_demand",
            "energy_carrier_electricity_heat_demand"
        ]
    run:
        muns_data = gpd.read_file(input.region_muns)
        wfbb_data = pd.read_csv(input.preprocessed_wfbb, dtype=str)

        merged_data = pd.merge(muns_data, wfbb_data, on='ags', how='inner').rename(columns={'id': 'municipality_id'})
        merged_data[params.decentral_demand_columns] = merged_data[params.decentral_demand_columns].apply(pd.to_numeric, errors='coerce')
        total_demand_per_municipality = merged_data.groupby(['municipality_id'])[params.decentral_demand_columns].sum()

        total_demand_per_carrier = merged_data[params.decentral_demand_columns].sum()

        demand_rel = total_demand_per_carrier / total_demand_per_carrier.sum()
        demand_rel = demand_rel.reset_index()
        demand_rel.columns = ["carrier", "demand_rel"]
        demand_rel["year"] = 2022

        demand_rel = demand_rel[['year', 'carrier', 'demand_rel']]
        demand_rel['carrier'] = demand_rel['carrier'].str.replace('energy_carrier_', '').str.replace('_heat_demand', '')

        demand_rel.to_csv(output.demand_rel_csv, index=False)
