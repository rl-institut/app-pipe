# Name des Datensatzes

Eine kurze Beschreibung des Datensatzes.
Diese hilft der Dokumentation und bei der Erstellung des Berichts.

# Notizen (nur zur Information, nicht Teil des dataset.md files)

Benennungskonvention: `<quelle_datasetname>` (Kleinschreibung), z.B. ein
Datensatz zu Naturschutzgebieten des Bundesamtes für Naturschutz (BfN) könnte
`bfn_natural_reserves` heißen.

Was ist ein Datensatz? Es gibt verschiedene Definitionen, aber in dieser
Pipeline ist ein Datensatz eine Sammlung von Daten, die als eine Einheit
behandelt, welche aus mehreren Dateien bestehen und durch eine einzige
Metadaten-Datei identifiziert werden kann.

Beispiele:
- [OSM Germany](https://download.geofabrik.de/europe/germany-latest.osm.pbf)
- [ERA5 weather dataset](https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=overview)
- [BKG administrative areas](https://gdz.bkg.bund.de/index.php/default/verwaltungsgebiete-1-250-000-stand-01-01-vg250-01-01.html)

Rohdateien kommen in das Verzeichnis `data` und werden nach Möglichkeit nicht
umbenannt.

## Beschreibung

Bitte gib zumindest eine kurze Beschreibung:

- Worum geht es in dem Datensatz
- Gibt es Besonderheiten, die es zu wissen gilt? (neben Metadaten, welche
  UNBEDINGT erstellt werden müssen, dazu unten mehr)

Eine schnelle und suboptimale Beschreibung ist besser als keine.

## Metadaten

Füge für jeden Roh-/Originaldatensatz, der erstellt wird, Metadaten zur
Beschreibung der Daten mit maschinenlesbaren Informationen hinzu.
Folge der [OEP](https://openenergy-platform.org/about/) Metadaten v1.5.1.
Es kann der [Metadata creator](https://meta.rl-institut.de/meta_creator/151)
verwendet werden.

Zum Vergleich die [metadata.json](metadata.json) in diesem Verzeichnis.

Alternativ kann sie auch manuell erstellt werden:
Folgen Sie
[dieses Beispiel](https://github.com/OpenEnergyPlatform/oemetadata/blob/develop/metadata/latest/example.json)
um zu verstehen, wie die Felder verwendet werden. Die Felder werden in der
[Open Energy Metadata Description](https://github.com/OpenEnergyPlatform/oemetadata/blob/develop/metadata/v141/metadata_key_description.md)
im Detail beschrieben. Bitte überprüfe, ob der Metadatenstring den OEP-Metadaten
Standards entspricht, indem das
[OMI-Tool](https://github.com/OpenEnergyPlatform/omi) verwendet wird.
Wenn der Metadatenstring konform ist, bringt OMI die Schlüssel in die richtige
Reihenfolge und gibt den vollständigen String aus (für den Export die Option
`-o` verwenden).
