# Design Document: SPM Modularization for DesignAtlas

## Summary
DesignAtlas now uses Swift Package Manager modularization through a single central manifest at `Libraries/Package.swift`. Modules are modeled as separate SPM targets and exposed as library products from that one package, instead of creating a standalone `Package.swift` for each module.

This keeps modular boundaries at the target level while centralizing dependency declaration, package resolution, and local package integration.

## Goals
- Create clear module boundaries for features and shared layers.
- Keep third-party dependencies centralized in one manifest.
- Reduce boilerplate compared with maintaining many local packages.
- Make it easy to add new feature modules with a consistent folder layout.

## Non-Goals
- Introducing a multi-repository distribution model.
- Independently versioning internal modules.
- Changing app behavior or UI as part of the packaging work.

## Current State
- The app target remains `DesignAtlas`.
- The central local package lives at `Libraries/Package.swift`.
- Internal modules are implemented as targets under `Libraries/Sources`.
- Module tests live under `Libraries/Tests`.

## Modularization Approach
Use one local package named `Libraries` and declare each internal module as its own target and, where needed, its own library product.

### Why One Manifest
- In SPM, the package is the unit of dependency resolution and versioning.
- In SPM, the target is the unit of modularization.
- For modules that live in the same repository and evolve together, one manifest is simpler and more maintainable than multiple local packages.

## Package Configuration
The package is defined once in `Libraries/Package.swift`, with multiple products and targets.

## How To Add A New Module
When a new internal module is needed:

1. Add a new target in `Libraries/Package.swift`.
2. Add a matching library product if the app or other modules should import it directly.
3. Create `Libraries/Sources/<ModuleName>/`.
4. Add an optional test target and `Libraries/Tests/<ModuleName>Tests/`.
5. Declare only the dependencies needed by that target.

This keeps the dependency graph explicit while avoiding package-per-module overhead.

## Risks and Mitigations
- **Risk:** The central manifest grows too large over time.
  - **Mitigation:** Keep helpers in `Package.swift` small and organize targets clearly by responsibility.
- **Risk:** Internal modules start depending on too many unrelated products.
  - **Mitigation:** Enforce target-level dependency discipline and review new dependencies when adding modules.
- **Risk:** The app target and Xcode project drift from the package structure.
  - **Mitigation:** Treat `Libraries/Package.swift` as the source of truth for module boundaries.

## Open Questions
- Which future app screens should move into `AppFeature` or additional feature targets.
- Whether `Libraries` should remain an empty umbrella/shared module or be removed later.
- Whether common UI abstractions should live in a dedicated shared target beyond the current wrapper modules.

## Decision
Use a single local package with multiple targets and products as the modularization strategy for DesignAtlas.

## Appendix: Naming Conventions
- Package name: `Libraries`
- Product names: PascalCase
- Target names: match the module name
- Test target names: `<ModuleName>Tests`
- Source folder convention: `Libraries/Sources/<ModuleName>/`
- Test folder convention: `Libraries/Tests/<ModuleName>Tests/`
