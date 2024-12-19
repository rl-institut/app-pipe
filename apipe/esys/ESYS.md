# Energy system Stadt-Land-Energie

The energy system in apipe is created using
[oemof-B3](https://github.com/rl-institut/oemof-B3).

## Build the energy system

To test if everything works, you can run the test scenario with

```
snakemake -j1 make_esys_appdata
```

For this you have to provide the corresponding input data in the store:

- raw/technology_data/data
- raw/renewables.ninja_feedin/data
- raw/demandregio/data
- raw/bkg_vg250/data
- raw/dwd_temperature/data.

Then, assumptions on constant parameters such as plant costs, lifetime and
efficiencies are mapped and set as values of the corresponding variables in the
scalars.

Empty scalars and time series can be created from the energy model setup with

```
snakemake -j1 create_empty_scalars
snakemake -j1 create_empty_ts
```

These prompts create empty csv files with scalars and time series in the
following directories:

- `store/datasets/esys_raw/data/scalars/`
- `store/datasets/esys_raw/data/time_series/`

To set up an empty energy system, the following prompt automatically writes
default scalar values (such as zero or NaN) to the empty scalars:

```
snakemake -j1 write_default_scalars
```
With this the file `empty_scalars.csv` is automatically updated and saved to:
`store/datasets/esys_raw/data/scalars/default_scalars.csv`

## Test the energy system

To test the solvability of the energy system, run

```
snakemake -j1 postprocessed_esys_appdata
```

which should result in an output like

```
[...]
INFO - Optimization successful...
INFO - Solved the model. Elapsed time: 0:00:00.291995
INFO - Model solved. Collecting results.
INFO - Results saved to store/appdata/esys/2045_scenario/optimized.
```

## FAQ
### Do default scalars defined in `write_default_scalars.yml` overwrite
`raw/technology_data/raw_cost_efficiencies.csv`?

Yes they do.
To change this. You can either:

1) Run once

```
snakemake -j1 make_esys_appdata
```
2) Navigate to `store/datasets/esys_raw/scalars`

```
cd store/datasets/esys_raw/scalars
```

3) Change the value in the file `default_scalars.csv`.

4) Run again:
```
snakemake -j1 make_esys_appdata
```

Alternatively:
1) Navigate to `store/raw/technology_data/raw_cost_efficiencies.csv`
```
cd store/raw/technology_data/raw_cost_efficiencies.csv
```
2) Update the values for those scalars you'd like to change
3) Delete the respective var_names from `write_default_scalars` within `write_default_scalars.yml`
4) Add var_names to `cost_efficiencies` within `write_default_scalars.yml`
5) Run
```
snakemake -j1 make_esys_appdata
```
