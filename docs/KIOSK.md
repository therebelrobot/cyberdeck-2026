# cyberdeck-2026 — Kiosk UI Context

This document provides full context for the kiosk UI component of the
cyberdeck-2026 project. Read this alongside the general project context before
working on anything in the kiosk application.

---

## Overview

The kiosk is a fullscreen Next.js (TypeScript) application served locally on
the Pi Zero 2W and displayed in kiosk mode on boot. It is the primary interface
for the device. Terminal and desktop are escape hatches only.

The aesthetic is Jurassic Park-themed: amber-on-black, monospace fonts,
terminal/control-room feel. The internal name is **RAPTOR OS**.

---

## Tech Stack

- **Next.js** (TypeScript, App Router)
- **Tailwind CSS** with custom JP color palette
- **WebSockets** for live push (Meshtastic feed, status updates, sync state)
- **API routes** for system interaction (PiSugar, cellular, notes, git sync)
- Fonts: `VT323` or `Share Tech Mono` (Google Fonts) for terminal aesthetic (should be locally hosted for off-grid use)

### Color Palette
- Background: `#0A0A0A`
- Primary amber: `#FFA500`
- Accent green: `#39FF14`
- Muted overlay: `#1A1A1A`
- Danger/alert: `#FF4500`

---

## Input Model

The ANO rotary encoder + XIAO SAMD21 HID bridge presents to the Pi as a USB
keyboard/mouse. The kiosk handles all navigation via keyboard and wheel events.

| Physical Input | HID Event | Kiosk Action |
|---|---|---|
| Encoder rotate CW | WheelDown | Scroll down in current panel |
| Encoder rotate CCW | WheelUp | Scroll up in current panel |
| Encoder center click | Space | Select / confirm |
| ANO up button | ArrowUp | Focus previous panel / navigate up |
| ANO down button | ArrowDown | Focus next panel / navigate down |
| ANO left button | ArrowLeft | Navigate to mesh panel |
| ANO right button | ArrowRight | Navigate to notes panel |
| CardKB any key | Standard keypress | Text input when compose is active |

Panel navigation: ArrowUp/Down switches between mesh and notes panels.
ArrowLeft/Right also switch panels (mesh left, notes right).
Compose mode (text input active) captures all keypresses for the CardKB.

---

## Layout

Single fullscreen layout. No multi-page routing. All content lives on one
screen with encoder-navigable panels.

```
┌─────────────────────────────────────────┐
│  RAPTOR OS  ●●●●○  [SIG] [MESH] [BAT]  │  ← StatusBar
├──────────────────┬──────────────────────┤
│                  │                      │
│   MESH COMMS     │   NOTES / LOG        │
│   (left panel)   │   (right panel)      │
│                  │                      │
│   message feed   │   note list /        │
│   compose bar    │   markdown editor    │
│                  │                      │
├──────────────────┴──────────────────────┤
│  [terminal]  [desktop]  [cellular]  [lora]  [settings]  │
└─────────────────────────────────────────┘
         ↑ QuickActions strip (bottom)
```

---

## Panels

### StatusBar (top, always visible)
Pulls from `/api/status` on mount, then subscribes to `status:update`
WebSocket channel for live updates.

Displays:
- Clock (from PiSugar RTC via I2C)
- Battery % + estimated runtime (from PiSugar I2C ring buffer)
- Cellular signal strength + connection state
- Meshtastic node count + last activity timestamp
- Unread mesh message indicator (pulses amber when unread messages exist)

All indicators styled as JP-themed glyphs where possible.

### Mesh Comms Panel (left, primary)
Primary communication interface. First-class feature, not a secondary view.

Subviews (navigable via directional buttons within panel):
- **Feed** — scrollable message history, newest at bottom, channel + direct
  messages interleaved with visual distinction
- **Compose** — triggered by Enter on feed, CardKB captures input, Enter sends
  via `/api/mesh/send`, Escape cancels
- **Nodes** — list of connected mesh nodes, signal strength, GPS coordinates
  if available

Data flow:
- Initial history from `/api/mesh/messages` (paginated)
- Live incoming messages pushed via `mesh:message` WebSocket channel
- Outgoing messages POST to `/api/mesh/send`
- All messages auto-written to `~/mesh-log/YYYY-MM-DD.md` server-side
  (Obsidian-compatible markdown, frontmatter + timestamps, node names as
  wiki-style links)

