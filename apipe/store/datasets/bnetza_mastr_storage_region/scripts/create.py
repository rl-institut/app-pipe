import geopandas as gpd
import pandas as pd

from apipe.config import GLOBAL_CONFIG
from apipe.scripts.datasets import mastr
from apipe.scripts.geo import overlay, rename_filter_attributes, write_geofile
from apipe.store.utils import PATH_TO_REGION_DISTRICTS_GPKG, get_names_from_nuts


def process() -> None:
    unit_attrs = snakemake.config["unit_attributes"]
    unit_attrs_filter = snakemake.config["unit_attributes_filter"]
    unit_attrs_filter["Landkreis"] = get_names_from_nuts(
        PATH_TO_REGION_DISTRICTS_GPKG,
        GLOBAL_CONFIG["global"]["geodata"]["nuts"],
    )
    # Read units
    units = pd.read_csv(
        snakemake.input.units,
        usecols=(set(unit_attrs.keys()) | set(unit_attrs_filter.keys())),
        dtype={"Postleitzahl": str},
    )
    units = rename_filter_attributes(
        gdf=units,
        attrs_filter_by_values=unit_attrs_filter,
        attrs_mapping=unit_attrs,
    ).set_index("mastr_id")

    # Read plants (for storage capacity)
    plants = pd.read_csv(
        snakemake.input.units_capacity,
        usecols=snakemake.config["plant_attributes"].keys(),
    )
    plants = rename_filter_attributes(
        gdf=plants,
        attrs_mapping=snakemake.config["plant_attributes"],
    )

    # Merge storage capacity
    units = units.merge(
        plants,
        left_on="mastr_id",
        right_on="unit_mastr_id",
        how="left",
    )
    units_count_wo_capacity = len(units.loc[units.plant_mastr_id.isna()])
    if units_count_wo_capacity > 0:
        print(
            f"{units_count_wo_capacity} storages have no plant associated and "
            f"hence no storage capacity assigned."
        )
    units.drop(columns=["unit_mastr_id", "plant_mastr_id"], inplace=True)

    units = mastr.add_voltage_level(
        units_df=units,
        locations_path=snakemake.input.locations,
        gridconn_path=snakemake.input.gridconn,
        drop_location_id=False,
    )

    # Add geometry and drop units without coords and
    # add column to indicate that location from original data was used
    units_with_geom = mastr.add_geometry(units)
    units_with_geom = units_with_geom.assign(
        geometry_approximated=0,
    )

    units_without_geom = units.loc[(units.lon.isna() | units.lat.isna())].drop(
        columns=["lon", "lat"]
    )

    # Add geometry for all units without coords (<=30 kW) and
    # add column to indicate that location was inferred by geocoding
    if len(units_without_geom) > 0:
        (
            units_with_inferred_geom_gdf,
            units_with_inferred_geom_agg_gdf,
        ) = mastr.geocode_units_wo_geometry(
            units_without_geom,
            columns_agg_functions={
                "capacity_net": ("capacity_net", "sum"),
                "unit_count": ("capacity_net", "count"),
                "capacity_gross": ("capacity_gross", "sum"),
                "storage_capacity": ("storage_capacity", "sum"),
            },
        )

        # Merge both GDFs
        units = pd.concat([units_with_geom, units_with_inferred_geom_gdf])

        units_agg = pd.concat(
            [
                units_with_geom.assign(unit_count=1),
                units_with_inferred_geom_agg_gdf,
            ]
        )
    else:
        units = units_with_geom
        units_agg = units_with_geom.assign(unit_count=1)

    # Clip to region and add mun and district ids
    units = overlay(
        gdf=units,
        gdf_overlay=gpd.read_file(snakemake.input.region_muns),
        retain_rename_overlay_columns={"id": "municipality_id"},
    )
    units = overlay(
        gdf=units,
        gdf_overlay=gpd.read_file(snakemake.input.region_districts),
        retain_rename_overlay_columns={"id": "district_id"},
    )
    units_agg = overlay(
        gdf=units_agg,
        gdf_overlay=gpd.read_file(snakemake.input.region_muns),
        retain_rename_overlay_columns={"id": "municipality_id"},
    )
    units_agg = overlay(
        gdf=units_agg,
        gdf_overlay=gpd.read_file(snakemake.input.region_districts),
        retain_rename_overlay_columns={"id": "district_id"},
    )

    # Search for associated PV roof units and save count and sum of nom. power
    pv_roof_units = gpd.read_file(snakemake.input.pv_roof_units)[
        ["mastr_location_id", "capacity_net"]
    ]
    pv_roof_units = (
        pv_roof_units[["mastr_location_id", "capacity_net"]]
        .groupby("mastr_location_id")
        .agg(
            pv_roof_unit_count=("capacity_net", "count"),
            pv_roof_unit_capacity_sum=("capacity_net", "sum"),
        )
        .reset_index()
    )
    units = units.merge(
        pv_roof_units,
        left_on="mastr_location_id",
        right_on="mastr_location_id",
        how="left",
    )
    units = units.assign(
        pv_roof_unit_count=units.pv_roof_unit_count.fillna(0),
        pv_roof_unit_capacity_sum=units.pv_roof_unit_capacity_sum.fillna(0),
    )

    write_geofile(
        gdf=units,
        file=snakemake.output.outfile,
        layer_name=snakemake.config["layer"],
    )
    write_geofile(
        gdf=units_agg,
        file=snakemake.output.outfile_agg,
        layer_name=snakemake.config["layer"],
    )


process()
