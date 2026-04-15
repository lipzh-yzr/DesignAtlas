# DesignAtlas

DesignAtlas is a small iOS SwiftUI playground for exploring and comparing design systems in one app.

The project uses a local Swift Package Manager workspace at `Libraries/Package.swift` to keep feature code, shared code, and design-system wrappers modular while still living in a single repository.

## Current scope

- Browse a simple gallery of design systems
- Open showcase screens for supported systems
- Collect lightweight rating data for each system
- Experiment with modular app structure using Swift Package Manager

Today, the gallery is centered on:

- Charcoal
- Structura

The package layout also includes modules for Material UI and SBB UI experiments.

## Notes

- The app entry point is `DesignAtlas/Sources/AppFeature.swift`.
- The modularization rationale is documented in `docs/design/spm-modularization.md`.
- This project is intentionally lightweight and still evolving.
