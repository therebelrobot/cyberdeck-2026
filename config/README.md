# Configuration

Project-level configuration files.

## Files

### `project.yaml`

The project manifest — declares which boards your project uses, their roles, and how they communicate. This is the central registry for multi-board projects.

See [docs/ARCHITECTURE.md](../docs/ARCHITECTURE.md) for the full manifest format and examples.

### `pins/`

Optional shared pin mapping references for cross-board consistency. Useful when multiple boards of the same type are used with different pin assignments per role.

Board-specific pin configs live alongside their firmware in `firmware/boards/<board>/config.yaml`.
