/**
 * GET /api/mesh/nodes
 * 
 * Connected mesh node list per docs/KIOSK.md:
 * - Returns list of connected nodes
 * - Includes signal strength and GPS coordinates if available
 */

import { NextResponse } from 'next/server';

export async function GET() {
  try {
    // Placeholder - in production, query MeshtasticService
    const nodes = [
      {
        id: '1',
        name: 'dr-grant',
        signal: -45,
        lat: 37.7749,
        lon: -122.4194,
        lastSeen: '2m ago',
      },
      {
        id: '2',
        name: 'ian-malcolm',
        signal: -62,
        lat: null,
        lon: null,
        lastSeen: '5m ago',
      },
    ];

    return NextResponse.json({ nodes });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch nodes' },
      { status: 500 }
    );
  }
}
