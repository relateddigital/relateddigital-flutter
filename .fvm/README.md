# FVM pins

| Flavor | Flutter | When |
|--------|---------|------|
| `cocoapods` (default) | 3.32.8 | `master` / CocoaPods |
| `spm` | 3.44.8 | SPM branch |

```bash
fvm use cocoapods          # 3.32.8 — master
fvm use spm                # 3.44.8 — SPM
# or without FVM:
#   /usr/local/flutter/bin/flutter   (3.32.8)
```

3.44.8 remains installed at `~/fvm/versions/3.44.8`. Backup: `fvm_config.spm.json`.
