rule write_default_scalars:
    """
    Write default values in scalar data files
    """
    input: "store/datasets/esys_raw/data/scalars/empty_scalars.csv"
    output:
        "store/datasets/esys_raw/data/scalars/default_scalars.csv",
        "store/datasets/esys_raw/data/scalars/unresolved_costs_efficiencies.csv",
    shell: "python esys/scripts/write_default_scalars.py {input} {output}"
