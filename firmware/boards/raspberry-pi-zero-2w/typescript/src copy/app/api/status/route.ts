/**
 * GET /api/status
 * 
 * Aggregated system status per docs/KIOSK.md:
 * - Battery % + estimated runtime (from PiSugar I2C)
 * - Cellular signal strength + connection state
 * - Meshtastic node count + last activity timestamp
 * - Clock (from PiSugar RTC via I2C)
 */

import { NextResponse } from 'next/server';

// In production, these would be imported from services
// import { PiSugarService } from '@/services/pisugar';
// import { CellularService } from '@/services/cellular';
// import { MeshtasticService } from '@/services/meshtastic';

export async function GET() {
  try {
    // Placeholder data - in production, query actual services
    const status = {
      time: new Date().toLocaleTimeString('en-US', { hour12: false }),
      date: new Date().toISOString().split('T')[0],
      battery: 75,
      batteryRuntime: '~6.2hrs',
      cellularSignal: 4,
      cellularConnected: true,
      meshNodes: 3,
      meshLastActivity: '4m ago',
      meshUnread: 0,
    };

    return NextResponse.json(status);
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch status' },
      { status: 500 }
    );
  }
}
