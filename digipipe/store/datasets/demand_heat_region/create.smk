"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""

import json
import geopandas as gpd
import numpy as np
import pandas as pd
from digipipe.scripts.geo import clip_raster, raster_zonal_stats
from digipipe.store.utils import (
    get_abs_dataset_path,
    get_abs_store_root_path,
    PATH_TO_REGION_MUNICIPALITIES_GPKG,
    PATH_TO_REGION_DISTRICTS_GPKG
)
from digipipe.scripts.datasets.demand import (
    demand_prognosis,
    disaggregate_demand_to_municipality,
    normalize_filter_timeseries
)

DATASET_PATH = get_abs_dataset_path(
    "datasets", "demand_heat_region", data_dir=True
)

rule raster_clip:
    """
    Clip raster file to boundary
    """
    input:
        heat_demand=get_abs_dataset_path(
            "preprocessed", "seenergies_peta5") / "data" / "HD_2015_{sector}_Peta5_0_1_GJ.tif",
        boundary=get_abs_store_root_path() / "datasets" / "{boundary_dataset}" / "data" / "{boundary_dataset}.gpkg"
    output:
        heat_demand = DATASET_PATH / "HD_2015_{sector}_Peta5_0_1_GJ_{boundary_dataset}.tif"
    run:
        clip_raster(
            raster_file_in=input.heat_demand,
            clip_file=input.boundary,
            raster_file_out=output.heat_demand,
        )

rule raster_convert_to_mwh:
    """
    Convert TIFF raster to geopackage and change unit from GJ to MWh
    Note: Unit conversion takes place after clipping as it takes too long to
          apply to entire dataset for Europe.
    """
    input: DATASET_PATH / "HD_2015_{sector}_Peta5_0_1_GJ_{boundary_dataset}.tif"
    output: DATASET_PATH / "HD_2015_{sector}_Peta5_0_1_MWh_{boundary_dataset}.tif"
    shell:
        """
        gdal_calc.py -A {input} --A_band=1 --outfile={output} --calc="A/3.6"
        rm {input}
        """

rule create_raster_zonal_stats:
    """
    Create zonal heat statistics (heat demand per geographical unit)
    """
    input:
        heat_demand=DATASET_PATH / "HD_2015_{sector}_Peta5_0_1_MWh_{boundary_dataset}.tif",
        clip_file=get_abs_store_root_path() / "datasets" / "{boundary_dataset}" / "data" / "{boundary_dataset}.gpkg"
    output:
        heat_demand=DATASET_PATH / "demand_heat_zonal_stats-{sector}-{boundary_dataset}.gpkg"
    run:
        raster_zonal_stats(
            raster_file_in=input.heat_demand,
            clip_file=input.clip_file,
            zonal_file_out=output.heat_demand,
            var_name="heat_demand",
            stats="sum"
        )

SECTOR_MAPPING = {"hh": "res", "cts": "ser"}

rule heat_demand_shares:
    """
    Calculate buildings' heat demand shares of federal state, region and
    municipalities by merging zonal statistics (for HH and CTS)
    """
    input:
        state=lambda wildcards: DATASET_PATH / f"demand_heat_zonal_stats-{SECTOR_MAPPING[wildcards.sector]}-bkg_vg250_state.gpkg",
        federal_states=lambda wildcards: DATASET_PATH / f"demand_heat_zonal_stats-{SECTOR_MAPPING[wildcards.sector]}-bkg_vg250_federal_states.gpkg",
        region_muns=lambda wildcards: DATASET_PATH / f"demand_heat_zonal_stats-{SECTOR_MAPPING[wildcards.sector]}-bkg_vg250_muns_region.gpkg"
    output:
        #demand_shares=lambda wildcards: SECTOR_MAPPING[wildcards.sector]
        demand_shares=DATASET_PATH / "demand_heat_shares_{sector}.json"
    run:
        # Read demands
        demand_state = gpd.read_file(input.state)
        demand_federal_state = gpd.read_file(input.federal_states)
        demand_region_muns = gpd.read_file(input.region_muns)

        demand_state = float(demand_state.heat_demand)
        demand_federal_state = float(
            demand_federal_state.loc[
                demand_federal_state.nuts == "DEE"].heat_demand)
        demand_region_muns = demand_region_muns.heat_demand

        # Calculate shares
        demand_shares = {
            "federal_state_of_state": demand_federal_state / demand_state,
            "region_of_federal_state": (
                demand_region_muns.sum() / demand_federal_state
            ),
            "muns_of_region": (
                    demand_region_muns / demand_region_muns.sum()
            ).to_dict()
        }

        # Dump
        with open(output.demand_shares, "w", encoding="utf8") as f:
            json.dump(demand_shares, f, indent=4)

