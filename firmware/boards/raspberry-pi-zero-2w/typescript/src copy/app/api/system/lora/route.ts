/**
 * POST /api/system/lora
 * 
 * Toggle LoRa/Meshtastic on/off per docs/KIOSK.md
 */

import { NextResponse } from 'next/server';

export async function POST() {
  try {
    // Placeholder - in production, toggle via MeshtasticService
    return NextResponse.json({
      success: true,
      enabled: true,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to toggle LoRa' },
      { status: 500 }
    );
  }
}
