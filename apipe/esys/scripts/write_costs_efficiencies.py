# coding: utf-8
r"""
This module provides functionality to map raw scalar data on costs and
efficiencies from "store/raw/technology_data/data/raw_costs_efficiencies.csv" to
the default costs and efficiencies in
"store/datasets/esys_raw/data/scalars/default_costs_efficiencies.csv".
The default file is initially created using the "write_default_scalars" rule.

The mapped costs and efficiencies are then written to
"store/datasets/esys_raw/data/scalars/costs_efficiencies.csv", and the original
"default_costs_efficiencies.csv" file is deleted.
"""
import os
import sys

import pandas as pd

from apipe.esys.esys.config.esys_conf import add_snake_logger, settings
from apipe.esys.esys.tools.data_processing import (
    load_b3_scalars,
    multi_filter_df,
    save_df,
)


def check_var_value_empty(df, cols):
    """
    Checks if specified columns in a DataFrame have empty values.

    Parameters
    ----------
    df : pandas.DataFrame
        The DataFrame to check.
    cols : list
        List of column names to check.

    Raises
    ------
    ValueError
        If one or more columns contain non-empty values.

    """
    for col in cols:
        if not (df[col].isna() | (df[col] == "None")).all():
            raise ValueError(
                "There are not empty values in one or more of the columns "
                f"'{cols}' of {path_default_costs_eff}.\n"
                f"Please make sure that the columns '{cols}' are empty."
            )


def map_var_value_costs_effs(df_1, df_2, cols):
    """
    Maps values from df_2 to df_1 based on matching variable names, carriers,
    and technologies.

    Parameters
    ----------
    df_1 : pandas.DataFrame
        The source DataFrame where values will be mapped.
    df_2 : pandas.DataFrame
        The reference DataFrame containing the values to map.
    cols : list
        List of column names in df_1 to update with mapped values.

    Returns
    -------
    pandas.DataFrame
        The modified df_1 DataFrame with mapped values.

    Raises
    ------
    ValueError
        If a matching combination of var_name, carrier, and tech is not found
        in df_2.

    """

    for index, row in df_1.iterrows():
        var_name = row["var_name"]
        carrier = row["carrier"]
        tech = row["tech"]
        df_3 = multi_filter_df(
            df_2, var_name=var_name, carrier=carrier, tech=tech
        )

        if not df_3.empty:
            for col in cols:
                df_1.loc[index, col] = df_3[col].values[0]
        else:
            raise ValueError(
                f"Value of var_name '{var_name}', carrier '{carrier}' and tech "
                f"'{tech}' is missing in {path_raw_costs_eff}."
            )

    return df_1


if __name__ == "__main__":
    path_default_costs_eff = sys.argv[1]
    path_raw_costs_eff = sys.argv[2]
    path_region_costs_eff = sys.argv[3]
    path_costs_eff = sys.argv[4]

    logger = add_snake_logger("data_processing")

    default_costs_eff = load_b3_scalars(path_default_costs_eff)
    raw_costs_eff = load_b3_scalars(path_raw_costs_eff)
    region_spec_costs_eff = load_b3_scalars(path_region_costs_eff)

    # Concat region specific and non-region-specific data
    all_costs_eff = pd.concat([raw_costs_eff, region_spec_costs_eff])

    # Name of Columns to be filled
    target_cols = ["var_value", "var_unit", "source", "comment"]

    # Check if no values written in target_cols of
    # default_costs_efficiencies.csv
    check_var_value_empty(default_costs_eff, target_cols)

    # Map values from raw_costs_efficiencies.csv with
    # default_costs_efficiencies.csv
    costs_eff = map_var_value_costs_effs(
        default_costs_eff, all_costs_eff, target_cols
    )

    # Save costs_efficiencies.csv to store/datasets/esys_raw/data/scalars
    save_df(costs_eff, path_costs_eff)

    # Delete file default_costs_efficiencies.csv
    if settings.write_costs_efficiencies.delete_default:
        if os.path.exists(path_default_costs_eff):
            os.remove(path_default_costs_eff)
            # Print user info
            logger.info(f"The file {path_default_costs_eff} has been deleted.")
