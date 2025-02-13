# Note this file was copied from oemof-b3 and adapted for apipe:
# https://github.com/rl-institut/oemof-B3

rule plot_dispatch:
    input: "store/appdata/esys/{scenario}/postprocessed/"
    output: directory("store/appdata/esys/{scenario}/plotted/dispatch")
    params:
        logfile="store/appdata/esys/{scenario}/{scenario}.log"
    shell: "python esys/scripts/plot_dispatch.py {input} {output} {params.logfile}"

rule plot_storage_level:
    input: "store/appdata/esys/{scenario}/postprocessed/"
    output: directory("store/appdata/esys/{scenario}/plotted/storage_level")
    params:
        logfile="store/appdata/esys/{scenario}.log"
    shell: "python esys/scripts/plot_storage_levels.py {input} {output} {params.logfile}"

rule plot_scalar_results:
    input: "store/appdata/esys/{scenario}/postprocessed/"
    output: directory("store/appdata/esys/{scenario}/plotted/scalars/")
    params:
        logfile="store/appdata/esys/{scenario}.log"
    shell: "python esys/scripts/plot_scalar_results.py {input} {output} {params.logfile}"

# rule plot_joined_scalars:
#     input: "results/joined_scenarios/{scenario_group}/joined/"
#     output: directory("results/joined_scenarios/{scenario_group}/joined_plotted/")
#     params:
#         logfile="results/joined_scenarios/{scenario_group}/{scenario_group}.log"
#     shell: "python esys/scripts/plot_scalar_results.py {input} {output} {params.logfile}"
