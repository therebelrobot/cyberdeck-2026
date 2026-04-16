/**
 * POST /api/system/backlight
 * 
 * Set backlight level (0-100) per docs/KIOSK.md:
 * - Interfaces with PiSugarService for PWM control
 * - Used for screensaver dim/wake
 */

import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { level } = body;

    if (typeof level !== 'number' || level < 0 || level > 100) {
      return NextResponse.json(
        { error: 'Level must be a number between 0 and 100' },
        { status: 400 }
      );
    }

    // Placeholder - in production, set via PiSugarService
    // await PiSugarService.setBacklight(level);

    return NextResponse.json({
      success: true,
      level,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to set backlight' },
      { status: 500 }
    );
  }
}
