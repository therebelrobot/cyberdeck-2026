# 3D Models

3D printing and CAD files for physical components in this project.

## Directory Structure

```
models/
├── enclosures/    # Board cases and project housings
├── mounts/        # Mounting brackets, standoffs, DIN rail clips
├── robotics/      # Structural and mechanical parts (arms, joints, chassis)
├── jigs/          # Assembly jigs, soldering jigs, alignment tools
└── _source/       # Editable CAD source files (F3D, STEP, SCAD)
```

## File Format Conventions

| Format | Extension | Location | Purpose |
|--------|-----------|----------|---------|
| STL | `.stl` | Category folders | Print-ready mesh files |
| 3MF | `.3mf` | Category folders | Print-ready with metadata |
| STEP | `.step` | `_source/` | Interchange CAD format |
| Fusion 360 | `.f3d` | `_source/` | Parametric source files |
| OpenSCAD | `.scad` | `_source/` | Programmatic CAD source |

**Print-ready files** (STL, 3MF) go in the appropriate category folder.
**Editable source files** (F3D, STEP, SCAD) go in `_source/`.

## Naming Convention

Use lowercase-kebab-case with an optional version suffix:

```
<descriptive-name>[-v<version>].<ext>
```

Examples:
- `xiao-case-v2.stl`
- `servo-mount.step`
- `chassis-base.scad`
- `controller-box-v1.3mf`

## Recommended Print Settings

Document slicer settings for each part as needed. General defaults:

| Setting | Default |
|---------|---------|
| Layer Height | 0.2mm |
| Infill | 20% |
| Supports | As needed |
| Material | PLA (unless noted) |

### Material Recommendations

- **PLA** — General-purpose enclosures and mounts. Easy to print, sufficient for most indoor projects.
- **PETG** — Parts requiring heat resistance or outdoor use. Better layer adhesion than PLA.
- **TPU** — Flexible parts like vibration dampeners or cable grommets.
- **ABS/ASA** — High-temperature environments or parts needing chemical resistance.

## Tolerance Notes

- Board mounting holes: design for **M2.5 screws** unless otherwise noted
- Board slot fitment: add **0.2–0.3mm** clearance per side for snug fit
- Snap-fit tolerances vary by printer — test with a calibration piece first

## Assembly Notes

If parts interlock or require specific assembly order, document the sequence in a comment block at the top of the source file or in a companion markdown file alongside the STL.
