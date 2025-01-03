import json
from pathlib import Path


def update_foreign_keys(datapackage_path, updates_dict, target_field):
    """
    Update multiple foreignKey references in a datapackage.json file.

    Parameters:
        datapackage_path (str): Path to the datapackage.json file.
        updates_dict (dict): Dictionary with target_resource as keys and
        new_reference_resource as values.
        target_field (str): The field within 'foreignKeys' to identify the
        target entry.
    """
    # Load the datapackage.json file
    with open(datapackage_path, "r", encoding="utf-8") as file:
        datapackage = json.load(file)

    # Iterate over all resources and apply updates
    for resource in datapackage.get("resources", []):
        resource_path = resource.get("path")
        if resource_path in updates_dict:
            foreign_keys = resource.get("schema", {}).get("foreignKeys", [])
            for fk in foreign_keys:
                if fk.get("fields") == target_field:
                    old_reference = fk["reference"]["resource"]
                    fk["reference"]["resource"] = updates_dict[resource_path]
                    print(
                        f"Updated '{target_field}' in '{resource_path}': "
                        f"'{old_reference}' -> "
                        f"'{updates_dict[resource_path]}'"
                    )

    # Save the updated datapackage.json back to the file
    with open(datapackage_path, "w", encoding="utf-8") as file:
        json.dump(datapackage, file, indent=4, ensure_ascii=False)
    print("datapackage.json successfully updated.")


# Parameters
scenario = "2045_scenario"
scenario_path = (
    Path(__file__).resolve().parents[3]
    / "store"
    / "appdata"
    / "esys"
    / scenario
    / "preprocessed"
)  # Path to your datapackage.json file

datapackage_path = scenario_path / "datapackage.json"

updates_dict = {
    "data/elements/electricity-heatpump_central.csv": "electricity-heatpump_central_profile",
    "data/elements/electricity-heatpump_decentral.csv": "electricity-heatpump_decentral_profile",
    "data/elements/electricity-heatpump_heat_med.csv":"electricity-heatpump_heat_med_profile"
}

target_field = "efficiency"

# Run the function
update_foreign_keys(datapackage_path, updates_dict, target_field)