### Notes / Log Panel (right)
Interface into the Obsidian vault at `~/vault/`. Append-only from this device
— the Pi never edits existing notes from other devices, only creates new files
and appends to daily logs. This makes merge conflicts essentially impossible.

Vault structure:
```
~/vault/
  daily/      ← auto-created daily log, one file per day (YYYY-MM-DD.md)
  notes/      ← freeform notes created on device
```

Subviews:
- **Note list** — encoder-scrollable list of recent notes + today's daily log
  at top
- **Editor** — minimal markdown editor, CardKB for input, Enter to save,
  Escape to return to list
- **Sync status** — small indicator showing last sync time and queue depth

Data flow:
- Note CRUD via `/api/notes`
- Manual sync trigger via `/api/sync`
- Live sync progress via `sync:status` WebSocket channel

### QuickActions Strip (bottom)
Encoder-selectable row of actions. Accessed by pressing ANO down from any
panel. Rarely needed.

Actions:
- `[terminal]` — launches terminal emulator, exits kiosk focus
- `[desktop]` — launches full desktop environment, exits kiosk focus
- `[cellular]` — toggles LTE dongle on/off
- `[lora]` — toggles Meshtastic node on/off
- `[settings]` — opens settings overlay (screensaver timeout, sync interval,
  backlight level, etc.)

---

## Screensaver / Dim Mode

After configurable idle timeout (default: 5 minutes), the screensaver
activates. Backlight dims via PiSugar PWM control. The UI does not blank —
a styled overlay renders over the main UI showing live ambient data.

Wake condition: any encoder input or CardKB keypress. Backlight ramps up
smoothly on wake.

### Screensaver Layout
```
┌─────────────────────────────────────┐
│                                     │
│   [animated dino silhouette]        │
│                                     │
│   ████████████░░░░  72% / ~6.2hrs   │  ← battery sparkline (30min history)
│                                     │
│   MESH  ●  3 nodes  last: 4m ago    │
│   ──────────────────────────────    │
│   > dr-grant: anyone near sector 4? │  ← most recent mesh message
│                                     │
│   [slow amber scanline animation]   │
│                                     │
│        RAPTOR OS  //  STANDBY       │
└─────────────────────────────────────┘
```

