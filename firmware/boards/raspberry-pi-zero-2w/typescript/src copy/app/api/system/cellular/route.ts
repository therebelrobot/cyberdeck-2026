/**
 * POST /api/system/cellular
 * 
 * Toggle cellular on/off per docs/KIOSK.md
 */

import { NextResponse } from 'next/server';

export async function POST() {
  try {
    // Placeholder - in production, toggle via CellularService
    return NextResponse.json({
      success: true,
      enabled: true,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to toggle cellular' },
      { status: 500 }
    );
  }
}
