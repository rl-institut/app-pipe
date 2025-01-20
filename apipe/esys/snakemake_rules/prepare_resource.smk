rule prepare_scalars:
    input:
        raw_scalars="store/datasets/esys_raw/data/scalars/completed_scalars.csv",
    output: "store/appdata/esys/_resources/scal_costs_efficiencies.csv"  # todo rename?
    shell: "python esys/scripts/prepare_scalars.py {input.raw_scalars} {output}"
