/**
 * Shared types for RAPTOR OS services
 * Per docs/KIOSK.md
 */

export interface MeshMessage {
  id: string;
  time: string;
  sender: string;
  channel: string;
  message: string;
  direct: boolean;
}

export interface MeshNode {
  id: string;
  name: string;
  signal: number;
  lat?: number;
  lon?: number;
  lastSeen: string;
}

export interface Note {
  id: string;
  title: string;
  path: string;
  modified: string;
  content?: string;
}

export interface SyncStatus {
  status: 'idle' | 'syncing' | 'error';
  lastSync: string | null;
  queueDepth: number;
}
