"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""
import pandas as pd
from apipe.store.utils import get_abs_dataset_path

DATASET_PATH = get_abs_dataset_path(
    "preprocessed", "wfbb_heat_atlas_bb", data_dir=True)

rule create:
    """
    Extract data from raw csv, rename columns, clean and save to new CSV
    """
    input:
        get_abs_dataset_path(
            "raw", "wfbb_heat_atlas_bb") / "data" /
            "2023-09-26_waermekataster_bestand_potenzial_analyse_download.csv"
    output: DATASET_PATH / "wfbb_heat_atlas.csv"
    run:
        # Load the data
        data = pd.read_csv(input[0], dtype=str)

        # Clean dataframe
        empty_row_index = data.index[data.isnull().all(axis=1) | (data == '').all(axis=1)][0]
        data = data.iloc[:empty_row_index]
        data = data.dropna()

        rename_dict = config["rename_columns"]
        # Iterate through each pair in the renaming dictionary
        for key, value in rename_dict.items():
            if key in data.columns:
                data.rename(columns={key: value}, inplace=True)
            else:
                # If not found, check with a space added to the end of the key
                key_with_space = f"{key} "
                if key_with_space in data.columns:
                    # If the column name with a space at the end is found, replace it
                    data.rename(columns={key_with_space: value}, inplace=True)
                else:
                    raise ValueError(f"'{key}' not found!")

        # Write the updated DataFrame to new CSV
        data.to_csv(output[0], index=False)
