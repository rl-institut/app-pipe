"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""
import pandas as pd
from apipe.store.utils import get_abs_dataset_path

DATASET_PATH = get_abs_dataset_path("datasets", "heatpump_cop_heat_med")

rule prepare_heatpump_cop_heat_med_profile:
    """
    Copies heat pump cop time series of medium heat carrier to datasets.
    """
    input:
        get_abs_dataset_path(
            "raw", "heatpump_cop_heat_med") / "data" /
            "heatpump_cop_heat_med_timeseries.csv"
    output:
        DATASET_PATH / "data" / "heatpump_cop_heat_med_timeseries.csv",
    run:
        heat_timeseries = pd.read_csv(input[0]).cop
        heat_timeseries.to_csv(output[0])
