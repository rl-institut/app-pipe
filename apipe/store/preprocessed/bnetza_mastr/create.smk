"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""

from apipe.store.utils import get_abs_dataset_path

DATASET_PATH = get_abs_dataset_path("preprocessed", "bnetza_mastr")

rule create:
    input:
        get_abs_dataset_path("raw", "bnetza_mastr") / "data" / "bnetza_open_mastr_2024-11-27.zip"
    output:
        files=[DATASET_PATH / "data" / f for f in config["files_extract"]]
    params:
        outpath=DATASET_PATH / "data",
        files_extract=" ".join([f"bnetza_open_mastr_2024-11-27/{f}" for f in config["files_extract"]])
    shell:
        """
        unzip -j {input} {params.files_extract} -d {params.outpath}
        """
