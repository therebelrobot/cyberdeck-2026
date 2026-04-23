/**
 * GET /api/mesh/messages
 * 
 * Paginated mesh message history per docs/KIOSK.md:
 * - Returns messages from MeshtasticService
 * - Supports pagination via ?limit and ?offset
 * - Messages auto-written to ~/mesh-log/YYYY-MM-DD.md
 */

import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const limit = parseInt(searchParams.get('limit') || '50');
  const offset = parseInt(searchParams.get('offset') || '0');

  try {
    // Placeholder - in production, query MeshtasticService
    const messages = [
      {
        id: '1',
        time: '09:14:32',
        sender: 'dr-grant',
        channel: 'direct',
        message: 'anyone near sector 4?',
        direct: true,
      },
      {
        id: '2',
        time: '09:15:01',
        sender: 'raptor-os',
        channel: 'direct',
        message: 'sector 4 clear, heading your way',
        direct: true,
      },
      {
        id: '3',
        time: '11:32:44',
        sender: 'ian-malcolm',
        channel: 'base',
        message: 'life, uh... finds a way',
        direct: false,
      },
    ];

    return NextResponse.json({
      messages: messages.slice(offset, offset + limit),
      total: messages.length,
      hasMore: offset + limit < messages.length,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch messages' },
      { status: 500 }
    );
  }
}
