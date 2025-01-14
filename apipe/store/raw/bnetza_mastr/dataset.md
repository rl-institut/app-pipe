# Erzeugungsanlagen aus Marktstammdatenregister

Ereugungsanlagen aus dem Markstammdatenregister, das mit dem Tool
[open-mastr](https://github.com/OpenEnergyPlatform/open-MaStR) erstellt und
abgelegt wurde. Die Daten wurden folgendermaßen erstellt:
```
from open_mastr import Mastr
db = Mastr()
db.download("bulk")
db.to_csv()
```

Anschließend wurden die Dateien komprimiert.

Das Marktstammdatenregister (MaStR) ist ein deutsches Register, welches von der
Bundesnetzagentur (BNetza) bereitgestellt wird und alle in Deutschland
befindlichen Strom- und Gasanlagen erfasst.

Datenstand: 27.11.2024
