"""
Helper functions for geodata processing
"""

import os
from collections import OrderedDict
from typing import Tuple, Union

import fiona
import geopandas as gpd
import pandas as pd
import rasterio as rio
from rasterio.features import shapes
from rasterio.mask import mask
from rasterstats import zonal_stats
from shapely.geometry import shape
from shapely.geometry.multipolygon import MultiPolygon
from shapely.ops import transform

from apipe.config import GLOBAL_CONFIG


def read_schema_from_file(file: str) -> Tuple[str, OrderedDict]:
    """Read a geo file and returns schema definition using fiona

    Parameters
    ----------
    file : str
        Full path to file to read schema from

    Returns
    -------
    str
        Schema of geometry
    OrderedDict
        Properties/Fields of dataset (str: str)
    """
    try:
        with fiona.open(file) as f:
            schema_in_geom = f.schema["geometry"]
            schema_in_props = f.schema["properties"]
    except:
        f.close()
        raise
    return schema_in_geom, schema_in_props


def file_is_empty(file: str) -> bool:
    """Check if file holds no geodata (is empty)

    Parameters
    ----------
    file : str
        Full path to file to read

    Returns
    -------
    bool
        True if file is empty, False otherwise
    """
    with fiona.open(file) as coll:
        return len(coll) == 0


def convert_to_multipolygon(gdf: gpd.GeoDataFrame) -> gpd.GeoDataFrame:
    """Convert geometry column to type MultiPolygon

    Parameters
    ----------
    gdf : :pandas:`geopandas.GeoDataFrame`
        Data to be aligned

    Returns
    -------
    :pandas:`geopandas.GeoDataFrame`
    """

    def remove_z(row):
        """
        Remove z coordinate from Geometry, e.g. MultiPolygon (MULTIPOLYGON Z)
        """
        return transform(lambda x, y, z=None: (x, y), row)

    gdf["geometry"] = [
        MultiPolygon([feature]) if feature.geom_type == "Polygon" else feature
        for feature in gdf["geometry"]
    ]

    gdf["geometry"] = gdf["geometry"].apply(remove_z)

    return gdf


def write_geofile(
    gdf: gpd.GeoDataFrame,
    file: str,
    layer_name: str = None,
    schema: dict = None,
    driver: str = "GPKG",
    encoding: str = "utf-8",
    mode: str = "w",
) -> None:
    """Write geodata to file

    Parameters
    ----------
    gdf : :pandas:`geopandas.GeoDataFrame`
    file : str
        Target file
    layer_name : str
        Name of layer, usually same as file basename
    schema : dict
        Output schema with keys "geometry" and "properties"
    driver : str
        Geofile driver, default is Geopackage
    encoding : str
        Encoding
    mode : str
        The write mode, ‘w’ to overwrite the existing file and ‘a’ to append.
    """
    if layer_name is None:
        layer_name = os.path.basename(file).split(".")[0]
    if schema is None:
        # TODO: Log warning
        pass

    # check if data contain multiple geometry types
    if len(gdf.geometry.type.unique()) > 1:
        types = gdf.geometry.type.unique()
        raise ValueError(f"Data contain multiple geometry types: {types} !")

    gdf.to_file(
        file,
        layer=layer_name,
        schema=schema,
        driver=driver,
        encoding=encoding,
        mode=mode,
    )