Implementation notes:
- CSS-only animations for scanlines and dino silhouette to minimize CPU load (reference https://aleclownes.com/2017/02/01/crt-display.html for an example)
- Battery sparkline rendered from in-memory ring buffer (last 30 min of
  PiSugar readings, polled every 30s by PiSugarService)
- Mesh data from last known state — no new fetches during screensaver
- Dim level configurable in settings, default ~10% backlight

---

## Server-Side Services

Persistent services initialized at Next.js server startup (not per-request).
Lives in `src/services/`.

### MeshtasticService
- Maintains `@meshtastic/js` serial connection to XIAO ESP32-S3
- Emits events consumed by WebSocket handler
- Writes incoming messages to `~/mesh-log/YYYY-MM-DD.md`
- Exposes `send(message)` and `getHistory(limit)` methods

### PiSugarService
- Polls PiSugar 3 Plus via I2C (address 0x57) every 30 seconds
- Maintains in-memory ring buffer of last 30 minutes of readings
- Exposes `getStatus()` (current) and `getHistory()` (sparkline data)
- Controls backlight PWM for screensaver dim/wake

### CellularService
- Monitors LTE dongle connection state
- Triggers VaultSyncService on connect/disconnect
- Exposes `toggle()`, `getStatus()`, `getSignal()`

### VaultSyncService
- Wraps git operations for `~/vault/` sync
- Auth via SSH deploy key at `~/.ssh/vault_deploy_key`
- Vault repo treated as append-only from this device
- Sync strategy:
  - On connect: immediate pull then push
  - While connected: sync every N minutes (configurable, default 15)
  - On disconnect: queue writes locally, sync on next connection
- Exposes `sync()`, `getStatus()`, `getQueueDepth()`

### ScreensaverService
- Tracks last input timestamp
- Fires screensaver activate/deactivate events
- Configurable idle timeout (default 5 minutes)
- Interfaces with PiSugarService for backlight control

---

## API Routes

All routes under `/api/`.

| Route | Method | Description |
|---|---|---|
| `/api/status` | GET | Aggregated system status (battery, cellular, mesh, clock) |
| `/api/mesh/messages` | GET | Paginated mesh message history |
| `/api/mesh/send` | POST | Send a Meshtastic message |
| `/api/mesh/nodes` | GET | Connected mesh node list |
| `/api/notes` | GET | List notes in vault |
| `/api/notes/[id]` | GET/POST/PUT | Note CRUD |
| `/api/sync` | POST | Manual vault sync trigger |
| `/api/sync/status` | GET | Current sync state + queue depth |
| `/api/system/cellular` | POST | Toggle cellular on/off |
| `/api/system/lora` | POST | Toggle LoRa/Meshtastic on/off |
| `/api/system/backlight` | POST | Set backlight level (0–100) |
| `/api/system/screensaver` | GET/POST | Screensaver config |

---

## WebSocket Channels

| Channel | Direction | Payload |
|---|---|---|
| `mesh:message` | Server → Client | New incoming Meshtastic message |
| `mesh:nodes` | Server → Client | Node list update |
| `status:update` | Server → Client | Battery / cellular / mesh state change |
| `sync:status` | Server → Client | Vault sync progress and result |
| `screensaver:activate` | Server → Client | Idle timeout reached |
| `screensaver:wake` | Server → Client | Input detected, wake display |

---

## Mesh Log Format

Stored at `~/mesh-log/YYYY-MM-DD.md`. Obsidian-compatible. Not synced to vault
by default — stored separately at `~/mesh-log/`. Format is intentionally
compatible so a future `mv ~/mesh-log ~/vault/mesh-log` + commit is all that's
needed to merge.

Example file:
```markdown
---
date: 2026-04-16
type: mesh-log
---

# Mesh Log — 2026-04-16

## 09:14:32 — [[dr-grant]] (direct)
anyone near sector 4?

## 09:15:01 — [[raptor-os]] (sent)
sector 4 clear, heading your way

## 11:32:44 — [[ian-malcolm]] (channel: base)
life, uh... finds a way
```

---

## Vault Sync — SSH Deploy Key Setup

On first boot, a setup script handles:
1. Generate SSH key pair at `~/.ssh/vault_deploy_key`
2. Display public key for user to add to vault repo as deploy key
3. Clone vault repo to `~/vault/`
4. Configure git remote with SSH key via `GIT_SSH_COMMAND` env var or
   `~/.ssh/config` entry

`~/.ssh/config` entry format:
```
Host vault-sync
  HostName github.com
  User git
  IdentityFile ~/.ssh/vault_deploy_key
  IdentitiesOnly yes
```

Git remote set as: `git@vault-sync:your-username/your-vault-repo.git`

VaultSyncService uses this host alias for all git operations.

---

## Constraints and Notes for All Kiosk Work

- **Display is 640×480** — all UI must be designed for this resolution. No
  responsive breakpoints needed. This is the only target. Center that frame it within the view if the viewport is actually larger.
- **No mouse assumed** — all navigation must be fully operable via encoder +
  CardKB keyboard events only. Touch is available (capacitive display) but
  is a bonus, not a requirement.
- **Performance matters** — Pi Zero 2W is not powerful. Minimize client-side
  JS bundle size. Prefer server-side rendering. Avoid heavy animation
  libraries — CSS animations only for screensaver effects.
- **Offline-first** — all core functionality (notes, mesh comms, status) must
  work without internet. Vault sync and cellular are additive, not required.
- **Single page** — no client-side routing. All panels live on one route.
  Use state to manage panel focus and subviews.
- **Kiosk mode** — the browser runs fullscreen with no chrome. No back button,
  no address bar. UI must provide all navigation affordances internally.
- **Escape hatches** — terminal and desktop launch via QuickActions only.
  The kiosk should never be in a state where the user is trapped with no
  way to reach them.
- **Mesh log and vault are separate** — do not merge or cross-write between
  `~/mesh-log/` and `~/vault/` without an explicit user action. Keep data
  sources cleanly separated until the user opts to merge.
