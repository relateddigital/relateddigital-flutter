# iOS Native Layer

```
ios/
├── relateddigital_flutter.podspec
└── relateddigital_flutter/
    ├── Package.swift
    └── Sources/relateddigital_flutter/*.swift
```

The plugin ships **both**:

- **Swift Package Manager** — `relateddigital_flutter/Package.swift` (Flutter 3.44+)
- **CocoaPods** — `relateddigital_flutter.podspec` (older Flutter / SPM disabled)

App developers: see the root [README](../README.md#choose-spm-or-cocoapods).

## Example app

The example is SPM-only (`example/ios` has no `Podfile`). A CocoaPods snapshot is kept as `example/ios/Podfile.cocoapods` (inactive until renamed to `Podfile`).
