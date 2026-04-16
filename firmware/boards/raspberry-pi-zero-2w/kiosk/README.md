# RAPTOR OS - Cyberdeck Kiosk

Jurassic Park-themed kiosk interface for the Cyberdeck 2026 handheld device.

> **Internal name**: RAPTOR OS  
> **Aesthetic**: Amber-on-black, monospace fonts, terminal/control-room feel  
> **Specification**: See [docs/KIOSK.md](../../../docs/KIOSK.md) for full context

## Features

- **RAPTOR OS Interface**: Fullscreen Next.js application served locally on Pi Zero 2W
- **Mesh Comms Panel**: Primary communication interface with Meshtastic integration
- **Notes / Log Panel**: Interface into Obsidian vault at `~/vault/`
- **StatusBar**: Real-time battery, cellular, and mesh status indicators
- **QuickActions Strip**: Terminal, desktop, cellular, LoRa, and settings access
- **Screensaver**: Configurable idle timeout with JP-themed dim overlay
- **Offline-First**: All core functionality works without internet

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Raspberry Pi Zero 2W                      │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌──────────────────────────────────┐  │
│  │  Chromium   │───▶│   Next.js Server (localhost:3000) │  │
│  │  (Kiosk)   │    │   ┌────────────────────────────┐  │  │
│  └─────────────┘    │   │   RAPTOR OS UI            │  │  │
│                     │   │   - StatusBar            │  │  │
│                     │   │   - Mesh Comms Panel     │  │  │
│                     │   │   - Notes Panel          │  │  │
│                     │   │   - QuickActions Strip   │  │  │
│                     │   └────────────────────────────┘  │  │
│                     └──────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Layout

Per [docs/KIOSK.md](../../../docs/KIOSK.md):

```
┌─────────────────────────────────────────┐
│  RAPTOR OS  ●●●●○  [SIG] [MESH] [BAT]  │  ← StatusBar
├──────────────────┬──────────────────────┤
│                  │                      │
│   MESH COMMS     │   NOTES / LOG        │
│   (left panel)   │   (right panel)      │
│                  │                      │
├──────────────────┴──────────────────────┤
│  [terminal]  [desktop]  [cellular]  [lora]  [settings]  │
└─────────────────────────────────────────┘
          ↑ QuickActions strip (bottom)
```

## Quick Start

### Development

```bash
cd firmware/boards/raspberry-pi-zero-2w/kiosk
npm install
npm run dev
```

Open http://localhost:3000 to view the kiosk.

### Production Build

```bash
npm run build
npm start
```

## Project Structure

```
kiosk/
├── package.json              # Dependencies and scripts
├── next.config.js           # Next.js configuration
├── tsconfig.json            # TypeScript configuration
├── src/
│   ├── app/
│   │   ├── layout.tsx       # Root layout with RAPTOR OS branding
│   │   ├── page.tsx         # Main kiosk page (single-page layout)
│   │   ├── globals.css      # JP color palette and styles
│   │   └── api/             # API routes
│   │       ├── status/      # GET /api/status
│   │       ├── mesh/        # mesh messages, send, nodes
│   │       ├── notes/      # GET /api/notes
│   │       ├── sync/       # POST /api/sync, GET /api/sync/status
│   │       └── system/     # cellular, lora, backlight controls
│   └── services/           # Server-side services
│       ├── pisugar.ts      # Battery monitoring, backlight PWM
│       ├── meshtastic.ts   # @meshtastic/js serial connection
│       ├── cellular.ts     # LTE modem control
│       ├── vault-sync.ts   # Git vault sync
│       ├── screensaver.ts  # Idle timeout tracking
│       └── types.ts        # Shared TypeScript types
└── README.md
```

## Color Palette

Per [docs/KIOSK.md](../../../docs/KIOSK.md):

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#0A0A0A` | Main background |
| Primary amber | `#FFA500` | Primary text, accents |
| Accent green | `#39FF14` | Success states, sender names |
| Muted overlay | `#1A1A1A` | Panel backgrounds |
| Danger/alert | `#FF4500` | Error states |

## Input Model

Per [docs/KIOSK.md](../../../docs/KIOSK.md), all navigation via keyboard events (ANO rotary encoder + CardKB):

| Physical Input | HID Event | Kiosk Action |
|---------------|-----------|--------------|
| Encoder rotate CW | ArrowDown | Scroll / next item |
| Encoder rotate CCW | ArrowUp | Scroll / prev item |
| Encoder center click | Enter | Select / confirm |
| ANO up | ArrowUp + Meta | Focus previous panel |
| ANO down | ArrowDown + Meta | Focus next panel |
| ANO left | ArrowLeft | Navigate within panel |
| ANO right | ArrowRight | Navigate within panel |
| CardKB any key | Standard keypress | Text input when compose active |

## API Routes

| Route | Method | Description |
|-------|--------|-------------|
| `/api/status` | GET | Aggregated system status |
| `/api/mesh/messages` | GET | Paginated mesh message history |
| `/api/mesh/send` | POST | Send a Meshtastic message |
| `/api/mesh/nodes` | GET | Connected mesh node list |
| `/api/notes` | GET | List notes in vault |
| `/api/sync` | POST | Manual vault sync trigger |
| `/api/sync/status` | GET | Current sync state + queue depth |
| `/api/system/cellular` | POST | Toggle cellular on/off |
| `/api/system/lora` | POST | Toggle LoRa/Meshtastic on/off |
| `/api/system/backlight` | POST | Set backlight level (0-100) |

## Display Resolution

- **Fixed 640x480** - All UI designed for this resolution
- No responsive breakpoints needed
- Centered within viewport if larger

## Performance Considerations

- Next.js standalone output for minimal footprint
- Static generation where possible
- Minimal JavaScript bundle size (Pi Zero 2W is limited)
- CSS-only animations for screensaver effects
- No heavy animation libraries

## Constraints

Per [docs/KIOSK.md](../../../docs/KIOSK.md):

- **No mouse assumed** - All navigation via encoder + CardKB
- **Offline-first** - Core functionality works without internet
- **Single page** - No client-side routing
- **Kiosk mode** - Browser runs fullscreen with no chrome
- **Escape hatches** - Terminal and desktop via QuickActions only
- **Mesh log and vault are separate** - Keep data sources cleanly separated
