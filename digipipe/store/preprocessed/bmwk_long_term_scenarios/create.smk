"""
Snakefile for this dataset

Note: To include the file in the main workflow, it must be added to the respective module.smk .
"""

from digipipe.store.utils import get_abs_dataset_path

DATASET_PATH = get_abs_dataset_path(
    "preprocessed", "bmwk_long_term_scenarios", data_dir=True)

rule create:
    input:
        get_abs_dataset_path(
            "raw", "bmwk_long_term_scenarios") / "data" /
            "bmwk_long_term_scenarios.zip"
    output:
        files = [DATASET_PATH / f for f in config["files_extract"]]
    params:
        outpath=DATASET_PATH,
        files_extract=" ".join(config["files_extract"])
    shell:
        """
        unzip -j {input} {params.files_extract} -d {params.outpath}
        """
