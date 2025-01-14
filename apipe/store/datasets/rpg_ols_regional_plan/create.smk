"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""

import geopandas as gpd
import numpy as np
import pandas as pd

from apipe.scripts.data_io import load_json
from apipe.scripts.datasets.mastr import create_stats_per_municipality
from apipe.scripts.geo import (
    convert_to_multipolygon,
    reproject_simplify,
    overlay,
    write_geofile,
)
from apipe.store.utils import (
    get_abs_dataset_path,
    PATH_TO_REGION_MUNICIPALITIES_GPKG,
)

DATASET_PATH = get_abs_dataset_path(
    "datasets", "rpg_ols_regional_plan", data_dir=True)


rule create_pv_ground_criteria_single:
    """
    Freiflächen-Photovoltaikanlagen Negativkriterien einzeln
    """
    input:
        get_abs_dataset_path(
            "preprocessed", "rpg_ols_regional_plan"
        ) / "data" / "{file}.gpkg"
    output:
        DATASET_PATH / "{file}.gpkg"
    shell: "cp -p {input} {output}"

rule create_pv_ground_criteria_merged:
    """
    Freiflächen-Photovoltaikanlagen Negativkriterien kombiniert
    Es werden Daten der RPG OLS und dem PV- und Windflächenrechner verwendet.
    """
    input:
        criteria_rpg_ols=rules.preprocessed_rpg_ols_regional_plan_create_pv_ground_criteria_single.output,
        criteria_pv_wfr=expand(
            get_abs_dataset_path(
                "datasets", "rli_pv_wfr_region"
            ) / "data" / "{file}.gpkg",
            file=[
                "military_region",
                "drinking_water_protection_area_region",
                "floodplain_region"
            ]
        ),
        criteria_bfn=expand(
            get_abs_dataset_path(
                "datasets", "bfn_protected_areas_region"
            ) / "data" / "{file}.gpkg",
            file=[
                "nature_conservation_area_region",
                "fauna_flora_habitat_region"
            ]
        ),

    output:
        DATASET_PATH / "pv_ground_criteria_merged.gpkg"
    run:
        layers = []
        for file_in in input:
            layer = gpd.read_file(file_in)
            if layer.geom_type[0] == 'MultiPolygon':
                layers.append(layer)
        merged = gpd.GeoDataFrame(pd.concat(layers))

        # Merge all layers, remove gaps and union
        merged = gpd.GeoDataFrame(
            crs=merged.crs.srs,
            geometry=[merged.unary_union.buffer(10).buffer(-10)]
        ).explode()

        # Min size filtering and simplification required due to limitation of
        # vertices count in maplibre, cf.
        # https://github.com/rl-institut/django-mapengine/issues/25#issuecomment-2493515600

        merged = gpd.GeoDataFrame(
            crs=merged.crs.srs,
            geometry=[reproject_simplify(merged, min_size=1000).unary_union]
        )

        write_geofile(
            gdf=reproject_simplify(merged, simplify_tol=10),
            file=output[0],
            layer_name="pv_ground_criteria_merged"
        )

