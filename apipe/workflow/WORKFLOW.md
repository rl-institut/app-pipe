# Workflow

## Download and update RAW dataset

To run the pipeline some input datasets are required:

To download, extract and copy a current set of raw data into `store/raw`, type

    snakemake -j<NUMBER_OF_CPU_CORES> update_raw

A zip file from a prespecified
[URL](https://wolke.rl-institut.de/s/aN2ccptGtFsFiDs/download)
is downloaded and unzipped to `store/temp/`. The raw data files are copied to
the corresponding folders in `store/raw/`.
A prompt asks if an already existing file should be updated. Confirm with "y"
or type "n" to skip.

The following additional files must be downloaded manually:

- [OpenStreetMap](https://download.geofabrik.de/europe/germany-230101.osm.pbf)
  --> place in `store/raw/osm/data/`

## Run

To run the pipeline, go to apipe's root `apipe/` or to
`apipe/workflow/` and type

    snakemake -j<NUMBER_OF_CPU_CORES>

while `NUMBER_OF_CPU_CORES` is the number of CPU cores to be used for the
pipeline execution.  You can also make a dry-run (see what snakemake would do
but without actually really doing anything) by typing

    snakemake -n

To clean all produced data, use

    snakemake -j1 clean

This involves preprocessed data in directories: preprocessed, datasets and
appdata.

### Run specific dataset rule

Beside the global rules above each dataset contains one or more rules that can
be executed individually. The rule name consist of

- `<CATEGORY>`: the store's category (preprocessed, datasets, appdata)
- `<DATASET_NAME>`: dataset name
- `<RULE_NAME>`: name of dataset's rule

Format:

    snakemake -j1 <CATEGORY>_<DATASET_NAME>_<RULE_NAME>

Example: to run rule `create_power_stats_muns` in
[store/datasets/bnetza_mastr_storage_region/create.smk](../store/datasets/bnetza_mastr_storage_region/create.smk)
execute

    snakemake -j1 datasets_bnetza_mastr_storage_region_create_power_stats_muns

Further information on the modules see below.

## Pipeline visualization / DAG

The entire pipeline can be visualized as a directed acyclic graph (DAG).
The following command creates the DAG as an svg file in the current directory:

    snakemake --dag | dot -Tsvg > dag_rules_full.svg

As the full graph is too packed with information and therefore hardly to grasp,
consider to show only certain parts by disabling some target files in the `all`
rule. Also, a simple rule graph (the one shown above) can be created and saved
in the current directory using

    snakemake --rulegraph | dot -Tsvg > dag_rules_simple.svg

To create a graph in the current directory showing the file dependencies, type

    snakemake --filegraph | dot -Tsvg > dag_files.svg

The graphs also provide information on the completed (solid lines) and pending
(dashed lines) processing steps. For further details see
[Snakemake CLI docs](https://snakemake.readthedocs.io/en/stable/executing/cli.html).

## Snakefiles and config

- The global workflow is defined in the main
  [Snakefile](../workflow/Snakefile).
- It includes the module Snakefiles from the data store located at
  - [store/preprocessed/module.smk](../store/preprocessed/module.smk)
  - [store/datasets/module.smk](../store/datasets/module.smk)
  - [store/appdata/module.smk](../store/appdata/module.smk)
- In each of these modules, the rules as well as the config from the contained
  datasets are imported. See above how to run a specific rule.
