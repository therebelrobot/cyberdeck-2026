/**
 * POST /api/sync
 * 
 * Manual vault sync trigger per docs/KIOSK.md:
 * - Wraps git operations for ~/vault/ sync
 * - Auth via SSH deploy key at ~/.ssh/vault_deploy_key
 */

import { NextResponse } from 'next/server';

export async function POST() {
  try {
    // Placeholder - in production, trigger VaultSyncService.sync()
    return NextResponse.json({
      success: true,
      message: 'Sync triggered',
      status: 'syncing',
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to trigger sync' },
      { status: 500 }
    );
  }
}

/**
 * GET /api/sync/status
 * 
 * Current sync state + queue depth
 */
export async function GET() {
  try {
    return NextResponse.json({
      status: 'idle',
      lastSync: '5m ago',
      queueDepth: 0,
    });
  } catch (error) {
    return NextResponse.json(
      { error: 'Failed to fetch sync status' },
      { status: 500 }
    );
  }
}