rule create_pv_ground_units_filtered:
    """
    Filter PV units for different status and add municipality ids.
    For approved and planned units add missing power (=0) using power density
    from tech data.
    """
    input:
        units=DATASET_PATH / "rpg_ols_pv_ground.gpkg",
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
        tech_data=rules.datasets_technology_data_copy_files.output,
    output:
        units_all=DATASET_PATH / "rpg_ols_pv_ground_all.gpkg",
        units_filtered=expand(
            DATASET_PATH / "rpg_ols_pv_ground_{status}.gpkg",
            status=["operating", "approved", "planned"]
        )
    run:
        units = gpd.read_file(input.units)

        # assign mun id
        units = overlay(
            gdf=units,
            gdf_overlay=gpd.read_file(input.region_muns),
            retain_rename_overlay_columns={"id": "municipality_id"},
            gdf_use_centroid=True
        )

        # Add capacity to units where capacity is 0
        # (approximation for planned units)
        tech_data = load_json(input.tech_data[0])
        print(
            "Capacity in original data: ",
            units[["status", "capacity_net"]].groupby(
                "status").capacity_net.sum()
        )
        units = units.assign(capacity_net_inferred=0)
        mask = (
            #(units.status.isin(["Planung", "genehmigt"])) &
            (units.capacity_net == 0)
        )
        units["capacity_net"].update(
            units[mask].area / 1e6 *
            tech_data["power_density"]["pv_ground"]
        )
        units.loc[mask, "capacity_net_inferred"] = 1
        units["capacity_net"] = units["capacity_net"].mul(1e3).round()  # MW to kW
        print(
            "Capacity inferred: ",
            units[["status", "capacity_net"]].groupby(
                "status").capacity_net.sum()
        )

        # Write all
        write_geofile(
            gdf=convert_to_multipolygon(units),
            file=output.units_all
        )

        # Write filtered
        for status, file_suffix in {
            "realisiert": "operating",
            "Planung": "planned",
            "genehmigt": "approved",
        }.items():
            write_geofile(
                gdf=convert_to_multipolygon(units.loc[units.status == status].copy()),
                file=DATASET_PATH / f"rpg_ols_pv_ground_{file_suffix}.gpkg"
            )


rule create_pv_ground_power_stats_muns:
    """
    Create stats on installed count of units and power per mun
    """
    input:
        units=expand(
            DATASET_PATH / "rpg_ols_pv_ground_{status}.gpkg",
            status=["all", "operating", "approved", "planned"]
        ),
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
    output:
        stats=expand(
            DATASET_PATH / "rpg_ols_pv_ground_stats_muns_{status}.csv",
            status=["all", "operating", "approved", "planned"]
        )
    run:
        for status in ["all", "operating", "approved", "planned"]:
            units = gpd.read_file(
                DATASET_PATH / f"rpg_ols_pv_ground_{status}.gpkg"
            )

            # Exclude specific predefined planned units
            if status == "planned":
                units["name"] = units["name"].fillna("")
                for name_substr in config["pv_ground_exclude_planned_units_name_substrings"]:
                    units = units.loc[~units.name.str.contains(name_substr)]

            units = create_stats_per_municipality(
                units_df=units,
                muns=gpd.read_file(input.region_muns),
                column="capacity_net",
                only_operating_units=False  # Disable MaStR-specific setting
            )
            units["capacity_net"] = units["capacity_net"].div(1e3)  # kW to MW
            print(f"Total capacity for {status} units: {units.capacity_net.sum()}")
            units.to_csv(
                DATASET_PATH /
                f"rpg_ols_pv_ground_stats_muns_{status}.csv"
            )


rule create_pv_ground_power_stats_operating_over_time:
    """
    Create stats on operating units: count and power
    """
    input:
        units=DATASET_PATH / "rpg_ols_pv_ground_operating.gpkg"
    output:
        stats=DATASET_PATH / "rpg_ols_pv_ground_stats_operating_over_time.csv"
    run:
        units = gpd.read_file(input.units)
        units["ts1"] = pd.to_datetime(
            units.construction_end_date,
            format="mixed"
        )
        units["ts2"] = pd.to_datetime(
            units.loc[(~units.year.isna()) & (units.year > 0)].year,
            format="%Y"
        )
        units["ts"] = units[["ts1", "ts2"]].max(axis=1)

        stats = {}
        for year in config["pv_ground_stats_operating_years"]:
            # import pdb
            # pdb.set_trace()
            stats.update({year: units.loc[
                (~units.ts.isna()) &
                (units.ts <= pd.to_datetime(f"{year}-12-31"))
                ].capacity_net.agg(["sum", "count"]
                ).rename({"sum": "capacity_net"})
            })

        stats_df = pd.DataFrame.from_dict(stats).T

        count_filtered = stats_df.loc[stats_df.index == stats_df.index.max()]["count"].iloc[0]
        if count_filtered < len(units):
            print(
                f"WARNING: Number of PV units for {stats_df.index.max()} is "
                f"{count_filtered} but total in file is {len(units)}. "
                f"Most likely, some commissioning dates are missing which "
                f"leads to wrong numbers for max year! An additional line with "
                f"totals will be added."
            )
            stats.update({"total": units.capacity_net.agg(["sum", "count"]
                ).rename({"sum": "capacity_net"})})
            stats_df = pd.DataFrame.from_dict(stats).T

        stats_df.index.name = "year"
        stats_df["capacity_net"] = stats_df["capacity_net"].div(1e3)
        stats_df.to_csv(output.stats)