rule heat_demand_hh_cts:
    """
    Calculate absolute heat demands for municipalities for HH and CTS
    """
    input:
        demand_germany=get_abs_dataset_path(
            "preprocessed", "ageb_energy_balance") / "data" /
            "ageb_energy_balance_germany_{sector}_twh_2021.csv",
        demand_shares=DATASET_PATH / "demand_heat_shares_{sector}.json",
        demand_future_TN=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "TN-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_T45=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "T45-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
    output:
        DATASET_PATH / "demand_{sector}_heat_demand.csv"
    run:
        ### Demand 2021 ###
        demand_germany=pd.read_csv(input.demand_germany, index_col="carrier")
        with open(input.demand_shares, "r") as f:
            demand_shares=json.load(f)

        # Calc demand share for each municipality
        demand_muns = (
                pd.DataFrame.from_dict(
                    demand_shares.get("muns_of_region"),
                    orient="index"
                )
                * demand_shares.get("federal_state_of_state")
                * demand_shares.get("region_of_federal_state")
                * demand_germany.drop("Strom", axis=0)[
                    ["space_heating", "hot_water", "process_heat"]
                ].sum().sum()
                * 1e6 # TWh to MWh
        )
        demand_muns.index.name = "municipality_id"
        demand_muns.rename(columns={0: 2022}, inplace=True)

        ### Demand 2045: Use reduction factor ###
        demand_muns = demand_muns.join(
            demand_prognosis(
                demand_future_T45=input.demand_future_T45,
                demand_future_TN=input.demand_future_TN,
                demand_region=demand_muns,
                year_base=2022,
                year_target=2045,
                scale_by="total",
            ).rename(columns={2022: 2045})
        )
        print(
            f"Total heat demand for sector {wildcards.sector} in TWh:\n",
            demand_muns.sum() / 1e6
        )

        # Dump as CSV
        demand_muns.to_csv(output[0])

