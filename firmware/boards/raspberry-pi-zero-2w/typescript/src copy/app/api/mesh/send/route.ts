/**
 * POST /api/mesh/send
 * 
 * Send a Meshtastic message per docs/KIOSK.md:
 * - Accepts { message: string, channel?: string }
 * - Returns success/failure
 */

import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const { message, channel = 'base' } = body;

    if (!message || typeof message !== 'string') {
      return NextResponse.json(
        { error: 'Message is required' },
        { status: 400 }
      );
    }

    // Placeholder - in production, send via MeshtasticService
    // await MeshtasticService.send(message, channel);

    return NextResponse.json({
      success: true,
      message: 'Message sent',
      id: Date.now().toString(),
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to send message' },
      { status: 500 }
    );
  }
}