rule create_wind_units:
    """
    Ddd municipality ids to wind units
    """
    input:
        units=expand(
            get_abs_dataset_path("preprocessed", "rpg_ols_regional_plan") /
            "data" / "rpg_ols_wind_{status}.gpkg",
            status=["approved", "planned", "operating"]
        ),
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG
    output:
        units=expand(
            DATASET_PATH / "rpg_ols_wind_{status}.gpkg",
            status=["approved", "planned", "operating"]
        ),
        units_all=DATASET_PATH / "rpg_ols_wind_all.gpkg"
    run:
        all_units = list()
        for file_in, file_out, status in zip(
                input.units, output.units, ["approved", "planned", "operating"]
        ):
            units = gpd.read_file(file_in)
            # assign mun id
            units = overlay(gdf=units,
                gdf_overlay=gpd.read_file(input.region_muns),
                retain_rename_overlay_columns={"id": "municipality_id"},
            )
            all_units.append(units.copy().assign(status=status))
            units.commissioning_date = units.commissioning_date.astype(str)
            write_geofile(
                gdf=units,
                file=file_out
            )
        write_geofile(
            gdf=pd.concat(all_units, axis=0),
            file=output.units_all
        )


rule create_wind_power_stats_muns:
    """
    Create stats on installed count of units and power per mun
    """
    input:
        units=expand(
            DATASET_PATH / "rpg_ols_wind_{status}.gpkg",
            status=["all", "approved", "planned", "operating"]
        ),
        region_muns=PATH_TO_REGION_MUNICIPALITIES_GPKG,
    output:
        stats=expand(
            DATASET_PATH / "rpg_ols_wind_stats_muns_{status}.csv",
            status=["all", "operating", "approved", "planned"]
        )
    run:
        for status in ["all", "operating", "approved", "planned"]:
            units = gpd.read_file(
                DATASET_PATH / f"rpg_ols_wind_{status}.gpkg"
            )
            units = create_stats_per_municipality(
                units_df=units,
                muns=gpd.read_file(input.region_muns),
                column="capacity_net",
                only_operating_units=False  # Disable MaStR-specific setting
            )
            print(f"Total capacity for {status} units: {units.capacity_net.sum()}")
            units.to_csv(
                DATASET_PATH /
                f"rpg_ols_wind_stats_muns_{status}.csv"
            )

rule create_wind_power_stats_operating_over_time:
    """
    Create stats on operating units: count and power
    """
    input:
        units=DATASET_PATH / "rpg_ols_wind_operating.gpkg"
    output:
        stats=DATASET_PATH / "rpg_ols_wind_stats_operating_over_time.csv"
    run:
        units = gpd.read_file(input.units)
        units["ts"] = pd.to_datetime(units.commissioning_date)
        stats = {}
        for year in config["wind_stats_operating_years"]:
            stats.update({year: units.loc[
                (~units.ts.isna()) &
                (units.ts <= pd.to_datetime(f"{year}-12-31"))
                ].capacity_net.agg(["sum", "count"]
                ).rename({"sum": "capacity_net"})
            })

        stats_df = pd.DataFrame.from_dict(stats).T

        count_filtered = stats_df.loc[stats_df.index == stats_df.index.max()]["count"].iloc[0]
        if count_filtered < len(units):
            print(
                f"WARNING: Number of turbines for {stats_df.index.max()} is "
                f"{count_filtered} but total in file is {len(units)}. "
                f"Most likely, some commissioning dates are missing which "
                f"leads to wrong numbers for max year! An additional line with "
                f"totals will be added."
            )
            stats.update({"total": units.capacity_net.agg(["sum", "count"]
                ).rename({"sum": "capacity_net"})})
            stats_df = pd.DataFrame.from_dict(stats).T

        stats_df.index.name = "year"
        stats_df.to_csv(output.stats)
