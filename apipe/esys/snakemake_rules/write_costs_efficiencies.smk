rule write_costs_efficiencies:
    """
    Write costs and efficiencies from raw data to esys datasets
    """
    input:
        "store/datasets/esys_raw/data/scalars/unresolved_scalars.csv",
        "store/raw/technology_data/data/raw_costs_efficiencies.csv",
        "store/raw/technology_data/data/region_specific_scalars.csv",
    output: "store/datasets/esys_raw/data/scalars/completed_scalars.csv"
    shell: "python esys/scripts/write_costs_efficiencies.py {input} {output}"