rule heat_demand_ind:
    """
    Calculate absolute heat demands for municipalities for Industry
    """
    input:
        demand_heat_ind_germany=get_abs_dataset_path(
            "preprocessed", "ageb_energy_balance") / "data" /
            "ageb_energy_balance_germany_ind_twh_2021.csv",
        demand_ind_states=rules.preprocessed_regiostat_extract_demand_ind.output.demand_states,
        demand_ind_districts=rules.preprocessed_regiostat_extract_demand_ind.output.demand_districts,
        lau_codes=rules.preprocessed_eurostat_lau_create.output,
        employment=get_abs_dataset_path("datasets","employment_region") /
                   "data" / "employment.csv",
        demand_future_TN=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "TN-Strom_ind_demand_reformatted.csv",
        demand_future_T45=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios"
            ) / "data" / "T45-Strom_ind_demand_reformatted.csv",
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
        region_districts=PATH_TO_REGION_DISTRICTS_GPKG
    output:
        DATASET_PATH / "demand_ind_heat_demand.csv"
    run:
        # Industrial heat demand Germany
        demand_heat_ind_germany = pd.read_csv(
            input.demand_heat_ind_germany, index_col="carrier"
        )
        demand_heat_ind_germany = demand_heat_ind_germany.drop("Strom", axis=0)[
            ["space_heating", "hot_water", "process_heat"]
        ].sum().sum() * 1e6  # TWh to MWh

        # Industrial energy demand federal states and districts
        demand_ind_germany = pd.read_csv(
            input.demand_ind_states, index_col="lau_code", dtype={"lau_code": str}
        ).total.sum()
        demand_ind_districts = pd.read_csv(
            input.demand_ind_districts, index_col="lau_code", dtype={"lau_code": str}
        )

        # Get region's NUTS codes
        districts = gpd.read_file(input.region_districts)
        # Get region's LAU codes
        lau_codes_region = pd.read_csv(
            input.lau_codes[0], dtype={"lau_code": str}, usecols=["lau_code", "nuts_code"]
        )
        lau_codes_region = lau_codes_region.loc[
            lau_codes_region.nuts_code.isin(districts.nuts.to_list())]
        lau_codes_region["lau_code"] = lau_codes_region.lau_code.apply(lambda _: _[:5])
        lau_codes_region = lau_codes_region.groupby("lau_code").first()

        # Calculate industrial demand using LAU codes of region
        demand_ind_districts = demand_ind_districts.loc[
            lau_codes_region.index.to_list()].join(lau_codes_region)
        demand_ind_districts = demand_ind_districts[["nuts_code", "total"]].set_index("nuts_code")
        demand_ind_districts = demand_ind_districts.assign(
            demand_heat_share_germany=demand_ind_districts.total.div(demand_ind_germany)
        )
        demand_ind_districts = demand_ind_districts.assign(
            demand_heat=demand_ind_districts.demand_heat_share_germany.mul(demand_heat_ind_germany)
        )
        demand_ind_districts = demand_ind_districts.rename(
            columns={"demand_heat": "demand_districts"})[["demand_districts"]]

        # Disggregate using employees in industry sector
        demand_muns = disaggregate_demand_to_municipality(
            demand_districts=demand_ind_districts,
            muns=gpd.read_file(input.region_muns),
            districts=districts,
            disagg_data=pd.read_csv(input.employment, index_col=0),
            disagg_data_col="employees_ind"
        ).rename(columns={"employees_ind": 2022})

        demand_muns.index.name = "municipality_id"
        demand_muns.rename(columns={0: 2022}, inplace=True)

        ### Demand 2045: Use reduction factor ###
        demand_muns = demand_muns.join(
            demand_prognosis(
                demand_future_T45=input.demand_future_T45,
                demand_future_TN=input.demand_future_TN,
                demand_region=demand_muns,
                year_base=2022,
                year_target=2045,
                scale_by="total",
            ).rename(columns={2022: 2045})
        )
        print(
            f"Total heat demand for sector industry in TWh:\n",
            demand_muns.sum() / 1e6
        )

        # Dump as CSV
        demand_muns.to_csv(output[0])

rule normalize_timeseries:
    """
    Extract heat demand timeseries for districts, merge and normalize them
    """
    input:
        timeseries=get_abs_dataset_path("preprocessed", "demandregio") /
                   "data" / "dr_{sector}_gas_timeseries_2011.csv",
        region_districts=PATH_TO_REGION_DISTRICTS_GPKG
    output:
        timeseries=DATASET_PATH / "demand_{sector}_heat_timeseries.csv"
    run:
        normalize_filter_timeseries(
            infile=input.timeseries,
            outfile=output.timeseries,
            region_nuts=gpd.read_file(input.region_districts).nuts.to_list(),
        )

rule district_heating:
    """
    Calculate heat demands using district heating shares
    """
    input:
        heat_demand=DATASET_PATH / "demand_{sector}_heat_demand.csv"
    output:
        heat_demand_cen=DATASET_PATH / "demand_{sector}_heat_demand_cen.csv",
        heat_demand_dec=DATASET_PATH/ "demand_{sector}_heat_demand_dec.csv"
    run:
        print(
            f"Split heat demand into central and decentral heat demand for "
            f"sector: {wildcards.sector}"
        )
        heat_demand = pd.read_csv(
            input.heat_demand,
            index_col="municipality_id",
        )
        ds_shares = pd.DataFrame.from_dict(
            config["district_heating_share"].get(wildcards.sector),
            orient="index",
            columns=["district_heating_share"]
        )

        # Check municipality IDs
        if not all(mun_id in heat_demand.index for mun_id in ds_shares.index):
            raise ValueError(
                "One or more municipality IDs from district_heating_share are "
                "not found in the heat demand data."
            )

        # Calculate district heating and decentral heating demand
        heat_demand_cen = heat_demand.mul(
            ds_shares.district_heating_share, axis=0)
        heat_demand_dec = heat_demand.mul(
            (1 - ds_shares.district_heating_share), axis=0)

        # Dump
        heat_demand_cen.to_csv(output.heat_demand_cen)
        heat_demand_dec.to_csv(output.heat_demand_dec)