def rename_filter_attributes(
    gdf: Union[pd.DataFrame, gpd.GeoDataFrame],
    attrs_filter_by_values: dict = None,
    attrs_mapping: dict = None,
) -> Union[pd.DataFrame, gpd.GeoDataFrame]:
    """Rename attributes and filter them by values

    Note: Only attributes as given by `attrs_mapping` are kept!

    Parameters
    ----------
    gdf : pd.DataFrame or gpd.GeoDataFrame
        Geodata
    attrs_filter_by_values : dict
        Attributes whose values are to be filtered. Use attributes as dict
        keys and desired values as dict values (values can be of type str,
        int, float or list)
        Example: {"GF": 4, "NUTS": ["DEE01", "DEE05", "DEE0E"]}
    attrs_mapping : dict
        Attributes to select and rename. Use original attributes' names as
        dict keys and new names as values.

    Returns
    -------
    pd.DataFrame or gpd.GeoDataFrame
        Filtered geodata
    """
    # Filter by attribute values, if defined
    if attrs_filter_by_values is not None:
        list_vals = []
        query = ""
        for k, v in attrs_filter_by_values.items():
            if isinstance(v, list):
                list_vals.append(v)
                query += f" & {k} in @list_vals[{len(list_vals)-1}]"
            elif isinstance(v, str):
                query += f" & {k}=='{v}'"
            elif isinstance(v, (int, float)):
                query += f" & {k}=={v}"
            else:
                raise ValueError(
                    "Data type in attribute filter is not supported!"
                )
        query = query[2:]
        gdf = gdf.query(query)

    # Extract and rename fields
    if attrs_mapping is not None:
        gdf = gdf.filter(attrs_mapping.keys())
        gdf.rename(columns=attrs_mapping, inplace=True)

    return gdf


def reproject_simplify(
    gdf: gpd.GeoDataFrame,
    target_crs: str = GLOBAL_CONFIG["global"]["geodata"]["crs"].lower(),
    min_size: float = None,
    simplify_tol: float = None,
    fix_geom: bool = False,
    add_id_column: bool = False,
) -> gpd.GeoDataFrame:
    """General purpose function for processing of geodata

    Parameters
    ----------
    gdf : gpd.GeoDataFrame
        Geodata
    target_crs : str
        CRS the data should be reprojected to. Defaults to value from global
        config.
    min_size : float
        Min. size of area to select (in sqm). Use None for no filtering
        (default).
        Raises exception if `target_crs` is not LAEA Europe (EPSG:3035).
    simplify_tol : float
        Threshold for simplification of geometries in meter. Use None for no
        simplification (default).
        Raises exception if `target_crs` is not LAEA Europe (EPSG:3035).
    fix_geom : bool
        If True, invalid geometries are fixed by buffering by the value
        specified in the global config (geodata -> fix_geom_buffer).
    add_id_column : bool
        If True, data is reindexed starting from 0 and a new column "id" is
        added with the same values.

    Returns
    -------
    gpd.GeoDataFrame
        Processed geodata
    """

    def check_crs(operation: str) -> None:
        """Check if requested CRS is LAEA Europe (EPSG:3035)"""
        if target_crs.lower() != "epsg:3035":
            raise ValueError(
                f"Cannot apply {operation} in non-equistant CRS "
                f"(requested CRS: {target_crs.lower()}) !"
            )

    # Transform to target CRS
    if gdf.crs is not None:
        if str(gdf.crs).lower() != target_crs.lower():
            gdf = gdf.to_crs(target_crs)
    else:
        raise ValueError("Geodata has not CRS assigned.")

    # Filter by min size
    if min_size is not None:
        check_crs("min size filtering")
        if gdf.area.sum() == 0:
            print("Total area = 0. Will skip filtering by min size.")
        else:
            gdf = gdf[gdf.area > min_size]

    # Generalize
    if simplify_tol is not None:
        check_crs("simplification")
        gdf["geometry"] = gdf.simplify(simplify_tol, preserve_topology=True)

    # Fix invalid geometries
    if (~gdf.is_valid.all()) and (fix_geom is True):
        buffer = GLOBAL_CONFIG["global"]["geodata"]["fix_geom_buffer"]
        if buffer > 0:
            gdf["geometry"] = gdf.buffer(buffer)

    # Reindex starting from 0 and add new column "id" with same values
    if add_id_column is True:
        gdf.reset_index(drop=True, inplace=True)
        gdf = gdf.assign(id=gdf.index)

    return gdf


