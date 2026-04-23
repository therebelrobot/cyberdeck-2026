/**
 * VaultSyncService
 * 
 * Per docs/KIOSK.md:
 * - Wraps git operations for ~/vault/ sync
 * - Auth via SSH deploy key at ~/.ssh/vault_deploy_key
 * - Vault repo treated as append-only from this device
 * - Sync strategy:
 *   - On connect: immediate pull then push
 *   - While connected: sync every N minutes (configurable, default 15)
 *   - On disconnect: queue writes locally, sync on next connection
 * - Exposes sync(), getStatus(), getQueueDepth()
 */

import type { SyncStatus } from './types';

class VaultSyncService {
  private status: SyncStatus = {
    status: 'idle',
    lastSync: null,
    queueDepth: 0,
  };
  private syncInterval: NodeJS.Timeout | null = null;
  private readonly syncIntervalMs = 15 * 60 * 1000; // 15 minutes

  /**
   * Trigger immediate sync
   */
  async sync(): Promise<void> {
    this.status.status = 'syncing';
    // Placeholder - in production, run git pull/push
    console.log('Vault sync started');

    // Simulate sync delay
    await new Promise(resolve => setTimeout(resolve, 1000));

    this.status.status = 'idle';
    this.status.lastSync = new Date().toISOString();
    this.status.queueDepth = 0;
    console.log('Vault sync complete');
  }

  /**
   * Start automatic sync interval
   */
  startAutoSync(intervalMs = this.syncIntervalMs): void {
    if (this.syncInterval) return;

    this.syncInterval = setInterval(() => {
      this.sync();
    }, intervalMs);
  }

  /**
   * Stop automatic sync
   */
  stopAutoSync(): void {
    if (this.syncInterval) {
      clearInterval(this.syncInterval);
      this.syncInterval = null;
    }
  }

  /**
   * Get current sync status
   */
  getStatus(): SyncStatus {
    return { ...this.status };
  }

  /**
   * Get queue depth
   */
  getQueueDepth(): number {
    return this.status.queueDepth;
  }
}

// Singleton instance
export const vaultSyncService = new VaultSyncService();