rule heating_structure_hh_cts:
    """
    Create heating structure for households and CTS: demand per technology
    """
    input:
        demand_future_TN=get_abs_dataset_path(
            "preprocessed", "bmwk_long_term_scenarios") / "data" /
            "TN-Strom_buildings_heating_demand_by_carrier_reformatted.csv",
        demand_future_T45=get_abs_dataset_path(
            "preprocessed","bmwk_long_term_scenarios") / "data" /
            "T45-Strom_buildings_heating_demand_by_carrier_reformatted.csv"
    output:
        # heating_structure_cen=(
        #     #DATASET_PATH / "demand_{sector}_heat_structure_cen.csv"
        #     DATASET_PATH / "demand_heat_structure_cen.csv"
        # ),
        heating_structure_dec=(
            #DATASET_PATH / "demand_{sector}_heat_structure_dec.csv"
            DATASET_PATH / "demand_heat_structure_dec.csv"
        ),
        heating_structure_esys_dec=(
            # DATASET_PATH / "demand_{sector}_heat_structure_esys_dec.csv"
            DATASET_PATH/ "demand_heat_structure_esys_dec.csv"
        )
    run:
        # Get data from future scenarios
        demand_future_T45 = pd.read_csv(
            input.demand_future_T45)#.set_index(["year", "carrier"])
        demand_future_TN = pd.read_csv(
            input.demand_future_TN)#.set_index(["year", "carrier"])

        # Interpolate for base year
        demand_future = pd.concat(
            [demand_future_TN.loc[demand_future_TN.year == 2020],
             demand_future_T45], axis=0
        )
        demand_future = demand_future.set_index(["year", "carrier"]).append(
            pd.DataFrame(
                index=pd.MultiIndex.from_product(
                    [[2022], demand_future.carrier.unique(), [np.nan]],
                    names=demand_future.columns,
                )
            )
        )
        demand_future.sort_index(inplace=True)
        demand_future = demand_future.unstack(level=1).interpolate().stack()

        # Calculate heating structure
        demand_future = demand_future.loc[
            config["heating_structure"].get("years")].reset_index()

        demand_total = demand_future[["year", "demand"]].groupby("year").sum()
        demand_dec = (
            demand_future.loc[
                demand_future.carrier != "district_heating"]
        )
        # Drop auxiliary power
        demand_dec = demand_dec.loc[
            demand_dec.carrier != "electricity_auxiliary"]
        demand_total_dec = demand_dec[["year", "demand"]].groupby("year").sum()
        demand_dec = demand_dec.set_index("year").assign(
            demand_rel=demand_dec.set_index("year").demand.div(
                demand_total_dec.demand)
        )
        demand_dec.drop(columns=["demand"], inplace=True)

        #demand_total_cen = demand_total - demand_total_dec

        # Dump heating structure (for info)
        demand_dec.to_csv(output.heating_structure_dec)

        # Aggregate heat pump demand
        demand_dec.carrier = demand_dec.carrier.replace({
            "ambient_heat_heat_pump": "heat_pump",
            "electricity_heat_pump": "heat_pump"})
        demand_dec = demand_dec.reset_index().groupby(["year", "carrier"]).sum()

        # Dump heating structure (for esys)
        demand_dec.to_csv(output.heating_structure_esys_dec)

        # TODO: Central heating structure, cf. config -> district_heating