def overlay(
    gdf: gpd.GeoDataFrame,
    gdf_overlay: gpd.GeoDataFrame,
    retain_rename_overlay_columns: dict = None,
    gdf_use_centroid: bool = False,
) -> gpd.GeoDataFrame:
    """Clips geodata to polygon

    Parameters
    ----------
    gdf : gpd.GeoDataFrame
        Geodata to be clipped (geometry in column "geometry")
    gdf_overlay : gpd.GeoDataFrame
        Geodata to clip `gdf` to, e.g. municipalities (geometry in column
        "geometry")
    retain_rename_overlay_columns : dict
        Columns to retain from `gdf_clip` (do not include "geometry")
    gdf_use_centroid : bool
        If True, the centroid of gdf will be used for overlay (geometry column
        will be retained though). Defaults to False.
    """
    if retain_rename_overlay_columns is None:
        columns = ["geometry"]
        retain_rename_overlay_columns = {}
    else:
        if "geometry" in retain_rename_overlay_columns.keys():
            raise ValueError("Geometry must not be in rename dict!")
        columns = list(retain_rename_overlay_columns.keys()) + ["geometry"]

    # Use centroid if requested
    if gdf_use_centroid is True:
        # Retain geometry
        geometry_backup = gdf.geometry.copy()

        # Clip and rename columns
        gdf_clipped = (
            gpd.overlay(
                gdf.assign(geometry=gdf.centroid),
                gdf_overlay[columns],
                how="intersection",
            )
            .rename(columns=retain_rename_overlay_columns)
            .assign(geometry=geometry_backup)
        )
    else:
        # Clip and rename columns
        gdf_clipped = gpd.overlay(
            gdf, gdf_overlay[columns], how="intersection"
        ).rename(columns=retain_rename_overlay_columns)

    return gdf_clipped


def clip_raster(
    raster_file_in: str, clip_file: str, raster_file_out: str
) -> None:
    """Clip raster data using vector data

    Parameters
    ----------
    raster_file_in : str
        Path to raster file to be clipped
    clip_file : str
        Path to vector file used for clipping
    raster_file_out : str
        Path to clipped raster file

    Returns
    -------
    None
    """
    clip_data = gpd.read_file(clip_file).geometry
    with rio.open(raster_file_in) as f:
        out_image, out_transform = mask(f, clip_data, crop=True)
        out_meta = f.meta

    out_meta.update(
        {
            "driver": "GTiff",
            "height": out_image.shape[1],
            "width": out_image.shape[2],
            "transform": out_transform,
        }
    )
    with rio.open(raster_file_out, "w", **out_meta) as dest:
        dest.write(out_image)


def raster_zonal_stats(
    raster_file_in: str,
    clip_file: str,
    zonal_file_out: str,
    var_name: str = "mean",
    stats: str = "mean",
) -> None:
    """Create zonal stats

    Parameters
    ----------
    raster_file_in : str
        Path to raster file with data
    clip_file : str
        Path to vector file (zones) used for zonal stats
    raster_file_out : str
        Path to output raster file
    var_name : str
        Name of variable in output file
    stats : str
        Stats to be created, e.g. "mean" or "sum mean"

    Returns
    -------
    None
    """
    schema_in_geom, schema_in_props = read_schema_from_file(clip_file)
    clip_data = gpd.read_file(clip_file)

    zonal_stats_df = gpd.GeoDataFrame()
    zonal_stats_df = (
        zonal_stats_df.from_features(
            zonal_stats(
                clip_data, raster_file_in, stats=stats, geojson_out=True
            ),
            crs=3035,
        )
        .rename(columns={"sum": var_name})
        .to_crs(GLOBAL_CONFIG["global"]["geodata"]["crs"])
    )

    field_types = [
        (field, dtype)
        for field, dtype in schema_in_props.items()
        if field in zonal_stats_df.columns
    ]
    field_types.extend([(var_name, "float")])

    schema_out = {
        "geometry": schema_in_geom,
        "properties": OrderedDict(field_types),
    }

    write_geofile(
        gdf=zonal_stats_df,
        file=zonal_file_out,
        layer_name="res",
        schema=schema_out,
    )


def raster_to_vector(raster_file_in):
    """Vectorize raster data

    Parameters
    ----------
    raster_file_in : pathlib.Path
        Path to raster file with data

    Returns
    -------
    pd.DataFrame or gpd.GeoDataFrame
        Vector data
    """
    with rio.open(raster_file_in) as src:
        image = src.read(1)
        results = [
            {"properties": {"value": v}, "geometry": shape(s)}
            for s, v in shapes(image, transform=src.transform)
            if v > 0
        ]
        gdf = gpd.GeoDataFrame.from_features(results, crs=src.crs)
    return gdf
