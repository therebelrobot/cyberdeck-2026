/**
 * GET /api/notes
 * 
 * List notes in vault per docs/KIOSK.md:
 * - Vault at ~/vault/
 * - daily/ - auto-created daily log files
 * - notes/ - freeform notes
 */

import { NextResponse } from 'next/server';

export async function GET() {
  try {
    // Placeholder - in production, read from ~/vault/
    const notes = [
      {
        id: '1',
        title: '2026-04-16',
        path: 'daily/2026-04-16.md',
        modified: '09:14:32',
      },
      {
        id: '2',
        title: 'Sector 4 Notes',
        path: 'notes/sector-4.md',
        modified: 'Yesterday',
      },
    ];

    return NextResponse.json({ notes });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch notes' },
      { status: 500 }
    );
  }
}
