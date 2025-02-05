"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""

import pandas as pd
from apipe.store.utils import get_abs_dataset_path

DATASET_PATH = get_abs_dataset_path("datasets", "demand_heat_ind_med_high")

rule prepare_demand_ind_heat_med_high_profiles:
    """
    Copies industry heat demand time series of medium and high heat carrier to
    datasets.
    """
    input:
        get_abs_dataset_path(
            "raw", "industry_heat_profiles_med_high") / "data" /
            "{carrier}-demand_ind-profile.csv"
    output:
        DATASET_PATH / "data" / "demand_ind_{carrier}_timeseries.csv",
    run:
        heat_timeseries = pd.read_csv(input[0], sep=";").demand_norm
        heat_timeseries.to_csv(output[0])
